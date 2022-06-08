function NRTL_solubilityCurve(params::Dict, T, solvent::String; j::Union{Float64, Int64} = 0, 
    guess::Union{Float64, Int64} = 0)

    xi = []

    for t in range(1, length(T))

        function f(i)
            γi() = NRTL_activityCoefficient(params, solvent, T[t])
            γj() = NRTL_activityCoefficient(params, solvent, T[t], e = true)
            x  = [i, j, 1-i-j]
            solubilityPoint(params, γi, γj, T[t], x = x, e_2 = false)
        end

        if guess == 0
            
            try
                append!(xi, fzero(f, rand()))
            catch
                println("")
                println("Algorithm failed to converge. Estimate initial point by changing 'guess' or try again")
                println("")
            end
            
            guess = true

        elseif guess == true
            
            append!(xi, fzero(f, xi[t-1]))

        else

            append!(xi, fzero(f, guess))
            guess = true

        end

    end

    hcat(xi, T)

end