"""

  NRTL_exportParameters(params, components::Int64, outputfile::String; 
      sol::Vector = deleteat!(collect(keys(params)), 
      findall(x->x=="Solute", collect(keys(params)))))

Using the package XLSX we export the dictionary as a dataframe to 
a sheet of the xlsx file for every solvent. The first sheet will always contain
the calorimetric data of the molecule. If 2 components are specified,
the sheet will contain a 2x2 matrix of the interaction parameters of the 
molecule and the solvent. If 3 components are specified, the sheet will
contain a 3x3 matrix of the interaction parameters of the R and S enantiomer
and the solvent

Inputs:
1. params = Dictionary that includes the keys for the solute (first sheet)
and the solvents used. The values correspond to the parameters used in the
model.
2. components = An integer that should be either a 2 or a 3. A 2 component
system would be used to model a system made up of a target molecule and its
solvent. A 3 component system would be used to model a system with an R and
S enantiomer along with its solvent
3. outputfile = String that includes the filepath of the xlsx file that we
are intending to export 

Optional:
1. sol = Vector that includes a list of strings that are the solvents used
for the modeling. Automatically loads the keys of the params dictionary

"""

function NRTL_exportParameters(params, components::Int64, outputfile::String; 
    sol::Vector = deleteat!(collect(keys(params)), 
    findall(x->x=="Solute", collect(keys(params)))))
  
    NRTLparams = ["⍺", "g"]
    fusΔH = params["Solute"][1]
    Tm = params["Solute"][2]
  
    if components == 2
  
      components = range(1, components)
  
      XLSX.writetable(outputfile, DataFrame(fusΔH = fusΔH, Tm = Tm), 
        sheetname = "Solute")
  
      for l in range(1, length(sol))
  
        ⍺_1 = params[sol[l]]["⍺"][1:length(components), 1]
        ⍺_2 = params[sol[l]]["⍺"][1:length(components), 2]
        g_1 = params[sol[l]]["g"][1:length(components), 1]
        g_2 = params[sol[l]]["g"][1:length(components), 2]
  
        df = DataFrame(⍺_1 = ⍺_1, ⍺_2 = ⍺_2, g_1 = g_1, g_2 = g_2)
  
        XLSX.openxlsx(outputfile, mode="rw") do xf
  
            numb_of_sheets = XLSX.sheetcount(xf)
            XLSX.addsheet!(xf, sol[l])
            sheet = xf[numb_of_sheets+1]
            XLSX.writetable!(sheet, df)
  
        end
  
      end
  
    elseif components == 3
  
      components = range(1, components)
  
      XLSX.writetable(outputfile, DataFrame(fusΔH = fusΔH, Tm = Tm), 
        sheetname = "Solute")
  
  
      for l in range(1, length(sol))
  
        ⍺_1 = params[sol[l]]["⍺"][1:length(components), 1]
        ⍺_2 = params[sol[l]]["⍺"][1:length(components), 2]
        ⍺_3 = params[sol[l]]["⍺"][1:length(components), 3]
        g_1 = params[sol[l]]["g"][1:length(components), 1]
        g_2 = params[sol[l]]["g"][1:length(components), 2]
        g_3 = params[sol[l]]["g"][1:length(components), 3]
  
        df = DataFrame(⍺_1 = ⍺_1, ⍺_2 = ⍺_2, ⍺_3 = ⍺_3, g_1 = g_1, 
        g_2 = g_2, g_3 = g_3)
  
        XLSX.openxlsx(outputfile, mode="rw") do xf
  
            numb_of_sheets = XLSX.sheetcount(xf)
            XLSX.addsheet!(xf, sol[l])
            sheet = xf[numb_of_sheets+1]
            XLSX.writetable!(sheet, df)
  
        end
  
      end
  
  
    elseif components == 1
  
      println("Try again")
  
    else
  
    println("Component number is not supported")
  
    end
  
end