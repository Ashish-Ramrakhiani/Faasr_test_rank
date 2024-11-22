# FaaSr Weather Analysis Workflow to test rank functionality

The workflow generates artificial weather data for multiple regions, analyzes them in parallel, and produces a climate report.

## Overview

The workflow consists of three main stages:
1. **Data Generation**: Creates artificial weather data for multiple geographic regions
2. **Parallel Analysis**: Processes each region's data simultaneously using rank functionality
3. **Report Compilation**: Aggregates results into a global climate summary

## Repository Structure

```
├── generate_weather_data.R     # Generates artificial weather data for multiple regions
├── analyze_regional_weather.R      # Analyzes weather data for individual regions
├── compile_globall_report.R       # Combines regional analyses into global report
└── payload_weather.json          # FaaSr workflow configuration
```

## Setup Instructions

1. **Fork/Clone the Repository**
   ```bash
   git clone https://github.com/Ashish-Ramrakhiani/Faasr_test_rank.git
   cd Faasr_test_rank
   ```

2. **Configure Secrets**
   Add the following secrets to your faasr_env file:
   - `MY_GITHUB_ACCOUNT_TOKEN`: Your GitHub Personal Access Token
   - `MY_MINIO_BUCKET_ACCESS_KEY`: MinIO Access Key
   - `MY_MINIO_BUCKET_SECRET_KEY`: MinIO Secret Key

3. **Modify payload.json**
   Update the following fields in `payload_weather.json`:
   - `UserName`: Your GitHub username
   - `ActionRepoName`: Your repository name
   - `Bucket`: Your S3/MinIO bucket name
   - `Endpoint`: Your S3/MinIO endpoint
     
4. **Create folders in S3 bucket**
   Create two folders namely "weather_raw" and "weather_report" in your S3 bucket

## File Descriptions

### generate_weather_data.R
Generates artificial weather data for a specified number of regions. Each region's data includes:
- Daily temperature
- Humidity levels
- Precipitation
- Wind speed

Parameters:
- `folder`: Target storage folder
- `region_prefix`: Prefix for region file names
- `num_regions`: Number of regions to generate data for

### analyze_regional_weather.R
Processes weather data for individual regions in parallel using FaaSr's rank functionality. Calculates:
- Average temperature
- Temperature extremes
- Total precipitation
- Average humidity
- Extreme weather events

Parameters:
- `folder`: Data storage folder
- `region_prefix`: Input file prefix
- `stats_prefix`: Output statistics file prefix
- `output_folder`: Output folder for stats files

### compile_global_report.R
Combines all regional analyses into a global report. Generates:
- Global temperature averages
- Precipitation patterns
- Regional comparisons
- Extreme weather statistics

Parameters:
- `folder`: Data folder
- `expected_regions`: Number of regions to combine
- `stats_prefix`: Statistics file prefix

## Example Output

The workflow generates several types of files:

1. Raw Weather Data (per region):
```csv
date,temperature,humidity,precipitation,wind_speed
2023-01-01,18.5,65.2,2.3,12.1
...
```

2. Regional Analysis:
```csv
region,avg_temp,max_temp,min_temp,total_precip,avg_humidity,avg_wind,extreme_weather_days
1,19.8,32.1,5.2,850.3,68.5,14.2,12
```

3. Global Summary:
```csv
total_regions,global_avg_temp,highest_recorded_temp,lowest_recorded_temp,total_precipitation,avg_humidity,total_extreme_days
4,20.1,35.2,2.1,3245.6,67.8,45
```

## Customization

You can modify the workflow by:
1. Adjusting the number of regions in `payload_weather.json`
2. Adjusting rank value for action "analyze"
3. Adjusting number of expected regions
4. Way to check if rank functionality is working as expected is to set identical value for all of the above
