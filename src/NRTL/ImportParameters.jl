function NRTL_importParameters(filepath::String, components::Int64)

  if components == 2

    params = Dict()

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