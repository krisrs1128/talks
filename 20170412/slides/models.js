
function partial_dependence_points(cur_data, x_scale, y_scale) {
  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data(cur_data)
    .enter()
    .append("circle")
    .attrs({
      "class": "partial_dependence",
      "r": 5,
      "opacity": 0,
      "cx": x_scale,
      "cy": y_scale
    });

  d3.selectAll(".partial_dependence")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}

function taxa_partial_dependence() {
  partial_dependence_points(
    [].concat.apply([], f_combined["order"]),
    function(d) { return scales.taxa(d.order) + 5; },
    function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); }
  );
}

function partial_dependence_path(cur_data, x_scale, y_scale) {
  d3.selectAll(".partial_dependence")
    .remove();

  var partial_dependence_line = d3.line()
      .x(function(d) {return x_scale(d); })
      .y(function(d) { return y_scale(d); });

  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data(cur_data)
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

function relative_day_partial_dependence() {
  partial_dependence_path(
    f_combined["relative_day"],
    function(d) { return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day); },
    function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); }
  );
}

function phylo_ix_partial_dependence() {
  partial_dependence_path(
    f_combined["phylo_ix"],
    function(d) { return scales.phylo_ix(d.phylo_ix) },
    function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); }
  );
}
