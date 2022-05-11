function NRTL_exportModel(model, outputfile::String; 
    solvents::Vector = collect(keys(model)))
  
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