"""

  errorAnalysis(model, experimental, components)

Using the package XLSX we export the dictionary as a dataframe to 
construct 2 columns in every sheet of the xlsx file for every solvent

Inputs: 
1. model = Array that includes the temperature in the first column,
molar composition of the R enantiomer on the second column, and/or 
the molar composition of the S enantiomer depending on the component 
value.
2. experimental = Array that includes the keys for the solvents and
the values that correspond to the temperature and molecular fraction 
composition of the target molecule.
3. components = Integer value that specifies the number of components

"""
function errorAnalysis(model, experimental, components::Int64)

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