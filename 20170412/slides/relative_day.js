
function update_relative_day(y_scale) {
  var line_fun = d3.line()
    .x(function(d) {
      return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day);
    })
    .y(y_scale);

  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "opacity": 0.8,
      "cx": function(d) {
        return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day);
      },
      "cy": y_scale
    });

  d3.selectAll(".rsv")
    .transition()
    .duration(1000)
    .attrs({
      "d": line_fun,
      "opacity": 0.2
    });
}

function counts_relative_day() {
  update_relative_day(function(d) { return scales.subject(d.subject) + scales.counts(d.jittered_count); });
}

function binarized_relative_day() {
  update_relative_day(function(d) { return scales.subject(d.subject) + scales.binarized(d.jittered_binarized) });
}
