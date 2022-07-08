The Nonrandom two-liquid segment activity coefficient  model (NRTL-SAC) is an activity coefficient model used to calculate the Gibbs free energy of a non-ideal system [^1] . It is a modification to the NRTL model and it  defines the activity coefficient ``\gamma_I`` as a function of the molar composition ``x_I``. In NRTL-SAC the activity coefficient is defined in a way that:

```math
ln \gamma_I = ln \gamma_I^C + ln \gamma_I^R
```
Where ``ln \gamma_I^C`` and ``ln \gamma_I^R`` are the combinatorial and residual contributions to the activity coefficient of molecule ``I``. The residual contribution ``ln \gamma_I^R`` is defined as:

```math
ln \gamma_I^R = ln \gamma_I^{lc} = \sum_m{r_{m,I} [ln \Gamma_m^{lc} - ln \Gamma_m^{lc, I}]}
```

The residual contribution of the activity coefficient is set equal to the local composition (lc) interaction contribution ``ln \gamma_i^{lc}``. The segment activity coefficient `` \Gamma_m^{lc}`` and the segment activity coefficient for the molecule `` \Gamma_m^{lc, I}`` can be computed as follows:

```math
ln \Gamma_m^{lc} = \dfrac{\sum_{j} {\tau_{j m} G_{j m} x_{j}} }{ \sum_{k}  {G_{k m} x_{k}} } + \sum_{m'} \dfrac{x_{m'} G_{m m'}}{\sum_{k} { x_k G_{k m'}}}(\tau_{m m'} - \dfrac{\sum_{j} {x_j \tau_{j m'} G_{j m}}}{\sum_{k} {x_k G_{k m'}}})
```

```math
ln \Gamma_m^{lc, I} = \dfrac{\sum_{j, I} {\tau_{j m} G_{j m} x_{j}} }{ \sum_{k}  {G_{k m} x_{k, I}} } + \sum_{m'} \dfrac{x_{m', I} G_{m m'}}{\sum_{k} { x_{k, I} G_{k m'}}}(\tau_{m m'} - \dfrac{\sum_{j} {x_{j, I} \tau_{j m'} G_{j m}}}{\sum_{k} {x_{k, I} G_{k m'}}})
```

```math
x_j = \dfrac{\sum_J {x_J r_{j, J}}}{\sum_I \sum_i x_I r_{i, I}}
```

```math
x_{j, I} = \dfrac{r_{j, I}}{\sum_i r_{i, I}}
```

Where ```i```, ``j``, ``k``, ``m``, and ``m′`` are the segment-based species indices, ``I`` and ``J`` are the component indices, ``x_j`` is the segment-based mole fraction of segment species ``j``, ``x_J`` is the mole fraction of component ``J``, ``r_{m,I}`` is the number of segment species m contained in component ``I``. The ``G`` and ``\tau`` parameters are the same from the standard NRTL model defined by the following:

```math
G = e^{-\alpha \tau}
```

The combinatorial contribution of the activity coefficient ``ln \gamma_I^C`` is solved from the Flory-Huggins term:

```math
ln \gamma_I^C = ln \dfrac{\phi_I}{x_I} + 1 - r_I \sum_J {\dfrac{\phi_J}{x_J}}
```

```math
r_I = \sum_i {r_{i, I}}
```

```math
\phi_I = \dfrac{r_I x_I}{\sum_J r_J x_J}
```

[^1]: Chen CC, Song Y. Solubility modeling with a nonrandom two-liquid segment activity coefficient model. Industrial & engineering chemistry research. 2004 Dec 22;43(26):8354-62.