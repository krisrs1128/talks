My everyone, my name is Kris Sankaran, I'm an assistant professor in the statistics department, and my lab works on applications of statistics to the microbiome. A microbiome is just an ecosystem of microbes.

The main goal of my lab is to help researchers in this area get the most out of their data. How exactly? First, it helps to integrate different data sources. You might have a genomic dataset about microbes and a metabolomic dataset about their environment, and you want to study them together. Second, we're at a point where we can start designing microbes for specific functions, like environmental remediation, and this is essentially a design problem. For reproducibility, just this last summer there was a very high profile retraction of a Nature paper about the cancer microbiome. They didn't lie, there wasn't anything sloppy in the wet lab, ... they had just done their batch effect correction in a way that introduced a spurious signal. Statistics has something to offer here.
---- 
Themes: Visualization

For the rest of the talk, I want to review some of the major problem solving techniques we use to address these issues.

A few of our projects have used topic models. This model was developed independently in the text mining and genetics literature, and the main idea is that you can think of samples as mixtures. A newspaper article is a mixture of a few basic topics; an organisms' genome is a mixture of a few ancestral populations.
---- 
Themes: Visualization

Whenever you think about mixtures, you have to ask, how many things do you mix together? In this visualization, we look at topics from across many models -- the similar ones are linked together. By looking at the data this way, we can change the question from, what's the right K, to which topics are robust across many K?
---- 
Themes: Simulation

I mentioned experimental design and reproducibility at the start, and to solve this, we often use simulation. For example, it can provide ground truth for understanding the power of different workflows.

This is a screenshot from a set of online notebooks that walk through many applications of simulation to microbiome data. All these data are public and we give code for all our experiments.
---- 
Themes: Simulation

For example, in one of the notebooks, we give examples of how to evaluate the quality of the simulated correlation structure. And you can use this to run power analysis for methods that require the correlation structure.
---- 
Themes: Interface Design

Finally, this is related to visualization, but we often think about how write clear interfaces to methods. It turns out that causal mediation analysis is helpful for microbiome analysis, but we weren't too happy with a lot of the existing software. They worked well for their one application, but were difficult to adapt to new settings.
---- 
Themes: Interface Design

We designed software that makes it easy to swap in and out mediation and outcome models, while still being able to reuse a lot of the surrounding code. We could try many different mediation models, but use the same visualization and sensitivity analysis code, for example.
---- 
This is just showing that we can learn something interesting in real data. This is from an integration problem between the metabolome and the microbiome.
---- 
Alright, that's all, you can read more here. Don't hesitate to reach out. And finally, welcome to all the new students and welcome back to all the returning ones.

