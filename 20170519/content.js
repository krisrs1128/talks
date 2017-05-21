function get_slides() {
  var slide_funs = [];

  slide_funs.push(
    function() {
      d3.select("#content")
        .append("div")
        .attrs({
          "class": "main_title"
        })
        .text("Jane Austen, Gut Microbes, and Exploratory Data Analysis")
    }
  );


  slide_funs.push(
    function() {
      d3.select("#content")
        .selectAll(".main_title")
        .remove();

      d3.select("#content")
        .append("div")
        .attrs({"class": "callout"})
        .style("opacity", 0)
        .text(
          "I study the ways that statistical methods for analyzing text data can be useful for studying the microbiome (The bacteria that live in, on, and around us)."
        );

      d3.select("#content")
        .selectAll(".callout")
        .transition()
        .duration(1000)
        .style("opacity", 1);

      d3.select("#content")
        .append("img");
    }
  );

  slide_funs.push(
    function() {
      d3.select("#content")
        .selectAll(".callout")
        .transition("fade")
        .duration(1000)
        .style("opacity", 0);
    }
  );

  slide_funs.push(
    function() {
      d3.select("#content")
        .selectAll(".callout")
        .text(
          "In both problems, we care about finding representations of complex data sets (collections of webpages or bacterial abundances) that facilitate human interpretation (e.g., clusters of similar documents or samples)."
        );

      d3.select("#content")
        .selectAll(".callout")
        .transition("arrive")
        .duration(1000)
        .style("opacity", 1);
    }
  );

  slide_funs.push(
    function() {
      d3.select("#content")
        .selectAll(".callout")
        .transition("fade")
        .duration(1000)
        .style("opacity", 0);
    }
  );

  slide_funs.push(
    function() {
      clear_content();
      pride_prejudice_opening();
    }
  );

  slide_funs.push(opening_sentiments);
  slide_funs.push(stack_words);
  slide_funs.push(first_bar);
  slide_funs.push(fade_word_list);
  slide_funs.push(next_words(1));
  slide_funs.push(fade_word_list);
  slide_funs.push(next_words(2));
  slide_funs.push(fade_word_list);
  slide_funs.push(remaining_bars);
  slide_funs.push(all_book_bars);
  slide_funs.push(highlight_worst);
  slide_funs.push(mansfield_text);
  slide_funs.push(dtm_slide);
  slide_funs.push(add_bacteria_counts);
  slide_funs.push(remove_matrices);
  slide_funs.push(sentiment_sketch);
  slide_funs.push(microbiome_sketch);
  slide_funs.push(relate_microbiome);

  return slide_funs;
}

function pride_prejudice_opening() {
  var opening = book.filter(
    function(d) {
      return d.book == "Pride & Prejudice" && d.index == 0;
    }
  );

  var line_numbers = opening.map(function(d) { return d.linenumber; });
  var scales = {
    "y": d3.scaleLinear()
      .domain(d3.extent(line_numbers))
      .range([20, 1200]),
    "x": function(x) { return 10 * x; }
  };

  elem.selectAll(".austen_text")
    .data(opening).enter()
    .append("text")
    .attrs({
      "class": "austen_text",
      "y": function(d) { return scales.y(d.linenumber); },
      "x": function(d) { return scales.x(d.nchar_offset); },
      "dy": "0.45em"
    })
    .style("fill", "white")
    .text(function(d) { return d.word; });

  elem.selectAll(".austen_text")
    .transition()
    .duration(1500)
    .attr("x", function(d) { return scales.x(d.nchar_offset); })
    .style("fill", "black");
}

function opening_sentiments() {
  var scales = {
    "fill": d3.scaleOrdinal()
      .domain(["none", "positive", "negative"])
      .range(["#ebebeb", "#7fc7c4", "#e36e30"])
  };

  d3.selectAll(".austen_text")
    .transition()
    .duration(1000)
    .style("fill", function(d) { return scales.fill(d.sentiment); });
}

function stack_scales() {
  var sentiment_ix = book.map(function(d) { return d.sentiment_ix; });
  return {
    "x": d3.scaleOrdinal()
      .domain(["none", "positive", "negative"])
      .range([-1000, 0, 150]),
    "y": d3.scaleLinear()
      .domain(d3.extent(sentiment_ix))
      .range([100, 15000]),
    "fill": d3.scaleOrdinal()
      .domain(["none", "positive", "negative"])
      .range(["white", "#7fc7c4", "#e36e30"])
  };
}

function bar_scales() {
  var index = sentiment.map(function(d) { return d.index; });
  var sentiment_val = sentiment.map(function(d) { return d.sentiment; });
  var book_order = ["Emma", "Persuasion", "Pride & Prejudice", "Mansfield Park",
                    "Sense & Sensibility", "Northanger Abbey"];
  return {
    "height_initial": d3.scaleLinear()
      .domain(d3.extent(sentiment_val))
      .range([500, -500]),
    "height": d3.scaleLinear()
      .domain(d3.extent(sentiment_val))
      .range([40, -40]),
    "x": d3.scaleLinear()
      .domain(d3.extent(index))
      .range([350, 1500]),
    "fill": function(d) {
      if (d.sentiment > 0) {
        return "#7fc7c4";
      }
      return "#e36e30";
    },
    "facet": d3.scaleOrdinal()
      .domain(book_order)
      .range(d3.range(100, 700, 100))
  };
}

function stack_words() {
  var scales = stack_scales();
  elem.selectAll(".austen_text")
    .transition()
    .duration(1000)
    .attrs({
      "x": function(d) { return scales.x(d.sentiment); },
      "y": function(d) { return scales.y(d.sentiment_ix); }
    })
    .style(
      "fill",
      function(d) { return scales.fill(d.sentiment); }
    );
}

function first_bar() {
  var scales = bar_scales();
  elem.selectAll(".sentiment_bar")
    .data(sentiment).enter()
    .append("rect")
    .attrs({
      "class": function(d) {
        if (d.index < 3 & d.book == "Pride & Prejudice") {
          return "sentiment_bar" + d.index;
        }
        return "sentiment_bar";
      },
      "x": function(d) { return scales.x(10 * d.index); },
      "y": 0,
      "width": scales.x(10) - scales.x(0),
      "height": 0,
      "fill": function(d) { return scales.fill(d); },
      "transform": function(d) { return "translate(0, " + scales.facet(d.book) + ")"; }
    });

  display_bar(".sentiment_bar0");
}

function display_bar(class_name) {
  var scales = bar_scales();
  elem.selectAll(class_name)
    .transition()
    .duration(1000)
    .attrs({
      "y": function(d) { return Math.min(0, scales.height_initial(d.sentiment)); },
      "height": function(d) {
        return Math.abs(scales.height_initial(d.sentiment) - scales.height_initial(0));
      }
    });
}

function fade_word_list() {
  elem.selectAll(".austen_text")
    .transition()
    .duration(1000)
    .attrs({
      "y": 0
    })
    .style("fill", "white")
    .remove();
}

function next_words(index) {
  return function() {
    var scales = stack_scales();
    elem.selectAll(".austen_text")
      .data(book.filter(function(d) { return d.index == index && d.sentiment != "none"})).enter()
      .append("text")
      .attrs({
        "class": "austen_text",
        "dy": "0.45em",
        "y": 0,
        "x": function(d) {
          return scales.x(d.sentiment);
        }
      })
      .text(function(d) { return d.word; })
      .style("fill", "white");

    stack_words();
    display_bar(".sentiment_bar" + index);
  };
}

function remaining_bars() {
  var scales = bar_scales();

  function transition_bars(x) {
    x.transition()
    .duration(1500)
    .attrs({
      "x": function(d) { return scales.x(d.index); },
      "width": scales.x(1) - scales.x(0),
      "y": function(d) {
        if (d.book == "Pride & Prejudice") {
          return Math.min(0, scales.height(d.sentiment));
        }
        return 0;
      },
      "height": function(d) {
        if (d.book == "Pride & Prejudice") {
          return Math.abs(scales.height(d.sentiment) - scales.height(0));
        }
        return 0;
      }
    });
  }
  transition_bars(elem.selectAll(".sentiment_bar"))
  transition_bars(elem.selectAll(".sentiment_bar0"))
  transition_bars(elem.selectAll(".sentiment_bar1"))
  transition_bars(elem.selectAll(".sentiment_bar2"))
}

function all_book_bars() {
  var scales = bar_scales();

  elem.selectAll(".sentiment_bar")
    .attrs({
      "fill-opacity": function(d) {
        if (d.book == "Pride & Prejudice") {
          return 1;
        }
        return 0;
      }
    });

  elem.selectAll(".sentiment_bar")
    .transition()
    .duration(1000)
    .attrs({
      "fill-opacity": 1,
      "y": function(d) { return Math.min(0, scales.height(d.sentiment)); },
      "height": function(d) { return Math.abs(scales.height(d.sentiment) - scales.height(0)); }
    });

  elem.selectAll(".book_label")
    .data(scales.facet.domain()).enter()
    .append("text")
    .attrs({
      "class": "book_label",
      "x": 100,
      "y": function(d) { return scales.facet(d); }
    })
    .style("fill", "white")
    .text(function(d) { return d; });

  elem.selectAll(".book_label")
    .transition()
    .duration(1000)
    .style("fill", "black");
}

function highlight_worst() {
  function fade_rest(class_name) {
    elem.selectAll(class_name)
      .transition()
      .duration(1000)
      .attrs({
        "fill-opacity": function(d) {
          if (d.index == 179 & d.book == "Mansfield Park") {
            return 1;
          }
          return 0.1;
        }
      });
  }

  var classes = [".sentiment_bar0", ".sentiment_bar1", ".sentiment_bar2", ".sentiment_bar"];
  for (var i = 0; i < classes.length; i++) {
    fade_rest(classes[i]);
  }

  elem.selectAll(".book_label")
    .transition()
    .duration(1000)
    .style(
      "fill",
      function(d) {
        if (d == "Mansfield Park") {
          return "black";
        }
        return "#ebebeb";
      }
    );
}

function remove_bars() {
  elem.selectAll(".book_label")
    .transition("fade_labels")
    .duration(1000)
    .attr("y", 100)
    .style(
      "opacity",
      function(d) {
        if (d == "Mansfield Park") {
          return 1;
        }
        return 0;
      }
    );

  function remove_helper(class_name) {
    elem.selectAll(class_name)
      .attrs({
        "fill-opacity": function(d) {
          if (d.book == "Mansfield Park") {
            if (d.index == 179) {
              return 1;
            } else {
              return 0.1;
            }
          } else {
            return 0;
          }
        }
      });
  }

  remove_helper(".sentiment_bar0");
  remove_helper(".sentiment_bar1");
  remove_helper(".sentiment_bar2");
  remove_helper(".sentiment_bar");
  elem.selectAll(".sentiment_bar")
    .transition("move_bars")
    .duration(1000)
    .attr("transform", "translate(0, 100)");
}

function mansfield_text() {
  remove_bars();
  var mansfield = book.filter(function(d) { return d.book == "Mansfield Park"; });
  var line_numbers = mansfield.map(function(d) { return d.linenumber; });

  var scales = {
    "y": d3.scaleLinear()
      .domain(d3.extent(line_numbers))
      .range([200, 1200]),
    "x": function(x) { return 10 * x; },
    "fill": d3.scaleOrdinal()
      .domain(["none", "positive", "negative"])
      .range(["#ebebeb", "#7fc7c4", "#e36e30"])
  };

  elem.selectAll(".austen_text")
    .data(mansfield).enter()
    .append("text")
    .attrs({
      "class": "austen_text",
      "y": function(d) { return scales.y(d.linenumber); },
      "dy": "0.35em",
      "x": function(d) { return scales.x(d.nchar_offset); },
      "fill": function(d) { return scales.fill(d.sentiment); }
    })
    .style("opacity", 0)
    .text(function(d) { return d.word; })

  elem.selectAll(".austen_text")
    .transition()
    .duration(1000)
    .style("opacity", 1);
}

function clear_austen() {
  elem.selectAll(".austen_text")
    .transition("remove_text")
    .duration(1000)
    .style("opacity", 0)
    .remove();

  elem.selectAll(".sentiment_bar")
    .transition("fade_bars")
    .duration(1000)
    .style("fill-opacity", 0)
    .remove();

  elem.selectAll(".sentiment_bar0").remove();
  elem.selectAll(".sentiment_bar1").remove();
  elem.selectAll(".sentiment_bar2").remove();
  elem.selectAll(".book_label")
    .transition("remove_book")
    .duration(1000)
    .style("opacity", 0)
    .remove();
}

function matrix_scales(columns, term_range) {
  return {
    "term": d3.scaleOrdinal()
      .domain(columns)
      .range(term_range),
    "document": d3.scaleBand()
      .domain(d3.range(10))
      .range([50, 210])
  };
}

function build_entries(x, columns) {
  var entries = [];
  for (var i = 0; i < x.length; i++) {
    for (var j = 0; j < columns.length; j++) {
      entries.push(
        {"index": i, "column": columns[j], "value": x[i][columns[j]]}
      );
    }
  }
  return entries;
}

function draw_matrix(g, entries, scales, class_name) {
  g.selectAll("." + class_name)
    .data(entries).enter()
    .append("text")
    .attrs({
      "class": class_name,
      "x": function(d) { return scales.term(d.column); },
      "y": function(d) { return scales.document(d.index); },
      "dy": "0.35em"
    })
    .style("opacity", 0)
    .text(function(d) { return d.value; });
}

function draw_header(g, columns, scales, class_name) {
  g.selectAll("." + class_name)
    .data(columns).enter()
    .append("text")
    .attrs({
      "class": class_name,
      "x": function(d) {
        if (d == "book") {
          return 70 + scales.term(d);
        }
        return scales.term(d);
      },
      "y": scales.document(0) - 15,
      "dy": "0.35em"
    })
    .style("opacity", 0)
    .text(function(d) { return d; });
}

function label_matrix(g, class_name, labels) {
  g.selectAll("." + class_name)
    .data(labels).enter()
    .append("text")
    .attrs({
      "class": class_name,
      "x": function(d) {
        if (d == labels[0]) {
          return 0;
        }
        return 300;
      },
      "y": function(d) {
        if (d == labels[0]) {
          return 0;
        }
        return 20;
      },
      "transform": function(d) {
        if (d == labels[0]) {
          return "translate(15, 140)rotate(-90)";
        }
        return "";
      }
    })
    .text(function(d) { return d; });
}

function dtm_slide() {
  clear_austen();

  var columns = Object.keys(document_term[0]);
  var scales = matrix_scales(columns, [35, 90].concat(d3.range(290, 900, 50)));
  var entries = build_entries(document_term, columns);

  var dtm_elem = elem.append("g")
      .attrs({
        "class": "dtm_g",
        "transform": "translate(0, 0)"
      });

  draw_matrix(dtm_elem, entries, scales, "dtm_entry");
  draw_header(dtm_elem, columns, scales, "dtm_header");
  label_matrix(dtm_elem, "dtm_label", ["passage", "word"]);

  dtm_elem.selectAll(".dtm_entry")
    .transition()
    .duration(1000)
    .style("opacity", 1);

  dtm_elem.selectAll(".dtm_header")
    .transition()
    .duration(1000)
    .style("opacity", 1);
}

function add_bacteria_counts() {
  var columns = Object.keys(sample_rsv[0]);
  var scales = matrix_scales(columns, [35, 85].concat(d3.range(155, 900, 90)));
  var entries = build_entries(sample_rsv, columns);

  var sample_rsv_elem = elem.append("g")
      .attrs({
        "class": "sample_rsv_g",
        "transform": "translate(0, 220)"
      });

  draw_matrix(sample_rsv_elem, entries, scales, "sample_rsv_entry");
  draw_header(sample_rsv_elem, columns, scales, "sample_rsv_header");
  label_matrix(sample_rsv_elem, "sample_rsv_label", ["sample", "bacteria"]);

  sample_rsv_elem.selectAll(".sample_rsv_entry")
    .transition()
    .duration(1000)
    .style("opacity", 1);

  sample_rsv_elem.selectAll(".sample_rsv_header")
    .transition()
    .duration(1000)
    .style("opacity", 1);
}

function remove_matrices() {
  elem.selectAll(".sample_rsv_g")
    .transition()
    .duration(1000)
    .style("opacity", 0)
    .remove();

  elem.selectAll(".dtm_g")
    .transition()
    .duration(1000)
    .style("opacity", 0)
    .remove();
}

function update_circles(i, base_elem, array, class_name, scales) {
  var cur_array = array.slice(0, i);
  base_elem.selectAll("." + class_name)
    .data(cur_array).enter()
    .append("circle")
    .attrs({
      "class": class_name,
      "cy": function(d) { return scales.y(d.y); },
      "cx": function(d) { return scales.x(d.x); },
      "fill": function(d) { return scales.fill(d.y); }
    });

  base_elem.selectAll("." + class_name)
    .attrs({
      "r": function(d) { return Math.max(1.5, 20 * Math.exp(-0.05 * Math.abs(i - d.i))); },
      "fill-opacity": function(d) { return Math.max(0.4, Math.exp(-0.1 * Math.abs(i - d.i))); }
    });
}

function animate_circles(elem, class_name, scales) {
  i = 0;
  function f() {
    update_circles(i, elem, sketch_data, class_name, scales);
    i += 1;
    if (i > 250) {
      elem.selectAll("." + class_name)
        .transition()
        .duration(1000)
        .attrs({"r": 1});
      timer.stop();
    }
  }

  var timer = d3.timer(f, 100);
}

function sentiment_sketch() {
  var scales = {
    "x": d3.scaleLinear()
      .domain([0, 1])
      .range([50, 50]),
    "y": d3.scaleLinear()
      .domain([-1, 1])
      .range([200, 10]),
    "fill": d3.scaleLinear()
      .domain([-1, 1])
      .range(["#e36e30", "#7fc7c4"])
  };

  var sentiment_elem = elem.append("g")
      .attrs({
        "class": "sentiment_sketch_g",
        "transform": "translate(100, 10)"
      });
  animate_circles(sentiment_elem, "sentiment_circle", scales);

}

function microbiome_sketch() {
  var scales = {
    "x": d3.scaleLinear()
      .domain([-1, 1])
      .range([200, 10]),
    "y": d3.scaleLinear()
      .domain([-1, 1])
      .range([200, 10]),
    "fill": d3.scaleLinear()
      .domain([-1, 1])
      .range(["#e36e30", "#7fc7c4"])
  };

  var microbiome_elem = elem.append("g")
      .attrs({
        "class": "microbiome_sketch_g",
        "transform": "translate(600, 10)"
      });
  animate_circles(microbiome_elem, "microbiome_circle", scales);

}

function relate_microbiome() {}

function sleep(miliseconds) {
  var currentTime = new Date().getTime();

  while (currentTime + miliseconds >= new Date().getTime()) {
  }
}
