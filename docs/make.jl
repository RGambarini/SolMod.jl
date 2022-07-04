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
         "Background" => "Background.md",
         "Basic Usage" => "Basic_Usage.md",
         "Notebook Examples" => "Notebook_Examples.md",
         "To-do list" => "To-Do_List.md",
         
         "Available Models" => [
         "Empirical Models" => Any[
            "Wilson"=>"AvailableModels/Wilson.md",
            "NRTL"=>"AvailableModels/NRTL.md",
            "UNIQUAC"=>"AvailableModels/UNIQUAC.md"]
         "Semi-Empirical Models" => Any[
            "NRTL-SAC"=>"AvailableModels/NRTL-SAC.md",
            "UNIQUAC-SAC"=>"AvailableModels/UNIQUAC-SAC.md"]
         "Predictive Models" => Any[
            "PC-SAFT"=>"AvailableModels/PC-SAFT.md"]
         ]])

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.

deploydocs(
    repo = "github.com/RGambarini/SolMod.jl.git"
)