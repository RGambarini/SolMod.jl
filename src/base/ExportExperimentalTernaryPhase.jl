"""

    exportExperimentalTernaryPhase(exp, outputfile::String; temperatures::Vector = collect(keys(exp)))

Using the package XLSX we export the dictionary as a dataframe to construct 3 columns in every sheet of the xlsx file for every temperature

Inputs: 
1. exp = Dictionary that includes the keys for the temperatures and the values that correspond to the molecular fraction composition of the R(x_1) and S(x_2) enantiomers and the solvent(x_3) used 
2. outputfile = String that includes the filepath of the xlsx file that we are intending to export 

Optional:
1. temperatures = Vector that includes strings of the solvents that are used for the solubility prediction. Automatically uses all the keys in the exp dictionary
"""
function exportExperimentalTernaryPhase(exp, outputfile::String; 
    temperatures::Vector = collect(keys(exp)))

    XLSX.writetable(outputfile)
  
    for t in range(1, length(temperatures))
  
      df = DataFrame(x_1 = Exp[temperatures[t]][1], 
      x_2 = Exp[solvents[t]][2], x_3 = Exp[solvents[t]][3])
  
      XLSX.openxlsx(outputfile, mode="rw") do xf
          numb_of_sheets = XLSX.sheetcount(xf)
          XLSX.addsheet!(xf, termperatures[l])
          sheet = xf[numb_of_sheets+1]
          XLSX.writetable!(sheet, df)
      end
    end
end