
function counts_phylo_ix() {
  d3.select("#vis svg")
    .selectAll("circle")
    .data(combined, function(d) { return d.Meas_ID + d.rsv; })
    .enter()
    .append("circle")
    .attrs({
      "cx": function(d) { return phylo_ix_scale(d.phylo_ix); },
      "cy": function(d) { return counts_scale(d.jittered_count); },
      "fill": function(d) { return taxa_cols(d.order_top); },
      "r": 2,
      "opacity": 0.8
    });
}

function binarize_phylo_ix() {
  d3.select("#vis svg")
    .selectAll("circle")
    .transition()
    .duration(3000)
    .attrs({
      "cy": function(d) { return binarized_scale(d.jittered_binarized); }
    });

}
