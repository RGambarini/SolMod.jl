function solubilityPoint(params::Dict, Tx; R = 8.314, e_1 = true, e_2 = true,
   cal_params = params["Solute"], x::Vector = [0.3, 0.2, 0.5], γi = 1,  γj = 1)

    # Inputs: 
    # 1. params = Dictionary that includes the solvents used as keys and the respective
    # interaction parameters. The solute key contains the calorimetric data of the
    # target molecule as an array
    # 2. γix = Activtiy coefficient of the i component at temperature Tx in the x compositon
    # 3. γjx = Activtiy coefficient of the j component at temperature Tx in the x compositon
    # 4. Tx = Value of the type Int64/Float64 of the temperature used to determine the
    # activity coefficient

    # Optional:
    # 1. R = Value of the type Int64/Float64 that represents the ideal gas constant. Automatically
    # set to 8.314
    # 2. e_1 = Boolean to determine the solubility of the i component in the solution. Automatically
    # set to true. If e_2 is also true, the solubility of the racemate product will be determined
    # 3. e_2 = Boolean to determine the solubility of the j component in the solution. Automatically
    # set to true. If e_1 is also true, the solubility of the racemate product will be determined
    # 4. fusΔH = Enthalpy of fusion of the solute
    # 5. Tm = Melting temperature of the solute
    # 6. fusΔH_rac = Enthalpy of fusion of the racemate
    # 7. Tm_rac = Melting temperature of the racemate

    # Solubility is modeled acording to the Schrödenberg Van Laar equation:

    # log(x_i γ_i) = (fusΔH / R) (1 / Tm - 1 / T)

    # Solubility of the racemate is modeled acording to the Prigogine and 
    # Defay equation:

    # log(4 γi γj x_i x_j) = ( 2 fusΔH_rac/R ) ( 1 / Tm_rac - 1 / T )

    # Which details that the solubility of the racemate can be easily computed with the respective
    # calorimetric properties, where fusΔH_rac is the enthalpy of fusion and Tm is the melting
    # temperature of the racemate.

    fusΔH = cal_params[1]; Tm = cal_params[2] 

    if e_1 == true && e_2 == false
        xi = x[1]
        nzi = (fusΔH/R)*(1/Tm-1/Tx)-log(γi())-log(xi)

    elseif e_1 == false && e_2 == true
        xj = x[2]
        nzi = (fusΔH/R)*(1/Tm-1/Tx)-log(γj())-log(xj)

    elseif e_1 == true && e_2 == true
        fusΔH_rac = cal_params[3]; Tm_rac = cal_params[4]
        xi = x[1]
        xj = x[2]
        nzi = (2*fusΔH_rac/R)*(1/Tm_rac-1/Tx) - (log(4) + log(γi()) + log(γj()) + log(xi) + log(xj))
    end

    nzi^2

end