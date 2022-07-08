"""

    importTernaryPhase(filepath::String)

Using the package XLSX we import the data from the xlsx file as a dataframe to an array that corresponds to the partial molar composition of each component

Inputs: 
1. filepath = String that includes the filepath of the xlsx file that we are intending to import

"""
function importTernaryPhase(filepath::String)

  model = Dict()
  xf = XLSX.readxlsx(filepath)
  sheet = XLSX.sheetnames(xf)

  for t in range(1, length(sheet))

    x_1 = Matrix(DataFrame(XLSX.readtable(filepath, sheet[t])...))[:,1]
    x_2 = Matrix(DataFrame(XLSX.readtable(filepath, sheet[t])...))[:,2]
    x_3 = Matrix(DataFrame(XLSX.readtable(filepath, sheet[t])...))[:,3]

    model[sheet[t]] = zeros(length(x_1), 3)

    for i in range(1, length(x_3))

      model[sheet[t]][i, 3] = x_3[i]

    end

    for j in range(1, length(x_2))

      model[sheet[t]][j, 2] = x_2[j]

    end

    for k in range(1, length(x_1))

      model[sheet[t]][k, 1] = x_1[k]

    end
    
  end
    
  return model
  
end