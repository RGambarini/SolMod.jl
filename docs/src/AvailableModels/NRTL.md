The Nonrandom two-liquid model (NRTL) is an activity coefficient model to calculate the Gibbs free energy of a non-ideal system. It  defines the activity coefficient ``\gamma_i`` as a function of the molar composition ``x_i``. This model has been used in  chemical engineering applications and has been used in a wide variety of mixtures calculating vapour-liquid and liquid-liquid equilibria [^1] . The NRTL equation of a binary system is as follows:

```math
ln \gamma_1 = x_2^2[\tau_{2 1} (\dfrac{G_{2 1}}{x_1 + x_2 G_{2 1}})^2+\dfrac{\tau_{1 2} G_{1 2}}{(x_2 + x_1 G_{1 2})^2}]
```
where

```math
G_{1 2} = e^{-\alpha_{1 2}\tau_{1 2}} \\
G_{2 1} = e^{-\alpha_{2 1}\tau_{2 1}} \\
\tau_{1 2} = \dfrac{(g_{1 2} - g_{2 2})}{RT} \\
\tau_{2 1} = \dfrac{(g_{2 1} - g_{1 1})}{RT}
```

In the NRTL model the ``R`` is the universal gas constant, ``T`` is the temperature at equilibrium, ``G`` is a dimensionless interaction parameter, that depends on a the specific component interaction energy parameter ``g`` and a non-randomness factor ``\alpha``. The two energy parameters ``(g_{1 2} - g_{2 2})`` and ``(g_{2 1} - g_{1 1})`` are adjustable values obtained by the regression of experimental data. ``alpha_{1 2}`` and ``alpha_{2 1}`` are the two adjustable non-randomness parameters. Experimental data for a large number of systems show that they range from ``0.20`` to ``0.47``. It is sometimes chosen casually as it has no physical correlation [^2].

The equation for a multicomponent system is as follows:

```math
ln \gamma_i = \dfrac{\sum_{j=1}^C {\tau_{j i} G_{j i} x_{j}} }{ \sum_{j=1}^C  {G_{j i} x_{j}} } + \sum_{j=1}^C \dfrac{x_j G_{i j}}{\sum_{k=1}^C { x_k G_{k j}}}(\tau_{i j} - \dfrac{\sum_{k=1}^C {x_k \tau_{k j} G_{k j}}}{\sum_{k=1}^C {x_k G_{k j}}})
```

[^1]: Renon H, Prausnitz JM. Estimation of parameters for the NRTL equation for excess Gibbs energies of strongly nonideal liquid mixtures. Industrial & Engineering Chemistry Process Design and Development. 1969 Jul;8(3):413-9.
[^2]: Chen FX, Qi ZL, Feng L, Miao JY, Ren BZ. Application of the NRTL method to correlate solubility of diosgenin. The Journal of Chemical Thermodynamics. 2014 Apr 1;71:231-5.