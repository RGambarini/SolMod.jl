The UNIQUAC segment activity coefficient  model (UNIQUAC-SAC) is an activity coefficient model used to calculate the Gibbs free energy of a non-ideal system [^1] . It is a modification to the UNIQUAC model and it  defines the activity coefficient ``\gamma_I`` as a function of the molar composition ``x_I``. In UNIQUAC-SAC the activity coefficient is defined in a way that:

```math
ln \gamma_I = ln \gamma_I^C + ln \gamma_I^R
```
Where ``ln \gamma_I^C`` and ``ln \gamma_I^R`` are the combinatorial and residual contributions to the activity coefficient of molecule ``I``. The combinatorial contribution ``ln \gamma_I^C`` is defined as:

```math
ln \gamma_I^C = ln \dfrac{\phi_I}{x_I} + \dfrac{z}{2} q_I ln \dfrac{\theta_I}{\phi_I} + l_I - \dfrac{\phi_I}{x_I} \sum_{J} {x_J l_J}
```

and

```math
\theta_I = \dfrac{x_I q_I}{\sum_J {x_J q_J}}
```

```math
\phi_I = \dfrac{x_I r_I}{\sum_J {x_J r_J}}
```

```math
l_I = \dfrac{z}{2} (r_I - q_I) - (r_I - 1)
```

```math
r_I = \sum_K{v_K^I R_K}
```

```math
q_I = \sum_K{v_K^I Q_K}
```
The variables ``r_I`` and ``q_I`` are the volume and surface parameters of molecule ``I`` that are calculated using the segment surface area, ``Q`` , and segment volume, ``R`` , parameters as well as the number of occurrences of the segment on each molecule ``v^I_K``. ``\theta_I`` and ``\phi_I`` are surface and volume fraction of component ``I`` in the mixture, respectively. The residual part in the term of segment activity coefficient is written as:

```math
ln \gamma_I^R = ln \gamma_I^{lc} = \sum_k{v_{k}^I [ln \Gamma_k - ln \Gamma_k^I]}
```

```math
ln \Gamma_k = Q_k[1 - ln \sum_m {\Theta_m \Psi_{m k}} - \sum_m{\dfrac{\Theta_m \Psi_{m k}}{\sum_n{\Theta_n \Psi_{n m}}}}]
```

```math
\Theta_m = \dfrac{Q_m X_m}{\sum_n {Q_n X_n}}
```

```math
\Psi_{m n} = exp^{-\dfrac{U_{m n} - U_{n m}}{RT}} = exp^{-\dfrac{a_{m n}}{T}}
```

```math
X_m = \dfrac{\sum_J {v_m^J x_J}}{\sum_J \sum_n v_n^J x_J}
```

``x_I`` and ``x_J`` are the mole fractions of component ``I`` and ``J``, respectively, and the subscripts ``m``, ``n``, and ``k`` denote the segment-base species indices. ``X_m`` and ``X_m^I`` are the segment-based mole fractions of segment species in solution and in pure component ``I``, respectively.

[^1]: Haghtalab A, Yousefi Seyf J. Vapor–liquid and solid–liquid modeling with a universal quasichemical segment-based activity coefficient model. Industrial & Engineering Chemistry Research. 2015 Sep 2;54(34):8611-23.