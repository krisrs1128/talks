Good morning everyone, my name is Kris Sankaran, I am an assistant professor
at the University of Wisconsin. Today I am going to be sharing an R package for
mediation analysis of microbiome data. You can find these slides at this link,
and all the discussion is in this paper. Ok, before I get into the main
substance of this talk, I just want to give a short philosophical point that
something I've been hearing from a lot of people these days is that, maybe we'll
never need open source software anymore. Everyone will be able to just clawed
their way to whatever nature analysis that they need or whatever data science
you don't really need to actually review any open source software. I actually
totally disagree with this, and I think it's important because this whole talk
is a software talk. So what I think is actually going to happen is that it'll be
easy to get mediocre analysis just any easy data analysis without really
understanding where things are going. Actually a lot of the education that
happens in taking people to learn about very advanced statistical methods
actually happens at the software level. One of our goals in this project is to
write very good examples a little bit of a clear interface that people feel some
agency and using mediation analysis for micro-bounds. A common example of this
it's known that chemotherapy can change the microbiome which then leads to
certain adverse events and those can actually affect the treatment so you can't
give people as much dosage if they're having these very severe side effects so
it actually makes the treatment potentially less effective right. So a lot of
interest in how the microbiome mediates relationship in the environment and
host. Statistics can help think about this problem much more clearly right so
how do you reason about mediation in a statistical way? You can think in this
term this diagram why is the outcome of interest? So that could be that could be
say mucositis m is a mediator like a micro-vom T is treatment chemotherapy. X
are background variables that are potentially influencing both the response and
the mediator but which are not affected by the treatment. They're called
pretreatment mediators. These models can be estimated in a relatively
straightforward way using linear regression so if you're willing to assume that
the effect of the treatment and the pretreatment variables on the mediators is
linear then you can just write it down this way similarly the relationship from
the treatment to the response and the mediators to the response if it's linear
you can write it like this and then you get a very clean formula for the
indirect effect so the effect of the treatment on the response via the mediators
is alpha times beta which makes sense because you think of The link from t to m
is alpha. The link from m to y is beta. You multiply these together and you get
the indirect effect. But linear models are very limiting, especially in
multi-ohmics settings where you have non-negative data, compositional data. You
can try to transform your way to linearity but you might not always be able to
So how can you think about non-linear mediation analysis? One effective way is a
perspective called generalized causal mediation analysis Here there are two
types of counterfactuals The first kind of counterfactual is for the mediator So
these are the mediator under different treatments t And then there's also one
for the response There's the first It looks a little bit strange because you
have two kinds of treatments going on But the way the notation means is the
mediator had the treatment in T prime The response had the treatment in T and
the mediator when this value m Does that make sense? So, right, the mediator m
of t prime, it has taken some value when it had that treatment You substitute
that value into the second argument of this y And that represents the value of y
had the treatment been t and the mediator been m Okay, so there are two kinds of
counterfactuals The first is standard: you can have a mediator under different
values of the treatment and that's m of t Second is a stranger looking one y has
two arguments: t and m What we're substituting in this second argument is value
the mediator had taken had the treatment been t prime But the point is even if
the mediator is a certain value if you fix the value of the mediator When you
change the treatment you might have a different response So even for a fixed
value there's nothing traveling through that m path Changing t could change y so
that's why you would write that first argument So this quantity is never
actually observed if t is not equal to t prime but you can still abstractly
think about it There's a nice geometric interpretation of this so Here the
colors are treatment and control so think of red is treatment green is control y
is the response so think of it could be like the abundance of some bacteria or
it could be like the severity of the mucositis symptoms m is the mediator so it
could be like some bacteria I'm drawing these two normal distributions saying
these are the distributions of the mediator under treatment and control So in
this case the treatment and control doesn't really influence the mediator
there's no difference in the media and retrieval control but for a given value
of mediator there's a very clear difference in the response So we have a big
change in the response Y for a given value of mediator that's a direct effect
you could also have an indirect effect so imagine here M is like a microbe Y is
like a metabolite and suppose you have a treatment that changes the amount of
this microbe right so then even if for a given value of the microbe there's
never any change in the response between treatment and control then you can
still have a large change in the observed Y due to the treatment because M has
changed right so it is you've gone from this typical value to this typical value
it looks like the response is changing and it's entirely through the mediators
this is what an indirect effect in most studies real-world you're gonna have a
mix of these both during directing the direct effect and kind of the art of
causal mediation analysis is being able to decompose an observed effect into a
component that's indirect your component is direct so I drew it all in one
dimensional but then in real world we're going to have multi-dimensional
mediators and multi-dimensional response the whole goal of the mediation package
for multimedia package is going to be making it easy to do these sort of
multi-omic high dimensional examples so how do we build this package imagine you
have just a windy mediator and a 1d response the formula I gave for the linear
regression you can write it down like this and in this case there's a very
simple formula for direct and indirect effects it's just the coefficients of
these two variables so that suggests a very obvious implementation you could
just have the response the mediator and the treatment and then run those linear
regressions compute those parameters and then get that indirect and direct
effects right so everything would be done trouble is this won't work in that
generalized nonlinear version because we don't have a formula in terms of the
parameters we need to think in terms of the predicted values right there M of T
and the y of T and M so how can you still run some sort of mediation analysis
like what would the interface be if it's not just accessible through a parameter
the solution from the mediation package is pass in a model object in those
diagrams I showed you if you can estimate those curves you can estimate the
direct and indirect effects so all you actually need access to are the functions
that predict the effect given some value of mediators some value of the
treatment and that's so that's how this function works internally it's just
running predict at different configurations and this is very modular approach
you can substitute different kinds of methods that have a prediction method for
example you can use GLM and get substitute logistic models everything still
works so our philosophy is let's do something like mediation package but instead
of being univariate we allow it to be multivariate this is an example of real
function call using our package here would be you have a maybe the microbiome is
the response so you want to use a logistic normal multinomial model as a
response and then you have many mediators so you think it might make sense to
have some sort of penalized regression or maybe you have many many pre treatment
variables so for each of those mediators this is going to fit a glenn net model
okay so one of the reasons I like this design is that it can you can very easily
extend it so we have a nonlinear version using random forest we have a hurdle
model so vrms we have a survival version right so very easy to extend beyond
just modeling one of the priorities in this package is making it easy to prepare
your data for the mediation analysis so we defined a data class think of it kind
of like a summarized experiment but for mediation analysis and we have a way of
constructing it using syntax like tidyverse right so i want to treat all the
variables that start with m those are going to be outcomes anything that starts
with g that's going to be mediators right so it makes it a little bit cleaner
code to start running your mediation analysis after you've estimated a model a
very natural thing to want to do is to assess the uncertainty now one of the
challenges of this sort of software approach is we're trying to support many
models but that means we don't have we are not actually assuming that any one of
those models provides formal inference right so this is just a limitation of
this package so instead what we're doing is we allow you to bootstrap so it will
run the entire mediation outcome model combination that you've specified and it
will run bootstrap versions and return direct and indirect effects on all those
bootstrap times it's a little bit of a compromise we now can run many more kinds
of models and model combinations but we don't have any formal theory for getting
confidence intervals for those different combinations I think it'd be
interesting if there is like eventually we do develop theory for different paths
in this mediation outcome model to be able to incorporate those in the
uncertainty estimation and finally we do have a way of getting sensitivity
analysis so any kind of causal analysis you have to make some untestable
assumption the traditional one in ordinary causal inference is ignorability so
you assume that the treatment is independent of all the unmeasured confounders
right mediation analysis has something similar so the treatment can't be related
to unmeasured confounders it also requires that the mediators are independent of
any unmeasured confounders like you can't just treat the people who are going to
have very good like mediators in a certain value range. So to test this you do
sensitivity analysis where you create those confounders that violate the
assumption and you see how strong would the confounding have to be before the
direct effect or indirect effect estimates change so practically we take the
fitted values and then we simulate from our fitted model but where we have
correlated outcome and mediators okay last few minutes i just want to give a
short example so this comes from the ibd mdb data set it's a large study tries
to see changes in microbiome according to like in healthy people and also in two
different subtypes of ibd uh ulcerative colitis and chronic disease they run
both metabolomics and microbiome 16s sequencing for 220 patients or whole genome
sequencing sorry there are several thousands of these metabolites in genre we
got it from this curated metabolism microbiome repository so if you're
interested in integrative analysis and you haven't already heard about this this
is a really excellent resource lots of data sets with paired microbiome and
metabolism this is kind of an illustrative example so we filtered pretty
aggressively and then we transformed everything so that a linear model or a
sparse linear model is sort of reasonable in these cases so we apply log ratio
and log transformation for the metabolites and microbiome i'm going to assume
that the metabolites are the outcome and the microbes are the mediators so this
is an assumption you could imagine the paths are actually their feedback loops
but just to test hypothesis of the microbes are mediating relationship between
the disease type and the metabolite abundance this is how you would formalize it
in this diagram i am showing one way of interpreting the global indirect
indirect effects so here each panel the points are the same the different panels
correspond to different metabolites each point corresponds to one sample the
locations of the points were determined just using the microbiome so samples
that are close to each other have very similar microbiome profiles but it
doesn't use the location of the points doesn't use a metabolite instead the look
the size of the points reflects the metabolite right so points where it's larger
mean you have more of that metabolite points where it's smaller means you have
less of that metabolism color or other different disease groups so control
ulcerative colitis Crohn's disease and interesting thing is so these are the top
direct effects so that means that then metabolite is very different between the
different colors and these are the top indirect effects so it means that their
metabolite is different across the groups and it's mediated by the microbes and
you can see in the ones that are mediated by the microbes that there's kind of a
systematic difference in the size of the points so it's showing that oh wait
there's a systematic difference according to the microbiome all right so it's
not just that there's a difference in the size of the points overall is that it
might be mediated by and then you can tease it dig in a little bit more deeply
so here I'm showing the individual mediators that are significant individual
metabolites that are responding and you can see this should remind you a lot of
that geometric diagram I had at the beginning all right so even though at any
one value of the species it's not that large of a change and abundance to them
metabolites the differences in the species abundance are very strongly
associated with disease so the change in disease is related to their spots
metabolite via these issues so it's like the two histograms in the bottom are
shifting according to what should be good here okay and then we can run a
sensitivity analysis we can change the degree of correlation between the errors
one of them disappears very quickly but then the other two it seems relatively
more stable even more relatively large compound okay you can find the paper here
the package is on Crayon you can also get the documentation at this link happy
to take any questions thank you