function NRTL_importExperimentalData(filepath::String, components::Int64)

  if components == 2
    Exp = Dict()
  
    xf = XLSX.readxlsx(filepath)
    solvents = XLSX.sheetnames(xf)[2:end]
  
    for l in range(1, length(solvents))
  
      Ti = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,1]
      xi = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,2]
  
      Exp[solvents[l]] = Ti, xi
  
    end
  
    return Exp

  elseif components == 3

    Exp = Dict()

    xf = XLSX.readxlsx(filepath)
    temperatures = XLSX.sheetnames(xf)

    for t in range(1, length(temperatures))

      x1 = Matrix(DataFrame(XLSX.readtable(filepath, temperatures[t])...))[:,1]
      x2 = Matrix(DataFrame(XLSX.readtable(filepath, temperatures[t])...))[:,2]
      x3 = Matrix(DataFrame(XLSX.readtable(filepath, temperatures[t])...))[:,3]

      Exp[temperatures[t]] = zeros(length(x1), 3)

      for i in range(1, length(x1))
    
        Exp[temperatures[t]][i, 1] = x1[i]
    
      end
    
      for i in range(1, length(x2))
    
        Exp[temperatures[t]][i, 2] = x2[i]
    
      end
    
      for i in range(1, length(x3))
    
        Exp[temperatures[t]][i, 3] = x3[i]
    
      end
    

    end

    return Exp

  else

    println("Try again")

  end
  
end