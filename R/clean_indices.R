#' Clean AP output data sets
#'
#' @param output_directory
#' @param file_name
#' @param ind Three digit code of acoustic indices
#'
#' @return
#' @export
#'
#' @examples
clean_indices <- function(output_directory, file_name, ind){

  indices <- read.csv(paste0(output_directory, "\\Towsey.Acoustic\\", str_sub(file_name, end = -5),
                             "__Towsey.Acoustic.", ind, ".csv"))

  colnames(indices) <- c("Index", paste(ind, str_pad(seq(1, (ncol(indices)-1),1), width = 3, pad = "0"), sep ="_"))

  return(indices)
}
