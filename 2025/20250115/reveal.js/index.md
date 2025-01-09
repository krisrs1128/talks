
### Visualizing Microbiome Data

<div id="subtitle">
Kris Sankaran <br/>
15 | January | 2025 <br/>
Lab: <a href="https://go.wisc.edu/pgb8nl">go.wisc.edu/pgb8nl</a> <br/>
Slides: <a href="https://go.wisc.edu/">go.wisc.edu/</a><br/>
</div>

<!-- 45 minute talk -->

---

### Outline

1. Visualization Fundamentals

1. Microbiome Gallery - Single Table

1. Microbiome Gallery - Integrative

---

### Visualization Fundamentals

---

### Motivation

If our brains were built differently, we might be able to understand an entire
experiment by glancing at a spreadsheet. Unfortunately, we can only keep track
of so much information at a time.

---

### Motivation

Statistical thinking allows us to get past this limitation:

1. **Compression**: Find a simple representation that captures the essential
properties of the data. 

1. **Localization**: Narrow down to a subset of data that is sufficient to
answer a question of interest. 

(figures summarizing dimensionality reduction and differential analysis)

---

## Designing Effective Visualizations

---

### Encoding and Efficiency

Different ways of encoding information are perceived with different accuracies.
This means that any visualization implicitly prioritizes some comparisons over
others.

---

### Information Density

> Premature summarization is the root of all evil in statistics.
>
> -- Susan Holmes

Good visualizations maximize the data-to-ink ratio. Let the readers see as much
of the relevant data as possible and minimize any distracting elements.

---

### Faceting

It's often surprisingly easy to understand many related views in parallel. This technique is called "small multiples" or "faceting."

---

### Focus-plus-Context

We can let readers zoom into patterns of interest without losing relevant
context.

> Overview first, zoom and filter, then details on demand.

-- Schneiderman's "Visual Information Seeking Mantra"

---

## Microbiome Visualization

---

### MA Plot

An MA plot can be used to identify taxa that are systematically different across groups.

* $x$-axis: Average log-abundance across groups
* $y$-axis: Difference in log-abundances across groups.

---

### MA Plot

An MA plot can be used to identify taxa that are systematically different across groups.

We typically expect most taxa to have a $y$-axis value centered around 0.

---

### ECDF Plots

An empirical cumulative distribution function (ECDF) plot is a version of a histogram that doesn't require any choice of binsize. It is especially helpful in zero-inflated data.

The first jump is at the minimum value of the feature. The curve reaches 1 at
the maximum. The $x$ value when $y = 0.5$ is the median.

---

### ECDF Interpretation

Here are the ECDF plots for taxa that are differentially abundant across groups.
Curves further to the right have systematically larger abundances.

---

### Considerations

1. What scale? Different variable transformations will emphasize some
distributional differences over others.

1. Which taxa? We typically order the panels using the result of a differential
abundance analysis.

---

### Principal Components Analysis

A principal components analysis (PCA) finds the best low-dimensional linear
approximation of a high-dimensional data cloud.

---

### Resulting Map

This results in a map of the samples so that those with similar measurements are
placed close to one another.


---

### Components

The "components" in the PCA give a way of interpreting the axes of the map. The
further we move in the PC1 direction, the more we increase the positive PC1
coordinates and decrease the negative ones.

When the number of features is manageable, both the samples and components can
be shown simultaneously in a "biplot."

---

### PCA Interpretation


---

### Considerations

Like with ECDF plots, the output from a dimensionality reduction will depend on
initial original data transformations.

When there are many more features than samples, PCA can be unstable. Requiring
most of the component coordinates to be zero, like in sparse PCA, can address
this.

---

### Topic Models

Since components can have both positive and negative values, effects can
sometimes cancel out. This can complicate interpretation.

Topic models deal with this by requiring components to be nonnegative.
Therefore, they can be interpreted as latent communities.

---

### Topic Models

In this context, components are called _topics_, and each sample is a mixture of
topics.

---

### STRUCTURE Plot

The mixtures across the entire dataset can be visualized in a STRUCTURE plot.

---

### Considerations

Unlike PCA, topic models are a generative model. This allows us to evaluate model quality by comparing real with simulated samples. 

---

### Topics

We can also visualize the topics themselves. It helps to sort the taxa so that
those that have the highest diversity across topics are shown first.

---

### Alto Plot

The main hyperparameter in topic models is the number of topics $K$. It can be
helpful to compare the topic model results across a range of $K$.

---

### Alto Plot

Similar topics are often recovered across a wide range of $K$. We draw larger
edges between topics that have similar latent communities.

---

## Integration

---

### MA Plot - Revisited

1. MA plots are often helpful for identifying batch effects. 

1. Instead of comparing treatments, compare batches.  If we see systematic
differences, we know that we need to apply a batch effect correction method.

---

### Mediation Analysis

If we have precise hypotheses about how datasets might be related, we can design
visualization to evaluate them.

For example, in mediation analysis, expect the treatment to affect an omic dataset indirectly through an intermediary.

---

### Mediation Analysis

This faceted plot shows the paths with the strongest indirect effects in joint
metabolome-microbiome analysis.

---

### CCA Biplots

The exploratory analog of PCA for multiple tables is called canonical
correlation analysis (CCA).



---

### Considerations

---

### Honorable Mentions

Phylogeny, partial dependence plot, adjacency network plot, 

---