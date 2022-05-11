function NRTL(params::Dict, components::Int64;
    solvents::Vector = deleteat!(collect(keys(params)), 
    findall(x->x=="Solute", collect(keys(params)))), x_start::Float64 = 0.001, 
    x_finish::Float64 = 0.999, x_step::Float64 = 0.001, x_rac::Float64 = 0.0, 
    T_start::Int64 = 200, T_finish::Int64 = 400, T_guess::Int64 = T_finish)
    
    if components == 1
  
      println("Try again")
  
    elseif components >= 4
  
      println("Number of components is not yet supported")
  
    else
  
      if components == 2
  
        xi = hcat(range(x_start, x_finish, step = x_step), 
        range(x_finish, x_start, step = -x_step))
  
      elseif components == 3
  
        x_1 = range(x_start, x_finish, step = 0.001)
        x_2 = x_rac * ones(length(range(x_start, x_finish, step = 0.001)))
        x_3 = range(1-x_start-x_rac, 1-x_finish-x_rac, 
        length = length(range(x_start, x_finish, step = 0.001)))
        xi = hcat(x_1, x_2, x_3)
  
      end
  
      solub = Dict(); ; R = 8.314
      fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
      
      T = range(T_start, T_finish, length = length(xi[:,1]))  
  
      for l in range(1, length(solvents))
  
        Tc = []; ⍺ = params[solvents[l]]["⍺"]; g = params[solvents[l]]["g"]
        J = 1:length(xi[1, :]); K = 1:length(xi[1, :]); M = 1:length(xi[1, :])
  
        function NRTL(xi, T)
          𝜏 = g/(T*R)
          G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
          nlnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
          nzi = log(xi[1])+nlnγi-(fusΔH/R)*(1/T-1/Tm)
          nzi^2
  
        end
  
        for n in range(1, length(xi[:, 1]))
  
          function z(T)
  
            NRTL(xi[n, :], T)
  
          end
  
          append!(Tc, fzero(z, T_guess))
  
        end
  
        solub[solvents[l]] = xi[:, 1], Tc
  
      end
  
      references = String["10.1002/aic.690140124"]; model = solub
      return model
  
    end
  
end

function exportParametersNRTL(params, components::Int64, outputfile::String; 
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

function importParametersNRTL(filepath::String, components::Int64)

    if components == 2
  
      params = Dict()
  
      fusΔH = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))[1]
      Tm = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))[2]
  
      params["Solute"] = fusΔH, Tm
  
      xf = XLSX.readxlsx(filepath)
      solvents = XLSX.sheetnames(xf)[2:end]
  
      for l in range(1, length(solvents))
  
        params[solvents[l]] = Dict()
  
        ⍺ = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:2,1:2]
        g = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:2,3:4]
  
        params[solvents[l]]["⍺"] = ⍺
        params[solvents[l]]["g"] = g
  
      end
  
      return params
  
    elseif components == 3
  
      params = Dict()
  
      fusΔH = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))[1]
      Tm = Matrix(DataFrame(XLSX.readtable(filepath, "Solute")...))[2]
  
      params["Solute"] = fusΔH, Tm
  
      xf = XLSX.readxlsx(filepath)
      solvents = XLSX.sheetnames(xf)[2:end]
  
      for l in range(1, length(solvents))
  
        params[solvents[l]] = Dict()
  
        ⍺ = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:3,1:3]
        g = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[1:3,4:6]
  
        params[solvents[l]]["⍺"] = ⍺
        params[solvents[l]]["g"] = g
  
      end
  
      return params
  
    else
  
      println("Try again")
  
    end
  
end

function binaryNRTLTable(model::Dict{Any, Any}, solvent::String; 
    start::Int64 = 1, finish::Int64 = length(model[solvent][2]))
  
    x1 = start
    x2 = finish
  
    df = DataFrame(Partial_Molar_Composition = model[solvent][1], 
    Calculated_Temperature = model[solvent][2])
    
    df[x1:x2, 1:2]
  
end

function binaryNRTLPlot(model::Dict{Any, Any}; 
    solvents::Vector = deleteat!(collect(keys(params)), 
    findall(x->x=="Solute", collect(keys(params)))), PP = false, ExpData = true, 
    T_correction::Int64 = 1000)
  
    plt.clf()
  
    for l in range(1, length(solvents))
      plt.plot(model[solvents[l]][2], model[solvents[l]][1], 
        label = solvents[l], linestyle="-", linewidth = 2)
    end
  
    plt.legend(frameon=false,fontsize=12) 
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.grid(alpha = 0.2)
    
    if ExpData == true
  
      if PP == false
  
        for l in range(1, length(solvents))
          plt.scatter(Exp[solvents[l]][1], Exp[solvents[l]][2], linewidth = 4, 
          label = solvents[l])
        end
  
        plt.xticks(fontsize=12)
        plt.yticks(fontsize=12)
  
        x1 = Exp[solvents[1]][1][1]
        x2 = Exp[solvents[1]][1][length(Exp[solvents[1]][1])]
  
        y1 = Exp[solvents[1]][2][1]
        y2 = Exp[solvents[1]][2][length(Exp[solvents[1]][2])]
  
        for l in range(1, length(solvents))
          if Exp[solvents[l]][1][1] < x1
            x1 = Exp[solvents[l]][1][1]
          end
  
          if Exp[solvents[l]][1][length(Exp[solvents[l]][1])] > x2
            x2 = Exp[solvents[l]][1][length(Exp[solvents[l]][1])]
          end
        end
  
        for l in range(1, length(solvents))
          if Exp[solvents[l]][2][1] < x1
            y1 = Exp[solvents[l]][2][1]
          end
  
          if Exp[solvents[l]][2][length(Exp[solvents[l]][2])] > x2
            y2 = Exp[solvents[l]][2][length(Exp[solvents[l]][2])]
          end
        end
  
        plt.xlim(x1-3, x2+10)
        plt.ylim(y1-0.1,y2+0.18)
        plt.grid(alpha = 0.2)
  
      else
  
        pp_Exp = Dict(); pp_solub = Dict()
  
        for l in range(1, length(solvents))
          
          ppT = []; ppxi = []
  
          for i in range(1, length(model[solvents[l]][1]))
              append!(ppT, T_correction/model[solvents[l]][2][i]) 
          end
          if length(ppxi) == 0
            for i in range(1, length(model[solvents[l]][1]))
                append!(ppxi, log(model[solvents[l]][1][i]))
            end
          end
  
          pp_solub[solvents[l]] = ppT, ppxi
  
          ppT = []; ppxi = []
  
          for i in range(1, length(Exp[solvents[l]][1]))
  
            append!(ppT, T_correction/Exp[solvents[l]][1][i])
            append!(ppxi, log(Exp[solvents[l]][2][i]))
  
          end
  
          pp_Exp[solvents[l]] = ppT, ppxi
  
        end
  
        plt.clf()
  
        for l in range(1, length(solvents))
          plt.plot(pp_solub[solvents[l]][1], pp_solub[solvents[l]][2], 
            label = solvents[l], linestyle="-", linewidth = 2)
          plt.scatter(pp_Exp[solvents[l]][1], pp_Exp[solvents[l]][2], linewidth = 4)
        end
  
        plt.legend(frameon=false,fontsize=12)
        plt.xticks(fontsize=12)
        plt.yticks(fontsize=12)
        plt.xlim(3.05, 3.45)
        plt.ylim(-5, 0)
        plt.grid(alpha = 0.2)
  
      end
  
    end
  
end

function importExperimentalDataBinaryNRTL(filepath::String)

    Exp = Dict()
  
    xf = XLSX.readxlsx(filepath)
    solvents = XLSX.sheetnames(xf)[2:end]
  
    for l in range(1, length(solvents))
  
      Ti = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,1]
      xi = Matrix(DataFrame(XLSX.readtable(filepath, solvents[l])...))[:,2]
  
      Exp[solvents[l]] = Ti, xi
  
    end
  
    return Exp
  
end

function exportExperimentalDataBinaryNRTL(Exp, outputfile::String; 
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

function exportModelBinaryNRTL(model, outputfile::String; 
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