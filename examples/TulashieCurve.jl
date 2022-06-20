using SolMod, Plots

dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Parameters.xlsx"

params = NRTL_importParameters(dir, 3)

Exp = [298.15 0.1334
       308.15 0.1703
       318.15 0.2 
       323.15 0.2287
       328.15 0.2415
       333.15 0.2607]

model = Dict()

model["Diethyl Tartrate"] = NRTL_solubilityCurve(params, [298, 334], "Diethyl Tartrate", guess = 0.12, components = 3)

scatter(Exp[1:end, 1], Exp[1:end, 2], markercolor = "blue", label = "Experimental")
plot!(model["Diethyl Tartrate"][1:end, 1], model["Diethyl Tartrate"][1:end, 2], color = "blue", label = "Calculated", legend=:topleft)
plot!(xlabel = "Temperature (K)", ylabel = "Mandelic Acid in Diethyl Tartrate [mol/mol]")