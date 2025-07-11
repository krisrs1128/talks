
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
- It's also a little discouraging to see people follow workflow papers kind of
blindly.
- Perhaps related to sanity checks -- it would be helpful to have
counterexamples.

1. What are some challenges you have faced and how have you addressed them
(including those that arose during the research process and any pushback from
others in the field)?

- Feeling like I know enough of anything. I've sort of come to terms with it,
that this is just how interdisciplinary work happens. But I have to try really
hard to understand enough about the microbiology, and sequencing technology, the
bioinformatics, and then on top of that the statistics.

- I subscribe to amplification theory of statistical collaboration -- I didn't
realize how important it is to work with scientists that I learn from. Sometimes
have been called in to rescue a doomed study and that is not a fun experience.
Now I don't agree to be on a grant until I've actually worked on a project with
someone.

- pushback from others: compositionality, rarefaction, directly modeling --
there are a lot of very strong opinions without that much careful analysis. This
has been an endless source of frustration.

- Not sure if it's a challenge, but there is some pressure to move fast, and I
think some kinds of work really need to be done a bit more slowly to be done
well. (hopefully it's not just me?). I'm not sure I've done anything for it
besides just trying to be a bit more patient with myself, and perhaps to have a
couple of tracks running simultaneously -- I can write some software relatively
quickly while setting up a longer-term collaboration.

- I think there's a related pushback I've encountered from other people in
statistics, where some people seem skeptical of people who do very good
interdisciplinary work. I've heard faculty members dismiss job candidates
because they think that they couldn't establish the types of collaborations that
were necessary for their PhD work.

1. What are some inspiring things you've seen in the field that advance rigorous
and reproducible methods in computational biology?

- The most obvious candidate is Susan's book. I've read other books that really
feel like recipes -- hers encourages people to get a feel for how methods work,
tinkering and seeing how things change. And the entire book can be compiled.
I've literally reviewed books where the author's home directory is visible in
the code snippets -- it took me some time to appreciate how much more advanced
the book really is!
- There are people who think very clearly about the measurement process, and
this is always inspiring. The first example I can think of is the Tseng and Wong
paper on normalizing microarrays. I remember one of their experiments generated
microarray data from exactly the same samples, but between the two runs they
swapped out the dyes that were used.
- Obvious from the content of my talk, but I am really impressed by the
meta-algorithms from Jessica Li's lab. Instead of inventing new algoithms, they
are thinking really carefully about meta-algorithms to help us navigate the
ocean of methods that have been proposed.
- I was really impressed by James Zou's interpretability for protein language
models. That seems much more valuable than simply proposing a new foundation
model.
- I've seen people like Susan who created the phyloseq package without any grant
money (I think it was considered innovative enough)
- People take visualization seriously. I learned ggplot2 from microbiome
researchers, and now I teach a class on it at UW Madison.
- I've seen a few people who are willing to question the assumptions behind very
commonly used practices. (example about the assumptions behind Harmony integration)
- I think we could learn things from ML: Ideas like codalab and huggingface
datasets are really good ideas!
- Some of my collaborators have been willing to take their work a bit more
slowly to ensure they have reliable findings
- People are more willing to engage in data generation, not just expecting
collaborators to come to them. Example of Anthony generating the solar panel
dataset, and in microbiome the curatedMetagenomicData and
curatedMetagenomicMetabolomic data repositories.

1. How can we promote better sharing of code, models, and data?

- We should share data at multiple stages of processing, raw and completely
processed are both not that satisfactory (too far at the extremes)
- I just reviewed for the benchmarks and datasets track, and I thought there
were some quite impressive submission (also a bunch that were poorly motivated).
I think the ones that really stood out were clearly connected to a meaningful
question. Curating lots of frandom data isn't that helpful. It's when the data
are linked to something like "visual understanding of natural scenes" or
"biogeography of all tree species" that data sharing starts to really matter.
- Mila had setup a system for people to spin up jupyter notebooks on their
computer clusters. Anyone could spin up an instance with a GPU and connected to
some very large datasets without that much effort.
- I think efforts like the CZ "Open Problems" page is helpful. We would need to
buy into working on competitions, but that is a good way to ensure that data and
models are more widely used.