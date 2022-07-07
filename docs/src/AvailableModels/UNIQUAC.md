The UNIQUAC model is frequently used in the correlating experimental data for phase equilibrium. It is an extension from the quasi-chemical theory, where the local area fraction is used as the composition variable and the use of a combinatorial factor [^1] . In this model, a liquid is represented by a three-dimensional lattice sites and each molecule is divided in into individual segments. The UNIQUAC equation consists of two adjustable parameters per binary and two pure structural parameters per component. The equation for a binary mixture is:

```math
ln\gamma_1 = ln \dfrac{\phi_1}{x_1} + \dfrac{z}{2} q_1 ln \dfrac{\theta_1}{\phi_1} + \phi_2 (l_1 - \dfrac{r_1}{r_2} l_2) - q_1 ln(\theta_1 + \theta_2 \tau_{2 1})+ \theta_2 q_1(\dfrac{\tau_{2 1}}{\theta_1 + \theta_2 \tau_{2 1}} - \dfrac{\tau_{1 2}}{\theta_2 + \theta_1 \tau_{1 2}})
```

```math
l_i = \dfrac{z}{2}(r_i - q_i) - (r_i - 1)
```

The variables ``r`` and ``q`` are measures of the molecule's size and external surface area. The coordination number ``z`` can be assigned casually between values of ``6 > z > 12`` but is consistent with literature at a values of ``10``. The variable ``\phi`` and ``\theta`` are the average segment fraction and average area fraction and can be calculated as:

```math
\phi_i = \dfrac{x_i r_i}{\sum_j x_j r_j}
```
```math
\theta_i = \dfrac{x_1 q_1}{\sum_j x_j q_j}
```

``\tau`` is the adjustable binary parameter and can be defined using the equation:

```math
\tau_{i j} = e^{(-\dfrac{a_{i j}}{T})}
```

``T`` is the temperature at equilibrium, and ``a`` is the specific component interaction energy parameter obtained by the regression of experimental data. The equation for a multicomponent mixture can be defined as:

```math
ln\gamma_i = ln \dfrac{\phi_i}{x_i} + \dfrac{z}{2} q_i ln \dfrac{\theta_i}{\phi_i} + l_i - \dfrac{\phi_i}{x_i} \sum^n_{j = 1} {x_j l_j} + q_i[1 - ln(\sum^n_{j = 1} {\theta_j \tau_{j i}}) - \sum^n_{j = 1} {\dfrac{\theta_j \tau_{i j}}{\sum^n_{k = 1}{\theta_k \tau_{k j}}}}]
```

[^1]: Abrams DS, Prausnitz JM. Statistical thermodynamics of liquid mixtures: a new expression for the excess Gibbs energy of partly or completely miscible systems. AIChE Journal. 1975 Jan;21(1):116-28.