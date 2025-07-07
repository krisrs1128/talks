
---

title slide

Good morning everyone my name is Kris Sankaran. I mainly work in analysis of
microbiome data. Related to the theme of today's workshop, I thought it would be
interesting to share how simulation has helped in these kind of data analysis.
Most of what I'll be talking about is discussed in this review paper linked here
below. You can also check out the slide at this link in case you want to see
what references I'm talking about as we go through.

---

An Early Simulation Study

The organizers gave us an interesting instruction, which is to give a more
personal take than I would usually give. So in that spirit, I wanted to start
with, but I think it's the first time I ever use simulation in a publication
which comes from this paper. The topic of the paper was to do a kind of multi
mic analysis of some longitude or data about the micro b and I remember one of
the questions from the reviewers was why exactly did you use this design? so the
design was every single person was traced overtime, and they were given an
intervention over the course of this experiment. This is pretty different from
if you were just taken cross-sectional data and then divide the group into a
treatment group and a control group. So in response to the reviewer, we ran a
small extra simulation experiment to understand. What are the trade-offs between
doing a pure case control study and a study where you intervene within a
longitudinal structure, and those experiments ended up in our supplement.

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
simulated with Gaussian errors. But I think it raised some questions that I
don't think I fully appreciated when I started -- it seemed so basic compared to
what other students were doing --  but which lately has become really my primary
interest.

---

Why Simulate?

So stepping back, why should we care about simulation the three main reasons
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
studies. I think it actually has a very interesting in her face example you can
see the parameters which have been modified, depending on whether they're
capitalized or not. But the simulation mechanism is actually quite simple. Maybe
even a little bit naïve. It also uses a Gaussian model just like what we did in
our original PLOS multi domain paper.

---

Existing Interfaces - 2

Here's the interface to the scdesign3 package. This example comes from their
online vignette. This is a much more powerful package compared to splatter
because you no longer have to use a gaussian model and you can use more general
covariates. But I think it's also clear that this interface is a little bit less
intuitive.

---

Challenges

I think it's useful to think about the design of simulation from perspective of
interaction gulfs. In this human computer interface that are sure there are two
gulfs of interaction -- the gulf of execution occurs when it's difficult to
understand how to use a tour to achieve a goal while the gulf of evaluation
refers to the time it takes to get an understand results after having made an
interaction. I think we encounter the same issue when we try to use simulation
in OMX. It's both difficult to specify the simulator and to understand its
output well enough to know whether you can use it as is or improve it.

---

Main Idea

So the main idea in the product number about right now is: how can we apply some
of these interactive computing ideas to support multi-omics simulation? There
are three main principles. The first is that if we can define a good building
blocks, then researchers should be able to compose them in a way that applies to
diverse problems. Second is interactivity people should feel in control and
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
on care areas like treatment status, or in this case pseudo time.

---

scDesign3 Review - 2

The second step takes together these marginal models using a copula. This is a
kind of multivariate model that attempts to capture the correlation between the
ranks of high dimensional vector. While preserving the marginal structure from
the first step. For example, here are samples from the fitted copula for these
five genes.

---

Nouns & Verbs

OK, so how can we build a more modular and approachable interface? It's helpful
to distinguish between the nouns and the verbs of the interface. The noun
represent certain kinds of data structures while the verbs are operations that
you can apply to those data structures. Ideally if these nouns and verbs are
clear enough, then users will be able to compose their own kinds of simulators.

---

Verbs: Mutate - 1

Since I don't have that much time, I wanna focus on just a couple different kinds of verbs.

One of the verbs is mutate. The idea is that after having initially fit a
simulator to some template data we might want to alter that simulator to
establish some sort of ground truth. In this example these are abundances of
different proteins a mouse model of Huntington's disease. When I fit a template
simulator, you can see that the curves mostly overlap but the ground truth would
have some difference between these two conditions, Huntington's disease and wild
type control.


---

Verbs: Mutate - 2

Here I applied mute it to remove the difference between treatment and control
for the subset of proteins. I deliberately chose proteins where they hadn't been
a strong effect initially so that even after removing the effect, the simulator
seems to generally reflect the original data.

---

Verbs: Join

---

Verbs: Join - Copula

---

Verbs: Join - Conditioning

---

Verbs: Join - Conditioning

---

Example: Microbiome Network Inference

---

Simulation Mechanism

---

Estimated Correlation

---

Establishing Ground Truth

---

Methods Comparison - 1

---

Methods Comparison - 2

---

Generalizing

---

Future Work

---

Bigger Picture

---

Software and Resources

---

Thank You