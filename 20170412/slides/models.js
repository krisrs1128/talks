
function partial_dependence_points(cur_data, x_scale, y_scale) {
  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data(cur_data, function(d) { return d.order + "_" + d.ix + "_" + d.subject; } )
    .enter()
    .append("circle")
    .attrs({
      "class": "partial_dependence",
      "r": 2,
      "opacity": 0,
      "cx": x_scale,
      "cy": y_scale
    });

  d3.selectAll(".partial_dependence")
    .transition("new_partial_dependence")
    .duration(1000)
    .attr("opacity", 1);
}

function taxa_partial_dependence(filter_types, scale_type) {
  var order_data = [].concat.apply([], f_combined["order"]);
  var filtered_data = order_data.filter(
    function(d) {
      return filter_types.indexOf(d.model_type) != -1;
    }
  );

  var panel_scale;
  if (scale_type == "counts") {
    panel_scale = scales.counts;
  } else {
    panel_scale = scales.binarized;
  }
  partial_dependence_points(
    filtered_data,
    function(d) { return scales.taxa(d.order) + 10 * Math.random(); },
    function(d) { return scales.subject(d.subject) + panel_scale(d.f_bar); }
  );
}

function partial_dependence_path(cur_data, x_scale, y_scale, key_fun) {
  var partial_dependence_line = d3.line()
      .x(function(d) {return x_scale(d); })
      .y(function(d) { return y_scale(d); });

  console.log(key_fun);
  d3.select("#vis svg")
    .selectAll(".partial_dependence")
    .data(cur_data, key_fun)
    .enter()
    .append("path")
    .attrs({
      "opacity": 0,
      "class": "partial_dependence",
      "d": partial_dependence_line
    })
    .style("stroke-dasharray", function(d) { return scales.model_dashes(d[0].algorithm); });

  d3.selectAll(".partial_dependence")
    .transition("show_partial_dependence_path")
    .duration(1000)
    .attr("opacity", 1);
}

function relative_day_partial_dependence(filter_types, scale_type) {
  var filtered_data = f_combined["rday"].filter(
    function(d) {
      return filter_types.indexOf(d[0].model_type) != -1;
    }
  );

  var panel_scale;
  if (scale_type == "counts") {
    panel_scale = scales.counts;
  } else {
    panel_scale = scales.binarized;

  }
  partial_dependence_path(
    filtered_data,
    function(d) { return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day); },
    function(d) { return scales.subject(d.subject) + panel_scale(d.f_bar); },
    function(d) { return d.ix + d.order + d.subject;}
  );
}

function phylo_ix_partial_dependence() {
  var filtered_data = f_combined["phylo_ix"].filter(
    function(d) {
      return ["conditional"].indexOf(d[0].model_type) != -1;
    }
  );

  partial_dependence_path(
    f_combined["rday"],
    function(d) { return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day); },
    function(d) { return scales.subject(d.subject) + scales.binarized(d.f_bar); },
    function(d) { return d.ix + d.order + d.subject;}
  );
}

function binarized_phylo_ix_partial_dependence() {
  var filtered_data = f_combined["phylo_ix"].filter(
    function(d) {
      return ["binarize"].indexOf(d[0].model_type) != -1;
    }
  );

  partial_dependence_path(
    filtered_data,
    function(d) { return scales.phylo_ix(d.phylo_ix); },
    function(d) { return scales.subject(d.subject) + scales.counts(d.f_bar); },
    function(d) { return d.ix + d.subject;}
  );
}

function binarized_phylo_ix_partial_dependence() {
  var filtered_data = f_combined["phylo_ix"].filter(
    function(d) {
      return ["binarize"].indexOf(d[0].model_type) != -1;
    }
  );

  partial_dependence_path(
    filtered_data,
    function(d) { return scales.phylo_ix(d.phylo_ix) },
    function(d) { return scales.subject(d.subject) + scales.binarized(d.f_bar); },
    function(d) { return d.ix + d.subject;}
  );
}

