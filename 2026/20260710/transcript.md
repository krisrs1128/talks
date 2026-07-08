
---

### Title

I'm very excited to be here. Thank you to all the organizers for putting together such a nice retreat.

Today I'm going to be sharing some new methods for visualizing omics data, if
you'd like to follow along you can find the slides at this link.

---

### Visualization

My background is statistics, and one of the first things you learn in statistics
classes is that you should never trust statistics.  Here is a famous example
called Anscombe's quartet, which is a dataset where the key summary statistics
(like the mean, SD, regression line and R^2) are all equal even though the data
look very different. If you had only computed the summary statistics, you would
be missing out on a lot of important information.

---

### Visualization

Have you seen this example before? This was a fun paper that took the same idea and automatically generated many types of data again wtih the same summary statistics.

---

###  How many times larger is the circle on the right?

It's one thing to say you should plot your data, but it's another thing to plot
your data well. This is an example that, when I first learned about it, really
made it clear what an impact visualization has.

Right now, I'd like you all to raise your hands. I'm going to ask how many times larger (in area) the circle on the right is relative to the circle on the left. When I get to what you think is the answer, lower your hand.

1 times
2 times, lower your hand

---

### How many times taller is the bar on the right

Same question, but now let's look at the barplot. 2x, 3x, ...

Okay, so the correct answer in both cases was 7x. But it seesm we were much more
accurate with the barplot example.

---

### Encoding and efficiency

And this is a general finding. The x-axis is how much error people made when you
crowdsource the example I just gave.

Positional encoding is alwasy more accurate. Area
using circular areas is not so clear.

---

### Visualizing High Dimensions

The rest of this talk is in the same spirit, but focused on omics data. These
are more complex than the example I just gave, because we measure expression
over many genes or species at once. I'll argue that some of the common
visualizations in this space are sort of like the circle example, we aren't
making conclusions as accurately as we could if we visualized them using
different methods.

---

### Focus-plus-context

I'll walk through two examples, both apply the same problem solving technique, based on the focus-plus-context principle. The idea of the principle is to allow users to query details within a specific region without the broader context.

Here is a map of the UCLA campus that exactly matches this principle. The
satellite view is the focus, the roadmap of the LA area is the context. I'm not
showing it here, but you can pan and zoom in both the focus and context and they
can be used to navigate the area.

---

### Phylobar

So this is the first paper that we're going to go over. The name comes from the
fact that we're creating barplots that are linked with phylogenetic trees.

---

### Motivation

One of the most common visualizations in microbiome research is the stacked
barplot. Each column is a sample. The colors are different bacterial taxonomies.
It lets you study bacterial composition across many samples. For example, here
you can see that chloroflexi is more common within a particular temperature
range.

---

### Challenges

The basic problem of this visualization is that we can only distinguish so many
colors at a time. Usually we add colors for the most common species and all the
rest get placed into an "other" group.

---

### Challenges

If you don't use "other," it becomes very messy. Here's actually the website
associated with the paper that I just showed on the previous page. It's a bit
crazy and I swear I didn't cherry pick this. See, I'll follow the link. This is
really what it looks like.

---

### Approach

Here's the solution that we came up with. The basic observation is that you can
usually organize strains into a hierarchical structure, so that strains that are
more similar to one another appear close to each other on the tree. Then, we are
able to bypass setting the color palette in advance -- we can create it
interactively  by painting this tree.

---

### Interactions

Here's a recording showing how it works. We can introduce new colors by pressing
they keyboard. When I hover over a taxonomic group in the tree, the associated
taxonomic group lights up in the barplot.

---

### Interactions

If you have a large tree, it can help to collapse the nodes. We keep the barplot
and the tree synchronized, so that only the leaves in the original tree are
visible in the associated bar plot.

---

### Interactions

Here's another example. This one shows that when we hover over the rectangles, it also highlights the tree.

---

### Pseudobulk data

Even though we were motivated by microbiome data, I wanted to mention that it's
useful for pseudobulk data too. This is an example from a COVID-19 immune cell
composition study. The patients are sortedd from least to most severe COVID
cases. the paper gave a discussion of how T vs. meyeloid cell composition
changed in relation to COVID. But one thing they missed but which is immediately
obvious when you use phylobar to zoom in is that the gamma-delta cells are only
present in the less severe covid cases.

---

### Notebooks

Even though I'm showing you this example in a browser, it can be embedded into R quarto notebooks.

---

### Distortion Visualization

Okay, so that's how the focus-plus-context technique can improve visualization
for stacked bar plots. Next, I'd like to demonstrate focus-plus-context to
improve UMAP.

---

### Distortions in $t$-SNE adn UMAP

If you've ever run nonlinear dimensionality reduction for omics data, you
probably  used either $t$-SNE or UMAP. Despite being so popular, these methods
have documented limitations. For example, it's well known that they fail to
preserve density. Here, the data are just 2D, there are six clusters but they
have very different sizes. If you just run vanillay UMAP /t-SNE they fail to
preserve density.

The idea in this paper was to modify the UMAP objective so that it must also
preserve density. We'll revisit this method later during our examples.

---

### Distortions in $t$-SNE adn UMAP

Another failure mode is that it can completely fail to preserve the original
topology of the data, at least if you don't initialize it properly.

---

### Consequences

Okay, no one is every going to try running t-SNE on a ring. But these artifacts
have real biological consequences. Jessica will be here later at CGSI -- here is
an amazing example from one of her papers where if you use the default t-SNE
hyperparameters, it looks like these neuron ec2, 3, 5 cells are split all across
the visualization. But if you tune perplexity using their scDEED method, they
are all placed close to one another in a reasonable way.

---

### Approach

From a focus-plus-context perspective, the idea is to overlay extra information
that helps ensure the interpretations are accurate. The two types of informatino
we overlay are local distortion and fragmentation, in a sense that we'll make
precise.

---

### Precedent

This idea actually has a precedent from the 19th centruty. The cartographer (X.)
A basic fact in cartography is that if you try projecting the surface of the
earth onto a two-dimensional plane, then you cannot preserve all angles and
distances perfectly. That's why there are many types of map projection methods.

Tissot's idea is that you should overlay how a unit circle gets distorted in
different parts of the map projection. This circle near the equator has the same
physical area on the map as this larger circle near the poles.

---

### Local Distortion

We adapt an idea from about ten years ago in machine learning, called the
RMetric algorithm, which is able to output a similar kind of distortion estimate
even when we don't have an analytical formula for the embedding map. The
ellipses we show in our plots exactly show how a unit circle in the original
omics expression space would be warped by the embedding.

---

### Example Interpretation

---

### Example Interpretation

---

### Example Interpretation

---
