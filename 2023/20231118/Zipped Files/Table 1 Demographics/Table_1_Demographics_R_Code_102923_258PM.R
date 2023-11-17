# Demographics Analysis
Demographics_data_columns <- read.csv("Demographic_data_graphs.csv")

# ggplots
library(ggplot2)

ggplot(data=Demographics_data_columns)+geom_bar(aes(x=Gender))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=AgeGp))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=ESL))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=Work))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=FGC))


ggplot(data=Demographics_data_columns)+geom_bar(aes(x=ESL))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=AgeGp))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=FGC))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=Work))
ggplot(data=Demographics_data_columns)+geom_bar(aes(x=Gender))
