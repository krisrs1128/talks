function get_slides() {
  var slide_funs = [];
  slide_funs.push(
    function() {
      slide_text(
        [
          "I study ways methods for analyzing text data can be useful for studying bacteria that live all around us"
        ],
        "Text Analysis and the Microbiome"
      );
      d3.select("#content")
        .append("img");
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

  elem.attr("transform", "translate(-700, 0)");
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
    .duration(1000)
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
