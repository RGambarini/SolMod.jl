function NRTL_activityCoefficient(params::Dict, solvent::String, Tx::Union{Float64, Int64}; 
    R::Union{Float64, Int64} = 8.314, e = false, x::Vector = [0.3, 0.2, 0.5], components = 3)
    
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

    # To determine the activity coefficient of the system at the specified composition we
    # use the NRTL activity coefficient model:

    # lnγi = ∑_j=1 (x_j 𝜏_ji G_ji) / ∑_k=1 (x_k G_kj) + ∑_j=1 (x_j G_ij / ∑ (x_k G_kj) (𝜏_ji - ( ∑_m=1 (x_m 𝜏_mj G_mj) / ∑_k=1 (x_k G_kj)))) 

    # γi is the activity coefficient of component i, x is the molar fraction of the i 
    # component, and 𝜏 and G are the binary parameters that truly define the NRTL model

    # The interaction parameters 𝜏 and G are defined by the equations:

    # 𝜏_ij = g_ij - g_jj / (T R)
    # G_ij = 𝘦 ^(-⍺_ij 𝜏_ij)

    # 𝜏 defines the temperature dependency in the equation. The parameter g is obtained 
    # from experimental data, where g_ij is the interaction between two components in 
    # the solution while g_jj can be chosen freely as a reference state. R is defined as 
    # the ideal gas constant. 𝜏 can then be used in the definition for G, which also contains 
    # the nonrandomness parameter ⍺. This parameter has no true physical meaning, and can be 
    # chosen at a value close to 0.3 in most literature

    # By using the boolean "e" parameter The function will find the activity coefficient of 
    # the R enantiomer and the S enantiomer
    
    ⍺ij = params[solvent]["⍺"][1, 2]; ⍺ji = params[solvent]["⍺"][2, 1]
    gij = params[solvent]["g"][1, 2]; gji = params[solvent]["g"][2, 1]
    ⍺ik = 0; ⍺jk = 0; ⍺ki = 0; ⍺kj = 0; gik = 0; gjk = 0; gki = 0; gkj = 0
    xi = x[1]; xj = x[2]; xk = 0

    if components == 3

        ⍺ik = params[solvent]["⍺"][1, 3]; ⍺jk = params[solvent]["⍺"][2, 3]
        ⍺ki = params[solvent]["⍺"][3, 1]; ⍺kj = params[solvent]["⍺"][3, 2]
        gik = params[solvent]["g"][1, 3]; gjk = params[solvent]["g"][2, 3]
        gki = params[solvent]["g"][3, 1]; gkj = params[solvent]["g"][3, 2]

        xk = x[3]

        if e == true
            xi = x[2]; xj = x[1]

            ⍺ij = params[solvent]["⍺"][2, 1]; ⍺ik = params[solvent]["⍺"][2, 3]
            ⍺ji = params[solvent]["⍺"][1, 2]; ⍺jk = params[solvent]["⍺"][1, 3]
            ⍺ki = params[solvent]["⍺"][3, 2]; ⍺kj = params[solvent]["⍺"][3, 1]

            gij = params[solvent]["g"][2, 1]; gik = params[solvent]["g"][2, 3]
            gji = params[solvent]["g"][1, 2]; gjk = params[solvent]["g"][1, 3]
            gki = params[solvent]["g"][3, 2]; gkj = params[solvent]["g"][3, 1]
        end
    end

    𝜏ij = gij/(R*Tx); 𝜏ik = gik/(R*Tx); 𝜏ji = gji/(R*Tx)
    𝜏jk = gjk/(R*Tx); 𝜏ki = gki/(R*Tx); 𝜏kj = gkj/(R*Tx)

    Gij = exp(-1*⍺ij*𝜏ij); Gik = exp(-1*⍺ik*𝜏ik)
    Gji = exp(-1*⍺ji*𝜏ji); Gjk = exp(-1*⍺jk*𝜏jk)
    Gki = exp(-1*⍺ki*𝜏ki); Gkj = exp(-1*⍺kj*𝜏kj)

    lnγi1 = ((Gji*xj + Gki*xk)*(𝜏ji*Gji*xj + 𝜏ki*Gki*xk))/(xi+Gji*xj + Gki*xk)^2
    lnγi2 = (𝜏ij*Gij*xj^2 + (𝜏ij - 𝜏kj)*Gij*Gkj*xj*xk)/(Gij*xi + xj + Gkj*xk)^2
    lnγi3 = (𝜏ik*Gik*xk^2 + (𝜏ik - 𝜏jk)*Gik*Gjk*xj*xk)/(Gik*xi + xk + Gjk*xk)^2

    lnγi = lnγi1 + lnγi2 + lnγi3

    exp(lnγi)

end