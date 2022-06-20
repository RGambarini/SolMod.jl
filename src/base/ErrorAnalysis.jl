function errorAnalysis(model, experimental, components)

    if components == 2
        
        Tex = experimental[1:end, 1]
        xex = experimental[1:end, 2]
        
        Tc = model[1:end, 1]
        xc = model[1:end, 2]
        
        residual = []
        
        for n in range(1, length(Tex))
        
            append!(residual, (xex[n] - xc[findmin(Tc.-Tex[n])[2]]))
        
        end
        
        println("")
        println("RMSD: "*string(sqrt((sum(residual))^2/length(residual))))
        println("")

        hcat(Tex, xex, residual)

    elseif components == 3

        residual = []

        for i in range(1, length(experimental[1:end, 1]))

            q = (model .- transpose(experimental[i, 1:end])).^2
            w = (q[1:end, 1] + q[1:end, 2] + q[1:end, 3]).^0.5
            x = findmin(w)[1]
            append!(residual, x)

        end

        println("")
        println("RMSD: "*string((sum(residual)/length(residual))))
        println("")

        hcat(experimental, residual)
    
    else

        println("Number of components not supported")

    end

end