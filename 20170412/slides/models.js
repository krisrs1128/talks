
function initialize_partial_dependence() {
  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data([].concat.apply([], f_combined["order"]))
    .enter()
    .append("circle")
    .attrs({
      "class": "partial_dependence",
      "r": 5,
      "opacity": 0,
      "cx": function(d) { return scales.taxa(d.order) + 5; },
      "cy": function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); }
    });
}

function taxa_partial_dependence() {
  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attrs({
      "opacity": 1
    });
}

function phylo_ix_partial_dependence() {
  d3.selectAll(".partial_dependence")
    .remove();

  var partial_dependence_line = d3.line()
      .x(function(d) {
        console.log(d)
        return scales.phylo_ix(d.phylo_ix);
      })
      .y(function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); });

  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data(f_combined["phylo_ix"])
    .enter()
    .append("path")
    .attrs({
      "opacity": 0,
      "class": "partial_dependence",
      "d": partial_dependence_line
    });

  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}
