using Test, SolMod

    ideal = ideal_activityCoefficient()

@test ideal == 1

    dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Parameters.xlsx"

    params = NRTL_importParameters(dir, 3)

    import_params = params["Solute"][2]

    t = 298.15

    γi() = ideal_activityCoefficient()
    γj() = ideal_activityCoefficient()

    solubility_point = solubilityPoint(params, t, γi = γi, γj = γj)

@test solubility_point == 11.194194287941198