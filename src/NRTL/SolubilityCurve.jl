"""

    NRTL_solubilityCurve(params::Dict,  T::Vector, solvent::String; j::Union{Float64, Int64} = 0, 
    guess::Union{Float64, Int64} = 0, components = 3, Ti_step::Union{Float64, Int64} = 1, 
    R::Union{Float64, Int64} = 8.314)

Inputs: 
1. params = Dictionary that includes the solvents used as keys and the respective interaction parameters. The solute key contains the calorimetric data of the target molecule as an array
2. T = Vector of length 2 that includes the start and the end temperature for the solubility curve
3. solvent = String of the solvent used for the modeling

Optional:
1. j = Float or integer value that represents the constant amount of the opposite enantiomer in the solution. Automatically set to 0
2. guess = Float or integer value that represents a guess of the solubility point at the initial temperature. This can be inferred from experimental information. Automatically set to 0
3. components = Integer value that represents the number of components in the solution. Automatically set to 3
4. Ti_step = Float or integer value that represents the stepsize of the temperature iterations between the start temperature to the final temperature in the T vector. Automatically set to 1
5. R = Value of the type Int64/Float64 that represents the ideal gas constant. Automatically set to 8.314

"""
function NRTL_solubilityCurve(params::Dict, T::Vector, solvent::String; j::Union{Float64, Int64} = 0, 
    guess::Union{Float64, Int64} = 0, components = 3, Ti_step::Union{Float64, Int64} = 1, 
    R::Union{Float64, Int64} = 8.314)

    if components == 3

        xi = []

        Ti = T[1]:Ti_step:T[2]

        for t in Ti

            function f(i)
                γi() = NRTL_activityCoefficient(params, solvent, t)
                x  = [i, j, 1-i-j]

                if 1-i-j > 0
                    solubilityPoint(params, t, x = x, e_2 = false, γi = γi)
                else
                    println("")
                    println("Unfeasable molar composition")
                    println("")
                end
            end

            if length(xi) == 0

                if guess == 0
                    
                    try
                        append!(xi, fzero(f, rand()))
                    catch
                        println("")
                        println("Algorithm failed to converge. Estimate initial point by changing 'guess' or try again")
                        println("")
                    end

                    guess = rand()

                else

                    append!(xi, fzero(f, guess))

                end

            else

                append!(xi, fzero(f, xi[end]))

            end

        end
        hcat(Ti, xi)

    else

        xi = []; fusΔH = params["Solute"][1]; Tm = params["Solute"][2]

        Ti = T[1]:Ti_step:T[2]

        for t in Ti

            function f(x)
                γi() = NRTL_activityCoefficient(params, solvent, t, x = [x, 1-x], components = 2)
                nzi = (log(x)+log(γi())-(fusΔH/R)*(1/t-1/Tm))
                nzi^2
            end

            if length(xi) == 0
                if guess == 0
                    try
                        append!(xi, fzero(f, rand()))
                    catch
                        println("")
                        println("Algorithm failed to converge. Estimate initial point by changing 'guess' or try again")
                        println("")
                    end
                else
                    append!(xi, fzero(f, guess))
                end
            else
                append!(xi, fzero(f, xi[end]))
            end


        end

        hcat(Ti, xi)

    end

end