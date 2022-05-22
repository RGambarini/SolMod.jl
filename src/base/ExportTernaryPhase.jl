function exportTernaryPhase(model, outputfile::String)
  
    # Inputs:
    # 1. model = Array that includes the molar composition of the R enantiomer,
    # the S enantiomer, and the solvent at a specified temperature
    # 2. outputfile = String that includes the filepath of the xlsx file that we
    # are intending to export 
    
    # Using the package XLSX we export the array as a dataframe to the first sheet
    # of an xlsx file. This will contain three columns that represent the partial 
    # molar composition of the R enantiomer,the S enantiomer, and the solvent at 
    # a specified temperature

    XLSX.writetable(outputfile)
  
    df = DataFrame(x_1 = model[1:end, 1], 
    x_2 = model[1:end, 2], x_3 = model[1:end, 3])

    XLSX.openxlsx(outputfile, mode="rw") do xf
        sheet = xf[1]
        XLSX.writetable!(sheet, df)
    end
  
end