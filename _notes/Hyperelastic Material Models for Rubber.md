---
category: research
---

based on [[A comparison among Neo-Hookean model, Mooney-Rivlin model, and Ogden model for chloroprene rubber]] 

The Neo-Hookean and Mooney-Rivlin models are hyperelastic material models defined by the strain energy density function derived from the invariants of the left Cauchy-Green deformation tensor.

---
#### Neo-Hookean Model

The Neo-Hookean model is a hyperelastic material model that predicts the stress-strain behavior of materials, paralleling Hooke’s law. It is one of the simpler models, with the strain energy density function for incompressible Neo-Hookean materials expressed as:

$$ W = C_1 (\bar{I}_1 - 3) $$
where:
- $C_1$​ is a material constant.
- $\bar{I}_1$ ​ is the first invariant of the  left Cauchy-Green deformation tensor.

However, the Neo-Hookean model is known to become inaccurate at large strains.

---

#### Mooney-Rivlin Model

The Mooney-Rivlin model, introduced by Melvin Mooney and Ronald Rivlin, improves upon the Neo-Hookean model by including a second invariant of the deformation tensor, allowing better accuracy for larger strains.

The strain energy density function is expressed as:

$$W = C_1 (\bar{I}_1 - 3) + C_2 (\bar{I}_2 - 3)$$

where:

- $C_1$​ and $C_2$ are empirically determined material constants.
- $\bar{I}_1$ ​​ and $\bar{I}_2$ ​ are the first and second invariant of the deviatoric component of the left Cauchy -Green deformation tensor.

The shear modulus $G$ is related to the material constants by:

$$G=2 (C_1 + C_2)$$

The Mooney-Rivlin model is widely used for rubber-like materials and allows the shear modulus to be defined as a function of temperature. Although it has limitations under specific stress states, it is commonly applied for strains up to approximately 200%.

---

### Ogden Model

The Ogden model is highly effective for predicting the nonlinear stress-strain behaviour of materials like rubbers and polymers, particularly under large deformations of up to 700%. It is frequently used for the analysis of components such as O-rings and seals.

Unlike the Neo-Hookean and Mooney-Rivlin models, which are expressed in terms of invariants, the Ogden model uses the principal stretch ratios $\lambda_j$

The strain energy density function is given by:

$$W = \sum_{i=1}^N \frac{\mu_i}{\alpha_i} \left( \lambda_1^{\alpha_i} + \lambda_2^{\alpha_i} + \lambda_3^{\alpha_i} - 3 \right)$$ 
where:

- $\lambda_j$ (for $j=1,2,3$) are the principal stretch ratios.
- $\mu_i$​ and $\alpha_i$​ are empirically determined material constants.
- $N$ is the number of terms used to fit experimental data.

The Ogden model is widely regarded for its accuracy and flexibility in capturing large strain behaviour.