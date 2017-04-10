
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
    .text("Abundance Modeling for Exploratory Micribiome Analysis");

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
    ["From a high level, we often compute some summary statistics of the data, and interpret them in terms of contextual information",
     "For example, we often interpret PCA scores / loadings and LDA mixing weights / topics in terms of sample and taxonomic characteristics",
     "There are exceptions though, consider hypothesis testing or more careful uncertainty quantification",
     "If we will be guiding interpretation based on these contextual features anyways, why not directly build a model of the data using them?"
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
  slide_text(
    [
      "A straightforwards, but not particularly informative, follow-up technique is to compare test-set performances ",
      "To explore the shape of the response surface, which lives in a high-dimensional space, we can visualize partial dependence of the response \\(y\\left(\\mathbf{x}\\right)\\) on a subset \\(s\\) of coordinates, \\begin{align} \\bar y\\left(\\mathbf{x}_{s}\\right) &:= \\mathbf{E}_{F_{X_{-s}}}\\left[y\\left(\\mathbf{x}_{s}, X_{-s}\\right)\\right] \\\\ &\\approx \\frac{1}{n}\\sum_{i = 1}^{n} y\\left(x_{is}, x_{i,-s}\\right)\\end{align}",
      "This averages out the effects due to the coordinates outside of \\(s\\)."
    ],
    "Implementation Principles: Interpretation"
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
    .style("padding-top", "10%")
    .selectAll(".bullet_point")
    .data(bullet_content)
    .enter()
    .append("li")
    .classed("bullet_point", true)
    .html(function(d) { return d; });

}
