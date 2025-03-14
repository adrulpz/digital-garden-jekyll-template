---
category: research
---


[Ansys Hyperelasticity course](https://innovationspace.ansys.com/product/hyperelasticity/) where the model is mentioned and [[Notes on the ANSYS hyperelasticity course|some notes]] on it. 

## The Neo-Hookean Model

The **Neo-Hookean model** is a simple yet effective constitutive model used to describe the **nonlinear elastic behavior** of materials, especially soft materials like **rubbers, biological tissues, and inflatables**. It is a special case of **hyperelastic material models**, meaning that it derives from a **strain energy function**.
### 1. Strain Energy Function

In the Neo-Hookean model, the **strain energy density function** \( W \) (also called the strain energy potential) is given by:

$$
W = \frac{\mu}{2} (I_1 - 3) + \frac{\kappa}{2} (J - 1)^2
$$

where:

- $\mu$ is the **shear modulus**, related to material stiffness.
- $\kappa$ is the **bulk modulus**, which controls volumetric compressibility.
- $I_1$ is the **first invariant of the right Cauchy-Green deformation tensor**, given by:

  $$
  I_1 = \lambda_1^2 + \lambda_2^2 + \lambda_3^2
  $$

- where $\lambda_1$, $\lambda_2$, $\lambda_3$  are the **principal stretches**.
- $J =$ $\lambda_1$ $\lambda_2$ $\lambda_3$ is the **Jacobian determinant**, representing the volume change.

For an **incompressible material**, $J = 1$ , so the second term in  $W$  is omitted.

### 2. Stress-Strain Relationship

The **Cauchy stress tensor** for an incompressible Neo-Hookean material is:

$$
\sigma = -pI + \mu B
$$

where:

- $p$  is a **Lagrange multiplier** (acting as a pressure term to enforce incompressibility).
- $B$ is the **left Cauchy-Green deformation tensor**, defined as:

  $$
  B = F F^T
  $$

  where $F$ is the **deformation gradient**.

For a **uniaxial extension** along the **x-direction** with stretch $\lambda$, the stress simplifies to:

$$
\sigma_x = \mu \left( \lambda^2 - \frac{1}{\lambda} \right)
$$

For a **pure shear deformation**, the shear stress is:

$$
\sigma_{xy} = \mu \gamma
$$

where $\gamma$  is the **shear strain**.

### 3. Comparison to Hookean Elasticity

The **Neo-Hookean model** is a **nonlinear extension** of Hooke’s Law, useful for large deformations.

- **Hooke’s Law** (linear elasticity) assumes **small strains** and is expressed as:

  $$
  \sigma = E \epsilon
  $$

- The **Neo-Hookean model** accounts for **large deformations** while maintaining a **simple formulation**.







