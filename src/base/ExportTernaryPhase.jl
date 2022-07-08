"""

    exportTernaryPhase(model, outputfile::String; Ts::Vector = collect(keys(model)))

Using the package XLSX we export the array as a dataframe to the first sheet of an xlsx file. This will contain three columns that represent the partial molar composition of the R enantiomer,the S enantiomer, and the solvent at a specified temperature 

Inputs:
1. model = Array that includes the molar composition of the R enantiomer, the S enantiomer, and the solvent at a specified temperature
2. outputfile = String that includes the filepath of the xlsx file that we are intending to export 

"""
function exportTernaryPhase(model, outputfile::String; 
    Ts::Vector = collect(keys(model)))

    XLSX.writetable(outputfile)

    for t in range(1, length(Ts))
  
        df = DataFrame(x_1 = model[Ts[t]][1:end, 1], 
        x_2 = model[Ts[t]][1:end, 2], x_3 = model[Ts[t]][1:end, 3])
    
        XLSX.openxlsx(outputfile, mode="rw") do xf
            numb_of_sheets = XLSX.sheetcount(xf)
            XLSX.addsheet!(xf, string(Ts[t]))
            sheet = xf[numb_of_sheets+1]
            XLSX.writetable!(sheet, df)
        end
    
    end
    
end