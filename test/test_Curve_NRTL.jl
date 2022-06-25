using SolMod, Test

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Parameters.xlsx"

    params = NRTL_importParameters(dir, 2)

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Experimental.xlsx"

    Exp = importExperimentalSolubility(dir)

    import_exp_solubility = Exp["Trichloroethylene"][4, 2]

@test import_exp_solubility == 0.1562

    model = Dict()

    model["Trichloroethylene"] = NRTL_solubilityCurve(params, [280, 330], "Trichloroethylene", guess = 0.005, components = 2)
    
    solubility_curve =  model["Trichloroethylene"][10, 2]

@test solubility_curve == 0.055663957224097324