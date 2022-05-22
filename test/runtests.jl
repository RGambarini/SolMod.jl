using Test, SolubilityModeling # This load both the test suite and our Package

params = Dict()

params["Solute"] = [24500 404.65 25600 387.75]

params["Diethyl Tartrate"] = Dict()
params["Diethyl Tartrate"]["⍺"] = [0 0.979748 0.40104 ; 0.979748 0 0.40104; 0.40104 0.40104 0 ]
params["Diethyl Tartrate"]["g"] = [0 216631 25269 ; 141879 0 25269; -3235.6 -3235.6 0 ]

out = NRTL_ternaryPhase(params, "Diethyl Tartrate", [298.0])[298.0][1000]

@test out == 0.115               # This is the actual test condition. You can add as many tests as you wish.