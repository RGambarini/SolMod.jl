function NRTL_exportExperimentalData(Exp, outputfile::String; 
    solvents::Vector = collect(keys(Exp)))
  
    XLSX.writetable(outputfile)
  
    for l in range(1, length(solvents))
  
      df = DataFrame(Temperature = Exp[solvents[l]][1], 
      Mol_Fraction_of_Solute = Exp[solvents[l]][2])
  
      XLSX.openxlsx(outputfile, mode="rw") do xf
          numb_of_sheets = XLSX.sheetcount(xf)
          XLSX.addsheet!(xf, solvents[l])
          sheet = xf[numb_of_sheets+1]
          XLSX.writetable!(sheet, df)
      end
  
    end
  
end