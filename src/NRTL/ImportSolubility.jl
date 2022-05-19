function NRTL_importSolubility(filepath::String)
  
    xf = XLSX.readxlsx(filepath)
    solvent = XLSX.sheetnames(xf)[1]
  
    Partial_Molar_Composition = Matrix(DataFrame(XLSX.readtable(filepath, solvent)...))[:,1]
    Calculated_Temperature = Matrix(DataFrame(XLSX.readtable(filepath, solvent)...))[:,2]

    model = zeros(length(Partial_Molar_Composition), 2)

    for k in range(1, length(Partial_Molar_Composition))

        model[k, 1] = Partial_Molar_Composition[k]
    
    end

    for j in range(1, length(Calculated_Temperature))

        model[j, 2] = Calculated_Temperature[j]

    end
  
    return model
  
end