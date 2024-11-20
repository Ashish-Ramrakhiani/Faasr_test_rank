# end.R
# Function to verify rank-based files exist and download them locally

verify_rank_files <- function(folder, expected_rank) {
  # Use folder as prefix to get list of files from S3
  files <- faasr_get_folder_list(faasr_prefix=folder)
  
  # Filter for rank-specific files - now matching "sum_rank_X.csv" pattern
  rank_files <- grep(paste0("sum_rank_[0-9]+\\.csv$"), files, value=TRUE)
  
  # Sort files numerically by rank number
  rank_numbers <- as.numeric(gsub(".*sum_rank_([0-9]+)\\.csv$", "\\1", rank_files))
  rank_files <- rank_files[order(rank_numbers)]
  
  # Check if number of files matches expected rank
  num_files <- length(rank_files)
  
  if (num_files == expected_rank) {
    # Verify we have files for all ranks from 1 to expected_rank
    expected_ranks <- 1:expected_rank
    actual_ranks <- sort(rank_numbers)
    
    if (!all(expected_ranks == actual_ranks)) {
      log_msg <- paste0('Verification failed: Missing files for some ranks. ',
                        'Expected ranks 1 to ', expected_rank, 
                        ', found ranks: ', paste(actual_ranks, collapse=", "))
      faasr_log(log_msg)
      return(FALSE)
    }
    
    # Download each file locally
    for (file in rank_files) {
      # Extract just the filename from the full path
      local_filename <- basename(file)
      
      # Download file
      faasr_get_file(remote_folder=folder, 
                     remote_file=local_filename, 
                     local_file=local_filename)
      
      # Log successful download
      log_msg <- paste0('Downloaded file: ', local_filename)
      faasr_log(log_msg)
    }
    
    # Log overall success
    log_msg <- paste0('Verification successful: Found and downloaded all ', 
                      expected_rank, ' expected files from folder ', folder)
    faasr_log(log_msg)
    return(TRUE)
    
  } else {
    # Log failure message
    log_msg <- paste0('Verification failed: Found ', num_files, 
                      ' files in folder ', folder, ', expected ', expected_rank)
    faasr_log(log_msg)
    return(FALSE)
  }
}