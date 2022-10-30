# Multiscale modeling for describing the immune system

## References
* "Systems Biology in Immunology: A Computational Modeling Perspective" Ronald N. Germain, Martin Meier-Schellersheim, Aleksandra Nita-Lazar, and Iain D.C. Fraser, The Annual Review of Immunology 2011 [[download]](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3164774/)    
* "Key Role of Local Regulation in Chemosensing Revealed by a New Molecular Interaction-Based Modeling Method" Martin Meier-Schellersheim, Xuehua Xu, Bastian Angermann, Eric J. Kunkel, Tian Jin, Ronald N. Germain, PLoS Computational Biology 2006 [[download]](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.0020082)    
* "T cell migration, search strategies and mechanisms" Matthew F. Krummel, Frederic Bartumeus and Audrey Gérard, Nature Reviews Immunology 2016 [[download]](https://www.nature.com/articles/nri.2015.16)
###



## Brief introduction to codes...
* flocking model   
This code generates flocking model in Julia.
Most code is based on [agents.jl](https://juliadynamics.github.io/Agents.jl/stable/examples/flock/).   
And I just made little modification.   
* tcell     
This code is pseudo implementation of immune system modeling.    
Initial goal is to make model just for single D cell and T cell.    

## Notes   
* Maybe I can apply the differential equation(PDE) to IL-2 diffusion using [DifferentialEquations.jl](https://diffeq.sciml.ai/stable/)

## 2022/10/25 weekly meeting  
* We made some assumptions for model implementation.   
  1. Movement pattern of Tcell and Dcell : [random walk(brownian motion)](https://juliadynamics.github.io/Agents.jl/dev/api/)  
  2. All Tcell can be activated by all Dcells.  
  3. Tcell-Dcell interaction lasts 24hours and secrete IL-2  
  4. Each Tcell get activated either from Dcell or IL-2 field. **But initial activation must be invoked by Dcell.**   
  
* Characteristics of each cells  
- Tcell 
  - radius : 5 $mu m
