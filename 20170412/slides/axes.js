
function axes_taxa() {
  var x_axis = d3.axisBottom(scales.taxa)
      .tickSize(0);
  d3.select("#vis svg")
    .append("g")
    .attrs({
      "id": "x_axis",
      "class": "x_axis",
      "transform": "translate(0," + scales.subject.range()[0] + ")",
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll("#x_axis text")
    .attrs({"transform": "rotate(20)translate(0,15)"});

  var y_axis = d3.axisLeft(scales.counts)
      .tickSize(0)
      .ticks(4);
  d3.select("#vis svg")
    .selectAll(".y_axis")
    .data(scales.subject.domain())
    .enter()
    .append("g")
    .attrs({
      "id": "y_axis",
      "class": "y_axis",
      "transform": function(d) { return "translate(" + (scales.taxa_top.range()[0]) + "," + (scales.subject(d)) + ")"; },
      "opacity": 0
    })
    .call(y_axis);

  var facet_data = [];
  for (var i = 0; i < scales.subject.domain().length; i++) {
    var cur_line = [];
    for (var j = 0; j < 2; j++) {
      cur_line.push({
        "x": scales.taxa_top.range()[j],
        "y": scales.subject(scales.subject.domain()[i])
      });
    }
    facet_data.push(cur_line);
  }

  facet_data = facet_data.concat([
    [{"x": scales.taxa_top.range()[0], "y": scales.subject.range()[1]},
     {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[1]}],
    [{"x": scales.taxa_top.range()[1], "y": scales.subject.range()[1]},
     {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[0]}]
  ]);

  var facet_line = d3.line()
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; });

  d3.select("#vis svg")
    .selectAll(".facet_boundary")
    .data(facet_data)
    .enter()
    .append("path")
    .attrs({
      "class": "facet_boundary",
      "d": facet_line,
      "stroke-width": 0.5,
      "stroke": "#808080",
      "opacity": 0
    });

  d3.selectAll(".facet_boundary")
    .transition("boundary")
    .duration(1000)
    .attr("opacity", 1);
  d3.selectAll(".x_axis, .y_axis")
    .transition("axis")
    .duration(1000)
    .attr("opacity", 1);
}

function axes_relative_day() {
  d3.selectAll(".x_axis").remove();
  d3.selectAll(".facet_boundary").remove();
  unbinarize_axes();

  // Draw new x axis, one per facet panel
  var x_axis = d3.axisBottom(scales.relative_day)
      .tickSize(0)
      .ticks(3, "d");

  d3.select("#vis svg")
    .selectAll(".x_axis")
    .data(scales.taxa_top.domain())
    .enter()
    .append("g")
    .attrs({
      "id": function(d) { return "x_axis" + d; },
      "class": "x_axis",
      "transform": function(d) {
        return "translate(" + scales.taxa_top(d) + "," + scales.subject.range()[0] + ")";
      },
      "opacity": 0
    })
    .call(x_axis);

  d3.selectAll(".x_axis")
    .transition()
    .duration(1000)
    .attr("opacity", 1);

  // Draw the faceting boundaries
  var facet_cols = [];
  for (var i = 0; i < scales.taxa_top.domain().length; i++) {
    var cur_line = [];
    for (j = 0; j < 2; j++) {
      cur_line.push({
        "x": scales.taxa_top(scales.taxa_top.domain()[i]),
        "y": scales.subject.range()[j]
      });
    }
    facet_cols.push(cur_line);
  }

  var facet_rows = [];
  for (var i = 0; i < scales.subject.domain().length; i++) {
    var cur_line = [];
    for (j = 0; j < 2; j++) {
      cur_line.push({
        "x": scales.taxa_top.range()[j],
        "y": scales.subject(scales.subject.domain()[i])
      });
    }
    facet_rows.push(cur_line);
  }

  // top and right most row & column
  facet_cols.push([
    {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[0]},
    {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[1]}
  ]);
  facet_rows.push([
    {"x": scales.taxa_top.range()[0], "x": scales.subject.range()[1]},
    {"y": scales.subject.range()[1], "y": scales.subject.range()[1]}
  ]);

  var facet_line = d3.line()
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; });

  d3.select("#vis svg")
    .selectAll(".facet_boundary")
    .data(facet_cols.concat(facet_rows))
    .enter()
    .append("path")
    .attrs({
      "class": "facet_boundary",
      "d": facet_line,
      "stroke-width": 0.5,
      "stroke": "#808080",
      "opacity": 0
    });

  d3.selectAll(".facet_boundary")
    .transition()
    .duration(1000)
    .attr("opacity", 1);

}

function axes_phylo_ix() {
  d3.selectAll(".x_axis").remove();
  d3.selectAll(".facet_boundary").remove();

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

  var facet_data = [];
  for (var i = 0; i < scales.subject.domain().length; i++) {
    var cur_line = [];
    for (var j = 0; j < 2; j++) {
      cur_line.push({
        "x": scales.taxa_top.range()[j],
        "y": scales.subject(scales.subject.domain()[i])
      });
    }
    facet_data.push(cur_line);
  }

  facet_data = facet_data.concat([
    [{"x": scales.taxa_top.range()[0], "y": scales.subject.range()[1]},
     {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[1]}],
    [{"x": scales.taxa_top.range()[1], "y": scales.subject.range()[1]},
     {"x": scales.taxa_top.range()[1], "y": scales.subject.range()[0]}]
  ]);

  var facet_line = d3.line()
      .x(function(d) { return d.x; })
      .y(function(d) { return d.y; });

  d3.select("#vis svg")
    .selectAll(".facet_boundary")
    .data(facet_data)
    .enter()
    .append("path")
    .attrs({
      "class": "facet_boundary",
      "d": facet_line,
      "stroke-width": 0.5,
      "stroke": "#808080",
      "opacity": 0
    });

  d3.selectAll(".facet_boundary")
    .transition("boundary")
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
