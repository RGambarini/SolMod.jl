using SolMod, Plots

dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Parameters.xlsx"

params = NRTL_importParameters(dir, 2)

dir = pathof(SolMod)[1:end-13]*"examples/Database/Calvo_Experimental.xlsx"

Exp = importSolubility(dir)

model = Dict()

for solvent in collect(keys(Exp))

    model[solvent] = NRTL_solubilityCurve(params, [280, 330], solvent, guess = 0.005, components = 2)

end

plot(model["Acetone"][1:end, 1], model["Acetone"][1:end, 2], color = "red", label = false)
scatter!(Exp["Acetone"][1:end, 1], Exp["Acetone"][1:end, 2], markercolor = "red", markershape =:circle, label = "Acetone")
plot!(model["Ethanol"][1:end, 1], model["Ethanol"][1:end, 2], color = "blue", label = false)
scatter!(Exp["Ethanol"][1:end, 1], Exp["Ethanol"][1:end, 2], markercolor = "blue", markershape =:circle, label = "Ethanol")
plot!(model["Hexane"][1:end, 1], model["Hexane"][1:end, 2], color = "green", label = false)
scatter!(Exp["Hexane"][1:end, 1], Exp["Hexane"][1:end, 2], markercolor = "green", markershape =:circle, label = "Hexane")
plot!(model["2-propanol"][1:end, 1], model["2-propanol"][1:end, 2], color = "orange", label = false)
scatter!(Exp["2-propanol"][1:end, 1], Exp["2-propanol"][1:end, 2], markercolor = "orange", markershape =:circle, label = "2-Propanol")
plot!(model["Trichloroethylene"][1:end, 1], model["Trichloroethylene"][1:end, 2], color = "purple", label = false)
scatter!(Exp["Trichloroethylene"][1:end, 1], Exp["Trichloroethylene"][1:end, 2], markercolor = "purple", markershape =:circle, label = "Trichloroethylene")
plot!(model["Heptane"][1:end, 1], model["Heptane"][1:end, 2], color = "brown", label = false)
scatter!(Exp["Heptane"][1:end, 1], Exp["Heptane"][1:end, 2], markercolor = "brown", markershape =:circle, label = "Heptane", legend=:topleft)
plot!(xlabel = "Temperature (K)", ylabel = "Palmitic Acid in Solvent [mol/mol]")