using Documenter
using SolubilityModeling

makedocs(
    sitename = "SolubilityModeling",
    format = Documenter.HTML(),
    modules = [SolubilityModeling]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
