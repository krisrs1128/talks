
function counts_relative_day() {
  d3.selectAll(".sample")
    .transition()
    .duration(1000)
    .attrs({
      "opacity": 0.8,
      "cx": function(d) { return scales.relative_day(d.relative_day); },
      "cy": function(d) {
        return scales.subject(d.subject) + scales.counts(d.jittered_count);
      }
    });

  d3.selectAll(".rsv")
    .transition()
    .delay(2000)
    .duration(1000)
    .attrs({
      "opacity": 0.2
    });
}
