function importSolubility(filepath::String)

  # Inputs: 
  # 1. filepath = String that includes the filepath of the xlsx 
  # file that we are intending to import

  # Using the package XLSX we import the data from the xlsx file as a dataframe to 
  # an array that corresponds to the molar composition and the calculated temperature
  
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