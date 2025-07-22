
title

Thank you to the organizers for putting together this workshop. Today I want to
talk about how mediation analysis can help integrate multi-omics microbiome
data.  In the first part, I'll give a brief tutorial on mediation analysis.
After that, I want to review an R package that we've released called
multimedia for multi-omics mediation analysis.  The package is designed to make
it easy to try out and compare mediation analysis methods for microbiome data.

---

Microbiome as mediator - 1

One of the main areas of interest in microbiome research is how microbes might
mediate the relationship between hosts and their environment. For example, some
adverse events during chemotherapy can be traced to changes that those
treatments induce on the microbiome.

---

Alternative Mediators

The mediators don't necessarily have to be microbes. For example, in cholesterol
research, it's known that a specific bacteria can influence protein production
in the gut which has an effect on cholesterol levels. In this case, the
metabolites lie on the indirect path between the presence of this bacteria and
host phenotype.  Something that I think is interesting in both of these examples
is that they don't explicitly use causal inference methods, but the language
they use about indirect effects sounds like what we would say in mediation
analysis.

---

Causal inference formalism

Causal mediation analysis is a useful technique for thinking through problems
like this. It is represented by this DAG. X are pretreatment covariates, these
are unchanging features associated with each sample. T is the treatment. M is a
mediator that can be affected by T and X. Y is a response that can depend on all
of these variables.

---

Generalied causal mediation

Generalized causal mediation expects two types of counterfactuals in mediation
analysis. The notation M(t) refers to the values of the mediator you would have
observed under different treatments t.

The notation for the outcome Y(t, M(t')) is perhaps strange, because unless t =
t', this is impossible to observe. It refers to the value of M under the
treatment t'. But even when fixing the mediator at this value M(t'), you might
see different response Y(t, M(t')) depending on the value of t.

---


Direct vs. indirect effects 

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

Integration Challenge - 2

A few of us this morning are talking about microbiome-metabolome integration.
Here is a quote from a study about IBD. They didn't use mediation analysis, but
the language sounds a lot like how we talk about indirect effects in a mediation
analysis. See, some of the species are associated with IBD. And then some
metabolites were more common when the IBD associated species were present.

---

Package Design

We'll revisit that study at the end. But next I want to talk about how we
designed a package to support mediation analysis in this multi-omics setting. We
call this package `multimedia`.

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
response. For example, in the mindfulness intervention, we can consider the
microbiome profile as an outcome using a logistic normal multinomial model,
given here by the `lnm_model()`.

---

Data formats - 1

In addition to modeling, we have some helpers to manipulate the data into a
format useful for mediation. For example, here we start with plain data.frame.

---

Data formats - 2

And we can split into a structure with separate slots for treatment, mediators,
and outcomes.

---

Bootstrap

We also have some helpers for gauging uncertainty. For example, we can rerun the
mediation analysis on bootstrap resampled versions of the data.

---

Model Alteration

We can also alter the initial model fit. This is a toy example where I've fit a
nonlinear mediation model with two outcomes. I've taken the original fit and
removed direct effects in this panel and indirect effects in this panel. Here,
we replaced the nonlinear model with a linear model.

The point is that more than estimation, our design allows us to manipulate a
fitted model to get some intuition about which paths or model choices are
important.

---

Synthetic null data

Here is the same idea applied to the real mindfulness study data. Each row is a
mediator, and the colors refer to the treatment groups.  In the middle panel, we
removed the treatment to mediator path. In the full model, we do estimate some
difference between the groups.

---

Synthetic null data

We can do the same thing for the path from treatment to outcome. This can help
us sanity check that any claimed direct effects are larger than we would observe
in these ground truth null data.

---

Sensitivity analysis

Just like ordinary causal inference, mediation analysis depends on some
untestable assumptions. For example, we have to make sure that we don't
accidentally only treat people who would have had good outcomes either way --
this is traditional ignorability. In mediation, we also have to make sure we
don't only observe certain mediators only when people are going to have good
outcomes -- this is called sequential ignorability.

---

Sensitivity analysis

The main idea of sensitivity analysis is that even though those assumptions are
not testable, we can simulate data where those assumptions are violated to see
by how much our conclusions would have changed. There are a few ways you could
do this, we simply correlate the noise between the mediators and the outcomes.

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

You can learn more details in our paper, and the package is available on CRAN. I
think that if there's one thing you takeaway is that, we've already seen a few
examples where causal language is helpful in reasoning about multi-omics, and
this package just gives more evidence that this might be true quite generally,
even in microbiome analysis.