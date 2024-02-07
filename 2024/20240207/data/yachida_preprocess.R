yachida <- curatedMetagenomicData(pattern = "YachidaS_2019.relative_abundance", count = TRUE, dry = FALSE)[[1]]

keep_indices <- colData(yachida)$disease %in% c("CRC", "healthy")
keep_taxa <- genefilter(assay(yachida), kOverA(250, 10)) # very aggressive
yachida <- yachida[keep_taxa, keep_indices]
rownames(yachida) <- str_extract(rownames(yachida), "s__[A-z]+")
colData(yachida) <- DataFrame(
  disease = factor(
    colData(yachida)$disease, 
    levels = c("healthy", "CRC")
  )
)