using SolMod, Test

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Parameters.xlsx"

    params = NRTL_importParameters(dir, 2)

    NRTL_exportParameters(params, 2, "test.xlsx")

    export_params_c2 = isfile("test.xlsx")

@test export_params_c2 == true
    
    rm("test.xlsx")

    export_params_c1 = NRTL_exportParameters(params, 1, "test.xlsx")
    
    export_params_c1 = NRTL_exportParameters(params, 4, "test.xlsx")
    
    dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Experimental.xlsx"

    Exp = importSolubility(dir)

    import_solubility = Exp["Trichloroethylene"][4, 2]

@test import_solubility == 0.1562

    exportSolubility(Exp, "test.xlsx")

    export_solubility = isfile("test.xlsx")

@test export_solubility == true
        
    rm("test.xlsx")

    model = Dict()

    model["Trichloroethylene"] = NRTL_solubilityCurve(params, [280, 330], "Trichloroethylene", guess = 0.005, components = 2)
    
    solubility_curve_c2 =  model["Trichloroethylene"][10, 2]

@test solubility_curve_c2 == 0.055663957224097324

    error = errorAnalysis(model["Trichloroethylene"], Exp["Trichloroethylene"], 2)
    
    error_analysis_c2 = error[4, 3]

@test error_analysis_c2 == 0.12833632631001185

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Parameters.xlsx"

    params = NRTL_importParameters(dir, 3)

    import_params = params["Solute"][2]

@test import_params == 404.65

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Experimental.xlsx"

    Exp = importTernaryPhase(dir)

    import_TPD = Exp["298.15"][3, 1]

@test import_TPD == 13.22

    exportTernaryPhase(Exp, "test.xlsx")

    export_tp = isfile("test.xlsx")

@test export_tp == true

    rm("test.xlsx")

    t = 298.15

    model = Dict()

    γi() = NRTL_activityCoefficient(params, "Diethyl Tartrate", t)
    γj() = NRTL_activityCoefficient(params, "Diethyl Tartrate", t, e = true)
    model[t] = ternaryPhase(params, γi, γj, t)

    tpd = model[t][100, 1]

@test tpd == 0.015

    error = errorAnalysis(model[t], Exp[string(t)], 3)
    error_analysis_c3 = error[4, 4]

@test error_analysis_c3 == 80.94808747586319

    model["Diethyl Tartrate"] = NRTL_solubilityCurve(params, [298, 334], "Diethyl Tartrate", guess = 0.12, components = 3)
    
    solubility_curve_c3 =  model["Diethyl Tartrate"][10, 2]

@test solubility_curve_c3 == 0.16399940624342582

    NRTL_exportParameters(params, 3, "test.xlsx")

    export_params_c3 = isfile("test.xlsx")

@test export_params_c3 == true
    
    rm("test.xlsx")

    m_params = UNIQUAC_FredenslundParameters([["CH3", "CH2"], ["CH3", "CH2"], ["H2O"]])

@test m_params[2, 1] == 1.5755

    i_params = Dict()

    i_params["Solvent"] = [ 0.821005  0.303414  0.356109
                            0.897201  0.242129  0.098042
                            0.967782  0.469891  0.320051]

    uniquac_ac = UNIQUAC_activityCoefficient(i_params, m_params, 298, "Solvent")

@test uniquac_ac == 1.2038400308711088