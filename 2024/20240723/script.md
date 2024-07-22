Prepare some audience questions!!
---- 
### Talk Notes

---- 
**Title Slide**
1. My name is Kris Sankaran. I am an assistant professor in the statistics dept at UW Madison.
2. In my research, I spend a lot of time collaborating with researchers who study the microbiome. 
3. Today, I want to share an idea that I've found useful for exploratory analysis of these data. I find it a useful alternative to something like K-means or PCA -- it's richer without being too complicated.
4. I think that it could also be useful for other types of count data, and that's why I want to share it.
---- 
**Motivation: Enterotypes**
1. Before getting into the technique, a short story.
2. This is a figure from a 2011 nature paper that introduced the idea of enterotypes.
3. Each point is a person. They are organized by whether they have similar microbiome community composition.
4. The thing that people got excited about is that there seem to be three clear groups, and they didn't really have to do with country.
---- 
**Motivation: Enterotypes**
1. This paper got a lot of attention -- the idea that was so attractive is that this could be something like a blood type.
2. It seemed to reveal some sort of fundamental structure about the microbiome.
---- 
**Motivation: Enterotypes**
1. WIRED magazine featured it in the weekly "Jargon Watch"
---- 
**Motivation: Enterotypes**
1. This was international news!
---- 
**Motivation: Enterotypes**
1. After people began interrogating the idea a bit further, they realized that it isn't really reasonable to talk about enterotypes.
2. For one, unlike blood type, your enterotype could change over time.
3. Now, I want to avoid sounding like the statistics police. Clustering can be very useful.
4. The real point is that there are other simple tools that can let you get even further.
---- 
**Improved EDA**
1. In this talk, we'll focus on two main ways we can improve our exploratory analysis.
2. First, we're going to understand data as mixtures, rather than clusters.
3. From this point of view, you don't just reduce data to the centroids (like in LHS). Instead, you find some extreme points and imagine that the real data are mixtures of these extremes (RHS).
---- 
**Improved EDA**
1. The second improvement is that we're going to want to study several scales at once. We're going to want something like a hierarchical clustering but where we can still think in terms of mixtures rather than hard clusters.
---- 
**Topic Models**
1. For the rest of the talk, I'm first going to introduce topic models, which are a way of modeling mixtures. This is an idea that has been around for a long time.
2. After this background, I'll introduce alignment idea, which will help us with multiscale analysis.
---- 
**Origins**

1. Topic models were introduced in the late 90s/early 2000s independently within the text and population genetics communities.
2. This might sound surprising at first, but there's actually a very natural analogy. You can do this for any omics, but for the microbiome,
	* Samples are like documents
	* Species are like terms.
	* Each person's microbiome is a distribution over species in the same way that a document is a distribution over words.
? (document -\> person, term -\> alleles, topic -\> population, corpus -\> metapopulation)
---- 
**Example 1: GTEX**
1. How does this look like in practice?
2. Here is an application to bulk RNA-seq data from the GTEX consortium. Each column is a sample, they are organized by tissues.
3. The colors indicate the contributions coming from different topics. These are called memberships.
4. For example, you can see that in the heart samples, there tends to be a lot of topic 9, 4 or 2. But you can be a bit of both.
---- 
**Example 1: GTEX **
1. To interpret these memberships, you make a plot like this. It shows which genes underlie each topic. For example, I liked up this first gene, and it's related to blood vessel thickness.
2. It has high expression in topic 9, so it makes sense that it has high activity in heart tissue (flipping back to previous).
---- 
**Example 2: Microbiome**\*\* 1. Here is another setting where it helps to think in terms of topics.
2. This was a study of how the gut microbiome responded to antibiotics.
3. Each line is the abundance of one taxonomic group over time. You can kind of tell that there is a decrease at these two timepoints.
---- 
**Example 2: Microbiome**\*\* 1. This is the same kind of plot as the GTEX plot, except the columns are timepoints and the groups are phases of sampling.
2. They introduced antibiotics here, removed it here, and give them it again here.
3. You can see that there is a dramatic shift after the first timecourse, something new emerges in the interim. You can also see a group that was pretty strongly affected after the first course and which was less sensitive the second time around.
---- 
**Example 2: Microbiome**
1. You can go back and see which microbes are contributing the most to these topics. Here are those that are very close to the "corners." 
2. You can see some that are doing pretty well during the antibiotic time course.
---- 
**Model**
1. Okay, so those are the model outputs. How exactly does it work?
2. Remember that the multinomial is the distribution used for sampling outcomes from dice throws.
3. Here, each gene or each species is like one side of the dice.
4. Each sample has a different dice throw. The main idea is that the die probabilities aren't completely unrelated. They're all mixtures of a small number of underlying probability vectors.
5. These underlying probability vectors are the betas. Amount that you mix these underlying vectors are the gamma.
6. The model is completed by placing Dirichlet priors on both the betas and the gammas.

I realize this is a lot of notation, so if later you need a reminder for what anything means, please do ask.

Before I move on are there any questions?
---- 
**Topic Alignment: Method**
Okay, so let's move on to topic alignment. This is going to allow us to work across scales, not just mixtures.
---- 
**Choice of K**
1. The main parameter in this model is K, and even the original paper commented on the challenge of choosing this parameter.
2. Since then, there have been a few proposals for how to evaluate them.
---- 
**alto: Main Idea**

1. This slide describes the main idea of topic alignment.
2. Each column corresponds to a different number of topics. Each rectangle is a single topic in one model.
3. The heights of the topics are the proportion of mixed membership assigned to that topic. 
4. The edges are used to represent similarities between topics estimated within different models.
---- 
**Alignment as a Graph**
1. To make this more formal, it helps to think of the ensemble as forming a graph. Each node is a topic, and we allow edges from K to K + 1.

---- 
**Notation**
1. This helps with managing notation. Instead of having to keep track of k's and m's, we just point to which node the topic lives in.
2. For example, it's easier to write Gamma(v) as the vector of memberships for a given topic, across all observed samples. It would be like, across all the tissue samples, how much membership for this one topic?
---- 
**Estimating Weights: Product Approach**
1. The next question is, how do we draw these edges? One idea is to use the inner product.
2. We can look at the memberships associated with a pair of topics. If both have high memberships on the same set of samples (for example, always high membership in heart tissue samples), then we give them high alignment.
---- 
**Estimating Weights: Transport approach**
1. Alternatively, we can apply an optimal transport perspective. The idea is that a all the topics in one model defines a distribution, and we need to learn the relationship between the distributions at different K.
2. It's a distribution with masses at the topics and locations defined by the genes that it has higher or lower expression levels for. The masses are the amount of membership assigned to that topic.
3. Blue represents a model with just two topics. Purple has three topics, it seems to have split this one topic into two new topics, one which has relatively low overall membership.
---- 
**Estimating Weights: Transport Approach**
1. The problem then is to learn the optimal transport map between the topics.
2. You can formalize this by learning the transport map W between the sets of topics.
3. It's helpful to think about the factories-mines analogy. You have a set of mines that produce material, and factories that have demand. You need to come up with an efficient way to transport material across them.
---- 
**Estimating Weights: Transport Approach**
1. The geometric picture can be captured by this optimization.
2. The costs defines the distance between the topics.
3. We need to learn weights so that the row and column sums agree with the original topic heights. And we want the entries of W to be small whenever the costs are large.
---- 
**Diagnostics**
1. Traditional goodness-of-fit measures focus on one model at a time. But now that we have computed these alignments, we can define some additional measures which are focused on the edges between models.
2. First, we can define paths, this is what's partitioning the diagram into clear colors.
3. Second, we can define coherence, which is the similarity between a topic and all other topics on the same path.
4. Third, we can define refinement, which measures whether descendant topics have unique parents.
---- 
**Topic Alignment: Examples**
This has been relatively abstract, so let's go into some examples.
---- 
**True Model**

Here is an example simulated from a true topic model. What do you think K is?

---- 
**Diagnostics**
The quantitative measures back this up.

1. We've simulated many datasets and computed metrics for each topic across the replicates. One point is a topic, the x-axis is the number of topics.
2. You can see that the number of paths plateaus at K = 5, which is what we want.
3. In these panels, I've added color showing how similar the estimated topic is to any of the true topics. We don't actually know color in reality. But you can can see that the topic quality improves as we get up to K = 5 and then drops off.
---- 
**No Title Diagnostics**
There are two points to note: 
1. These metrics become more reliable when there is a larger sample size. E.g., the number of paths peaks at the correct K when the number of samples is larger.
2. The optimal transport metric tends to be somewhat overoptimistic.
---- 
**Model with background variation**
1. We can use these diagnostics to understand certain departures from the assumed topic model structure.
2. We have a few examples of this in the paper, but here is an easy to explain one.
3. We use a parameter $\alpha$ to mix between a true topic model and another where the probability vector is drawn randomly from a Dirichlet. You can think of the nu's as random, unstructured variation that corrupts the low-rank topic model.
---- 
**Result**
1. In these four panels, the value of $\alpha$ ranges from all background variation to only the true LDA model.
2. So, we can use this diagram to evaluate the extent to which a true low rank model is sufficient. If we see something like the bottom right, we are in good shape, otherwise we might want to consider a different analysis.
---- 
**Diagnostics**
1. Again, we can quantify this using our metrics. Here, the rows correspond to different values of alpha.
2. The top panel is similar to what we had before -- it's almost like a true LDA. But as alpha decreases, we lose the clear dropoff that marks the true K.
---- 
**Application Background**
1. Okay, now I want to transition to a real data analysis. This whole project came about in some discussions about applying topic models to an analysis of the vaginal microbiome, so I want to first give some background.
2. The key thing to know is that a few years ago, researchers categorized samples into something called "Community State Types" (CSTs). These are basically like enterotypes of the vaginal microbiome, except the authors made no claim that they were universal or static.
3. That should already make you suspicious, but the situation is a little more complicated than with enterotypes.
4. There are four CSTs that are actually very obvious -- they are communities that are completely dominated by one of four lactobacillus species.
5. But there is a fifth CST that is a mix of many species, and Laura's suspicion was that there is more structure hidden within this mix.
---- 
**Deconstructing CSTs**
1. She had the sample size needed to actually check this. In total there were nearly 2200 samples (taken longitudinally) from 135 women.
2. If you run the alignment, you get clear blue and green topics representing the four known lactobacillus CSTs. There is some systematic structure among what we would have just called the dysbiotic CST, though.
---- 
**Coherence Scores**
1. We can evaluate coherence for each of the topics. Here I've extended the tree up to 15 topics.
2. One interesting property is that coherence is not a simple function of K. For example, this path is pretty stable across all K. This one becomes higher quality as you get deeper in the tree, while these get worse as you divide them further.
---- 
**Metrics across Replicates**
1. Here we're showing scores across $K = 1 \to 25$.
2. There is a slight decrease from 6 - 7 and 9 - 10. This is why we used K = 9 in our earlier diagram.
---- 
**Taxonomic Breakdown**
1. We can of course study the species that contributed to each of the topics. This is like the heatmap from the GTEX application.
2. The point is that IV-A and IV-C0 now gets split into a few sub-communities.
---- 
**Time Series**
1. It's also interesting to visualize change in the topic memberships over time. Here are scores for a single study participant.
2. You can see that there are transitions from between topics. It seems that green can transition to blue via the appearance of orange. 
3. If you look carefully, you can see that the orange states are related to menstruation.
---- 
**Test-set Perplexity**
1. Okay, so that is the data analysis. I'm about to wrap up, but I want to mention some related ideas.
2. First, you might be wondering how this is related to just evaluating test-set perplexity. They are definitely related, the main difference is that perplexity is a measure of the entire model, while our diagram helps to understand individual topics.
3. Second, you might look at this diagram and think we might be able to get something like hierarchical topic models. At a superficial level, these are similar, but their actual generative mechanism is very different. For each word, you traverse the full tree.
---- 
**Software**
1. We've implemented this all in an R package.
2. It's pretty easy to use, and all the simulations I talked about are on the package vigentte.
3. Also, all the data analysis figures I showed are in the supplement to the sub-communities paper that I linked to above. It's an amazing supplement because you can compile it in Rmarkdown -- it's a 90 page Rmarkdown doc...
---- 
**Takeaways**
1. The basic idea of alignment is very simple, but I hope that it can help you with your exploratory data analysis.
---- 
**Thank you!**
So, thank you to my paper co-authors, my lab members, and funding. I'm happy to take any questions.
---- 