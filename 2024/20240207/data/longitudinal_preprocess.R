
reads <- read_tsv("https://raw.githubusercontent.com/SarithaKodikara/Longitudinal_microbiome_data_analysis/main/Differential%20Abundance%20(DA)/Case%20Study/Data/Mu_etal_mouseVRE_FEATURE_TABLE_case_corrected.tsv", skip = 1) |>
  rename(otu_seq = `#OTU ID`)
mapping <- read_tsv("https://raw.githubusercontent.com/SarithaKodikara/Longitudinal_microbiome_data_analysis/main/Differential%20Abundance%20(DA)/Case%20Study/Data/Mu_etal_mouseVRE_MAPPING_FILE.txt") |>
  rename(sample = `#SampleID`)
sorted_ix <- reads |>
  select(-otu_seq) |>
  rowMeans() |>
  order(decreasing = TRUE)

mapping <- mapping |>
  filter(host_subject_id != "not applicable") |>
  rename(
    time = day_of_experiment,
    subject = host_subject_id,
    phase = phase_of_experiment
  )

reads <- reads[sorted_ix[1:50], ] |>
  select(otu_seq, any_of(mapping$sample)) |>
  mutate(otu_seq = glue("ASV{row_number()}")) |>
  pivot_longer(-otu_seq, names_to = "sample") |>
  pivot_wider(names_from = "otu_seq")
write_csv(reads, "~/Downloads/filtered_samples.csv")
mapping |>
  select(time, sample, subject, phase, Description) |>
  filter(sample %in% reads$sample) |>
  write_csv("~/Downloads/mapping.csv")