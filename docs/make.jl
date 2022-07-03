push!(LOAD_PATH,"../src/")
using Documenter
using SolMod

makedocs(sitename="SolMod",
    format = Documenter.HTML(
    canonical = "https://RGambarini.github.io/SolMod.jl/"
),
    authors = "Roberto Gambarini.",
    pages = [
            "Home" => "index.md",
         "Background" => "background.md",
         "Basic Usage" => "basic_usage.md",
         "Notebook Examples" => "notebook_examples.md",
         "To-do list" => "to-do_list.md",
         
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