function NRTL_ternaryPhase(params::Dict, solvent::String, Tx::Float64; x_step::Float64 = 0.001)
    
      x_1v = []
      x_2v = []
      x_3v = []
    
      R = 8.314; fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
      fusΔH_rac = params["Solute"][3]; Tm_rac = params["Solute"][4]
      ⍺ = params[solvent]["⍺"]; g = params[solvent]["g"]
      J = 1:length(⍺[1, :]); K = 1:length(⍺[1, :]); M = 1:length(⍺[1, :])
    
    function NRTLr(xi, T)
        𝜏 = g/(T*R)
        G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
        nγi = exp(sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J))
        nzi = log((xi[1])^2*(nγi)^2)+log(4)-(fusΔH_rac/R)*(1/T-1/Tm_rac)
        nzi^2

    end

    function NRTLe(xi, T)
        𝜏 = g/(T*R)
        G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
        nlnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
        nzi = log(xi[1])+nlnγi-(fusΔH/R)*(1/T-1/Tm)
        nzi^2

      end

    function r(xi)

        NRTLr(xi, Tx)

    end

    function e(xi)

        NRTLe(xi, Tx)

    end

    for i in 0.001:0.001:0.999

        for j in 0.001:0.001:0.999

        for k in 0.001:0.001:0.999

            if i + j + k == 1 && i/j > 1

            if round(r([i, j, k]), digits = 3) == 0

                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)

            end
            end
        end
        end
    end

    return [x_1v, x_2v, x_3v]
    
end