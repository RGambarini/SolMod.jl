module SolubilityModeling
using DataFrames
using Roots
using XLSX

# NRTL

include("NRTL/NRTL.jl")

export NRTL_model
export NRTL_exportModel
export NRTL_importParameters
export NRTL_exportParameters
export NRTL_importExperimentalData
export NRTL_exportExperimentalData

# NRTL-SAC
#include("NRTL-SAC/NRTL-SAC.jl")

#export NRTL-SAC_model
#export NRTL-SAC_plot
#export NRTL-SAC_table
#export NRTL-SAC_exportModel
#export NRTL-SAC_importParameters
#export NRTL-SAC_exportParameters
#export NRTL-SAC_importExperimentalData
#export NRTL-SAC_exportExperimentalData

# UNIQUAC
#include("UNIQUAC/UNIQUAC.jl")

# UNIQUAC-SAC
#include("UNIQUAC-SAC/UNIQUAC-SAC.jl")

end # end module
