function NRTL_solubility(params::Dict, components::Int64;
    solvents::Vector = deleteat!(collect(keys(params)), 
    findall(x->x=="Solute", collect(keys(params)))), x_start::Float64 = 0.001, 
    x_finish::Float64 = 0.999, x_step::Float64 = 0.001, x_rac::Float64 = 0.0, 
    T_start::Int64 = 200, T_finish::Int64 = 400, round1::Int64 = 3)

  # Inputs: 
  # 1. params = Dictionary that includes the solvents used as keys and the respective
  # interaction parameters. The solute key contains the calorimetric data of the
  # target molecule as an array
  # 2. components = An integer that should be either a 2 or a 3. A 2 component
  # system would be used to model a system made up of a target molecule and its
  # solvent. A 3 component system would be used to model a system with an R and
  # S enantiomer along with its solvent

  # Optional:
  # 1. solvents = Vector that includes a list of strings that are the solvents used
  # for the modeling. Automatically loads the keys of the params dictionary
  # 2. x_start = Starting molar composition of the target molecule. Automatically set
  # to 0.001
  # 3. x_finish =Last molar composition of the target molecule. Automatically set
  # to 0.001
  # 4. x_step = Step size of the molar composition increments
  # 5. x_rac = Molar composition of the enantiomer complementary to the target molecule
  # 6. T_start = Starting temperature
  # 7. T_finish = Last temperature
  # 3. round# = This affects the sensitivity of the solubility equation. This rounds to the
  # specified number of digits after the decimal place. Automatically set to 3

  # To determine the activity coefficient of the system at the specified composition we
  # use the NRTL activity coefficient model:

  # lnγi = ∑_j=1 (x_j 𝜏_ji G_ji) / ∑_k=1 (x_k G_kj) + ∑_j=1 (x_j G_ij / ∑ (x_k G_kj) (𝜏_ji - ( ∑_m=1 (x_m 𝜏_mj G_mj) / ∑_k=1 (x_k G_kj)))) 
  
  # γi is the activity coefficient of component i, x is the molar fraction of the i 
  # component, and 𝜏 and G are the binary parameters that truly define the NRTL model
  
  # The interaction parameters 𝜏 and G are defined by the equations:

  # 𝜏_ij = g_ij - g_jj / (T R)
  # G_ij = 𝘦 ^(-⍺_ij 𝜏_ij)

  # Solubility is modeled acording to the Schrödenberg Van Laar equation:

  # log(x_i γ_i) = (fusΔH / R) (1 / T - 1 / Tm)

  # Which details that the solubility of a molecule can be easily computed with the respective
  # calorimetric properties, where fusΔH is the enthalpy of fusion and Tm is the melting
  #  temperature of molecule i.

  # 𝜏 defines the temperature dependency in the equation. The parameter g is obtained 
  # from experimental data, where g_ij is the interaction between two components in 
  # the solution while g_jj can be chosen freely as a reference state. R is defined as 
  # the ideal gas constant. 𝜏 can then be used in the definition for G, which also contains 
  # the nonrandomness parameter ⍺. This parameter has no true physical meaning, and can be 
  # chosen at a value close to 0.3 in most literature
  
  # The function first checks if the number of components is allowed. Currently it is only able
  # to accept 2 or 3 component mixtures. For every solvent in the model, the function will 
  # calculate the activity coefficient for the respective temperature and composition.
  # The algorithm of the Roots.jl package is used to determine the temperature that corresponds
  # to the respective parameters in the Schrödenberg Van Laar equation. After calculating the
  # right temperature, the molar composition and temperature are appended to a dictionary under
  # the key of the respective solvent
    
    if components == 1
  
      println("Try again")
  
    elseif components >= 4
  
      println("Number of components is not yet supported")
  
    else
  
      if components == 2
  
        xi = hcat(range(x_start, x_finish, step = x_step), 
        range(1-x_start, 1-x_finish, step = -x_step))
  
      elseif components == 3
  
        x_1 = range(x_start, x_finish, step = 0.001)
        x_2 = x_rac * ones(length(range(x_start, x_finish, step = 0.001)))
        x_3 = range(1-x_start-x_rac, 1-x_finish-x_rac, 
        length = length(range(x_start, x_finish, step = 0.001)))
        xi = hcat(x_1, x_2, x_3)
  
      end
  
      solub = Dict(); ; R = 8.314; Tn = []
      fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
      
      T = range(T_start, T_finish, step = 0.01)  
  
      for l in range(1, length(solvents))
  
        Tc = []; ⍺ = params[solvents[l]]["⍺"]; g = params[solvents[l]]["g"]
        J = 1:length(xi[1, :]); K = 1:length(xi[1, :]); M = 1:length(xi[1, :])
  
        function NRTL(xi, Tx)
          𝜏 = g/(Tx*R)
          G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
          nlnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
          nzi = log(xi[1])+nlnγi-(fusΔH/R)*(1/Tx-1/Tm)
          nzi^2
  
        end
  
        for n in range(1, length(xi[:, 1]))
  
          function z(Tx)
  
            NRTL(xi[n, :], Tx)
  
          end

          Tn = []
  
          for i in T

            if round(z(i), digits = round1) == 0
              append!(Tn, i)
            end
          end

          if length(Tn) == 0
            println("Could not find solubility at "*string(n)*" please check sensitivity")
          end

          append!(Tc, sum(Tn)/length(Tn))
  
        end

        solub[solvents[l]] = xi[:, 1], Tc
  
      end
  
      references = String["10.1002/aic.690140124", "ISBN: 9780070498419"]
      model = solub
      return model
  
    end
  
end