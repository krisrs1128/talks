
1

- thank hosts, introduce topic

2

- omics data have many features
- example from microbiome
- main point is we go from very many species to just a few colors (community types)
- mention we'll see this figure in more detail later

3

- similar approach in single cell data
- how to read plot on right. each point a cell. those close to one another have similar expression profiles

4

- this talk focuses on the challenges we face when using these methods
- for topic modeling, choice of K
- for single cell analysis, the spurious patterns introduced by nonlinearity

5

- transition, those two challenges are the two parts of the talk
- acknowledge collaborators

6

- this is the model assumed by topic models
- x are samples (D species)
- It is a vector of counts. The probability of each coordinate comes from this multiplication
- columns of B are probability distributions, gamma mixes them.

7

- Consequence is that we learn a few underlying community types, but each sample gets its own mixture of those community types
- perhaps compare with clustering

8

- geometric interpretation of this diagram
- explain figure. two colors are two latent communities.
- heights of bars are the probabilities of the species in each community

9

- each sample is a mix of those community types

10

- the species per sample reflect those memberships. more red, then the community looks more lik the underlying red community

11

- a practical example
- each bar is a sample. colors are underlying gamma memberships
- what happened in this dataset is that during antibiotics, the community shifted
- surprising fact is that community that emerged in its place was qualitatively different

12

- challenge is the choice of number of commmunities K
- this issue was known even in the original paper that introduced topic models

13

- our main idea is that you can learn a lot by looking at several K's simultaneously
- it's more informative than picking a single K and visualizing only that
- each column is a model, each rectangle is a topic
- we add an edge showing which topics are more vs. less similar to one another

14

- the main object of interest is a graph
- we index the nodes of the graph by (v), each has a vector of memberships and a latent community
- use notation W to denote the edge weight between topics

15

- how to estimate edges?
- associate each community with a point on the simplex (each corner is one species)
- height is total amount of sample mass belonging to that topic (like number of samples in a cluster)
- in this picture, two adjacent models, with 2 and 3 topics respectively

16

- to learn the weights, solve an optimal transport problem
- mines and factories analogy

17

- once you have this graph, can develop diagnostics that aren't visible at just a single K
- example with refinement: if the edges are well defined and don't merge back into one another, then it has learned real structure

18

- simulated from a real dataset
- can anyone tell the true number of topics?

19

- this intuition is captured by the quantitative metrics
- each point is a topic from one of 200 simulation runs
- x-axis is number of topics, y-axis is the metric we just introduced
- color is the similarity between the estimated and true topics
- color is not known to us in reality but the y-values are
- so seems like it not only finds a good choice of k but it distinguishes good from bad topics when the K is too large

20

- share a small data analysis example
- vaginal microbiome has 5 well known CSTs
- one of the CSTs is associated with poor health outcomes, but also something of a "catchall"

21

- follow-up study could look into finer grained variation in that group

22

- interesting pattern is that some topics are high quality even at larger k
- main point is we have a topic level diagnostic while before we only had a model level diagnostic

23

- we have an R package if you ever want to try it out

24

- transitioning, next will discuss another kind of diagnostic focused on nonlinear embeddings of single cell data

25

- it's well documented that these methods can fail to preserve real patterns in data, like density

26

- it can even fail to preserve topology

27

- this affects real data too, you can see here that neuron en cells are spread out here but not when you tune the hyperparameters

28

- it can make clusters look artificially distinct, which caused a bit of a controversy a few years ago
- point of all-of-us study was that it was racially diverse, but that got misinterpreted

29

- there are efforts to "fix" these dimensionality reduction methods
- we took a different approach though, inspired by cartography
- it's impossible to project globe onto 2D without introducing distortion, but you can visualize the effect
- each ellipse shows what happens to a circle of the same size on the surface of the globe

30

- we adapted an idea from manifold learning literature, want to give a bit of an overview
- simple example, embedding the half sphere onto 2D plane, longitude is theta, elevation/latitude is phi

31

- formally, x is the original coordinate
- z is the embedding into two dimensions
- can you see how even this simple embedding introduces distortion?

32

- formally, this is encoded in the gradients of the embedding
- here I'm drawing gradient of z(theta) at different points on the manifold.
- the gradient is the direction on the tangent plane which most rapidly increases the function value, which is why its aligned horizontally like this
- at the equator, a small step doesn't change theta much, but near the pole, a small step covers many longitudes

33

- in the literature, the inner products between gradients for phi and theta would be stored in a metric H
- in the previous example, identity when phi is 0 (equator) and highly distorted near the edges
- difficulty is that this formula expects an analytical formula for the embedding, which we don't have

34

- but there is a theorem that relates the entries of that matrix to the laplacian
- the laplacian *can* be estimated directly from data
- so we can use it to estimate distortion

35

- in our code, estimate a laplacian from the real data
- z's are the UMAP embeddings
- substituting into the formula from before, we get the H matrices
- when this is identity, limited distortion, when far from identity, lrage distortion

36

- example simulation with different densities, truth is known

37

- locations lose the density difference, but H preserves it

38

- since we know H, we can invert it locally in the area around the mouse
- remember that orange was the denser cluster compared to blue
- the idea is to better preserve structure in the region around the mouse

39

- that was the most original approach, but our package also implements a few other checks
- first idea is to plot the original vs. embedding distances. probably always worth doing
- the outliers are points that are far apart in embedding but not in real data

40

- we count the number of outlier neighbors each point has
- if a point has many poorly preserved neighbor distances, flag that as a "fragmented neighborhood"

41

- example with swiss roll: just usual roll but I've reduced the density at the center

42

- usual t-SNE breaks the two parts at the low density region

43

- we can see those breaks very clearly
- there's also a second twist that got fragmented

44

- can also directly brush the outliers

45

- and a real dataset
- colors are different cell types, have distinct gene expression values

46

- point that stood out to us is that there are subgroups of t cells that are closer to monocytes than would be obvious at first

47

- final example, a differentiation atlas
- in this view, the broken points are at the cluster boundaries, they are split further apart than is appropriate
- similar to the all of us study

48

- at a different perplexity, the clusters are closer to one another, which is appropriate
- but the peripheral clusters are poorly spread apart unreliably
- this is like the neuron ec2 example

49

- another differentiation study
- applied ordinary UMAP and also densmap, the method that preserves density mentioned on one of the first slides

50

- estimating the local metrics, densmap is generally closer to identity, which gives some independent validation that it is better preserving the geometry of the underlying data

51

- summarizing the main results, here are links to papers and packages
- in both projects, philosophy of meta-algorithms that let us put methods into context
- generates more data to support wise application