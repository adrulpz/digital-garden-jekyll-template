---
---

### 1. Introduction

In this post, I will outline how the TMTDyn framework could be applied to the simulation and control of an inflatable robotic arm for space debris capture. My work focuses on soft robotic actuators, which at the moment are proposed as a pair of inflatable sleeves that include sealed sections to induce bending. This approach aims to create a reusable and adaptive capture mechanism, reducing mission costs and the risk of further debris generation.

TMTDyn is a MATLAB-based multi-body dynamics package that integrates hybrid rigid-continuum systems, providing an efficient method for numerical simulations and control analysis. This post will explore its potential advantages and limitations for modeling inflatable robotic arms in a space environment.

### 2. Overview of the TMTDyn Framework

TMTDyn is a MATLAB package designed for modeling and controlling hybrid rigid-continuum robots. It provides a unified framework to integrate soft robotics modeling with traditional rigid-body mechanics, using discretized lumped systems and reduced-order models. The package enables the derivation of equations of motion (EOMs) and is optimized for efficiency using C-mex functions, CAD-file imports, and a high-level language (HLL) interface.

For further details, see the [TMTDyn paper](https://journals.sagepub.com/doi/10.1177/0278364919881685): "_TMTDyn: A MATLAB Package for Hybrid Rigid-Continuum Systems_.”

#### Key Contributions:

**Two New Modeling Methods:**

- **Reduced-Order Model (ROM):** A simplified, computationally efficient approach for continuum manipulators.
- **Discretized Model:** Based on Euler-Bernoulli beam segments, which can use either:
    - **Absolute states (EBA):** Defined with respect to a global reference frame.
    - **Relative states (EBR):** Defined with respect to the previous segment.

**MATLAB-Based Simulation Package (TMTDyn):**

- Implements TMT (Vector Lagrange) dynamics for rigid and continuum systems.
- Faster than conventional finite element methods (FEM) .

**Validation and Case Studies:**

- **STIFF-FLOP robotic appendage:** Soft continuum manipulator validation.
- **Fabric sleeve on a rigid pendulum:** Tests hybrid modeling accuracy.

**Main Advantages:**

- Faster simulations compared to FEM-based solvers.
- Allows both rigid and soft robotic elements in a single framework.
- Provides automatic EOM derivation, making it more accessible to non-experts.

### 3. Application to Inflatable Robotic Arms

#### A) Modeling Inflatable Structures

**Soft Structure Representation:** My robotic arm features flexible, deformable sections, but it is unclear whether it should be treated as a continuum structure or as a segmented hybrid system, making traditional rigid-body models inadequate. TMTDyn’s Reduced-Order Modeling (ROM) approach could provide a computationally efficient alternative to FEM-based methods. However, ROM may not fully capture localized behaviors like buckling or wrinkling under pressure, which are common in inflatable systems.

**Hybrid Rigid-Soft Representation:** The arm consists of an inflatable sleeve but may require a rigid anchoring mechanism for debris capture. TMTDyn allows seamless integration of rigid and flexible components within a single framework. However, experimental validation may be needed to assess the accuracy of these interactions.

**Material Modeling Needs:** While TMTDyn supports various constitutive models, its ability to handle nonlinear hyperelastic materials, such as [[Neo-Hookean]]  or [[Mooney-Rivlin]] models, needs further evaluation. Accurately representing these materials is crucial for understanding the behavior of inflatable robotic arms.

#### B) Numerical Simulation & Equation of Motion (EOM) Derivation

- TMTDyn enables automatic EOM derivation, making it easier to analyze system dynamics without manually solving complex nonlinear equations.
    
- Unlike finite element methods (FEM), which are computationally expensive but highly accurate for large deformations, TMTDyn’s ROM approach allows for faster simulations. However, a discretized beam model might better capture localized deformations in highly flexible structures.

### 4. Key Questions for Discussion

1. **Which TMTDyn modeling approach best fits my inflatable robotic arm?**
    
    - **Reduced-Order Model (ROM):** Suitable for soft robotics with large deformations.
    - **Euler-Bernoulli Beam Model (EBA/EBR):** Provides more accurate local stress analysis, but could be computationally heavier.
    - **Would a hybrid approach (ROM + Beam model) improve accuracy while keeping computations manageable?**
2. **Handling Nonlinear Material Properties**
    
    - While TMTDyn supports various constitutive models, further evaluation is needed to determine its ability to accurately represent nylon-based inflatable structures. Unlike highly extensible elastomers, nylon has low stretchability but exhibits significant membrane tension-stiffening under pressure.
    - Would combining TMTDyn’s fast solvers with an external FEM validation improve the accuracy of simulations?

### 5. Next Steps

- Validate TMTDyn’s feasibility for modeling large, flexible, inflatable arms.
- Determine whether ROM is sufficient or if a more detailed beam-based model is needed.