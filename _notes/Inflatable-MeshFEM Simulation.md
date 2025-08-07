---
title: Exploring Inflatable Structure Simulation Using the MeshFEM Framework
category: research
---
As part of an early validation stage for my research, I’ve been testing the capabilities of the [MeshFEM Inflatables simulator](https://github.com/MeshFEM/Inflatables), developed by Panetta et al., to assess whether it can capture the deformation behaviour of inflatable structures designed using alternative strategies.

In particular, I began with a simplified configuration inspired by the **Aeromorph** design approach, which uses heat-sealed diamond patterns to induce controlled bending upon inflation. The assumption is that the seam is inextensible, so when the outer membrane stretches, the sealed region resists extension — producing a predictable bend.

The seam geometry and associated dimensions are shown below:

<figure>
  <img src="assets/aeromorph-bending.png" alt="Aeromorph bending angle">
  <figcaption>
    Figure 1. The width of the hinge diamond stays constant when the structure is inflated, causing the material to bend. Source: <a href="https://dl.acm.org/doi/10.1145/2984511.2984520">J Ou et al. , 2016</a>.
  </figcaption>
</figure>


In the Aeromorph paper, the resulting angle can be derived using the law of cosines:
$$
\theta = \arccos\left(\frac{a^2 + b^2 - w^2}{2ab}\right)
$$

Where:
- $\ a$ and $\ b$ are the lengths from the centre of the diamond to its left and right tips,
- $\ w$ is the original width of the sealed seam.

This formula gives the bending angle that preserves the seam width as the structure deforms. In this experiment, I use this setup to check whether the MeshFEM simulator reproduces that expected deformation behaviour — even though the original simulator wasn’t developed for this kind of forward geometric reasoning.


---
## On the Scope of the MeshFEM Inflatables Pipeline

While the full simulation pipeline introduced by Panetta et al. is designed to support **inverse design**, generating surface seams to match a desired 3D target , my current focus lies exclusively in the **forward simulation** stage.

<figure>
  <img src="assets/computational-pipeline.png" alt="Computational pipeline">
  <figcaption>
    Figure 2. Overview of the computational pipeline for inverse design of inflatables. Colors in the layouts indicate connected components of the air channel boundary curves. Blue dots in the zoom highlight the air channel wall vertices that are the unknowns in the design optimization. Source: <a href="https://julianpanetta.com/publication/inflatables/">J. Panetta et al., 2021</a>.
  </figcaption>
</figure>

Rather than targeting a specific deployed shape, I provide **predefined geometries and seam regions**, and use the simulator purely to compute the resulting deformation under internal pressure.

---
## Setup and Starting Point

The [MeshFEM Inflatables repository](https://github.com/MeshFEM/Inflatables) includes a small set of Jupyter notebook examples to demonstrate usage. Since the environment is tailored for Ubuntu, I set up the simulator on a virtual machine and ran the provided demos to confirm everything was working correctly before making modifications.

Among the available notebooks, the one that served as my entry point was:

- `ForwardDesign.ipynb` — a minimal forward inflation scenario based on predefined mesh and seam data
<figure>
  <img src="assets/demo-fw.png" alt="Forward design examples result">
  <figcaption>
    Figure 3. Mesh generated using the `ForwardDesign.ipynb` example in the MeshFEM Inflatables repository, along with the resulting deformation after inflation.
  </figcaption>
</figure>

Running this notebook helped clarify the types of input files the simulator expects: primarily a `.obj` file defining boundary curves (no faces), along with one or more `.txt` files containing lists of "fused" or "hole" points.

To generate these inputs, I wrote a MATLAB script to export the required `.obj` and `.txt` files (for borders and seam masks, respectively). I then parsed them into the simulator using its forward design interface. I experimented with boundary pinning, pressure levels, and seam density to explore how much bending behaviour could be tuned using only this minimal input.

The MATLAB script I developed allows flexible specification of the input geometry. I can define an arbitrary number of vertices to outline the outer pouches and the central diamond, as well as control the density and distribution of fused points, to simulate the heat-sealed regions used in physical prototypes.

The figure below shows one of the exported configurations, with vertex labels, connected line segments, and fused seam points highlighted.

<figure>
  <img src="assets/matlab-pre.png" alt="Matlab Plot">
  <figcaption>
    Figure 4. Exported geometry generated in MATLAB for forward simulation. Vertices are labeled, line connectivity is shown in green, and blue dots indicate the fused seam region.
  </figcaption>
</figure>

