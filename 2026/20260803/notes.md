
title

Thank you to the organizers for putting together this session. Today I want to talk about how mediation analysis for integrating multi-omics microbiome data.  In the first part, I'll give a brief tutorial on mediation analysis.  After that, I'll review an R package that we've released called multimedia for multi-omics mediation analysis. The package is designed to make it easy to try out and compare mediation analysis methods for microbiome data.

---

Microbiome as mediator

Mediation analysis could help improve the lives of patients.  For example, some
adverse events during chemotherapy can be traced to changes that those
treatments induce on the microbiome. This figure comes from a review that
studied how we could target specific microbes to improve cancer treatment.

---

Causal inference formalism

Causal mediation analysis helps us reason more clearly through problems like
this. It is represented by this DAG. X are pretreatment covariates, these are
unchanging features associated with each sample. T is the treatment. M is a
mediator that can be affected by T and X. Y is a response that can depend on all
of these variables.

---

Generalized causal mediation

Generalized causal mediation expects two types of counterfactuals in mediation
analysis. The notation M(t) refers to the values of the mediator you would have
observed under different treatments t.

The notation for the outcome Y(t, M(t')) is perhaps strange, because unless t =
t', this is impossible to observe. It refers to the value of M under the
treatment t'. But even when fixing the mediator at this value M(t'), you might
see different response Y(t, M(t')) depending on the value of t.

The advantage of this approach is that you can define direct and indirect
effects using only the counterfactual values. We don't have to refer to any
particular model parameters, and this gives more flexibility in how we might
model M(t) nad Y(t, m).

---

Geometric interpretation - 1

These effects have a nice geometric interpretation. In this figure, the y-axis
is the response variable. The x-axis is a mediator. The two colors are the
treatment and control groups. If there is a direct effect but no indirect
effect, then, for any given value of the mediator, we see changes in the
response depending on the treatment status. But the distribution of the
mediators doesn't depend on treatment status.

---

Geometric interpretation - 2

In contrast, we could have that the treatment changes the value of the mediator.
But for any fixed value of the mediator, there is no difference in the treatment
vs. control. There is still a treatment effect, but it is entirely an indirect
effect via the mediator.

---

Geometric interpretation - 3

In practice, we'd usually have something in-between, and we are interested in
estimating how much of any given treatment effect can be attributed to the
mediator. We'd also have some pretreatment covariates x and perhaps
higher-dimensional mediators and responses, but this still gives the intuition.

---

Integration Challenge - 1

Now I think we can see why mediation analysis might be useful in data
integration. We might have several omics, and we might want to say that the
effect we see in one of them is a consequence of a change that occurred in
another. For example, in one of our collaborations, we worked with researchers
interested in how psychological training might affect the microbiome. One
mechanism through which the microbiome might change is that peoples' diet or
sleep patterns might change. Fortunately, these kinds of data are available in
an accompanying survey.

---

Package Design

Next I want to talk about how we designed a package to support mediation
analysis in this multi-omics setting. We call this package `multimedia`.

---

Univariate Mediation Analysis

As a first step, let's consider how we might implement a univariate mediation
analysis. Both the mediator and the response are one dimensional,

---

Code Interfaces - 1

One approach is to give the response, mediator, and treatment as inputs to a
function whose responsibility is to estimate the direct and indirect effects
that we're interested in.

---

Code Interfaces - 2

But another idea is to allow the mediation function to take separate model
objects associated with the two regressions. This is in fact what the mediation
package does. The advantage is that it is naturally extensible, we don't have to
use linear models for f1 and f2, we could give a logistic regression and still
get estimated effects, since to estimate them we only need access to
counterfactual predictions, not the underlying parameters.

---

Multimedia interface

The multimedia interface extends this design to multiple response regression
models. That allows us to consider a vector of microbes or metabolites as the
response. For example, we can consider the microbiome profile as an outcome
using a logistic normal multinomial model, given here by the `lnm_model()`.

---

Data formats - 1

In addition to modeling, we have some helpers to manipulate the data into a
format useful for mediation. For example, here we start with plain data.frame.

And we can split into a structure with separate slots for treatment, mediators,
and outcomes.

---

Bootstrap

We also have some helpers for gauging uncertainty. For example, we can rerun the
mediation analysis on bootstrap resampled versions of the data.

---

Sensitivity analysis

Just like ordinary causal inference, mediation analysis depends on some
untestable assumptions. For example, we have to make sure that we don't
accidentally only treat people who would have had good outcomes either way --
this is traditional ignorability. In mediation, we also have to make sure we
don't only observe certain mediators only when people are going to have good
outcomes -- this is called sequential ignorability.

---

Okay, in the last few minutes, I want to show how you could use multimedia to
re-analyze the multi-omics data from the IBD study that I quoted from earlier.

---

Here are details of that study. They have taxonomic community profiles using
whole genome sequencing, and they got metabolomics profiles using untargeted
metabolomics.

---

We filtered to only the most abundant data, and we applied centered log ratio
and log transforms. After transformation, each metabolite is considered to be a
sparse linear function of the microbiome community.

---

These are multidimensional scaling visualizations of the microbiome community.
Samples are close to one another when their microbiome profiles are similar. I
then overlay metabolite information -- each panel corresponds to one metabolite
and the size of the points reflects its abundance. The interesting thing is that
metabolites with large indirect effects have a clear association with the
overall microbiome community profile, while those with only large direct effects
don't show such systematic structure.

---

Here is a visualization of pathwise indirect effects. This is similar to the
geometric picture I gave at the beginning -- the treatment shifts the abundance
of that bacteria, and the bacteria is associated with the metabolite.

---

We also ran a sensitivity analysis where we added some confounding between the
microbes and the metabolites. For example, this metabolite has a strong indirect
effect even when confounding is large, while this one doesn't seem so reliable.

---


Open Source Statisitcal Software

This project focuses on statistical software, and I want to share a
philosophical point before I dive in. I've heard from a few people that now that
we can vibe code our way into any data analysis, we might not need so many
statisticians, let alone statisticians who focus on software.

But I completely disagree. Statistical software is how we democratize statistics
research, and many people learn how to analyze their data well from good
software documentation. It's still incredibly important for statisticians to
help people think clearly about their data hopefully we can design code and
algorithms that gives people a sense of agency rather than forcing them to trust
a black box.

---


You can learn more details in our paper, and the package is available on CRAN. I
think that if there's one thing you takeaway is that, we've already seen a few
examples where causal language is helpful in reasoning about multi-omics, and
this package just gives more evidence that this might be true quite generally,
even in microbiome analysis.