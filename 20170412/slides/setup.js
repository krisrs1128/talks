
function setup_page() {
  d3.select("#vis")
    .append("svg")
    .attrs({
      "width": width,
      "height": height
    });
}
