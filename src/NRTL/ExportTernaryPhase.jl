function NRTL_exportTernaryPhase(model, outputfile::String)
  
    XLSX.writetable(outputfile)
  
    df = DataFrame(x_1 = model[1:end, 1], 
    x_2 = model[1:end, 2], x_3 = model[1:end, 3])

    XLSX.openxlsx(outputfile, mode="rw") do xf
        sheet = xf[1]
        XLSX.writetable!(sheet, df)
    end
  
end