Once SolMod is installed, it can be loaded using:

```julia
using SolMod
```
# Importing Parameters

We import our parameters from .xlsx files that contain the dataframe necessary to produce a solubility calculation. This format is used to exploit the use of sheets as the parameters for different solvents. The first sheet contains the calorimetric data of the enantiomeric molecule and the racemate:

| fusΔH |  Tm  | fusΔH_rac | Tm_rac |
| :---: | :--: | :-------: | :----: |
| 24,500|404.65|     25,600|  387.75|

The data frame is imported as a dictionary to the workspace. When specifying parameters of 3 components, the function will automatically import the calorimetric properties of the racemate as well:

```julia
params = NRTL_importParameters(dir, 3)

params["Solute"] = 24500  404.65  25600  387.75
```

The parameters specify the interaction values determined from either experimental or predicted values. Interaction parameters are model specific, in this case we will use those defined by the NRTL model:

|⍺_1|⍺_2|⍺_3|g_1|g_2|g_3|
|:-:|:-:|:-:|:-:|:-:|:-:|
|0|0.98|0.40|0|216,631|25,269|
|0.98||0|0.40|141,879|0|25,269|
|0.40|0.40|0|-3,235.60|-3,235.60|0|

The dataframe is imported as a dictionary with the key entry labelled as the solvent used:

```julia
params["Solvent"]["⍺"] = [0         0.979748  0.40104
                          0.979748  0         0.40104
                          0.40104   0.40104   0      ]

params["Solvent"]["g"] = [0       216631  25269
                          141879  0       25269
                          -3235.6 -3235.6 0    ]
```
!!! note

    Although SolMod imports parameters from .xlsx files, nothing stops you from creating the parameter dataframes directly in Julia. Parameters in SolMod are read as dictionaries. Examples like the one above are shown to demonstrate the output of the import function and how to replicate it yourself.

# Binary Curve

With the parameters imported, we can use the model to determine the activity coefficient. We want to predict a solubility curve for the S-enantiomer. The curve will range from  ``298 K``  to  ``334 K``  and an initial guess of the composition of  ``0.12 \dfrac{mol}{mol}`` :

```julia
NRTL_solubilityCurve(params, [298, 334], "Solvent", guess = 0.12, components = 3)
```

We can also obtain an error analysis using SolMod. We will get an output of the residuals from the experimental data and the RMSD (Root Mean Square Deviation). The RMSD of predicted values  ``\hat{x}``  for times a with variables observed over  ``A``  times, is computed for  ``A``  different predictions as the square root of the mean of the squares of the deviations:

```math
RMSD = \sqrt{\dfrac{\sum_{a=1}^A{(\hat{x}_a - x_a)^2}}{|A|}}
```

```julia
errorAnalysis(model, experimental, 2)
```

# Ternary Phase Diagram

Now we can do what this software was created for and predict ternary phase behaviour. We want to start by defining the method we will use to calculate the activity coefficient for component **i** (S-enantiomer) and for component **j** (R-enantiomer). For example calculating the activity coefficient using the NRTL model at  ``298 K`` :

```julia
γi() = NRTL_activityCoefficient(params, "Solvent", 298)
γj() = NRTL_activityCoefficient(params, "Solvent", 298, e = false)
```

Once the activity coefficient methods are set, we want to check solubility over every possible point at a specific temperature using the ternaryPhase function:

```julia
model = ternaryPhase(params, γi, γj, 298)
```

Similar to before we can obtain the error analysis related to the ternary phase diagram with the same function as before but increasing the number of components to 3:

```julia
errorAnalysis(model, experimental, 3)
```

# Next Steps

After this is done, we can either plot the diagrams inside Julia using [TernaryPlots.jl](https://github.com/jacobusmmsmit/TernaryPlots.jl) or using [PyCall](https://github.com/JuliaPy/PyCall.jl) to plot with [Matplotlib](https://github.com/marcharper/python-ternary) or [Plotly](https://plotly.com/python/ternary-plots/). 

If Julia is not your software of choice for plotting, then you can make use of SolMod's export features an save the dataframe created as an .xlsx file:

```julia
exportTernaryPhase(model, "TPD.xlsx")
```

This process can then be repeated across multiple temperatures and using different activity coefficient methods. One of the goals of this project was modularity. The many ways to obtain the activity coefficient requires the user to employ various methods to obtain accurate predictions. By separating the method to obtain the activity coefficient with the prediction of solubility we give the user the freedom to experiment with the calculations.

After learning the basic usage of this software you can read a more thorough analysis with results using the jupyter notebooks in the [notebook examples](https://rgambarini.github.io/SolMod.jl/dev/notebook_examples/) section, read more on the various models available, or [export an existing method](https://rgambarini.github.io/SolMod.jl/dev/AvailableModels/CustomModels/) to calculate the activity coefficient.