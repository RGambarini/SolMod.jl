function UNIQUAC_activityCoefficient(i_params::Dict, m_params::Matrix, Tx::Union{Float64, Int64}, 
  solvent::String; e = false, x::Vector = [0.3, 0.2, 0.5], z::Int64 = 10,
  components = 3)

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

  xn = [x[1] x[2] 0]; r = [m_params[1, 1] m_params[2, 1] 0]; q = [m_params[1, 2] m_params[2, 2] 0]
  q_p = [m_params[1, 3] m_params[2, 3] 0]

  l = [((z/2)*(r[1]-q[1])-(r[1] - 1)) ((z/2)*(r[2]-q[2])-(r[2] - 1)) 0]

  ⍺ = [0                       i_params[solvent][1, 2] 0
      i_params[solvent][2, 1] 0                       0
      0                       0                       0]

  𝜏 = [0            exp(-⍺[1, 2]/Tx) 0
      exp(-⍺[2, 1]/Tx) 0            0
      0            0            0]


  if components == 3

  xn = [xn[1] xn[2] x[3]]; r = [r[1] r[2] m_params[3, 1]]; 
  q = [q[1] q[2]  m_params[3, 2]]; q_p = [q_p[1] q_p[2]  m_params[3, 3]]

  l = [l[1] l[2] ((z/2)*(r[3]-q[3])-(r[3] - 1))]

  ⍺ = [0                       i_params[solvent][1, 2] i_params[solvent][1, 3]
          i_params[solvent][2, 1] 0                       i_params[solvent][2, 3]
          i_params[solvent][3, 1] i_params[solvent][3, 2] 0                      ]

  𝜏 = [exp(-⍺[1,1]/Tx) exp(-⍺[1,2]/Tx) exp(-⍺[1,3]/Tx)
          exp(-⍺[2,1]/Tx) exp(-⍺[2,2]/Tx) exp(-⍺[2,3]/Tx)
          exp(-⍺[3,1]/Tx) exp(-⍺[3,2]/Tx) exp(-⍺[3,3]/Tx)]

  if e == true

      xn = [xn[2] xn[1] xn[3]]; r = [r[2] r[1] r[3]]; 
      q = [q[2] q[1]  q[3]]; q_p = [q_p[2] q_p[1]  q_p[3]]
      
      l = [l[2] l[1] l[3]]

      ⍺ = [0                       i_params[solvent][2, 1] i_params[solvent][2, 3]
          i_params[solvent][1, 2] 0                       i_params[solvent][1, 3]
          i_params[solvent][3, 2] i_params[solvent][3, 1] 0                      ]

      𝜏 = [exp(-⍺[1,1]/Tx) exp(-⍺[1,2]/Tx) exp(-⍺[1,3]/Tx)
          exp(-⍺[2,1]/Tx) exp(-⍺[2,2]/Tx) exp(-⍺[2,3]/Tx)
          exp(-⍺[3,1]/Tx) exp(-⍺[3,2]/Tx) exp(-⍺[3,3]/Tx)]

  end

  end

  ɸ = [(r[1]*xn[1])/(sum(r[j]*xn[j] for j=1:components)) (r[2]*xn[2])/(sum(r[j]*xn[j] for j=1:components)) (r[3]*xn[3])/(sum(r[j]*xn[j] for j=1:components))]
  θ = [(q[1]*xn[1])/(sum(q[j]*xn[j] for j=1:components)) (q[2]*xn[2])/(sum(q[j]*xn[j] for j=1:components)) (q[3]*xn[3])/(sum(q[j]*xn[j] for j=1:components))]
  θ_p = [(q_p[1]*xn[1])/(sum(q_p[j]*xn[j] for j=1:components)) (q_p[2]*xn[2])/(sum(q_p[j]*xn[j] for j=1:components)) (q_p[3]*xn[3])/(sum(q_p[j]*xn[j] for j=1:components))]

  lnγi = log(ɸ[1]/xn[1]) + (z/2)*q[1]*log(θ[1]/ɸ[1])+l[1]-(ɸ[1]/xn[1])*sum(xn[j]*l[j] for j=1:3)+q_p[1]*(1-log(sum(θ_p[j]*𝜏[j, 1] for j=1:components)) - sum((θ_p[j]*𝜏[1,j])/sum(θ_p[k]*𝜏[k,j] for k=1:components) for j=1:components))

  exp(lnγi)
  
end