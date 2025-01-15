
Title Slide

1. Introduce your name and position. 
1. Mention that any microbiome paper is going to include data visualizations and
that you hope they can leave the talk with some new visualizations/general
strategies for improving their visualizations.
1. Mention that you want this to be something like a tutorial. This is an
audience with quite wide ranging interests and not necessarily trained in
statistics. I'm hoping that everyone can leave with something useful.

Designing Effective Visualizations

1. This talk is divided into two parts. In the first, I'll give a crash course on some fundamental concepts from data visualization.
1. In the second, I'm going to review a variety of visualization techniques that
I think are especially useful for microbiome work.

Motivation - 1

1. I can imagine a universe where data visualization is completely unecessary. If our brains were wired so that we could glance at spreadsheets and understand them, there would be no need.

1. But the reality is that our visual systems have evolved so that certain
representations can be processed much more efficiently than others. For example,
these numeric codes store the colors that are used in this lion image, but only
the image makes immediate sense.

Motivation  - 2

1. Here is another example. If two concepts are related to
one another, then an edge is drawn between them. For some questions, this list view is much less efficient than the network view.

1. For example, if I ask you how many steps there are between turing and infinity, it's immediate from the graph, but takes a bit more work for the list.

1. The reason this happens is because people have relatively limited working
memory, but we have great perceptual ability. The more that we can leverage our
perception and lift the burden on memory, the better we'll be able to reason
about data.

Strategy

1. The essence of biostatistics is reflected in two themes. First, we can
compress complex phenomena into summaries that can be fit effectively in our
working memory. For example, later, we'll be talking about principal components,
and this type of plot compresses a large dataset into a much smaller representation.

1. The second general strategy is to focus attention onto subsets of the data
that are especially interesting. For example, later we'll talk a bit about
differential abundance analysis. This can be thought of as a focusing technique,
helping narrow to just the taxa that are worth our attention.

Designing Effective Visualization

I've given some motivation for visualization, but so far I haven't really
distinguished between good and bad visualizations. Before we discuss the
microbiome, I want to go over some main ideas from the visualization literature
that can be used to compare visualizations.

Graphical Encoding

If you really deconstruct a visualization, you can think of it as mapping abstract fields of a dataset into 

Encoding and Efficiency

One observation is that different encodings can be processed with different
efficiencies. For example, it's much easier for people to compare the heights of
bars that are placed side by side than it is to compare the transparency of two
points, even if the underlying data are exactly the same.

Encoding and Efficiency -- 2

Just to make this concrete, consider the popout phenomenon. Here, you can
notice the blue dot without even having to look. Here, you can find the red
square if you look hard enough, but it takes quite a bit more work.

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

Faceting

One way you can display more data is to use small multiples. It turns out that
our eyes are good at viewing many parallel versions of the same basic
visualization. For example, we can pile many of these ridgeplots together and
still make some sense of them.
