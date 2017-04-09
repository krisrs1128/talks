
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
