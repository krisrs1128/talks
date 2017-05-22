
function slide_text(bullet_content, title) {
  clear_content();
  d3.select("#section_title")
    .append("text")
    .text(title);

  d3.select("#content")
    .append("ul")
    .style("padding-top", "1%")
    .selectAll(".bullet_point")
    .data(bullet_content)
    .enter()
    .append("li")
    .classed("bullet_point", true)
    .html(function(d) { return d; });
}

function clear_content() {
  d3.select("#section_title")
    .selectAll("text")
    .remove();

  d3.select("#content")
    .selectAll("div")
    .remove();

  d3.select("#content")
    .selectAll("ul")
    .remove();
}

function clear_callout() {
  d3.select("#content")
    .selectAll(".callout")
    .transition("fade")
    .duration(200)
    .style("opacity", 0);
}
