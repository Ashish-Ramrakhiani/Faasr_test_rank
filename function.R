# function.R
# Function to compute sum with rank-based file naming

compute_sum <- function(folder, input1, input2, output) {
  # Download input files
  faasr_get_file(remote_folder=folder, remote_file=input1, local_file="input1.csv")
  faasr_get_file(remote_folder=folder, remote_file=input2, local_file="input2.csv")
  
  # Read input files
  frame_input1 <- read.table("input1.csv", sep=",", header=T)
  frame_input2 <- read.table("input2.csv", sep=",", header=T)
  
  # Compute sum
  frame_output <- frame_input1 + frame_input2
  
  rank_list <- FaaSr::faasr_rank()
  MaxRank <- rank_list$MaxRank
  rank_number <- rank_list$Rank
  
  # Write output locally with rank-specific filename
  write.table(frame_output, file=paste0("sum_rank_", rank_number, ".csv"), 
              sep=",", row.names=F, col.names=T)
  
  rem_folder <- "tutorial2"
  
  # Upload to S3 with rank-specific filename
  rank_specific_output <- paste0("sum_rank_", rank_number, ".csv")
  faasr_put_file(local_file=paste0("sum_rank_", rank_number, ".csv"), 
                 remote_folder=rem_folder, 
                 remote_file=paste0("sum_rank_", rank_number, ".csv"))
  
  # Log message
  log_msg <- paste0('Function compute_sum finished for rank ', rank_number, 
                    '; output written to ', rem_folder, '/', rank_specific_output)
  faasr_log(log_msg)
}