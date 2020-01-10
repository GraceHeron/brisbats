#' Easy tile plot
#'
#' @param x data frame
#' @param chosen_indices can be single or multiple indices as the three digit code
#' @param sample_length max time length (seconds)
#' @param mytitle optional
#'
#' @return
#' @export
#'
#' @examples
tile_plot <- function(x, chosen_indices, sample_length, mytitle = F){

  if(length(chosen_indices) == 1){
    ggplot(filter(x, type %in% chosen_indices),
           aes(x = Index, y = Scale2, fill = value)) +
      geom_tile() +
      scale_fill_viridis_c() +
      scale_y_continuous(breaks = seq(0, 500, 25)) +
      scale_x_continuous(breaks = seq(0, sample_length, round(sample_length/8, digits = 1))) +
      theme_bw() +
      xlab("Time (s)") +
      labs(title = chosen_indices[1]) +
      ylab("Frequency (kHz)")
  } else {
    ggplot(filter(x, type %in% chosen_indices),
           aes(x = Index, y = Scale2, fill = value)) +
      geom_tile() +
      facet_wrap(vars(type)) +
      scale_fill_viridis_c() +
      scale_y_continuous(breaks = seq(0, 500, 25)) +
      scale_x_continuous(breaks = seq(0, sample_length, round(sample_length/8, digits = 1))) +
      theme_bw() +
      xlab("Time (s)") +
      labs(title = mytitle) +
      ylab("Frequency (kHz)")

  }

}
