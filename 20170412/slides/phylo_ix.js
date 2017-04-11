
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
      "cx": function(d) { return scales.taxa(d.order) + 10 * Math.random(); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      }
    });
}

function initialize_axes() {
  var x_axis = d3.axisBottom(scales.taxa)
      .tickSize(0)
  d3.select("#vis svg")
    .append("g")
    .attrs({
      "transform": "translate(0," + (10 + scales.subject.range()[0]) + ")",
      "id": "x_axis",
      "class": "axis"
    })
    .call(x_axis);

  d3.select("#x_axis")
    .selectAll("text")
    .attrs({
      "font-size": 10,
      "transform": "rotate(20)translate(0,15)"
    });

  d3.select("#x_axis")
    .selectAll("path")
    .attrs({
      "stroke-width": 0.5,
      "stroke": "#808080"
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
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.phylo_ix(d.phylo_ix); },
      "fill": function(d) { return scales.taxa_cols(d.order_top); },
      "r": 1.4
    });
}

function binarize_samples() {
  d3.select("#vis svg")
    .selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cy": function(d) {
        return scales.subject(d.subject) + scales.binarized(d.jittered_binarized);
      }
    });
}

function counts_taxa() {
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "cx": function(d) { return scales.taxa(d.order) + 10 * Math.random(); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      },
      "r": 0.7
    });

  d3.selectAll(".axis")
    .transition()
  .duration
}
