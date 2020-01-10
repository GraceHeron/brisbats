#' Calculate analysis programs from within R
#'
#' @param file wave file name
#' @param base_output_directory place to put AP output
#'
#' @return
#' @export
#'
#' @examples
calculate_indices <- function(file, base_output_directory){

  # get just the name of the file
  file_name <- basename(file)

  # make a folder for results
  output_directory <- normalizePath(file.path(base_output_directory, file_name))
  dir.create(output_directory, recursive = TRUE)

  # prepare command (full path)
  command <- sprintf('audio2csv "%s" "C:\\AP\\ConfigFiles\\Towsey.Acoustic.IndSpec.yml" "%s" ',
                     file,
                     output_directory)

  # finally, execute the command
  system2('C:\\AP\\AnalysisPrograms.exe', command)
}
