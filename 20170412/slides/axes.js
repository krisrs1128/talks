
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
      "font-size": 10,
      "transform": "rotate(20)translate(0,15)"
    });

}

function axes_relative_day() {
  d3.select("#x_axis").remove();
  var x_axis = d3.axisBottom(scales.relative_day)
      .tickSize(0)
      .ticks(3);

  d3.select("#vis svg")
    .append("g")
    .attrs({
      "transform": "translate(0," + (10 + scales.subject.range()[0]) + ")"
    })
    .call(x_axis)
}
