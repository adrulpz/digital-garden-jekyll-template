---
title: Inflatables MeshFEM Simulation Library
category: research
---
These are my technical notes on how the MeshFEM simulation pipeline for inflatables works, based on my understanding of the repository at [MeshFEM Inflatables](https://github.com/MeshFEM/Inflatables). They include details on how mesh inputs are defined, how regions are tagged and mapped, and how the physical simulation and output stages are handled.
 
>[!warning] Work in progress  
> These notes are based on my current understanding from experimenting with the MeshFEM Inflatables simulator. I’ve tried to be accurate, but things might be missing or misunderstood, and I’ll likely update this as I keep testing and learning.


## 1. Simulation Pipeline Overview

At a high level, the workflow proceeds as follows:
1. **Geometric definition**: Users define 2D outline geometry using vertex and edge data encoded in Wavefront OBJ files. The geometry specifies the external boundary as well as internal seams or structures via polylines.
2. **Region annotation**: Two additional files annotate the geometry:

	  - **Fused points** identify 2D coordinates where the top and bottom layers of the sheet are to be permanently bonded. These regions remain non-inflatable and function as walls or seams.

	  - **Hole points** (optional) identify internal locations where meshing and inflation should be suppressed, typically representing apertures or excluded areas.
	   
3. **Meshing**: The library performs constrained 2D triangulation using the boundary edges, generating a triangle mesh suitable for subsequent finite element simulation. Fused and hole regions are respected during this process by applying region-specific tagging and exclusion rules. 

4. **Physical model construction**: The triangulated domain is used to instantiate an `InflatableSheet` object. This object encapsulates the geometry, material parameters, and simulation state. 

5. **Inflation simulation**: The inflation behavior is computed using a Newton-Raphson solver that minimizes a total energy functional composed of:

	  - **In-plane stretch energy**
	
	  - **Bending energy**
	  
	  - **Pressure-volume coupling**	
	
6. **Visualization and analysis**: Simulation results are visualized either interactively in a Jupyter environment or offscreen for video rendering. The mesh deformation, seam behavior, and internal pressure response can be inspected at each time step.

## 2. Mesh Input Specification  

Unlike typical FEM packages that rely on volumetric or face-based mesh inputs, the Inflatables library accepts **purely curve-based geometry**. Input is given as:  

- A `.obj` file containing:

  - Lines of the form `v x y 0.0`, specifying 2D vertices in the plane.

  - Edges of the form `l i j`, specifying line segments between vertex indices.

  - No face (`f`) elements are used; surface connectivity is inferred via triangulation.  

- Fused point file (`*_fusedPts.txt`): a plain-text file with one `(x, y)` coordinate per line.  

- Hole point file (`*_holePts.txt`): similar structure, optional. These points serve as internal markers guiding the triangulator to remove interior regions.  

All input geometry is assumed to lie in the XY plane, with Z initialized to zero. The triangulator automatically constructs a conforming mesh using a quality-constrained Delaunay-like algorithm, and assigns triangle labels according to fused/hole logic.  

## 3. Sheet Meshing and Region Mapping  

The meshing routine `sheet_meshing.forward_design_mesh()` is the central function that converts the input curves into a simulation-ready mesh. It internally builds a signed distance field, resolves connectivity, and tags mesh triangles as belonging to inflatable areas, fused walls, or hole (excluded) regions.

A critical modelling feature is the treatment of **fused points** as locations with zero vertical displacement during inflation — effectively constraining those areas and preventing them from expanding like the surrounding membrane.

## 4. Physical Simulation Model  

Once meshing is complete, the physical model is constructed via the `InflatableSheet` class. This class supports a reduced shell model assuming two bonded, pressure-separated sheets. The deformation is driven by an internal pressure term and resisted by membrane and bending forces.

Users can configure:

- Sheet **thickness** (affects bending stiffness)

- **Young’s modulus** (material elasticity)

- **Tension field energy** (eliminates artificial compressive stress to mimic wrinkling)

- **Projected Hessian** use (for numerical stability)  


The inflation process is executed via the `inflation.inflation_newton()` function, which implements an iterative energy minimization scheme with support for user-defined callbacks (e.g., video capture, monitoring, or interactive updates).

## 5. Visualization and Output

Two primary tools are provided for visual output:

- `TriMeshViewer`: for real-time or notebook-based 3D visualization

- `OffscreenTriMeshViewer`: for producing high-resolution video renderings offscreen
 

Camera positioning can be precisely controlled using `setCameraParams((position, up, target))`, enabling fixed-plane views (XY, XZ, etc.) or custom orientations for documentation or presentation.

  Vertex trajectories can be tracked and recorded over time, and multiple runs can be benchmarked using the built-in profiler.  

## 6. Limitations and Assumptions  

- **Self-contact and collision** are not modeled. No repulsion or intersection penalty terms are included in the energy functional. Users seeking to avoid self-intersections must ensure appropriate geometric design or implement custom repulsion energies.

- **No volumetric modeling**: All simulations are performed on 2.5D sheets (surface inflation). Volume-preserving inflatables or fully 3D forms are outside the scope of this library.

- **Input validation is minimal**: Dangling vertices or malformed edge topologies can lead to meshing or simulation errors. Users are expected to pre-process and verify input geometry.  



