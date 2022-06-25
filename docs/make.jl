push!(LOAD_PATH,"../src/")
using Documenter
using SolMod

makedocs(sitename="SolMod",
    format = Documenter.HTML(
    canonical = "https://RGambarini.github.io/SolMod.jl/",
    assets = ["assets/solmod_logo.ico"]
),
    author = "Roberto Gambarini.",
    pages = [
            "Home" => "index.md"
         ],
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/RGambarini/SolMod.jl.git"
)