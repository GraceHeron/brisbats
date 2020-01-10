#' Detect bat calls from spectrogram peaks
#'
#' @param fwave wave file
#'
#' @return
#' @export
#'
#' @examples
bat_detection <- function(fwave){
  ## Stage 1: Y/N Bat detection

  ## Mean spectrograms
  fspec <- seewave::meanspec(fwave, f = fwave@samp.rate)

  ## find frequency peaks
  fpks <- seewave::fpeaks(spec = fspec)

  ## Select peaks in bat frequency range
  bat_freq <- filter(as_tibble(fpks), freq > 40 & freq < 100)

  ## Initialise time vector and storage vector
  x <- seq(0, length(fwave@left)/fwave@samp.rate*1e3, 1/(fwave@samp.rate-0.2)*1e3)
  bat_times <- c()

  ## For each bat peak frequency, filter around peak and store time index
  for(ii in 1:nrow(bat_freq)){

    ## Filter by frequency range
    filt_applied <- ffilter(fwave,
                            from = as.numeric((bat_freq[ii,1]*1e3*0.99)),
                            to = as.numeric((bat_freq[ii,1]*1e3*1.01)),
                            bandpass = T, output =  "Wave")

    ## Store as temporary table
    temp_table <- tibble(wave = filt_applied@left, time = x)

    ## Select time index for detected presences
    bat_times <- rbind(bat_times, temp_table[temp_table$wave > 0.1, "time"])

  }

  ## Only unique times in case of overlap
  bat_times <- unique(bat_times)

  ## Create table with waveform, time and bat pressence logical
  ftable <- tibble(wave = fwave@left, time = x, bat = FALSE)

  ## Apply filter for bat presence
  ftable[round(ftable$time, 2) %in% round(bat_times$time, 2), "bat"] <- TRUE

  ## Scale back to seconds from milliseconds
  ftable$time <- (ftable$time/1e3)
  ftable$Index <- 0

  return(ftable)
}
