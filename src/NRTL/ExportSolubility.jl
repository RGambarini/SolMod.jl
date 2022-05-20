function NRTL_exportSolubility(model, outputfile::String; 
    solvents::Vector = collect(keys(model)))
  
    # Inputs:
    # 1. model = Dictionary that includes the keys for the the solvents used and 
    # the values that correspond to the molar composition and temperature of the
    # points of solubility
    # 2. outputfile = String that includes the filepath of the xlsx file that we
    # are intending to export 

    # Optional:
    # 1. solvents = Vector that includes a list of strings that are the solvents used
    # for the modeling. Automatically loads the keys of the model dictionary
    
    # Using the package XLSX we export the dictionary as a dataframe to 
    # a sheet of the xlsx file for every solvent. Every sheet will contain two columns
    # that represent the partial molar composition and corresponding temperature for
    # each point of solubility

    XLSX.writetable(outputfile)
  
    for l in range(1, length(solvents))
  
      df = DataFrame(Partial_Molar_Composition = model[solvents[l]][1], 
      Calculated_Temperature = model[solvents[l]][2])
  
      XLSX.openxlsx(outputfile, mode="rw") do xf
          numb_of_sheets = XLSX.sheetcount(xf)
          XLSX.addsheet!(xf, solvents[l])
          sheet = xf[numb_of_sheets+1]
          XLSX.writetable!(sheet, df)
      end
  
    end
  
end