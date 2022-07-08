"""

    NRTL_importParameters(filepath::String, components::Int64)

Using the package XLSX we import the data from the xlsx file as a dataframe to a dictionary where the keys are the solute and the solvents used. The first sheet contains the calorimetric data of the molecule and will be added as a value  to the solute key. When 3 components are specified, aditional calorimetric data for the racemic product will be added as the values [3], and [4] If 2 components are specified, the  2x2 matrix of the interaction parameters of the molecule and the solvent will be imported as a value to their respective solvent keys. If 3 components are specified, the  3x3 matrix of the interaction parameters of the molecule and the solvent will be imported as a value to their respective solvent keys

Inputs: 
1. filepath = String that includes the filepath of the xlsx file that we are intending to import
2. components = An integer that should be either a 2 or a 3. A 2 component system would be used to model a system made up of a target molecule and its solvent. A 3 component system would be used to model a system with an R and S enantiomer along with its solvent

"""
function NRTL_importParameters(filepath::String, components::Int64)

  if components == 2

    params = Dict()

    # fusΔH, Tm

    params["Solute"] = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))

    xf = XLSX.readxlsx(filepath)
    solvents = XLSX.sheetnames(xf)[2:end]

    for l in range(1, length(solvents))

      params[solvents[l]] = Dict()

      ⍺ = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:2,1:2]
      g = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:2,3:4]

      params[solvents[l]]["⍺"] = ⍺
      params[solvents[l]]["g"] = g

    end

    return params

  elseif components == 3

    params = Dict()

    # fusΔH, Tm, fusΔH_rac, Tm_rac

    params["Solute"] = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))

    xf = XLSX.readxlsx(filepath)
    solvents = XLSX.sheetnames(xf)[2:end]

    for l in range(1, length(solvents))

      params[solvents[l]] = Dict()

      ⍺ = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:3,1:3]
      g = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:3,4:6]

      params[solvents[l]]["⍺"] = ⍺
      params[solvents[l]]["g"] = g

    end

    return params

  else

    println("Try again")

  end

end