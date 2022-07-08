"""

    ternaryPhase(params::Dict, γi, γj, Tx; x_step::Float64 = 0.001, x_start::Float64 = 0.001, x_end::Float64 = 0.999, round1::Int64 = 3, round2::Int64 = 3, round3::Int64 = 3, pp::Bool = true, e::Bool = true)

The function will find the activity coefficient of the R enantiomer and the S enantiomer and checks if the Schrödenberg Van Laar equation and the Prigogine and Defay equation  is correct. This is done for every molar composition possible. When the solubility equation is true, the molar composition is appended to an array. The array is then processed to remove solubility points beyond the eutectic points

Inputs: 
1. params = Dictionary that includes the solvents used as keys and the respective interaction parameters. The solute key contains the calorimetric data of the target molecule as an array
2. solvent = String of the solvent used for the modeling
3. γix = Activtiy coefficient of the i component at temperature Tx in the x compositon
4. γjx = Activtiy coefficient of the j component at temperature Tx in the x compositon
5. Tx = Value of the type Int64/Float64 of the temperature used to determine the activity coefficient

Optional:
1. x_step = Step size of the molar composition increments. Automatically set to 0.001
2. x_start = Start of the iteration of the molar composition. Automatically set to 0.001
3. x_end = End of the iteration of the molar composition. Automatically set to 0.999
4. round# = This affects the sensitivity of the solubility equation. This rounds to the specified number of digits after the decimal place. Automatically set to 4 for the solubility of the enantiomers and 3 for the solubility of the racemate
5. pp = Boolean that allows the post-processing of the output array will be done to  remove any points beyond the eutectic points

"""
function ternaryPhase(params::Dict, γi, γj, Tx; x_step::Float64 = 0.001, 
    x_start::Float64 = 0.001, x_end::Float64 = 0.999, round1::Int64 = 3, round2::Int64 = 3, 
    round3::Int64 = 3, pp::Bool = true, e::Bool = true)

    e_1 = []; e_2 = []; e_3 = []; r_1 = []; r_2 = []; r_3 = []
    e_values = [e_1, e_2, e_3]; r_values = [r_1, r_2, r_3]

    for i in x_start:x_step:x_end
        for j in x_start:x_step:x_end
          for k in x_start:x_step:x_end
    
            if i + j + k == 1

                if e == true

                    if round(solubilityPoint(params, Tx, x = [i, j, k], e_2 = false, γi = γi, γj = γj), 
                        digits = round1) == 0 && i/j > 1
                        append!(e_values[1], i); append!(e_values[2], j); append!(e_values[3], k)
                    end

                    if round(solubilityPoint(params, Tx, x = [i, j, k], e_1 = false, γi = γi, γj = γj),
                        digits = round2) == 0 && i/j < 1
                        append!(e_values[1], i); append!(e_values[2], j); append!(e_values[3], k)
                    end
    
                    if round(solubilityPoint(params, Tx, x = [i, j, k], γi = γi, γj = γj), digits = round3) == 0
                        append!(r_values[1], i); append!(r_values[2], j); append!(r_values[3], k)
                    end

                else

                    if round(solubilityPoint(params, Tx, x = [i, j, k], e_2 = false, γi = γi, γj = γj), 
                        digits = round1) == 0 && i/j > 1
                        append!(e_values[1], i); append!(e_values[2], j); append!(e_values[3], k)
                    end

                    if round(solubilityPoint(params, Tx, x = [i, j, k], e_1 = false, γi = γi, γj = γj),
                        digits = round2) == 0 && i/j < 1
                        append!(e_values[1], i); append!(e_values[2], j); append!(e_values[3], k)
                    end
                    
                end
    
              end
          end
        end
    end

    model_e = hcat(e_values[1], e_values[2], e_values[3])
    model_r = hcat(r_values[1], r_values[2], r_values[3])

    if pp == true && e == true
        
        eutectics = []

        for i in range(1, length(model_e[1:end, 1]))
            for j in range(1, length(model_r[1:end, 1]))
                if model_e[i, 1:end] == model_r[j, 1:end]
                    if length(eutectics) == 0
                        eutectics = [model_e[i, 1:end][1] model_e[i, 1:end][2] model_e[i, 1:end][3]]
                    else
                        eutectics = vcat(eutectics, [model_e[i, 1:end][1] model_e[i, 1:end][2] model_e[i, 1:end][3]])
                    end
                end
            end
        end

        min = eutectics[findmin(eutectics[1:end, 1])[2], 1:end]
        maxi = eutectics[findmax(eutectics[1:end, 1])[2], 1:end]

        a = round(abs(100*(min[2])/(min[1]+min[2])), digits = 2)
        c = round(abs(100*(min[1])/(min[1]+min[2])), digits = 2)
        b = round(abs(100*(maxi[2])/(maxi[1]+maxi[2])), digits = 2)
        d = round(abs(100*(maxi[1])/(maxi[1]+maxi[2])), digits = 2)

        println("Eutectic points of isotherm "*string(Tx)*"K are at composition: ")
        println("")
        println("x1: "*string(min[1])*" x2: "*string(min[2])*" x3: "*string(min[3]))
        println("x1: "*string(maxi[1])*" x2: "*string(maxi[2])*" x3: "*string(maxi[3]))
        println("")
        println("Enantiomeric Excess = ")
        println("")
        println("Eutectic 1: xi "*string(a)*"% - xj "*string(c)*"%")
        println("")
        println("Eutectic 2: xi "*string(b)*"% - xj "*string(d)*"%")
        println("")

        filt_r = []

        for i in range(1, length(model_r[1:end, 1]))
            if maxi[1] > model_r[i, 1] > min[1] && maxi[2] < model_r[i, 2] < min[2] && model_r[i, 3] > min[3]
                append!(filt_r, i)
            end
        end

        model_r = model_r[filt_r, 1:3]

        filt_e = []

        for i in range(1, length(model_e[1:end, 1]))
            if model_e[i, 3] > min[3]
                append!(filt_e, i)
            end
        end

        model_e = model_e[filt_e, 1:3]

    end

    model = vcat(model_e, model_r)

    model

end
    