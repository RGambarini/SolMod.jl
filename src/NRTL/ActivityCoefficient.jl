"""

    NRTL_activityCoefficient(params::Dict, solvent::String, Tx::Union{Float64, Int64}; 
    R::Union{Float64, Int64} = 8.314, e = false, x::Vector = [0.3, 0.2, 0.5], components::Int64 = 3)

To determine the activity coefficient of the system at the specified composition we use the NRTL activity coefficient model:

lnÎłi = â_j=1 (x_j đ_ji G_ji) / â_k=1 (x_k G_kj) + â_j=1 (x_j G_ij / â (x_k G_kj) (đ_ji - ( â_m=1 (x_m đ_mj G_mj) / â_k=1 (x_k G_kj)))) 

Îłi is the activity coefficient of component i, x is the molar fraction of the i component, and đ and G are the binary parameters that truly define the NRTL model

The interaction parameters đ and G are defined by the equations:

đ_ij = g_ij - g_jj / (T R)
G_ij = đŚ ^(-âş_ij đ_ij)

đ defines the temperature dependency in the equation. The parameter g is obtained from experimental data, where g_ij is the interaction between two components in the solution while g_jj can be chosen freely as a reference state. R is defined as the ideal gas constant. đ can then be used in the definition for G, which also contains the nonrandomness parameter âş. This parameter has no true physical meaning, and can be chosen at a value close to 0.3 in most literature

By using the boolean "e" parameter The function will find the activity coefficient of the R enantiomer and the S enantiomer

Inputs: 
1. params = Dictionary that includes the solvents used as keys and the respective interaction parameters. The solute key contains the calorimetric data of the target molecule as an array
2. solvent = String of the solvent used for the modeling
3. Tx = Value of the type Int64/Float64 of the temperature used to determine the activity coefficient

Optional:
1. R = Value of the type Int64/Float64 that represents the ideal gas constant. Automatically set to 8.314
2. e = Boolean for enantiomeric processes to determine the activity coefficient of the opposite enantiomer. Automatically set to false
3. x = Vector that includes the composition of the soluion. Automatically set to [0.3, 0.2, 0.5]
4. components = Integer value that represents the number of components in the solution. Automatically set to 3

"""
function NRTL_activityCoefficient(params::Dict, solvent::String, Tx::Union{Float64, Int64}; 
    R::Union{Float64, Int64} = 8.314, e = false, x::Vector = [0.3, 0.2, 0.5], components::Int64 = 3)
    
    âşij = params[solvent]["âş"][1, 2]; âşji = params[solvent]["âş"][2, 1]
    gij = params[solvent]["g"][1, 2]; gji = params[solvent]["g"][2, 1]
    âşik = 0; âşjk = 0; âşki = 0; âşkj = 0; gik = 0; gjk = 0; gki = 0; gkj = 0
    xi = x[1]; xj = x[2]; xk = 0

    if components == 3

        âşik = params[solvent]["âş"][1, 3]; âşjk = params[solvent]["âş"][2, 3]
        âşki = params[solvent]["âş"][3, 1]; âşkj = params[solvent]["âş"][3, 2]
        gik = params[solvent]["g"][1, 3]; gjk = params[solvent]["g"][2, 3]
        gki = params[solvent]["g"][3, 1]; gkj = params[solvent]["g"][3, 2]

        xk = x[3]

        if e == true
            xi = x[2]; xj = x[1]

            âşij = params[solvent]["âş"][2, 1]; âşik = params[solvent]["âş"][2, 3]
            âşji = params[solvent]["âş"][1, 2]; âşjk = params[solvent]["âş"][1, 3]
            âşki = params[solvent]["âş"][3, 2]; âşkj = params[solvent]["âş"][3, 1]

            gij = params[solvent]["g"][2, 1]; gik = params[solvent]["g"][2, 3]
            gji = params[solvent]["g"][1, 2]; gjk = params[solvent]["g"][1, 3]
            gki = params[solvent]["g"][3, 2]; gkj = params[solvent]["g"][3, 1]
        end
    end

    đij = gij/(R*Tx); đik = gik/(R*Tx); đji = gji/(R*Tx)
    đjk = gjk/(R*Tx); đki = gki/(R*Tx); đkj = gkj/(R*Tx)

    Gij = exp(-1*âşij*đij); Gik = exp(-1*âşik*đik)
    Gji = exp(-1*âşji*đji); Gjk = exp(-1*âşjk*đjk)
    Gki = exp(-1*âşki*đki); Gkj = exp(-1*âşkj*đkj)

    lnÎłi1 = ((Gji*xj + Gki*xk)*(đji*Gji*xj + đki*Gki*xk))/(xi+Gji*xj + Gki*xk)^2
    lnÎłi2 = (đij*Gij*xj^2 + (đij - đkj)*Gij*Gkj*xj*xk)/(Gij*xi + xj + Gkj*xk)^2
    lnÎłi3 = (đik*Gik*xk^2 + (đik - đjk)*Gik*Gjk*xj*xk)/(Gik*xi + xk + Gjk*xk)^2

    lnÎłi = lnÎłi1 + lnÎłi2 + lnÎłi3

    exp(lnÎłi)

end