"""
    NRTL_solubilityCurve(params::Dict,  T::Vector, solvent::String; j::Union{Float64, Int64} = 0, 
    guess::Union{Float64, Int64} = 0, components = 3, Ti_step::Union{Float64, Int64} = 1, 
    R::Union{Float64, Int64} = 8.314)

Inputs: 
1. x = 

Optional:
1. database = 
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