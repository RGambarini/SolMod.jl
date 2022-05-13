function NRTL_importModel(filepath::String)
  
    xf = XLSX.readxlsx(filepath)
    solvent = XLSX.sheetnames(xf)[1]
  
    x_1 = Matrix(DataFrame(XLSX.readtable(filepath, solvent)...))[:,1]
    x_2 = Matrix(DataFrame(XLSX.readtable(filepath, solvent)...))[:,2]
    x_3 = Matrix(DataFrame(XLSX.readtable(filepath, solvent)...))[:,3]

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