push!(LOAD_PATH,"../src/")
using Documenter
using SolMod

makedocs(sitename="SolMod",
         pages = [
            "Index" => "index.md"
         ],
         format = Documenter.HTML(prettyurls = false)
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/RGambarini/SolMod.jl.git"
)