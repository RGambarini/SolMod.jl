function NRTL_importExperimentalTernaryPhase(filepath::String)

  # Inputs: 
  # 1. filepath = String that includes the filepath of the xlsx 
  # file that we are intending to import
  
  # Using the package XLSX we import the the first 3 columns of every
  # sheet in the xlsx file. Every sheet name will be the key of our
  # dictionary and the values will be the 3 columns in the sheet

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
  
end