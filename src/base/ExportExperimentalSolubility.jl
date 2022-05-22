function exportExperimentalSolubility(exp, outputfile::String; 
    solvents::Vector = collect(keys(exp)))

    # Inputs: 
    # 1. exp = Dictionary that includes the keys for the solvents and
    # the values that correspond to the temperature and molecular
    # fraction composition of the target molecule
    # 2. outputfile = String that includes the filepath of the xlsx 
    # file that we are intending to export 

    # Optional:
    # 1. solvents = Vector that includes strings of the solvents that
    # are used for the solubility prediction
    
    # Using the package XLSX we export the dictionary as a dataframe to 
    # construct 2 columns in every sheet of the xlsx file for every solvent

    XLSX.writetable(outputfile)
  
    for l in range(1, length(solvents))
  
      df = DataFrame(Temperature = exp[solvents[l]][1], 
      Mol_Fraction_of_Solute = exp[solvents[l]][2])
  
      XLSX.openxlsx(outputfile, mode="rw") do xf
          numb_of_sheets = XLSX.sheetcount(xf)
          XLSX.addsheet!(xf, solvents[l])
          sheet = xf[numb_of_sheets+1]
          XLSX.writetable!(sheet, df)
      end
    end
end