#' @title Generate Weather Data for Multiple Regions
#' @param folder The folder to store the data
#' @param region_prefix Prefix for the region files
#' @param num_regions Number of regions to generate data for
#' @export
generate_weather_data <- function(folder, region_prefix, num_regions) {
  # Loop through each region and generate data
  for(region in 1:num_regions) {
    # Create synthetic daily weather data for one region
    days <- 365
    set.seed(region) # Different seed for each region
    
    weather_data <- data.frame(
      date = seq(as.Date("2023-01-01"), by="day", length.out=days),
      temperature = rnorm(days, mean=20, sd=8),
      humidity = runif(days, min=30, max=90),
      precipitation = rexp(days, rate=1/5),
      wind_speed = rnorm(days, mean=15, sd=5)
    )
    
    # Add some regional variation based on region number
    # Northern regions (higher numbers) are cooler, southern regions (lower numbers) are warmer
    weather_data$temperature <- weather_data$temperature + (num_regions - region) * 5
    
    # More precipitation in middle regions
    precip_factor <- 1 - abs(region - (num_regions/2))/(num_regions/2)
    weather_data$precipitation <- weather_data$precipitation * (1 + precip_factor)
    
    # Save locally with region-specific filename
    local_file <- paste0("region_", region, "_weather.csv")
    write.csv(weather_data, local_file, row.names=FALSE)
    
    # Upload to S3
    remote_file <- paste0(region_prefix, "_region_", region, "_weather.csv")
    faasr_put_file(local_file=local_file, 
                   remote_folder=folder, 
                   remote_file=remote_file)
    
    log_msg <- paste0("Generated weather data for region ", region)
    faasr_log(log_msg)
  }
  
  # Final completion message
  log_msg <- paste0("Completed generating weather data for all ", num_regions, " regions")
  faasr_log(log_msg)
}