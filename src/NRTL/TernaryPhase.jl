function NRTL_ternaryPhase(params::Dict, solvent::String, Tx; x_step::Float64 = 0.001)
    
    x_1v = []
    x_2v = []
    x_3v = []
  
    R = 8.314; fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
    fusΔH_rac = params["Solute"][3]; Tm_rac = params["Solute"][4]
    ⍺ = params[solvent]["⍺"]; g = params[solvent]["g"]
    J = 1:length(⍺[1, :]); K = 1:length(⍺[1, :]); M = 1:length(⍺[1, :])

  function NRTLei(xi, T)
      
    𝜏 = g/(T*R)
    G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    nlnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    nzi = log(xi[1])+nlnγi-(fusΔH/R)*(1/T-1/Tm)
    nzi^2

  end

  function NRTLej(xi, T)
      
    𝜏 = g/(T*R)
    G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    nlnγi = sum(xi[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xi[k]*G[k, 2] for k in K)+sum(xi[j]*G[2, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    nzi = log(xi[2])+nlnγi-(fusΔH/R)*(1/T-1/Tm)
    nzi^2

  end

  function NRTLr(xi, xj, T)

    𝜏 = g/(T*R)
    G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    lnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    lnγj = sum(xi[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xi[k]*G[k, 2] for k in K)+sum(xi[j]*G[2, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    nzi = (2*fusΔH_rac/R)*(1/Tm_rac-1/T) - (log(4) + lnγi + lnγj + log(xi[1]) + log(xj[2]))
    nzi^2

  end

  function ei(xi)

    NRTLei(xi, Tx)

  end

  function ej(xi)

    NRTLej(xi, Tx)

  end

  function r(xi, xj)

    NRTLr(xi, xj, Tx)

  end

  for i in 0.001:x_step:0.999

      for j in 0.001:x_step:0.999

        for k in 0.001:x_step:0.999

            if i + j + k == 1

              if round(ei([i, j, k]), digits = 3) == 0 && i/j > 1

                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)

              end

              if round(ej([i, j, k]), digits = 3) == 0 && i/j < 1

                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)

              end

              if round(r([i, j, k], [i, j, k]), digits = 3) == 0

                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)

              end

            end
        end
      end
  end

  model = zeros(length(x_1v), 3)

  for i in range(1, length(x_1v))

    model[i, 1] = x_1v[i]

  end

  for j in range(1, length(x_2v))

    model[j, 2] = x_2v[j]

  end

  for k in range(1, length(x_3v))

    model[k, 3] = x_3v[k]

  end

  return model
    
end