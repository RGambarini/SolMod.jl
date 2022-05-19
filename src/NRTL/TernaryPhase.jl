function NRTL_ternaryPhase(params::Dict, solvent::String, Tx; x_step::Float64 = 0.001)
  x_1v = []; x_2v = []; x_3v = []
  x_1r = []; x_2r = []; x_3r = []

  R = 8.314; fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
  fusΔH_rac = params["Solute"][3]; Tm_rac = params["Solute"][4]
  ⍺ = params[solvent]["⍺"]; g = params[solvent]["g"]
  J = 1:length(⍺[1, :]); K = 1:length(⍺[1, :]); M = 1:length(⍺[1, :])


function NRTLei(xi, T) 
  𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
  lnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
  #lnγi = 0
  nzi = (fusΔH/R)*(1/T-1/Tm)-lnγi-log(xi[1])
  nzi^2
end

function NRTLej(xi, T)
  𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
  lnγj = sum(xi[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xi[k]*G[k, 2] for k in K)+sum(xi[j]*G[2, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
  #lnγj = 0
  nzi = (fusΔH/R)*(1/T-1/Tm)-lnγj-log(xi[2])
  nzi^2
end

function NRTLr(xi, xj, T)
  𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
  #lnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
  #lnγj = sum(xi[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xi[k]*G[k, 2] for k in K)+sum(xi[j]*G[2, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
  lnγi = 0; lnγj = 0
  nzi = (2*fusΔH_rac/R)*(1/T-1/Tm_rac) - (log(4) + lnγi + lnγj + log(xi[1]) + log(xj[2]))
  nzi^2
end

function ei(xi) NRTLei(xi, Tx) end
function ej(xi) NRTLej(xi, Tx) end
function r(xi, xj) NRTLr(xi, xj, Tx) end

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

            if round(r([i, j, k], [i, j, k]), digits = 2) == 0
              append!(x_1r, i); append!(x_2r, j); append!(x_3r, k)
            end

          end
      end
    end
end

modelv = zeros(length(x_1v), 3); modelr = zeros(length(x_1r), 3)
xrow = []; row = []

  for i in range(1, length(x_1v)) modelv[i, 1] = x_1v[i] end

  for i in range(1, length(x_2v)) modelv[i, 2] = x_2v[i] end

  for i in range(1, length(x_3v)) modelv[i, 3] = x_3v[i] end

  for i in range(1, length(x_1r)) modelr[i, 1] = x_1r[i] end

  for i in range(1, length(x_2r)) modelr[i, 2] = x_2r[i] end

  for i in range(1, length(x_3r)) modelr[i, 3] = x_3r[i] end

  for i in range(1, length(modelv[1:end,1]))
      for j in range(1, length(modelr[1:end,1]))
          if modelv[i, 1:end] == modelr[j, 1:end]
              append!(xrow, [modelv[i, 1:end]])
          end
      end
  end

  row = zeros(length(xrow), 3)
  
  for i in range(1, length(xrow)) row[i, 1] = xrow[i][1] end
  for i in range(1, length(xrow)) row[i, 2] = xrow[i][2] end
  for i in range(1, length(xrow)) row[i, 3] = xrow[i][3] end

  min = row[findmin(row[1:end, 1])[2], 1:end]
  maxi = row[findmax(row[1:end, 1])[2], 1:end]

  println("Eutectic points of isotherm "*string(Tx)*"K are at composition: ")
  println("")
  println("x1: "*string(min[1])*" x2: "*string(min[2])*" x3: "*string(min[3]))
  println("x1: "*string(maxi[1])*" x2: "*string(maxi[2])*" x3: "*string(maxi[3]))
  println("")

  colx1 = findall(x -> maxi[1] > x > min[1], modelr)
  colx2 = findall(x -> maxi[2] < x < min[2], modelr)
  colx3 = findall(x -> x > min[3], modelr)
  
  col1 = zeros(length(colx1), 1)
  col2 = zeros(length(colx2), 1)
  col3 = zeros(length(colx3), 1)
  
  for i in range(1, length(colx1)) col1[i] = colx1[i][1] end
  for i in range(1, length(colx2)) col2[i] = colx2[i][1] end
  for i in range(1, length(colx3)) col3[i] = colx3[i][1] end
  
  col = trunc.(Int64, intersect(col1, col2, col3))

  modelx = zeros(length(col), 3)
  modely = zeros(length(col), 3)

  for i in range(1, length(col))
      for j in 1:3 
          modelx[i, j] = modelr[col[i], j]
      end
  end

  colx = findall(x -> x > min[3], modelv)
  
  col = zeros(length(colx), 1)
  
  for i in range(1, length(colx)) col[i] = colx[i][1] end
  
  col = trunc.(Int64, col)

  for i in range(1, length(col))
      for j in 1:3 
          modely[i, j] = modelv[col[i], j]
      end
  end

  model = vcat(modelx, modely)

  rem = []

  for i in range(1, length(model[1:end, 1]))
      if model[i, 3] <= min[3]
          append!(rem, i)
      end
  end
  
  model = model[setdiff(1:end, rem), :]

  return model

end