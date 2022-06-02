module SolubilityModeling
using DataFrames
using XLSX

# base

include("base/base.jl")

export importSolubility
export exportSolubility
export importTernaryPhase
export exportTernaryPhase
export importExperimentalSolubility
export exportExperimentalSolubility
export importExperimentalTernaryPhase
export exportExperimentalTernaryPhase
export solubilityPoint
export ternaryPhase

# NRTL

include("NRTL/NRTL.jl")

export NRTL_importParameters
export NRTL_exportParameters
export NRTL_activityCoefficient

# NRTL-SAC
#include("NRTL-SAC/NRTL-SAC.jl")

#export NRTL_SAC_solubility
#export NRTL_SAC_ternaryPhase
#export NRTL_SAC_importParameters
#export NRTL_SAC_exportParameters

# UNIQUAC
#include("UNIQUAC/UNIQUAC.jl")

#export UNIQUAC_solubility
#export UNIQUAC_ternaryPhase
#export UNIQUAC_importParameters
#export UNIQUAC_exportParameters

# UNIQUAC-SAC
#include("UNIQUAC-SAC/UNIQUAC-SAC.jl")

#export UNIQUAC-SAC_solubility
#export UNIQUAC-SAC_ternaryPhase
#export UNIQUAC-SAC_importParameters
#export UNIQUAC-SAC_exportParameters

end # end module
