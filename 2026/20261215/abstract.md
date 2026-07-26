
User-Friendly and Efficient Synthetic Null Generation in Spatial Omics Studies

Synthetic null simulation are a powerful mechanism for calibrating statistical claims in high-throughput biology. For example, they have been applied successfully to filter out false positives in marker gene detection in single-cell data (Song et al. 2024), guide multi-omics integration in 16S microbiome data (Sankaran et al. 2024), and isolate genetic variants with effects on downstream expression (Dong et al. 2026). One particularly exciting application is to spatial transcriptomics data, a data modality that associates gene expression profiles in individual cells with spatial locations in tissue.  To generate synthetic null data in this context, it is important to capture spatial structure. We will discuss new software that leverages Gaussian processes to support efficient and interpretable synthetic null generation for problems like spatial domain delination and spatially varying gene detection.  The package is designed to be user-friendly and extensible, and we give examples showing how complex effects can be encoded in data generation even in large-scale and high-resolution spatial data.



expression
localized in



 the strength
of statistical

Sankaran, K., Kodikara, S., Li, J. J., & Cao, K.-A. L. (2024). Semisynthetic simulation for microbiome data analysis. Briefings in Bioinformatics, 26(1), bbaf051. doi:10.1093/bib/bbaf051

Song, D., Chen, S., Lee, C., Li, K., Ge, X., & Li, J. J. (2024). Synthetic control removes spurious discoveries from double dipping in single-cell and spatial transcriptomics data analyses. doi:10.1101/2023.07.21.550107

Dong, C. Y., Cen, Y., Song, D., & Li, J. J. (2026). scDesignPop generates realistic population-scale single-cell RNA-seq for power analysis, benchmarking, and privacy protection. doi:10.64898/2026.02.23.707578