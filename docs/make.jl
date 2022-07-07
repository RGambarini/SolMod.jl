push!(LOAD_PATH,"../src/")
using Documenter
using SolMod

makedocs(sitename="SolMod",
    format = Documenter.HTML(
    canonical = "https://RGambarini.github.io/SolMod.jl/main",
    assets = ["assets/logo.ico"],
    sidebar_sitename = false
),
    authors = "Roberto Gambarini.",
    pages = [
            "Home" => "index.md",
         "Background" => "background.md",
         "Basic Usage" => "basic_usage.md",
         "Available Models" => [
         "Empirical Models" => Any[
            "NRTL"=>"AvailableModels/NRTL.md",
            "UNIQUAC"=>"AvailableModels/UNIQUAC.md"]
         "Semi-Empirical Models" => Any[
            "NRTL-SAC"=>"AvailableModels/NRTL-SAC.md",
            "UNIQUAC-SAC"=>"AvailableModels/UNIQUAC-SAC.md"]
         "Custom Model" => "AvailableModels/CustomModel.md"
         ],
         "Notebook Examples" => "notebook_examples.md",
         "API" => "api.md"])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/RGambarini/SolMod.jl.git"
)