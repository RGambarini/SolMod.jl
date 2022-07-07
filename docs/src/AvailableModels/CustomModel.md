One of the key features of SolMod.jl is modularity. The objective was to have a software that was able to switch between different methods of obtaining solubility through the calculation of the activity coefficient. SolMod.jl produces two fundamental processes simultaneously: 1. Calculate the activity coefficient at a specified temperature and composition 2. Check for the solubility at the same temperature and composition. We can use the built-in methods of obtaining the activity coefficient or we can customize this method. The way this is achieved is by declaring the activity coefficient as a function:

```julia
γi() = customActivityCoefficient(x, T)

# In this case x and T represent the temperature and composition
```

The custom method we just declared can be any number of alternative methods to obtain the activity coefficient. This can be a predefined dataframe of activity coefficients or using more robust methods available online. After finding the method to calculate the activity coefficient it is only a matter of using it in the rest of the calculations:

```julia
γi() = customActivityCoefficient(xi, T)
γj() = customActivityCoefficient(xj, T)

model = ternaryPhase(parameters, γi, γj, T)

# i and j refer to the identity of the enantiomers
```
[Clapeyron.jl](https://github.com/ypaul21/Clapeyron.jl) is a package for the use and development of thermodynamic models natively in Julia. This software includes a comfortable list of equations such as SAFT, cubic, activity, multi-parameter, and COSMO-SAC. This package served as the inspiration for the development of SolMod.jl and I hope that it only furthers the applicability of Clapeyron.jl.

[Thermopack](https://github.com/SINTEF/thermopack) is a thermodynamic model library for fluids written in Fortran. This package contains a flexible Python wrapper that can be called using [PyCall](https://github.com/JuliaPy/PyCall.jl). Python code can be easily called and used in Julia using the PyCall functions and serves to the ease-of-use of Python in Julia.