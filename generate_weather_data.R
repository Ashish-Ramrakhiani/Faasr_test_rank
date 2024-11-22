generate_weather_data <- function(folder, region_prefix) {
  # Generate synthetic weather data for multiple regions
  # Each rank will process a different region
  
  # Get rank information
  rank_list <- FaaSr::faasr_rank()
  rank_number <- rank_list$Rank
  
  # Create synthetic daily weather data for one region
  days <- 365
  set.seed(rank_number) # Different seed for each region
  
  weather_data <- data.frame(
    date = seq(as.Date("2023-01-01"), by="day", length.out=days),
    temperature = rnorm(days, mean=20, sd=8),
    humidity = runif(days, min=30, max=90),
    precipitation = rexp(days, rate=1/5),
    wind_speed = rnorm(days, mean=15, sd=5)
  )
  
  # Save locally with rank-specific filename
  local_file <- paste0("region_", rank_number, "_weather.csv")
  write.csv(weather_data, local_file, row.names=FALSE)
  
  # Upload to S3
  remote_file <- paste0(region_prefix, "_region_", rank_number, "_weather.csv")
  faasr_put_file(local_file=local_file, 
                 remote_folder=folder, 
                 remote_file=remote_file)
  
  log_msg <- paste0("Generated weather data for region ", rank_number)
  faasr_log(log_msg)
}