function NRTL_importTernaryPhase(filepath::String)
  
  # Inputs: 
  # 1. filepath = String that includes the filepath of the xlsx 
  # file that we are intending to import

  # Using the package XLSX we import the data from the xlsx file as a dataframe to 
  # an array that corresponds to the partial molar composition of each component

    xf = XLSX.readxlsx(filepath)
    sheet = XLSX.sheetnames(xf)[1]

    x_1 = Matrix(DataFrame(XLSX.readtable(filepath, sheet)...))[:,1]
    x_2 = Matrix(DataFrame(XLSX.readtable(filepath, sheet)...))[:,2]
    x_3 = Matrix(DataFrame(XLSX.readtable(filepath, sheet)...))[:,3]

    model = zeros(length(x_1), 3)

    for i in range(1, length(x_3))

    model[i, 3] = x_3[i]

    end

    for j in range(1, length(x_2))

    model[j, 2] = x_2[j]

    end

    for k in range(1, length(x_1))

    model[k, 1] = x_1[k]

    end

    return model
  
end