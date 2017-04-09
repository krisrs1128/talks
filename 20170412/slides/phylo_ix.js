
function initialize_samples() {
  d3.select("#vis svg")
    .selectAll(".sample")
    .data(combined, function(d) { return d.Meas_ID + d.rsv; })
    .enter()
    .append("circle")
    .attrs({
      "class": "sample",
      "opacity": 0,
      "r": 3,
      "fill": function(d) { return scales.taxa_cols(d.order_top); },
      "cx": function(d) { return scales.phylo_ix(d.phylo_ix); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count)
      }
    });
}

function initialize_rsvs() {
  line_fun = d3.line()
    .x(function(d) {
      return scales.taxa_top(d.order_top) + scales.relative_day(d.relative_day);
    })
    .y(function(d) {
      return scales.subject(d.subject) + scales.counts(d.jittered_count);
    });

  d3.select("#vis svg")
    .selectAll(".rsv")
    .data(rsv)
    .enter()
    .append("path")
    .attrs({
      "class": "rsv",
      "d": line_fun,
      "stroke": function(d) { return scales.taxa_cols(d[0].order_top); },
      "opacity": 0
    });
}

function counts_phylo_ix() {
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.phylo_ix(d.phylo_ix); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      },
      "fill": function(d) { return scales.taxa_cols(d.order_top); },
      "opacity": 0.8
    });
}

function binarize_phylo_ix() {
  d3.select("#vis svg")
    .selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cy": function(d) { return scales.binarized(d.jittered_binarized); }
    });
}

function counts_taxa() {
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.taxa(d.order) + 10 * Math.random(); },
      "opacity": 0.6
    });
}
