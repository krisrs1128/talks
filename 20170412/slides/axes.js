
function axes_taxa() {
  var x_axis = d3.axisBottom(scales.taxa)
      .tickSize(0);
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
      "transform": "rotate(20)translate(0,15)"
    });

}

function axes_relative_day() {
  d3.select("#x_axis").remove();

  var x_axis = d3.axisBottom(scales.relative_day)
      .tickSize(0)
      .ticks(3, "d");

  var facet_cols = scales.taxa_top.domain();
  d3.select("#vis svg")
    .selectAll("g")
    .data(facet_cols)
    .enter()
    .append("g")
    .attrs({
      "id": function(d) { return "x_axis" + d; },
      "class": "axis",
      "transform": function(d) {
        return "translate(" + scales.taxa_top(d) + "," + (10 + scales.subject.range()[0]) + ")";
      },
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}

function axes_phylo_ix() {
  d3.selectAll(".axis").remove();

  var x_axis = d3.axisBottom(scales.phylo_ix)
    .tickSize(0)
      .ticks(7, "d");
  d3.select("#vis svg")
    .append("g")
    .attrs({
      "transform": "translate(0," + (10 + scales.subject.range()[0]) + ")",
      "id": "x_axis",
      "class": "axis",
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);
}
