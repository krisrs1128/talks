### Talk Notes

---- 
**Title Slide**
1. My name is Kris Sankaran. I am an assistant professor in the statistics dept at UW Madison.
2. Today, I want to share an idea that I've found useful for exploratory analysis of these data. I find it a useful extension of standard topic models -- for just a little extra effort, you can get some interesting and practical information.

---- 
**Model**
1. First a review -- what are topic models?
2. Remember that the multinomial is the distribution used for sampling outcomes from dice throws.
3. Here, each feature is like one side of the dice.
4. Each sample has a different dice throw. The main idea is that the die probabilities aren't completely unrelated. They're all mixtures of a small number of underlying probability vectors.
5. These underlying probability vectors are the betas. Amount that you mix these underlying vectors are the gamma.
6. The model is completed by placing Dirichlet priors on both the betas and the gammas.

I realize this is a lot of notation, so if later you need a reminder for what anything means, please do ask.

---- 

**Simplex View**
1. This has a simple interpretation. The betas are K points on a D dimensional simplex. The gammas are N points on a K dimensional simplex.
2. From this point of view, you don't just reduce data to the centroids. Instead, you find some extreme points and imagine that the real data are mixtures of these extremes.

---

---- 
**Example Microbiome**\*\* 1. Here is an example of how topic models can summarize an entire study at a glance.
2. They introduced antibiotics here, removed it here, and give them it again here.
3. You can see that there is a dramatic shift after the first time course, something new emerges in the interim. You can also see a group that was pretty strongly affected after the first course and which was less sensitive the second time around.
---- 

**Example Microbiome**\*\* 1. Here is a setting where it helps to think in terms of topics.
2. This was a study of how the gut microbiome responded to antibiotics.
3. Each line is the abundance of one taxonomic group over time. You can kind of tell that there is a decrease at these two timepoints.
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
**Estimating Weights: Transport approach**
1. The next question is how to estimate the weights. One idea is to apply an optimal transport perspective. The point is that the topics in one model defines a distribution, and we need to learn the relationship between the distributions at different K.
2. It's a distribution with masses at the topics and locations defined by the genes that it has higher or lower expression levels for. The masses are the amount of membership assigned to that topic.
3. Blue represents a model with just two topics. Purple has three topics, it seems to have split this one topic into two new topics, one which has relatively low overall membership.
---- 
**Estimating Weights: Transport Approach**
1. The problem then is to learn the optimal transport map between the topics.
2. You can formalize this by learning the transport map W between the sets of topics.
3. It's helpful to think about the factories-mines analogy. You have a set of mines that produce material, and factories that have demand. You need to come up with an efficient way to transport material across them.
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
2. The key thing to know is that a few years ago, researchers categorized samples into something called "Community State Types" (CSTs). They want to say that all the study participants vaginal microbiomes fell into one of five types.
3. There are four CSTs that are actually very obvious -- they are communities that are completely dominated by one of four lactobacillus species.
4. But there is a fifth CST that is a mix of many species. This one is a mix of many species, and it was found to be associated with preterm birth and HIV status. But it is a bit of an ad hoc construction, and Laura's suspicion was that there is more structure hidden within this mix.
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
**Time Series**
1. It's also interesting to visualize change in the topic memberships over time. Here are scores for a single study participant.
2. You can see that there are transitions from between topics. After two weeks, this participant leaves the "Green" topic and enters a mix of orange and turquoise. And at the onset of bleeding, the orange state becomes more prominent.
3. If you look carefully, you can see that the orange states are related to menstruation.
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