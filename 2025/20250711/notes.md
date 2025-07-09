
---

title slide

Thank you for the introduction, and to the organizers for putting together this
workshop.  Today, I wanted to share some thoughts on simulation for microbiome
data, this is the topic of the review paper linked over here. I'd also like to
share some thoughts on how we could design package interfaces that make these
simulations easier to use. I hope that by the end of this talk, you'll have
learned a few tricks that might help in the design of your own simulations.

---

An Early Simulation Study

Preparing this talk made me wonder about the first time I ever used simulation
in a paper, and I think it was this one.  The topic was to do a kind of
multiomic analysis of some longitudinal data about the microbiome and I
remember, and a natural question was -- when should we use this design? so the
design was every single person was traced overtime, and they were given an
intervention over the course of this experiment. This is pretty different from
if you were just taken cross-sectional data and then divide the group into a
treatment group and a control group. To answer this we ran a small simulation
experiment. What are the trade-offs between doing a pure case control study and
a study where you intervene within a longitudinal structure.

---

Figures from early study

These are some of the figures from that experiment. Each line is a subject, and
the color represent before, during, and after the intervention. Along the Y we
have higher subject to subject variability, and along the X we have a larger
intervention signal and the main point is that when there's large
subject-to-subject variability it really does help to apply this kind of
longitudinal design.

---

sometimes it takes...

In many ways, the simulation experiment is quite naïve. I mean these are
simulated with Gaussian errors. I remember being a bit dissatisfied with it, but
lately I've returned to this question and realize that there is a lot of depth
in questions related to simulation.

---

Why Simulate?

So stepping back, why should we care about simulation? the three main reasons
like what we've just seen in the previous example simulation can often be useful
for understanding different experimental designs. We often use simulation to
create ground truth with which we can evaluate different algorithms or new
algorithms. We can also use them to sanity check that we aren't accidentally
over interpreting technical artifacts.

---

Semisynthetic Data

Something that's become more common in this area and which we never thought to
use in 2017 are semi-synthetic data. The idea is to guide the simulation, using
some real template data set. By trying to match the template, we have a bit more
guarantee that the simulated data will be realistic, but we also try to make
sure that the data generating mechanism is transparent so that we have some
ground truth for our downstream comparisons.

---

Existing Interfaces - 1

Even within the omics literature there are a fair number of simulation packages.
These are already quite widely used, but I think there's also some opportunity
for improvement.

One widely used package is called splatter it's even been used in microbial
studies. I think it actually has a very interesting interface example you can
see the parameters which have been modified, depending on whether they're
capitalized or not. But the simulation mechanism is actually quite simple. It
uses a Gaussian model just like what we did in our original PLOS multi domain
paper.

---

Existing Interfaces - 2

Here's the interface to the scdesign3 package. This example comes from their
online vignette. This is a much more powerful package compared to splatter
because you no longer have to use a gaussian model and you can use more general
covariates. But I think that this interface is a little bit less intuitive.

---

Challenges

I think it's useful to think about the design of simulation from perspective of
interaction gulfs. In this human computer interface literature there are two
gulfs of interaction -- the gulf of execution occurs when it's difficult to
understand how to use the interface to achieve a goal while the gulf of
evaluation refers to the time it takes to get an understand results after having
made an interaction. I think we encounter the same issue when we try to use
simulation in omics. It's both difficult to specify the simulator and to
understand its output well enough to know whether you can use it as is or
improve it.

---

Main Idea

So the main idea in the project right now is: how can we apply some of these
interactive computing ideas to support multi-omics simulation? There are three
main principles. The first is that if we can define a good building blocks, then
researchers should be able to compose them in a way that applies to diverse
problems. Second is interactivity people should help feel in control of
designing and refining simulators. The third is that science is essentially a
cooperative activity and a good interface can support cooperation.

---

Related - simChef

I wanted to mention that a lot of these ideas overlap with the SIM chef package.
This is a package that makes it easy to support the kind of simulation
experiments that are ubiquitous in statistics and machine learning. You can
think of this SC designer package focusing on a smaller component of the larger
SIM chef pipeline. We are interested in coming up with a flexible, syntax for
defining the data generating processes relevant to multiomics.

---

scDesign3 Review - 1

Since the rest of this talk is gonna be focused on how we can adapt the
scDesign3 interface I wanted to go into a little bit more detail about how
exactly it works. It's two main steps in the first step we fit marginal and GLM
models to every single gene. Crucially, these gene models are allowed to depend
on covariates like treatment status, or in this case pseudotime.

---

scDesign3 Review - 2

The second step takes together these marginal models using a copula. This is a
kind of multivariate model that captures the correlation between the ranks of
high dimensional vector while preserving the marginal structure from the first
step. For example, here are samples from the fitted copula for these five genes.

---

Nouns & Verbs

OK, so how can we build a more modular and approachable interface? It's helpful
to distinguish between the nouns and the verbs of the interface. The nouns
represent certain kinds of data structures while the verbs are operations that
you can apply to those data structures. Ideally if these nouns and verbs are
clear enough, then users will be able to compose their own kinds of simulators.

---

Verbs: Mutate - 1

Since I don't have that much time, I wanna focus on just a couple different
kinds of verbs.

One of the verbs is mutate. The idea is that after having initially fit a
simulator to template data we might want to alter that simulator to establish
some sort of ground truth. In this example these are abundances of different
proteins a mouse model of Huntington's disease. When I fit a template simulator,
you can see that the curves mostly overlap but the ground truth would have some
difference between these two conditions, Huntington's disease and wild type
control.


---

Verbs: Mutate - 2

Here I applied mutate to remove the difference between treatment and control for
the subset of proteins. I deliberately chose proteins where they hadn't been a
strong effect initially so that even after removing the effect, the simulator
seems to generally reflect the original data.

---

Verbs: Join

A second that we consider that's especially important for multiomics
applications is join. The idea is that if we've fit simulators for two different
omics, we want to be able to have a new simulator for a multiomic study. You
imagine having initially fit two different simulators first to bulk RNA-seq and
then second to methylation data. You would like to have operation that allows
you to combine those two simulators into a joint RNA and methylation simulator

---

Verbs: Join - Copula

There are a few different ways that we carry out this join. One simple idea is
just refit the copula. So here we discarded the copula that were estimated in
the initial simulators and simply use the marginal models from the two separate
simulators and learn a new correlation structure across all the features
simultaneously.

---

Verbs: Join - Conditioning

Another way that we have implemented the join operation is to condition on
latent structure. For example, you can learn something like partial manifold
alignment, which works, even when the samples are not exactly aligned, and use
that to obtain latent structure shared across all the omics. By simulating with
a shared conditional variable, we can induce correlation across the two omics.

---

Example: Microbiome Network Inference

Next I want to share an application to microbiome network inference. This is a
very common type of output in microbiome analysis, but there are no technologies
for establishing ground truth. Instead, we rely on benchmarking algorithms using
simulation.

Here are template data comes from the American gut project. We filter to adjust
45 abundant taxa. Will estimate a zero inflated negative binomial copula model,
insert some ground truth in the copula covariance matrix, and then compare how
well different algorithms can capture that ground truth correlation.

---

Simulation Mechanism

Here is a visualization of some of the samples. Each panel corresponds to one
taxon. We conditioned on the total sequencing depth and BMI because that was a
significant feature in the original study. Blue gives the real data while green
gives the simulation. For most taxer we fit relatively well though it's
interesting that the zero inflation tends to overestimate the number of zeros.

---

Estimated Correlation

This is the corresponding correlation matrix for the underlying copula. I'm
showing a pair of species plotted against each other which I've high estimated
correlation. This gives us some check that the correlation isn't due to a few
outliers, for example.

---

Establishing Ground Truth

We can create some ground truth for our benchmarking by defining a true
covariance matrix. Here there are three blocks with gradually decreasing
correlation structure .8, .6, .4.

---

Methods Comparison - 1

Here's a comparison of two different algorithms. Speakeasy was designed for
microbiome data while the ledoit wolf estimator is more generic for high
dimensional data. They both do a good job discovering that there are three main
blocks in this data, but it's kind of interesting that speakeasy thinks that
there are some negative correlation between the blocks.

---

Methods Comparison - 2

Here's another view of the same data. Now I have the ground truth versus the
estimated correlation on the two axis. Now the estimated negative correlations
are very clear in speakeasy, and in retrospect that this occurs is not too
surprising. This model assumes a sort of compositional structure and that
induces negative correlation. You can also tell that the wolf estimator has a
little bit of shrinkage, which makes sense because it was designed for the high
dimensional setting.

---

Generalizing

The block dependent structure is just one of many plausible structures from
Microbiome data. In our review, we consider also scale free, banded, and random
networks for example

---

Future Work

We have run a few workshops based on a prototype of this simulator and two
questions come up often. When is how do we make this a bit faster and second is
how can we make sure that the generator data are useful enough for whatever
downstream task we have and I have a lot of thoughts on this and we are updating
our work to refle so happy to talk about this off-line

---

Bigger Picture

So stepping back one thing, I really enjoy about this project is that it has
helped really overcome some of the communication barriers that arise when doing
collaborative work in biology it's much easier to communicate different kinds of
outcomes of an analysis when we have a simulation that we can point to. It tears
a little quote that I like that I think of a lot in the context of simulation.
People who know here probably know that I also really enjoy classical music and
this quote is something I think about in the context of simulation so the story
is that before Tchaikovsky ballet music was always kind of an afterthought the
main point of the valet was the dancing so we need a good music and I think
about this simulation sometimes because when I'm reviewing papers, I often see
people use stimulation and ask just a kind of cursory thing not something to
take very seriously, but I really think that there's a lot of value in taking
simulation seriously.

---

Software and Resources

OK, so about wrapping up on the slides, I have a bunch of links for more
resources examples from the workshop and the paper. 

---

Thank you for your attention.