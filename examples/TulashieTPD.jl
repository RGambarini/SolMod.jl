using SolMod, Plots, TernaryPlots

dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Parameters.xlsx"

params = NRTL_importParameters(dir, 3)

dir = pathof(SolMod)[1:end-13]*"examples/Database/Tulashie_Experimental.xlsx"

Exp = importExperimentalTernaryPhase(dir)

t = [298.15, 308.15, 318.15, 323.15, 328.15, 333.15]

model = Dict()

for i in t

    γi() = NRTL_activityCoefficient(params, "Diethyl Tartrate", i)
    γj() = NRTL_activityCoefficient(params, "Diethyl Tartrate", i, e = true)
    model[i] = ternaryPhase(params, γi, γj, i)

end

for j in range(1, length(collect(keys(model))))

    model[t[j]] = 100 .* model[t[j]]
    model[t[j]][1:end, 1], model[t[j]][1:end, 2] = model[t[j]][1:end, 2], model[t[j]][1:end, 1]

end

a = [zeros(eltype(model[t[1]]), size(model[t[1]], 1)) zeros(eltype(model[t[1]]), size(model[t[1]], 1))]
b = [zeros(eltype(model[t[2]]), size(model[t[2]], 1)) zeros(eltype(model[t[2]]), size(model[t[2]], 1))]
c = [zeros(eltype(model[t[3]]), size(model[t[3]], 1)) zeros(eltype(model[t[3]]), size(model[t[3]], 1))]
d = [zeros(eltype(model[t[4]]), size(model[t[4]], 1)) zeros(eltype(model[t[4]]), size(model[t[4]], 1))]
e = [zeros(eltype(model[t[5]]), size(model[t[5]], 1)) zeros(eltype(model[t[5]]), size(model[t[5]], 1))]
f = [zeros(eltype(model[t[6]]), size(model[t[6]], 1)) zeros(eltype(model[t[6]]), size(model[t[6]], 1))]

for i in 1:size(model[t[1]],1) a[i,:] = collect(tern2cart(model[t[1]][i,:]))' end
for i in 1:size(model[t[2]],1) b[i,:] = collect(tern2cart(model[t[2]][i,:]))' end
for i in 1:size(model[t[3]],1) c[i,:] = collect(tern2cart(model[t[3]][i,:]))' end
for i in 1:size(model[t[4]],1) d[i,:] = collect(tern2cart(model[t[4]][i,:]))' end
for i in 1:size(model[t[5]],1) e[i,:] = collect(tern2cart(model[t[5]][i,:]))' end
for i in 1:size(model[t[6]],1) f[i,:] = collect(tern2cart(model[t[6]][i,:]))' end

xa = [zeros(eltype(Exp["298.15"]), size(Exp["298.15"], 1)) zeros(eltype(Exp["298.15"]), size(Exp["298.15"], 1))]
xb = [zeros(eltype(Exp["308.15"]), size(Exp["308.15"], 1)) zeros(eltype(Exp["308.15"]), size(Exp["308.15"], 1))]
xc = [zeros(eltype(Exp["318.15"]), size(Exp["318.15"], 1)) zeros(eltype(Exp["318.15"]), size(Exp["318.15"], 1))]
xd = [zeros(eltype(Exp["323.15"]), size(Exp["323.15"], 1)) zeros(eltype(Exp["323.15"]), size(Exp["323.15"], 1))]
xe = [zeros(eltype(Exp["328.15"]), size(Exp["328.15"], 1)) zeros(eltype(Exp["328.15"]), size(Exp["328.15"], 1))]
xf = [zeros(eltype(Exp["333.15"]), size(Exp["333.15"], 1)) zeros(eltype(Exp["333.15"]), size(Exp["333.15"], 1))]

for i in 1:size(Exp["298.15"],1) xa[i,:] = collect(tern2cart(Exp["298.15"][i,:]))' end
for i in 1:size(Exp["308.15"],1) xb[i,:] = collect(tern2cart(Exp["308.15"][i,:]))' end
for i in 1:size(Exp["318.15"],1) xc[i,:] = collect(tern2cart(Exp["318.15"][i,:]))' end
for i in 1:size(Exp["323.15"],1) xd[i,:] = collect(tern2cart(Exp["323.15"][i,:]))' end
for i in 1:size(Exp["328.15"],1) xe[i,:] = collect(tern2cart(Exp["328.15"][i,:]))' end
for i in 1:size(Exp["333.15"],1) xf[i,:] = collect(tern2cart(Exp["333.15"][i,:]))' end

ternary_axes(
    title="Mandelic Acid",
    xguide="R-Enantiomer",
    yguide="Diethyl Tartrate",
    zguide="S-Enantiomer",
)

p = scatter!(a[:,1],a[:,2], markerstrokewidth=0, label = false,
markercolor = "red", markersize = 2)
p = scatter!(b[:,1],b[:,2], markerstrokewidth=0, label = false,
markercolor = "pink", markersize = 2)
p = scatter!(c[:,1],c[:,2], markerstrokewidth=0, label = false,
markercolor = "green", markersize = 2)
p = scatter!(d[:,1],d[:,2], markerstrokewidth=0, label = false,
markercolor = "blue", markersize = 2)
p = scatter!(e[:,1],e[:,2], markerstrokewidth=0, label = false,
markercolor = "orange", markersize = 2)
p = scatter!(f[:,1],f[:,2], markerstrokewidth=0, label = false,
markercolor = "purple", markersize = 2)
p = scatter!(xa[:,1],xa[:,2], markerstrokewidth=1,markercolor = "red", markersize = 4, 
label = "298.15 K", markershape =:circle)
p = scatter!(xb[:,1],xb[:,2], markerstrokewidth=1,markercolor = "pink", markersize = 4, 
label = "308.15 K", markershape =:hexagon)
p = scatter!(xc[:,1],xc[:,2], markerstrokewidth=0.5,markercolor = "green", markersize = 4, 
label = "318.15 K", markershape =:rect)
p = scatter!(xd[:,1],xd[:,2], markerstrokewidth=1,markercolor = "blue", markersize = 4, 
label = "323.15 K", markershape =:star5)
p = scatter!(xe[:,1],xe[:,2], markerstrokewidth=1,markercolor = "orange", markersize = 4, 
label = "328.15 K", markershape =:diamond)
p = scatter!(xf[:,1],xf[:,2], markerstrokewidth=0.5,markercolor = "purple", markersize = 4, 
label = "333.15 K", legend =:topleft, markershape =:star6)