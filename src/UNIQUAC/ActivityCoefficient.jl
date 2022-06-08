function UNIQUAC_activityCoefficient(i_params::Dict, m_params::Matrix, solvent::String, Tx::Union{Float64, Int64}; 
  e = false, x::Vector = [0.3, 0.2, 0.5], z::Int64 = 10)

  # Inputs: 
  # 1. params = Dictionary that includes the solvents used as keys and the respective
  # interaction parameters. The solute key contains the calorimetric data of the
  # target molecule as an array
  # 2. solvent = String of the solvent used for the modeling
  # 3. Tx = Value of the type Int64/Float64 of the temperature used to determine the
  # activity coefficient

  # Optional:
  # 1. R = Value of the type Int64/Float64 that represents the ideal gas constant. Automatically
  # set to 8.314
  # 2. e = Boolean for enantiomeric processes to determine the activity coefficient of the
  # opposite enantiomer. Automatically set to false
  # 3. x = Vector that includes the composition of the soluion. Automatically set to [0.3, 0.2, 0.5]

  xi = x[1]; xj = x[2]; xk = x[3]

  r = m_params[1:end, 1]
  q = m_params[1:end, 2]
  q_p = m_params[1:end, 3]

  ⍺ij = i_params[solvent][1, 2]; ⍺ik = i_params[solvent][1, 3]; ⍺ji = i_params[solvent][2, 1]
  ⍺jk = i_params[solvent][2, 3]; ⍺ki = i_params[solvent][3, 1]; ⍺kj = i_params[solvent][3, 2]

  if e == true

    xi = x[1]; xj = x[2]
    r = [r[2], r[1], r[3]]
    q = [q[2], q[1], q[3]]
    q_p = [q_p[2], q_p[1], q_p[3]]
    
    ⍺ij = i_params[solvent][2, 1]; ⍺ik = i_params[solvent][2, 3]; ⍺ji = i_params[solvent][1, 2]
    ⍺jk = i_params[solvent][1, 3]; ⍺ki = i_params[solvent][3, 2]; ⍺kj = i_params[solvent][3, 1]

  end
  
  𝜏ij = exp(-⍺ij/Tx); 𝜏ik = exp(-⍺ik/Tx); 𝜏ji = exp(-⍺ji/Tx)
  𝜏jk = exp(-⍺jk/Tx); 𝜏ki = exp(-⍺ki/Tx); 𝜏kj = exp(-⍺kj/Tx)

  li = (z/2)*(r[1]-q[1]) - (r[1] - 1)
  lj = (z/2)*(r[2]-q[2]) - (r[2] - 1) 
  lk = (z/2)*(r[3]-q[3]) - (r[3] - 1)

  ɸi = (r[1]*xi)/((r[1]*xi)+(r[2]*xj)+(r[3]*xk)) 
  ɸj = (r[2]*xj)/((r[1]*xi)+(r[2]*xj)+(r[3]*xk))
  ɸk = (r[3]*xk)/((r[1]*xi)+(r[2]*xj)+(r[3]*xk))

  θi = (q[1]*xi)/((q[1]*xi)+(q[2]*xj)+(q[3]*xk))
  θj = (q[2]*xj)/((q[1]*xi)+(q[2]*xj)+(q[3]*xk))
  θk = (q[3]*xk)/((q[1]*xi)+(q[2]*xj)+(q[3]*xk))

  θ_pi = (q_p[1]*xi)/((q_p[1]*xi)+(q_p[2]*xj)+(q_p[3]*xk))
  θ_pj = (q_p[2]*xj)/((q_p[1]*xi)+(q_p[2]*xj)+(q_p[3]*xk))
  θ_pk = (q_p[3]*xk)/((q_p[1]*xi)+(q_p[2]*xj)+(q_p[3]*xk))

  lnγiA = log(ɸi/xi) + (z/2)*q[1]*log(θi/ɸi) + li - ((ɸi*(xi*li + xj*lj + xk*lk))/xi)
  lnγiB = 1 - log(θ_pi + θ_pj*𝜏ji + θ_pk*𝜏ki) - (θ_pi/(θ_pi + θ_pj*𝜏ji + θ_pk*𝜏ki)) - (θ_pj*𝜏ij/(θ_pi*𝜏ij + θ_pj + θ_pk*𝜏kj)) - (θ_pk*𝜏ik/(θ_pi*𝜏ik + θ_pj*𝜏jk + θ_pk))

  lnγi = lnγiA + q[1]*lnγiB

  exp(lnγi)
  
end