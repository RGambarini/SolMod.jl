function NRTL_importExperimentalData(filepath::String)

    Exp = Dict()
  
    xf = XLSX.readxlsx(filepath)
    solvents = XLSX.sheetnames(xf)[2:end]
  
    for l in range(1, length(solvents))
  
      Ti = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,1]
      xi = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,2]
  
      Exp[solvents[l]] = Ti, xi
  
    end
  
    return Exp
  
end