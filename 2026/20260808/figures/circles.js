
d3.select("svg")
  .selectAll("circle")
  .data([1, Math.sqrt(7)]).enter()
  .append("circle")
  .attrs({
    r: d => 40 * d,
    cx: (d, i) => 150 + 200 * i,
    cy: 200,
    fill: "black"
  })