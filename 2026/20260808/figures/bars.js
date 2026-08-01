
d3.select("svg")
  .selectAll("rect")
  .data([1, 7]).enter()
  .append("rect")
  .attrs({
    x: (d, i) => 50 + 120 * i,
    y: d => 400 -  40 * d,
    height: d => 40 * d,
    width: 100,
    fill: "black"
  })