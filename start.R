create_sample_data <- function(folder, output1, output2) {
  # Create two data frames
  df1 <- NULL
  for (e in 1:10)
    rbind(df1, data.frame(v1=e, v2=e^2, v3=e^3)) -> df1
  
  df2 <- NULL
  for (e in 1:10)
    rbind(df2, data.frame(v1=e, v2=2*e, v3=3*e)) -> df2
  
  # Write local files
  write.table(df1, file="df1.csv", sep=",", row.names=F, col.names=T)
  write.table(df2, file="df2.csv", sep=",", row.names=F, col.names=T)
  
  # Upload to S3
  faasr_put_file(local_file="df1.csv", remote_folder=folder, remote_file=output1)
  faasr_put_file(local_file="df2.csv", remote_folder=folder, remote_file=output2)
  
  # Log message
  log_msg <- paste0('Function create_sample_data finished; outputs written to folder ', folder)
  faasr_log(log_msg)
}