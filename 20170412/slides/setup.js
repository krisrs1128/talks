
function setup_page() {
  d3.select("#vis")
    .append("svg")
    .attrs({
      "width": 1000,
      "height": 600
    });
}
