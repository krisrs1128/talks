
function initialize_samples() {
  d3.select("#vis svg")
    .selectAll(".sample")
    .data(combined, function(d) { return d.Meas_ID + d.rsv; })
    .enter()
    .append("circle")
    .attrs({
      "class": "sample",
      "r": 0,
      "fill": function(d) { return scales.taxa_cols(d.order_top); },
      "cx": function(d) { return scales.taxa(d.order) + 5 + 10 * Math.random(); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      }
    });
}

function initialize_rsvs() {
  d3.select("#vis svg")
    .selectAll(".rsv")
    .data(rsv)
    .enter()
    .append("path")
    .attrs({
      "class": "rsv",
      "stroke": function(d) { return scales.taxa_cols(d[0].order_top); },
      "opacity": 0
    });
}

function counts_phylo_ix() {
  unbinarize_axes();
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.phylo_ix(d.phylo_ix); },
      "cy": function(d) {return scales.subject(d.subject) + scales.counts(d.jittered_count);},
      "fill": function(d) { return scales.taxa_cols(d.order_top); },
    });
}

function binarize_samples() {
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cy": function(d) {
        return scales.subject(d.subject) + scales.binarized(d.jittered_binarized);
      }
    });
}

function counts_taxa() {
  d3.select("#vis svg")
    .append("g")
    .attr("class", "fill_legend")
    .attr("transform", "translate(" + (width - 100) + ",20)")
  var fill_legend = d3.legendColor()
      .scale(scales.taxa_cols);

  d3.select(".fill_legend")
    .call(fill_legend);

  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.taxa(d.order) + 5 + 10 * Math.random(); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      },
      "r": 2
    });
}
