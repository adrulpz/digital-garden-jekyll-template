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

---
## Exploring Design Variations and Their Effects

This section focuses on how I modified and tested different aspects of the input geometry and simulation setup to evaluate their influence on bending behaviour. Rather than diving into the internal workings of the simulator, I focus here on the practical effects of geometry, boundary conditions, and seam layout.

(For implementation-specific details on how MeshFEM handles meshing, region tagging, and simulation mechanics, see [[MeshFEM|Inflatables MeshFEM Simulation Library]])

### Initial Test: Flat Inflation Without Bending

As a first test, I created the simplest layout to represent an inflatable arm — a rectangular sheet with three internal diamond shapes placed where joints would be. The idea was to mimic the typical structure of soft inflatable arms, which bend at specific hinge points along their length.

The input geometry included just the rectangle corners and the corner points of each diamond. I also placed one fused point at the centre of each diamond to represent a minimal seam. No hole regions were defined.

When I ran the simulation, the structure inflated uniformly but remained completely flat — there was no out-of-plane bending at all. The result showed that a single central seam point wasn’t enough to induce bending.

<div style="text-align: center;">
	<video controls width="600">
  <source src="assets/sleeve3.mp4" type="video/mp4">
	</video>
</div>

This led to a key insight: to simulate a hinge, the diamond must be **divided along its horizontal axis** to create two triangular regions.

From this, some design questions emerged:

- Can the direction of bending be controlled through the placement of fused points?    
- Should fused points lie only along the hinge line, or also fill the surrounding area?    
- How many fused points are needed to produce a noticeable bend?
    

After splitting the diamonds along this axis, I observed that bending did occur, but it wasn’t directional. The structure bent, but whether it bent upward or downward wasn’t predictable. This lack of control led me to simplify the geometry further to see whether seam layout could influence bending direction.

I reduced the setup to a single central diamond and tested three seam configurations:

1. **Fused points placed along the hinge line** (the shared edge between the two triangles)    
2. **Three fused points in a triangular pattern within each triangle**, simulating a more distributed seam region    
3. **A single fused point** at the centre of the diamond (still part of the hinge line)    

The third case — **just one fused point at the centre** — was sufficient to produce a clear out-of-plane bend. The mesh triangulation became asymmetric due to that single constraint, and the resulting deformation appeared to follow the direction of that asymmetry.

<div style="text-align: center;">
  <video controls width="600">
    <source src="assets/hingev3.mp4" type="video/mp4">
    Your browser does not support the video tag.
  </video>
  <p><em>Simulation showing asymmetric triangulation and  bending resulting from a single fused point.</em></p>
</div>


At this stage, I believed that a geometric imbalance in the mesh near the seam region might be influencing the bending direction. However, this was just an early interpretation that I would later question as more tests were conducted.

Additionally, this version showed better simulation stability: there were no issues with boundary self-contact, which had occurred in earlier tests with more fused points.

### Refining Geometry to Explore Bending Angle

Next, I adjusted the dimensions of the structure so that the two outer pouches (or links) would each be square, with dimensions 10×10. This made the total sheet 10×20, creating a simplified configuration to begin testing the geometric relationship between diamond shape and bending angle.

My goal was to explore whether modifying the shape of one triangle within the diamond would produce a bend that matched the expected outcome from the cosine rule described earlier. Although I didn’t yet get to fully asymmetric links, I expected the inflated shape to show a clear difference in bending angle. However, based on visual inspection alone, this difference wasn’t immediately obvious — which led me to start looking for a way to extract and quantify the angle without relying on perception alone.

<figure style="text-align: center;">
  <img src="assets/angle-visual-check.png" alt="Comparison of simulated bends">
  <figcaption><em>
    Side-by-side screenshots from different simulation runs. Despite varying the triangle geometry, the bending angle differences are not visually obvious — highlighting the need for a more objective way to quantify deformation.
  </em></figcaption>
</figure>


Along the way, I also found that the final inflated mesh can be exported as a `.obj` file. I haven’t made use of that yet, but it could be useful later for tasks like measuring deformation, importing into other tools for analysis, or generating visual comparisons between designs.

### Moving Toward Angle Extraction Through Point Tracking

At this point, I wasn’t sure how to extract any useful numerical values from the inflated geometry. But since the simulation generates the mesh dynamically and inflates it over a series of time steps, I realized I could try **tracking the motion of specific points** throughout the inflation cycle. By saving their positions over iteration, I could reconstruct the bend and calculate the angle based on how those points move.

This raised two immediate questions:
1. Which points should I track?
2. How can I reliably locate them in the actual simulation mesh?

Because the triangulated mesh is generated internally from the input curves, there's no guarantee that a user-defined point , like the corner of the rectangle, will correspond exactly to a vertex in the final mesh. And since I had originally defined only a few key vertices (like the rectangle corners), I was concerned that none of them would align exactly with what I wanted to track.

That’s what led me to increase the number of vertices in the input geometry. By adding more points along the rectangle’s edges and interior, I improved the chances that the triangulated mesh would include nodes close enough to serve as **reliable tracking anchors**.

Initially, I tried selecting mesh vertices by comparing the simulation mesh (`m.vertices()`) to a set of fixed 3D target coordinates using simple distance matching. However, this approach didn’t yield reliable results. To solve this, I switched to a more robust method using the rest wall vertex positions and a KDTree for nearest-neighbour search.

---
In the next part, I’ll briefly explain how I selected the specific points to track, the role of the pinned point in the simulation, and how I eventually computed the bending angles based on the tracked motion.







