
---

Title Slide

1. Introduce your name and position. 
1. Mention that any microbiome paper is going to include data visualizations and
that you hope they can leave the talk with some new visualizations/general
strategies for improving their visualizations.
1. Mention that you want this to be something like a tutorial. This is an
audience with quite wide ranging interests and not necessarily trained in
statistics. I'm hoping that everyone can leave with something useful.

---

Designing Effective Visualizations

1. This talk is divided into two parts. In the first, I'll give a crash course on some fundamental concepts from data visualization.
1. In the second, I'm going to review a variety of visualization techniques that
I think are especially useful for microbiome work.

---

Motivation - 1

1. I can imagine a universe where data visualization is completely unecessary. If our brains were wired so that we could glance at spreadsheets and understand them, there would be no need.

1. But the reality is that our visual systems have evolved so that certain
representations can be processed much more efficiently than others. For example,
these numeric codes store the colors that are used in this lion image, but only
the image makes immediate sense.

---

Motivation  - 2

1. Here is another example. If two concepts are related to
one another, then an edge is drawn between them. For some questions, this list view is much less efficient than the network view.

1. For example, if I ask you how many steps there are between turing and infinity, it's immediate from the graph, but takes a bit more work for the list.

1. Give the definition of visualization. The more that we can leverage our
perception and lift the burden on memory, the better we'll be able to reason
about data.

---

Strategy

A second general motivation is that people actually have relatively limited
working memories. Even PhDs in statistics can only remember so many digits at a
time. In fact, a lot of statistics is about turning larger datasets into
reductions that we can hold in our heads and which are nonetheless faithful.

1. First, we can compress complex phenomena into summaries that can be fit
effectively in our working memory. For example, later, we'll be talking about
principal components, and this type of plot compresses a large dataset into a
much smaller representation.

1. The second general strategy is to focus attention onto subsets of the data
that are especially interesting. For example, later we'll talk a bit about
differential abundance analysis. This can be thought of as a focusing technique,
helping narrow to just the taxa that are worth our attention.

---

Designing Effective Visualization

I've given some motivation for visualization, but so far I haven't really
distinguished between good and bad visualizations. Before we discuss the
microbiome, I want to go over some main ideas from the visualization literature
that can be used to compare visualizations.

---

Graphical Encoding

If you really deconstruct a visualization, you can think of it as mapping abstract fields of a dataset into 

---

Encoding and Efficiency

One observation is that different encodings can be processed with different
efficiencies. For example, it's much easier for people to compare the heights of
bars that are placed side by side than it is to compare the transparency of two
points, even if the underlying data are exactly the same.

---

Encoding and Efficiency -- 2

Just to make this concrete, consider the popout phenomenon. Here, you can
notice the blue dot without even having to look. Here, you can find the red
square if you look hard enough, but it takes quite a bit more work.

---

Data-to-Ink Ratio

Another way to a visualization more effective is to maximize the data-to-ink
ratio. The ideal is to show as much of the data (maximize data) while having
simple, clear encodings. This is similar to the idea of avoiding premature
summarization -- don't just show a mean when you could show the entire
distribution.

A nice illustration comes from Tufte's book. Here are two versions of a plot of
the same data, originally appearing in Linus Pauling's chemistry book. Notice
what's changed -- there are fewer irrelevant marks. There is also a bit more
data, more complete annotation.

---

Faceting

One way you can display more data is to use small multiples. It turns out that
our eyes are good at viewing many parallel versions of the same basic
visualization. For example, this plot is called a horizon plot. It shows many
time series in a very compact space, we can understand this high density plot
because each panel is read similarly to the others.

---

Focus-plus-Context

Instead of trying to show all views at once, one technique is to allow readers
to navigate between different levels of detail. The hope is to see the detail
without losing track of the context. For example, this is a visualization that
lets people zoom up and down a phylogenetic tree, to see whether certain
categories have more weight in some parts of the tree relative to others.

---

Microbiome Visualization

Okay, so those were some relatively high level ideas for how to make effective data visualizations. Next, 

Okay, so those were general ideas from data visualization. Now, I want to go
into more depth about specific visualizations that I've often found helpful when
working with microbiome data.

---

MA Plot

One common task in microbiome analysis is to check whether there are some taxa
that are differentially abundant between conditions. Before running any tests,
you can try making an MA plot. On the y-axis is the difference between the
condition averages (on a log scale). On the x-axis is the midpoint between those
condition averages. 

---

You tend to see larger differences when the abundances are both large. This should generally be centered around zero, since most taxa should not be associated with a condition.

---

The MA plot gives a kind of overview, but it doesn't tell us the distribution of
taxa within specific groups. For this you can make an ECDF plot. A 0 on the
y-axis means that none of the observed values were smaller than this x-axis
value. A value of 1 means that all the observations were below that x-axis
value. A value of 0.5 means that half of the data are below that x-axis value,
etc..

---

What's nice here is that it avoids the issue of choosing bin sizes in a histogram. These plots can look quite different depending on the binwidth, especially when there are lots of zeros.

---

### ECDF Interpretation

Here are ECDFs for the differential analysis above. When there is a large gap, there is 

---

### Considerations

There are some issues that can make a big difference in the visualization.
First, even with faceting, there are only so many taxa we can visualize at once
-- we usually still need some statistical tests to focus our attention.

---

### Principal Components Analysis

PCA gives another overview of the data. You might have heard that it provides the views of the data that "maximize variance." The idea is actually very simple.

Can anyone tell what this object is?

---

Introduction

It's nice to be giving a talk about visualizations in a room that includes some
really beautiful ones.

Okay, I've heard that many of you are working on data analysis in your day to
day work.

---