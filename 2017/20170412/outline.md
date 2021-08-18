
# Announcements
* We've done some work on model checking for LDA / unigram
* We've extended some of the simulations described last time
* Talk to me if you're interested, but otherwise going to focus on a unified
  talk

# Outline

# A new (basic) idea / Philosophy
* Typical exploratory microbiome workflow: Compute some summary of the data, and
  interpret it in terms of contextual information
  - E.g., compute dimensionality-reduced coordinates, then highlight according
    to taxa or sample characteristics
  - Predict sample data characteristic from counts, and interpret taxonomic
    information of important features
  - Run a probabilistic clustering / mixture model, and interpret estimated
    proportions in terms of sample data and taxonomic features
  - I'm leaving out multitable and hypothesis testing / uncertainty
    quantification elements of microbiome analysis, but this is still quite a bit

* Another tool: Use a model to predict raw (not reduced) data in terms of the
  contextual features we would be using to inteprret them anyways
* Picture: Response surface is abundance, x-axis is phylo
   - or extension to y axis is time
* Think of modeling as giving a reduction of the data, but instead of reducing
  to parameters, we are reducing to a response surface. This is giving a kind of
  smoothing.
* Some random quotes: Cox and ...

# Implementation Principles
* Principles
    - Reproducibility: Should be possible to specify models and features and get
    results with minimal effort
    - Extensibility: We should be able to run with different subsets of the
    data (or different datasets alltogether), different features, and different
    models, without having to restart from scratch or accumulate lots of new
    code
    - Shared computation: If two models use the same feature set,
    - Evaluation and Interpretability: We should be able to make some sense of
    the models after the fact, as well as characterize how well our "theory"
    approximates reality

# Implementation Techniques

* Reproducibility
  - Explicitly define inputs and outputs via configuration files
  - Generates all the responses / features on the fly, starting from a single
  phyloseq object
  - Reruns from a single command: 'micro'
* Extensibility
  - Define a unified pattern for all model training, via caret
  - Define a unified pattern for all feature generation and preprocessing
  - Define a unified pattern for metric calculation
* Shared computation
  - Deliberate pipeline management (my case uses luigi)
  - Show figure. Related to reproducibility -- backtracks from end up to the
    part you've already run up to
* Evaluation / Interpretation
  - Can get cross-validated estimates, also have a separate test set (for doing ensembling)
  - Will visualize "partial dependence" (give formula)

# Experiments

* Cleanout study
* Response: asinh transformed counts
* Feature design
    - Relative day
    - Subject ID
    - Taxonomic order
    - phylogenetic "index"
    - PCA scores
    - Phylogenetic coordinates
* We're hoping the model can learn interesting interactions more or less
  automatically

* Describe specific features used in this run, and the models I include
  - Maybe show performance across models on test set
  - Maybe show variable importances for one of the good models

* Maybe just show raw data for order feature, along with prediction
  - transition in colors for different orders and collapse into
  - Add text about hurdle modeling: We want to decompose the 0-1 from the
  nonnegative part predictions
  - Transition in the nonnegative model
  - Collapse data into 0-1, transition in proportion estimates, transition in
  predicted probabilities
* Order vs. time feature
  - First the overall predictions
* Same sort of transitions for phylogenetic feature (residual, after order is
  accounted for)

# Extensions
* Quantifying uncertainty, outside of just prediction performance
* Unified hurdle modeling (that's why performance is bad)
* Designing more careful STAN models
* More formal forecasting, if it seems useful / possible
