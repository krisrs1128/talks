Title: Revisiting Iterative Data Structuration: Alignment, Refinement, and Simulation
 
Abstract: There are many sources of variation in biological data — in a typical study, a statistician may be expected to sort through real variation across subjects, timepoints, environments, and sequencing technologies, not to mention nuisance variation due to batch effects and technical artifacts. To manage such analysis, it is helpful to break the task into many, more manageable pieces, beginning with simple, transparent models without losing sight of the need for models faithful to reality, as complex as it may be.
 
With this in mind, this talk revisits the idea of iterative data structuration [1, 2] from the lens of modern data visualization and generative modeling. We dive deeply into the question of choosing K in Latent Dirichlet Allocation, a popular dimensionality reduction strategy for count data in ‘omics. We develop an approach to “topic alignment,” which makes it easy to jump across models with differing K in a way that parallels hierarchical clustering [3]. Our construction suggests several natural diagnostics for quantifying topic quality; these are evaluated in a simulation study. We also demonstrate the use of an accompanying R package, alto (https://lasy.github.io/alto), for analysis of a vaginal microbiome dataset.
 
We then transition to a series of vignettes on how coupling data visualization and generation can support navigation across the space of models. We give examples from experimental design, mixture modeling, and agent-based simulation, highlighting the value of iterative data structuration as problem solving device.
 
[1] Holmes, Susan. "Comment on “A Model for Studying Display Methods of Statistical Graphics”." Journal of Computational and Graphical Statistics 2.4 (1993): 349-353.
[2] Mallows, Colin L., and John W. Tukey. "An overview of techniques of data analysis, emphasizing its exploratory aspects." Some recent advances in statistics 33 (1982): 111-172.
[3] Fukuyama, Julia, Kris Sankaran, and Laura Symul. "Multiscale Analysis of Count Data through Topic Alignment." arXiv preprint arXiv:2109.05541 (2021).

