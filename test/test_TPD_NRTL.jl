using Test, SolMod

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Parameters.xlsx"

    params = NRTL_importParameters(dir, 3)

    import_params = params["Solute"][2]

@test import_params == 404.65

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Experimental.xlsx"

    Exp = importExperimentalTernaryPhase(dir)

    import_expTPD = Exp["298.15"][3, 1]

@test import_expTPD == 13.22

    t = 298.15

    model = Dict()

    γi() = NRTL_activityCoefficient(params, "Diethyl Tartrate", t)
    γj() = NRTL_activityCoefficient(params, "Diethyl Tartrate", t, e = false)
    model[t] = ternaryPhase(params, γi, γj, t)

    tpd = model[t][100, 1]

@test tpd == 0.017

    error = errorAnalysis(model[t], Exp[string(t)], 3)
    error_analysis = error[4, 4]

@test error_analysis == 80.94808747586319