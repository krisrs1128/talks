
function title_page()  {

  d3.select("#content")
    .selectAll("div")
    .remove();

  d3.select("#content")
    .append("div")
    .attr("id", "initial_title")
    .style("padding-top", "20%")
    .append("text")
    .style("font-size", "40px")
    .style("font-family", "Hind")
    .text("Abundance Modeling for Exploratory Micribiome Analysis");

  d3.select("#content")
    .append("div")
    .attr("id", "author")
    .style("padding-top", "5%")
    .append("text")
    .style("font-size", "20px")
    .style("font-family", "Bitter")
    .text("Kris Sankaran");

  d3.select("#content")
    .append("div")
    .attr("id", "date")
    .append("text")
    .style("font-size", "20px")
    .style("font-family", "Bitter")
    .text("4/12/2017");
}

function slide1() {
  slide_text(
    ["This is the first bullet", "this is the second"],
    "INTRODUCTION"
  );
}

function slide2() {
  slide_text(
    ["this is a bullet also"],
    "Slide 2"
  );
}

function slide_text(bullet_content, title) {
  d3.select("#section_title")
    .selectAll("text")
    .remove();

  d3.select("#content")
    .selectAll("div")
    .remove();

  d3.select("#content")
    .selectAll("ul")
    .remove();


  d3.select("#section_title")
    .append("text")
    .text(title);


  d3.select("#content")
    .append("ul")
    .style("padding-top", "10%")
    .selectAll(".bullet_point")
    .data(bullet_content)
    .enter()
    .append("li")
    .classed("bullet_point", true)
    .text(function(d) { return d; });

}
