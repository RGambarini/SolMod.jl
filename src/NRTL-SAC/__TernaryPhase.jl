function NRTL-SAC_ternaryPhase(params::Dict, solvent::String, Tx; x_step::Float64 = 0.001, 
  pp = true, round1::Int64 = 3, round2::Int64 = 3, round3::Int64 = 1)
  x_1v = []; x_2v = []; x_3v = []
  x_1r = []; x_2r = []; x_3r = []

# Inputs: 
# 1. params = Dictionary that includes the solvents used as keys and the respective
# interaction parameters. The solute key contains the calorimetric data of the
# target molecule as an array
# 2. solvent = String of the solvent used for the modeling
# 3. Tx = Temperature used for isotherm of the ternary phase diagram

# Optional:
# 1. x_step = Step size of the molar composition increments
# 2. pp = Post-processing of the output array will be done to remove any points beyond the
# eutectic points
# 3. round# = This affects the sensitivity of the solubility equation. This rounds to the
# specified number of digits after the decimal place. Automatically set to 3 for the
# solubility of the enantiomers and 1 for the solubility of the racemate

# To determine the activity coefficient of the system at the specified composition we
# use the NRTL activity coefficient model:

# lnγi = ∑_j=1 (x_j 𝜏_ji G_ji) / ∑_k=1 (x_k G_kj) + ∑_j=1 (x_j G_ij / ∑ (x_k G_kj) (𝜏_ji - ( ∑_m=1 (x_m 𝜏_mj G_mj) / ∑_k=1 (x_k G_kj)))) 

# γi is the activity coefficient of component i, x is the molar fraction of the i 
# component, and 𝜏 and G are the binary parameters that truly define the NRTL model

# The interaction parameters 𝜏 and G are defined by the equations:

# 𝜏_ij = g_ij - g_jj / (T R)
# G_ij = 𝘦 ^(-⍺_ij 𝜏_ij)

# Solubility is modeled acording to the Schrödenberg Van Laar equation:

# log(x_i γ_i) = (fusΔH / R) (1 / Tm - 1 / T)

# Solubility of the racemate is modeled acording to the Prigogine and 
# Defay equation:

# log(4 γi γj x_i x_j) = ( 2 fusΔH_rac/R ) ( 1 / Tm_rac - 1 / T )

# Which details that the solubility of the racemate can be easily computed with the respective
# calorimetric properties, where fusΔH_rac is the enthalpy of fusion and Tm is the melting
# temperature of the racemate.

# 𝜏 defines the temperature dependency in the equation. The parameter g is obtained 
# from experimental data, where g_ij is the interaction between two components in 
# the solution while g_jj can be chosen freely as a reference state. R is defined as 
# the ideal gas constant. 𝜏 can then be used in the definition for G, which also contains 
# the nonrandomness parameter ⍺. This parameter has no true physical meaning, and can be 
# chosen at a value close to 0.3 in most literature

# The function will find the activity coefficient of the R enantiomer and the S enantiomer
# and checks if the Schrödenberg Van Laar equation and the Prigogine and Defay equation 
# is correct. This is done for every molar composition possible. When the solubility equation
# is true, the molar composition is appended to an array. The array is then processed to remove
# solubility points beyond the eutectic points

  R = 8.314; fusΔH = params["Solute"][1]; Tm = params["Solute"][2]
  fusΔH_rac = params["Solute"][3]; Tm_rac = params["Solute"][4]
  ⍺ = params[solvent]["⍺"]; g = params[solvent]["g"]
  J = 1:length(⍺[1, :]); K = 1:length(⍺[1, :]); M = 1:length(⍺[1, :])


  function NRTLei(xi, T) 
    𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    lnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    #lnγi = 0
    nzi = (fusΔH/R)*(1/Tm-1/T)-lnγi-log(xi[1])
    nzi^2
  end

  function NRTLej(xi, T)
    𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    lnγj = sum(xi[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xi[k]*G[k, 2] for k in K)+sum(xi[j]*G[2, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    #lnγj = 0
    nzi = (fusΔH/R)*(1/Tm-1/T)-lnγj-log(xi[2])
    nzi^2
  end

  function NRTLr(xi, xj, T)
    𝜏 = g/(T*R); G = (ℯ*ones(size(⍺))).^(-1*⍺.*𝜏)
    lnγi = sum(xi[j]*𝜏[j, 1]*G[j, 1] for j in J)/sum(xi[k]*G[k, 1] for k in K)+sum(xi[j]*G[1, j]/sum(xi[k]*G[k, j] for k in K)*(𝜏[1, j]-(sum(xi[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xi[k]*G[k, j] for k in K))) for j in J)
    lnγj = sum(xj[j]*𝜏[j, 2]*G[j, 2] for j in J)/sum(xj[k]*G[k, 2] for k in K)+sum(xj[j]*G[2, j]/sum(xj[k]*G[k, j] for k in K)*(𝜏[2, j]-(sum(xj[m]*𝜏[m, j]*G[m, j] for m in M)/sum(xj[k]*G[k, j] for k in K))) for j in J)
    #lnγi = 0; lnγj = 0
    nzi = (2*fusΔH_rac/R)*(1/Tm_rac-1/T) - (log(4) + lnγi + lnγj + log(xi[1]) + log(xj[2]))
    nzi^2
  end

  function ei(xi) NRTLei(xi, Tx) end
  function ej(xi) NRTLej(xi, Tx) end
  function r(xi, xj) NRTLr(xi, xj, Tx) end

  for i in 0.001:x_step:0.999
      for j in 0.001:x_step:0.999
        for k in 0.001:x_step:0.999

            if i + j + k == 1

              if round(ei([i, j, k]), digits = round1) == 0 && i/j > 1
                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)
              end

              if round(ej([i, j, k]), digits = round2) == 0 && i/j < 1
                append!(x_1v, i); append!(x_2v, j); append!(x_3v, k)
              end

              if round(r([i, j, k], [i, j, k]), digits = round3) == 0
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

  if pp == true

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

    a = round(abs(100*(min[1]-min[2])/(min[1]+min[2])), digits = 2)
    b = round(abs(100*(maxi[1]-maxi[2])/(maxi[1]+maxi[2])), digits = 2)

    println("Eutectic points of isotherm "*string(Tx)*"K are at composition: ")
    println("")
    println("x1: "*string(min[1])*" x2: "*string(min[2])*" x3: "*string(min[3]))
    println("x1: "*string(maxi[1])*" x2: "*string(maxi[2])*" x3: "*string(maxi[3]))
    println("")
    println("Enantiomeric Excess = "*string(a)*"% - "*string(b)*"%")
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
  
  else

    return vcat(modelv, modelr)

  end

end