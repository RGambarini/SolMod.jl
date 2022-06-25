using Documenter
using SolMod

makedocs(
    sitename = "SolMod",
    format = Documenter.HTML(),
    modules = [SolMod]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

=deploydocs(
    repo = "github.com/RGambarini/SolMod"
)
