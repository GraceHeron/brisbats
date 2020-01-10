#' Title
#'
#' @param file
#'
#' @return
#' @export
#'
#' @examples
calculate_indices <- function(file){

  # get just the name of the file
  file_name <- basename(file)

  fwave <- readWave(file)
  sample_length <- length(fwave@left)/fwave@samp.rate
  sample_freq <- fwave@samp.rate

  # make a folder for results
  output_directory <- normalizePath(file.path(base_output_directory, file_name))
  dir.create(output_directory, recursive = TRUE)

  # prepare command (full path)
  command <- sprintf('audio2csv "%s" "C:\\AP\\ConfigFiles\\Towsey.Acoustic.IndSpec.yml" "%s" ',
                     file,
                     output_directory)

  # finally, execute the command
  # system2('C:\\AP\\AnalysisPrograms.exe', command)

  all_indices <- c("ACI", "ENT", "BGN", "CVR", "DIF", "EVN", "PMN", "R3D", "RHZ",
                   "RNG", "RPS", "RVT", "SPT", "SUM")

  master_indices <- clean_indices(output_directory, file_name, all_indices[1]) %>%
    reshape::melt(id = "Index") %>%
    mutate(value = (value - mean(value))/(sqrt((var(value)))))

  for(ii in 2:length(all_indices)){

    master_indices <- clean_indices(output_directory, file_name, all_indices[ii]) %>%
      reshape::melt(id = "Index") %>%
      mutate(value = (value - mean(value))/(sqrt((var(value))))) %>%
      bind_rows(master_indices)

  }

  master_indices <- master_indices %>%
    mutate(type = substr(variable, 1, 3),
           Scale = as.numeric(substr(variable, 5, 7)),
           Index = rescale(Index, seq(0, sample_length, sample_length/40))) %>%
    mutate(Scale2 = Scale/(max(Scale)/sample_freq)/2e3)


  tile_plot(master_indices, all_indices, sample_length, sample_freq, file_name)

  print(file_name)

  return(master_indices)
}
