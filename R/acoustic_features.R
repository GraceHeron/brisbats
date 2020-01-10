#' Acoustic features of wave file
#'
#' @param fwave
#'
#' @return
#' @export
#'
#' @examples
acoustic_features <- function(file, base_output_directory){

  # get just the name of the file
  file_name <- basename(file)

  # make a folder for results
  output_directory <- normalizePath(file.path(base_output_directory, file_name))

  ## Wave file features
  fwave <- readWave(file)
  sample_length <- length(fwave@left)/fwave@samp.rate
  sample_freq <- fwave@samp.rate

  all_indices <- c("ACI", "ENT", "BGN", "CVR", "DIF", "EVN", "PMN", "R3D", "RHZ",
                   "RNG", "RPS", "RVT", "SPT", "SUM")

  atable <- clean_indices(output_directory, file_name, all_indices[1]) %>%
    reshape::melt(id = "Index") %>%
    mutate(value = (value - mean(value))/(sqrt((var(value)))))

  for(ii in 2:length(all_indices)){

    atable <- clean_indices(output_directory, file_name, all_indices[ii]) %>%
      reshape::melt(id = "Index") %>%
      mutate(value = (value - mean(value))/(sqrt((var(value))))) %>%
      bind_rows(atable)

  }

  atable <- atable %>%
    mutate(type = substr(variable, 1, 3),
           Scale = as.numeric(substr(variable, 5, 7)),
           Index = rescale(Index, seq(0, sample_length, sample_length/40))) %>%
    mutate(Scale2 = Scale/(max(Scale)/sample_freq)/2e3)

  return(atable)
}
