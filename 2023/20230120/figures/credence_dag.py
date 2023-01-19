
import daft

# linear regression
pgm = daft.PGM()
pgm.add_node("x", r"$x_{i}$", 0.5, 1.4)
pgm.add_node("eps", r"$\epsilon_{i}$", 0.5, 2.2)
pgm.add_node("t", r"$t_{i}$", 1.5, 3)
pgm.add_node("y0", r"$y_{i}^0$", 1.5, 1.4)
pgm.add_node("y1", r"$y_{i}^1$", 1.5, 2.2)
pgm.add_node("y", r"$y_{i}$", 2.5, 1.4)

pgm.add_edge("x", "y0")
pgm.add_edge("x", "y1")
pgm.add_edge("eps", "y0")
pgm.add_edge("eps", "y1")
pgm.add_edge("eps", "t")
pgm.add_edge("x", "t")
pgm.add_edge("t", "y")
pgm.add_edge("y0", "y")
pgm.add_edge("y1", "y")

pgm.render()
pgm.savefig("credence_dag.svg", dpi=800)

