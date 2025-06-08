
### IISA Interpretability

Interactively Resolving Distortion in Nonlinear Dimensionality Reduction

Nonlinear dimensionality reduction is a key step in many modern analysis workflows. For example, when working with text embeddings from pretrained large language models or when exploring single-cell gene expression measurements, researchers routinely apply UMAP to organize the high-dimensional source data into a more manageable low-dimensional representation. Such nonlinear dimensionality can be powerful, but it inevitably introduces distortion. A growing body of work has demonstrated that this distortion can have serious consequences for downstream interpretation, for example, suggesting clusters that do not exist in the original data. Motivated by these developments, we have designed a visual interface which helps to identify where these distortions are most severe and supports interaction to locally resolve them. Though the design and interaction are relatively straightforward, we find through case studies from single-cell genomics and microbiome data analysis that they can enable more accurate interpretations than more traditional visualization methods which do not show distortion. This work helps researchers who apply nonlinear dimensionality reduction methods address concerns they may have about the reliability of their embeddings and proceed with confidence in their data analysis.

----


Brainstorming...



Title: Interpretable Embeddings in Microbiome Data



1. Techniques from the machine learning interpretability space can be used to
better understand the complex models that are now beginning to be applied to
biological data.

... this abstract would only work if we are able to share the analysis from
Ophelia's group

1. In this setting, interpretability is arguably more important, because the
purpose of the modeling is understanding. Unlike interpretability for text and
image data, it can be more difficult, because recognizing meaningful
interpretations can require domain knowledge.

-----

An Interactive Visualization to Resolve Distortion in Nonlinear Dimensionality Reduction

Nonlinear dimensionality reduction is a key step in many modern analysis workflows. For example, when working with text embeddings from pretrained large language models or when exploring high-dimensional single-cell gene expression measurements, researchers routinely apply UMAP to organize the data into a more manageable low-dimensional representation. Such nonlinear dimensionality can be powerful, but it inevitably introduces distortion. A growing body of work has demonstrated that this distortion can have serious consequences for downstream interpretation, for example, suggesting clusters that do not exist in the original data. Motivated by these developments, we have designed a visual interface which helps to identify where these distortions are most severe and supports interaction to locally resolve them. Though the design and interaction are relatively straightforward, we find through case studies from single-cell genomics and microbiome data analysis that they can suggest different interpretations relative to what would be obtained in the equivalent visualization that does not encode any distortion measures. The resulting visualizations make theoretically-sound measures of distortion more broadly accessible to audiences who may not understand their theoretical formulation but who can make sense of them visually. This work helps researchers who apply nonlinear dimensionality reduction methods address concerns they may have about the reliability of their embeddings and proceed with confidence in their data analysis.

1. Many modern datasets are high-dimensional, and nonlinear dimensionality
reduction is key step in the analysis workflow. For example, when working with
text embeddings from pretrained foundation models or single-cell RNA-seq
expression measurements, researchers routinely apply UMAP and its variants to
organize the original high-dimensional source into a more manageable
low-dimensional representation.  1. Such nonlinear dimensionality can be
particularly powerful, but it inevitably introduces distrotion 1. Recently, a
number of methods have emerged for characterizing the nature of this distortion,
demonstrating that these distortions can have substantial consequences on the
scientific interpretation (e.g., suggesting clusters that do not exist in the
original data).  1. Motivated by these developments, we have developed
visualization software that makes it easier to identify where these distortions
are most severe and supports interactions to locally resolve them.  1. We
present case studies showing that, though the visual encodings and interactions
are straightforard, they can suggest different interpretations than what would
be obtained in the equivalent visualization that does not encode distortion.  1.
The resulting visualizations make theoretically-sound distortion measures more
broadly accessible. In this way, it helps researchers who apply nonlinear
dimensionality reduction methods address concerns they may have about the
reliability of their embeddings and proceed with confidence in their data
analysis.

-----


Abstract: Microbiome data give us a glimpse into the microbial dynamics and
interactions that underlie so much of human health. Getting the most out of
these data often presents a challenge, however -- any analysis needs to account
for the large number of taxa present relative to the number of samples
(high-dimensionality) and the fact that meaningful signals can be present across
a range of resolutions (from entire phyla to individual strains). We will
explore how these issues can be addressed through topic modeling, an idea
originally developed in the population genetics and language modeling
literatures. In contrast to traditional clustering, where each sample/document
is assigned to a fixed cluster, topic models suppose that observations are a
continuous blend of representative prototypes. While broadly useful, topic
models do require users to specify the choice of the number of topics K, which
governs the resolution at which the topics are learned. We will discuss a new
technique, which we call topic alignment, for comparing topics from across a
collection of topic models.  Through simulation studies, we show that this
approach can distinguish between true and spurious topics by accounting for the
stability of the recovered topics across K. We will illustrate how topic
modeling and alignment can clarify the ecosystem dynamics in gut and vaginal
microbiome data. Code for all examples is available through online vignettes
(https://go.wisc.edu/uc1qq5, https://go.wisc.edu/73ne7a), and topic alignment is
available through the R package alto (https://go.wisc.edu/8ez208).