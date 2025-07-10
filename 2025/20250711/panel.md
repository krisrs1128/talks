
We have been given four discussion questions:

1. What do you see as the main thing you wish people would do differently in
your field? And why do you think people are not doing this (E.g., How data is
processed, how models are built, how methods are applied, etc.)

- A more personal reflection. Instead of jumping onto the next cool ML/Stats
thing and applying it immediately into microbiome data, taking a bit more time
to take the very common workflows and practices seriously. It's tempting to want
to try things that are cool and a lot of basic biological analysis is not cool.
But the more I grow as a statistician, the more I realize it's much more
productive to critically interrogate what people already do than to invent new
methods. You can highlight work like Nikos' and Jessica's. How this kind of
close analysis can either reveal beautiful statistical ideas that were hidden in
what seemed like heuristics or can highlight problems that statistics can help
resolve.
- From the more statistical end, I wish we would stay more up-to-date with the
types of data that people are generating. The microbiologists I talk to are
talking about using pacbio long read while most sessions I go to at stats
conferences are talking about 16S data
- From the more biological end, I wish there were more sanity checks. There was
a retraction of a very high-profile paper last year, the most interesting
re-analysis was a sanity check. But no one does this because it's so expensive. 
- Perhaps related to sanity checks -- it would be helpful to have
counterexamples.

1. What are some challenges you have faced and how have you addressed them
(including those that arose during the research process and any pushback from
others in the field)?

- Feeling like I know enough of anything. I've sort of come to terms with it,
that this is just how interdisciplinary work happens. But I have to try really
hard to understand enough about the microbiology, and sequencing technology, the
bioinformatics, and then on top of that the statistics.

- I don't have tenure yet so I need to be a little careful with this question....

- I subscribe to amplification theory of statistical collaboration -- I didn't
realize how important it is to work with scientists that I learn from. Sometimes
have been called in to rescue a doomed study and that is not a fun experience.
Now I don't agree to be on a grant until I've actually worked on a project with
someone.

- pushback from others: compositionality, rarefaction, directly modeling --
there are a lot of very strong opinions without that much careful analysis. This
has been an endless source of frustration.

1. What are some inspiring things you've seen in the field that advance rigorous
and reproducible methods in computational biology?

- I've seen people like Susan who created the phyloseq package without any grant
money (I think it was considered innovative enough)
- People take visualization seriously. I learned ggplot2 from microbiome
researchers, and now I teach a class on it at UW Madison.
- I've seen a few people who are willing to question the assumptions behind very
commonly used practices. (example about the assumptions behind Harmony integration)
- I think we could learn things from ML: Ideas like codalab and huggingface
datasets are really good ideas!
- I was really impressed by some recent work on interpretability for protein
language models. That seems much more valuable than simply proposing a new
foundation model.

1. How can we promote better sharing of code, models, and data?

- We should share data at multiple stages of processing, raw and completely
processed are both not that satisfactory (too far at the extremes)
- I just reviewed for the benchmarks and datasets track, and I thought there
were some quite impressive submission (also a bunch that were poorly motivated).
I think the ones that really stood out were clearly connected to a meaningful
question. Curating lots of frandom data isn't that helpful. It's when the data
are linked to something like "visual understanding of natural scenes" or
"biogeography of all tree species" that data sharing starts to really matter.