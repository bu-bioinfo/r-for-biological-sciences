library(tibble)
library(tidyr)
library(readr)
library(stringr)
library(ggplot2)
library(DESeq2)


#' Filter zero-variance genes from count matrix.
#'
#' @param count_data tibble: a (gene x sample) matrix of raw read counts
#'
#' @return tibble: a (gene x sample) matrix of raw reads with zero variance
#' genes removed.
#' @export
#'
#' @examples
#' `filtered_counts <- filter_zero_var_genes(count_data)`
filter_zero_var_genes <- function(count_data) {
  genes <- count_data$gene
  variance <- apply(count_data[-c(1)], 1, var)
  return(list(genes=genes[variance > 0], matrix=count_data[variance > 0, -c(1)]))
}



#' Extract time point information from sample name
#'
#' @param x string: sample name from count matrix.
#'
#' @return string: string character representing sample time point 
#' @export
#'
#' @examples
#' `timepoint_from_sample("vAd_1")`
#' `"Ad"`
timepoint_from_sample <- function(x) {
  return(stringr::str_extract(x, "(?<=^v)(.*?)(?=_)"))
}


#' Grab sample number from sample name
#'
#' @param x  string: sample name from count matrix.
#'
#' @return string: string character represent sample replicate number
#' @export
#'
#' @examples
#' `sample_number("vAd_1")`
#' `"1"`
sample_number <- function(x) {
  return(stringr::str_split(x , "_")[[1]][2])
}


#' Generate sample-level metadata from sample names
#'
#' @param sample_names vector: character vector of sample names from count matrix.
#'
#' @return tibble: tibble containing sample-level metadata including columns
#' "sample", "timepoint", and "replicate" that store sample names, sample
#' time points, and sample replicate number, respectively.
#' @export
#'
#' @examples
#' `meta_info_from_labels(colnames(count_matrix))`
meta_info_from_labels <- function(sample_names) {
  timepoints <- sapply(sample_names, timepoint_from_sample)
  replicate <- sapply(sample_names, sample_number)
  return(tibble::tibble(sample=sample_names, timepoint=timepoints, replicate=replicate))
}


#' Calculate total read counts for each sample in a count matrix.
#'
#' @param count_matrix tibble: a (gene x sample) matrix of raw read counts.
#'
#' @return vector: numeric vector of read totals from each sample
#' @export
#'
#' @examples
#' `get_library_size(count_matrix)`
get_library_size <- function(count_matrix) {
  return (apply(count_matrix, 2, sum))
}


#' Normalize raw count matrix to counts per million.
#' 
#' Normalizes read counts using the following formula:
#' 
#' $C_{i, j} = \frac{X_{i, j}}{\frac{\sum \limits_{j}^N X_{i, j}}{10^6}}$
#'
#' @param count_matrix tibble: a (gene x sample) matrix of raw read counts.
#'
#' @return tibble: a (gene x sample) matrix with read count normalized to counts
#' per million 
#' @export
#'
#' @examples
#' `normalize_by_cpm(count_matrix)`
normalize_by_cpm <- function(count_matrix) { 
  library_sizes <- get_library_size(count_matrix)
  scale_factors <- library_sizes / 10^6
  return(log2((count_matrix + 1)/ (scale_factors + 1)))
}


#' Normalize raw count matrix using DESeq2
#'
#' @param count_matrix tibble: a (gene x sample) matrix of raw reads
#' @param meta_data tibble: sample-level information tibble containing time point,
#' sample, and replicate information.
#' @param design_formula formula: formula of comparision of interest
#'
#' @return tibble: DESeq2 normalized count matrix.
#' @export
#'
#' @examples
#' `deseq_normalize(count_matrix, meta_data, ~ timepoint)`
deseq_normalize <- function(count_matrix, meta_data, design_formula) {
  dds <- DESeq2::DESeqDataSetFromMatrix(
    countData=count_matrix,
    colData=meta_data,
    design=design_formula
  )
  vsd <- DESeq2::vst(dds, blind=FALSE)
  return (tibble::as_tibble(SummarizedExperiment::assay(vsd)))
}


#' Perform and plot PCA using a provided count matrix.
#' 
#' PCA is performed over genes, and samples should be colored by time point.
#' Both `y` and `x` axis should have percent of explained variance included.
#'
#' @param count_matrix tibble: count matrix to perform PCA over.
#' @param meta tibble: sample-level meta information
#' @param title string: title for plot
#'
#' @return ggplot: scatter plot showing each sample in the first two PCs. 
#' @export
#'
#' @examples
#' `plot_pca(count_matrix, meta, "Raw Count PCA")`
plot_pca <- function(count_matrix, meta, title="") {
  pca <- prcomp(t(count_matrix))
  plot_data <- meta
  plot_data$PC1 <- pca$x[ , 1]
  plot_data$PC2 <- pca$x[ , 2]
  percent_var <- pca$sdev^2 / sum( pca$sdev^2 )
  pca_plot <- ggplot2::ggplot(plot_data, ggplot2::aes(x=PC1, y=PC2, col=timepoint)) + 
    ggplot2::geom_point() +
    ggplot2::xlab(paste0("PC1: ",round(percent_var[1] * 100),"% variance")) +
    ggplot2::ylab(paste0("PC2: ",round(percent_var[2] * 100),"% variance")) +
    ggplot2::ggtitle(title)
  return(pca_plot)
}


#' Plot gene count distributions for each sample using boxplots.
#' 
#'
#' @param count_matrix tibble: a (gene x sample) count matrix
#' @param scale_y_axis boolean: whether to scale the `y` axis to log10 values.
#' Default is FALSE, and y-axis will not be transformed.
#' @param title string: title to give the chart.
#'
#' @return ggplot: boxplot show gene count distributions for each sample
#' @export
#'
#' @examples
#' `plot_sample_distributions(count_matrix, scale_y_axis=TRUE, title='Raw Count Distributions')`
plot_sample_distributions <- function(count_matrix, scale_y_axis=FALSE, title="") {
  long_counts <- tidyr::pivot_longer(count_matrix,
                                     cols=colnames(count_matrix),
                                     names_to='sample',
                                     values_to='counts')
  dist_plot <- ggplot2::ggplot(long_counts, ggplot2::aes(x=sample, y=counts, col=sample)) +
    ggplot2::geom_boxplot() + 
    ggplot2::ggtitle(title)
  if (scale_y_axis) {
    dist_plot <- dist_plot + ggplot2::scale_y_log10()
  }
  return(dist_plot)
}


#' Plot relationship between mean read counts and variability over all genes.
#'
#'
#' @param count_matrix tibble: a (gene x sample) data matrix containing raw or 
#' normalized count values. 
#' @param scale_y_axis boolean: whether to scale to y-axis to log10 values. Default
#' is false, and the y-axis will not be transformed.
#' @param title string: title to give the chart.
#'
#' @return ggplot: A scatter plot where the x-axis is the rank of gene ordered by mean
#' count over all samples, and the y-axis is the observed variance of the
#' given gene. Each dot should have their transparency increased. The scatter
#' plot should also be accompanied by a line representing the average mean and
#' variance values.
#' @export
#'
#' @examples
#' `plot_variance_vs_mean(count_matrix, scale_y_axis=TRUE, title='variance vs mean (raw counts)')`
plot_variance_vs_mean <- function(count_matrix, scale_y_axis=FALSE, title="") {
  means <- apply(count_matrix, 1, mean)
  variances <- apply(count_matrix, 1, var)
  plot_data <- tibble::tibble(mean=means, variance=variances)
  plot_data$rank <- rank(plot_data$mean)
  mv_plot <- ggplot2::ggplot(plot_data, aes(x=rank, y=variance)) + 
    ggplot2::geom_point(alpha=0.5) +
    ggplot2::geom_smooth() + 
    ggplot2::xlab("Rank(Mean)") + 
    ggplot2::ylab("Variance") + 
    ggplot2::ggtitle(title)
  if (scale_y_axis) {
    mv_plot <- mv_plot + ggplot2::scale_y_log10()
  }
  return(mv_plot)
}
