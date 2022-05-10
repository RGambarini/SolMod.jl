using Documenter
using SolubilityModeling

push!(LOAD_PATH,"../src/")
makedocs(sitename = "SolubilityModeling.jl Documentation",
    pages = [
        "Index" => "index.md",
        "An other page" => "anotherPage.md",
     ],
     format = Documenter.HTML(prettyurls = false)
)
# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "https://github.com/RGambarini/SolubilityModeling.jl.git",
    devbranch = "main"
)
