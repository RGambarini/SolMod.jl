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