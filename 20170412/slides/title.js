
function title_page()  {

  d3.select("#content")
    .selectAll("ul")
    .remove();
  d3.select("#section_title")
    .selectAll("text")
    .remove();
  d3.select("#content")
    .selectAll("div")
    .remove();

  d3.select("#content")
    .append("div")
    .attr("id", "initial_title")
    .style("padding-top", "20%")
    .append("text")
    .style("font-size", "40px")
    .style("font-family", "Hind")
    .text("Abundance Modeling for Exploratory Microbiome Analysis");

  d3.select("#content")
    .style("width", "95%");

  d3.select("#content")
    .append("div")
    .attr("id", "author")
    .style("padding-top", "5%")
    .append("text")
    .style("font-size", "20px")
    .style("font-family", "Bitter")
    .text("Kris Sankaran");

  d3.select("#content")
    .append("div")
    .attr("id", "date")
    .append("text")
    .style("font-size", "20px")
    .style("font-family", "Bitter")
    .text("4/12/2017");
}

function slide1() {
  slide_text(
    [
      "<i>Problem formulation</i>: Can we apply supervised techniques to succinctly describe variation in bacterial counts?",
      "<i>Implementation</i>: Practically, how do we pursue a supervised strategy and ensure that results are interpretable?",
      "<i>Experiments</i>: Are these methods actually useful for the cleanout study data?"
    ],
    "Outline"
  );
}

function slide2() {
  slide_text(
    ["Simplifying somewhat aggressively, our work often involves computing summary statistics about a primary data source, and interpret these statistics in terms of supplementary data",
     "For example, we often interpret PCA scores / loadings and LDA mixing weights / topics in terms of sample and taxonomic characteristics",
     "(There are exceptions though, consider hypothesis testing or more careful uncertainty quantification)",
     "If we will be guiding interpretation based on these contextual features anyways, why not directly build a model of the data based on them?"
    ],
    "Motivation"
  );
}

function slide3() {
  d3.select("#vis")
    .select("img")
    .remove();

  slide_text(
    [
      "<i>Data Reduction</i>: We can think of supervised methods as giving a reduction of the data, but instead of reducing to parameters, we are reducing to a response surface",
      "<i>Characterizing Uncertainty</i>: We can measure the test error, to get a sense of how much variation can be explained by known features"
    ],
    "Proposal"
  );
}

function slide4() {
  slide_text(
    [
      "From the \"surface-fitting\" perspective, there is no need to focus on any single model, set of features, or subset of data",
      "To ensure reproducibility, we need to avoid assuming that the user has any specific feature sets or trained models",
      "Instead, we start with a raw phyloseq object and an experiment configuration file, creating all features and models from there"
    ],
    "Implementation Principles: Reproducibility"
  );

  d3.select("#content")
    .style("width", "45%")
  d3.select("#vis")
    .select("img")
    .remove();
  d3.select("#vis")
    .append("img")
    .attr("src", "experiment_conf.png")
}

function slide5() {
  d3.select("#vis")
    .select("img")
    .remove();
  d3.select("#vis")
    .append("img")
    .attr("src", "features.png");

  slide_text(
    [
      "To work easily across multiple models, we use caret",
      "We'll see some examples later that leverage caret's ability to run custom models",
      "We define a generic way of including new features, based on the configuration files"
    ],
    "Implementation Principles: Extensibility"
  );
}

function slide6() {
  d3.select("#vis")
    .select("img")
    .remove();
  slide_text(
    [
      "Across models, there is often substantial redundant computation (e.g., two models might use the same feature set)",
      "To improve efficiency, we define the dependencies between tasks using a formal pipeline library"
    ],
    "Implementation Principles: Shared Computation"
  );
}

function slide7() {
  d3.select("#content")
    .style("width", "95%");
  slide_text(
    [
      "A straightforwards, but not particularly informative, follow-up technique is to compare test-set performances",
      "Feature importances are another standard way of beginning to interpret model fit",
      "To explore the shape of the response surface, which lives in a high-dimensional space, we can visualize partial dependence of the response \\(\\mu\\left(\\mathbf{x}\\right)\\) on a subset \\(s\\) of coordinates, \\begin{align} \\tilde \\mu\\left(\\mathbf{x}_{s}\\right) &:= \\mathbf{E}_{F_{X_{-s}}}\\left[\\mu\\left(\\mathbf{x}_{s}, X_{-s}\\right)\\right] \\\\ &\\approx \\frac{1}{n}\\sum_{i = 1}^{n} \\mu\\left(x_{is}, x_{i,-s}\\right)\\end{align}",
      "This averages out the effects due to the coordinates outside of \\(s\\)."
    ],
    "Implementation Principles: Interpretation"
  );
}

function slide8() {
  slide_text(
    [
      "We will apply these ideas to reanalyze data from the cleanout study",
      "For illustration, we filter to subjects A and I, though with more computation, we could run on all subjects",
      "We \(\sinh^{-1}\) transform the response",
      "Feature set considered: \{Day (relative to cleanout), Subject ID, Taxonomic Order, position on phylogenetic tree\}",
      "We randomly remove 20\% of entries from the OTU table for validation, and all CV folds are contained in the remaining 80\%."
    ],
    "Experiment Setup"
  );
  d3.select("#vis svg")
    .remove();
}

function slide9() {
  d3.select("#content")
    .style("width", "45%");
  slide_text(
    [
      "We first try to capture broad taxonomic effects using the taxonomic order feature",
      "Each point represents one \\(\\text{rsv} \\times \\text{timepoint} \\times \\text{subject}\\) unit (for the rest of the slides)",
      "For visualization (but not model estimation), we have downsampled the RSVs and limited the number fo timepoints in view"
    ],
    "Order Effects"
  );
}

function slide10() {
  d3.select("#vis")
    .append("svg")
    .attrs({
      "width": width,
      "height": height
    });
  initialize_axes();
  initialize_samples();
  counts_taxa();
}

function slide11() {
  taxa_partial_dependence("full", "counts");

  slide_text(
    [
      "Each gray circle represents the partial effect of order, after marginalizing out all other features, for a single model",
      "Models trained across different folds are all represented",
      "It appears that zero-inflation has thrown off our naive regression models, placing many predictions midway between the zero and positive mixture components of the response",
      "As an alternative, consider the hurdle model decomposition, \\begin{align} \\mathbf{E}\\left[Y\\right] = \\mathbf{E}\\left[Y \\vert Y > 0\\right] \\mathbf{Pr}\\left(Y > 0\\right)\\end{align}"
    ],
    "Order Effects"
  );
}

function slide12() {
  d3.selectAll(".partial_dependence")
    .transition("fade_points")
    .duration(1000)
    .attr("opacity", 0.1);
  taxa_partial_dependence("conditional", "counts");
}

function slide13() {
  d3.selectAll(".partial_dependence")
    .transition("remove_points")
    .duration(1000)
    .attr("opacity", 0)
    .remove();
}

function slide14() {
  binarize_samples();
}

function slide15() {
  taxa_partial_dependence("binarized", "binarize");
}

function slide16() {
  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attr("opacity", 0)
    .remove();

  slide_text(
    [
      "Order level taxonomic effects are very coarse, but we can query a range of properties of the fitted response surface",
      "Next we consider the joint partial dependence of subject, time, and order, conditional on the phylogenetic position feature",
      "As before, we show estimates from both the naive and hurdle decomposed models"
    ],
    "Order + Time Effects"
  );
}

function slide17() {
  initialize_rsvs();
  counts_relative_day();
  slide_text(
    [
      "We've now separated each order into a separate panel column",
      "As before, the rows describe different subjects",
      "Within a panel, we have arranged samples by time and drawn lines linking the same RSV across timepoints"
    ],
    "Order + Time Effects"
  );
}

function slide18() {
  relative_day_partial_dependence("full", "counts");
  slide_text(
    [
      "Again, failing to distinguish between zero and nonzero counts leads to poor model fit",
      "Note that CART never attempts to model any change over time",
    ],
    "Order + Time Effects"
  );
}

function slide19() {
  d3.selectAll(".partial_dependence")
    .transition("fade_relative_day_full_paths")
    .duration(1000)
    .style("stroke-opacity", 0.05);
}

function slide20() {
  relative_day_partial_dependence("conditional", "counts");
  slide_text(
    [
      "Viewing the conditionally-positive partial dependences, we identify very little variation over time, at least when marginalizing everything besides order and subject",
      "That is, there seems to be little difference between this figure and the earlier one which only varied subject and taxonomic order",
      "Generally, the subject time effect seems relatively weak"
    ],
    "Order + Time Effects"
  );
}

function slide21() {
  d3.selectAll(".partial_dependence")
    .transition("fade_relative_day_positive_paths")
    .duration(1000)
    .style("stroke-opacity", 0)
    .remove();
}

function slide22() {
  binarized_relative_day();
  relative_day_partial_dependence("binarized", "binarize");

  slide_text(
    [
      "Modeling presence-absence, we note a very slight increasing trend in predicted probability of presence, at least in the time range displayed here"
    ],
    "Order + Time Effects"
  );
}

function slide23() {
  slide_text(
    [
      "We now consider effects occuring at a finer scale than taxonomic order, but without simply modeling raw RSV averages over time",
      "Our approach is to arrange all RSVs along the phylogenetic tree and use the ordering along the tips to define a new feature, and look at partial dependence after marginalizing over order",
    ],
    "Phylogentic Position Effect"
  );
}

function slide24() {
  d3.selectAll(".rsv")
    .transition()
    .duration(1000)
    .attr("opacity", 0)
    .remove();
  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attr("opacity", 0)
    .remove();

  counts_phylo_ix();
}

function slide25() {
  phylo_ix_partial_dependence();
}

function slide26() {
  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attr("opacity", 0)
    .remove();
}

function slide27() {
  binarize_samples();
  binarized_phylo_ix_partial_dependence();
}

function slide28() {
  slide_text(
    [
      "We have walked through a basic exercise in analyzing microbiome data from a supervised modeling perspective",
      "The primary advantages of this approach are that it allows the investigator to incorporate rich contextual knowledge through careful feature design and honest evaluation of the relevance of those features",
      "This increased flexibility comes at a cost of more difficult interpretation, and besides partial dependence, there are few devices that facilitate this step",
      "While it is encouraging that different models trained on across CV folds tend to estimate similar partial dependence, this is still far from honest uncertainty assessment"
    ],
    "Conclusion"
  );
}

function slide_text(bullet_content, title) {
  d3.select("#section_title")
    .selectAll("text")
    .remove();

  d3.select("#content")
    .selectAll("div")
    .remove();

  d3.select("#content")
    .selectAll("ul")
    .remove();


  d3.select("#section_title")
    .append("text")
    .text(title);


  d3.select("#content")
    .append("ul")
    .style("padding-top", "1%")
    .selectAll(".bullet_point")
    .data(bullet_content)
    .enter()
    .append("li")
    .classed("bullet_point", true)
    .html(function(d) { return d; });

}
