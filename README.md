[![Build status (Github Actions)](https://github.com/RGambarini/SolMod.jl/workflows/CI/badge.svg)](https://github.com/RGambarini/SolMod.jl/actions)
[![codecov.io](http://codecov.io/github/RGambarini/SolMod.jl/coverage.svg?branch=main)](http://codecov.io/github/RGambarini/SolMod.jl?branch=main)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://RGambarini.github.io/SolMod.jl/dev)

![Logo](docs/src/assets/logo_2.ico)

**SolMod.jl** is a [Julia](http://julialang.org) package used for the prediction of solubility with the focus on creating ternary phase diagrams for pharmaceutical solubility of enantiopure drugs.

Once SolMod.jl is installed, it can be loaded using:

```julia
using SolMod
```

If we want to predict a solubility curve for the single enantiomer we can use the following command:

```julia
NRTL_solubilityCurve(params, [298, 334], "Solvent", guess = 0.12, components = 3)
```