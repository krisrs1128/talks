
function axes_taxa() {
  var facet_rows = scales.subject.domain();
  var x_axis = d3.axisBottom(scales.taxa)
      .tickSize(0);
  d3.select("#vis svg")
    .selectAll(".x_axis")
    .data(facet_rows)
    .enter()
    .append("g")
    .attrs({
      "id": function(d) { return "x_axis" + d; },
      "class": "x_axis",
      "transform": function(d) { return "translate(0," + (scales.subject(d) + scales.subject.step()) + ")"; },
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".x_axis")
    .selectAll("text")
    .attrs({
      "transform": "rotate(20)translate(0,15)"
    });


  var last_subject = scales.subject.domain()[0];
  d3.selectAll(".x_axis:not(#x_axis" + last_subject + ") text")
    .remove();

  var y_axis = d3.axisLeft(scales.counts)
      .tickSize(0)
      .ticks(4);
  d3.select("#vis svg")
    .selectAll(".y_axis")
    .data(facet_rows)
    .enter()
    .append("g")
    .attrs({
      "id": function(d) { return "y_axis" + d; },
      "class": "y_axis",
      "transform": function(d) { return "translate(" + (scales.taxa.range()[0]) + "," + (scales.subject(d)) + ")"; },
      "opacity": 0
    })
    .call(y_axis);

  d3.selectAll(".x_axis, .y_axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}

function axes_relative_day() {
  d3.select(".x_axis").remove();
  unbinarize_axes();

  var x_axis = d3.axisBottom(scales.relative_day)
      .tickSize(0)
      .ticks(3, "d");

  var facet_cols = scales.taxa_top.domain();
  d3.select("#vis svg")
    .selectAll(".x_axis")
    .data(facet_cols)
    .enter()
    .append("g")
    .attrs({
      "id": function(d) { return "x_axis" + d; },
      "class": "x_axis",
      "transform": function(d) {
        return "translate(" + scales.taxa_top(d) + "," + (scales.subject.range()[0]) + ")";
      },
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".x_axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}

function axes_phylo_ix() {
  d3.selectAll(".x_axis").remove();

  var x_axis = d3.axisBottom(scales.phylo_ix)
      .tickSize(0)
      .ticks(7, "d");
  d3.select("#vis svg")
    .append("g")
    .attrs({
      "transform": "translate(0," + (scales.subject.range()[0]) + ")",
      "id": "x_axis",
      "class": "x_axis",
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".x_axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}

function binarize_axes() {
  var y_axis = d3.axisLeft(scales.binarized)
      .tickSize(0)
      .ticks(3);
  d3.selectAll(".y_axis")
    .transition()
    .duration(1000)
    .call(y_axis);
}

function unbinarize_axes() {
  var y_axis = d3.axisLeft(scales.counts)
    .tickSize(0)
    .ticks(3);
  d3.selectAll(".y_axis")
    .transition()
    .duration(1000)
    .call(y_axis);
} 
