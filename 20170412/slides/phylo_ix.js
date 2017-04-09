function draw_phylo(context) {
  detached_container = document.createElement("custom");

	//Clear canvas
	context.fillStyle = "#fff";
	context.rect(0,0,canvas.attr("width"),canvas.attr("height"));
	context.fill();

  phylo_binding.each(function(d) {
    var sample = d3.select(this);
    context.fillStyle = sample.attr("fill");
    context.beginPath();
    context.arc(
      sample.attr("cx"),
      sample.attr("cy"),
      sample.attr("r"),
      0,
      2 * Math.PI,
      true
    );
    context.fill();
    context.closePath();
  });

}

function counts_phylo_ix() {
  phylo_binding = phylo_container.selectAll("circle")
    .data(combined, function(d) { return d.Meas_ID + d.rsv; })
    .enter()
    .append("circle")
    .attrs({
      "cx": function(d) { return phylo_ix_scale(d.phylo_ix); },
      "cy": function(d) { return counts_scale(d.jittered_count); },
      "fill": function(d) { return taxa_cols(d.order_top); },
      "r": 2,
      "opacity": 0.5
    });
}

function binarize_phylo_ix() {
  phylo_container.selectAll("circle")
    .transition()
    .duration(5000)
    .attrs({
      "cy": function(d) { return binarize_scale(d.jittered_binarized); }
    });

  console.log("binarized")
}
