function NRTL_solubility(params::Dict, components::Int64;
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