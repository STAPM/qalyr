
#' Reads in survey HODaR data
#'
#' Reads in the survey data and calculate EQ5D.
#'
#' @param file - the file path to the data
#'
#' @return Returns a data.table of the survey data.
#' @importFrom data.table fread :=
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' read_survey_data()
#'
#' }
#'
read_survey_data <- function(
  file = "D:/QALYs/Raw/routine_survey_data.csv"
) {

  cat("Reading survey data\n")
  
  # clean HODAR data
  HODAR_data <- fread(file)

  
  cat("Creating age and year variables\n")
  
  # Create age variable
  HODAR_data <- HODAR_data[ , Year := format(as.Date(Date_Survey_Sent, format = "%d/%m/%Y"), "%Y")]
  HODAR_data <- HODAR_data[ , Age := as.numeric(Year) - as.numeric(Year_of_birth)]
  
  cat("Removing missing values\n")
  
  # Remove missing values for age, sex and dimensions of the EQ5D
  HODAR_data <- na.omit(HODAR_data,
                        cols = c("Mobility", "Self_Care", "Usual_Activities",
                                 "Pain", "Depressed", "Age", "gender"))
 
  cat("Calculating utility values...\n")
  
  # Add utility column
  scores <- data.frame(
    MO = HODAR_data$Mobility,
    SC = HODAR_data$Self_Care,
    UA = HODAR_data$Usual_Activities,
    PD = HODAR_data$Pain,
    AD = HODAR_data$Depressed
  )

  # Calculate eq5d
  # Error in get(type) : object 'TTO' not found - only happens when run in package.
  HODAR_data <- HODAR_data[ , Utility_value := eq5d::eq5d(scores = scores,
                                                    country = "UK",
                                                    version = "3L",
                                                    type = "TTO")]


  return(HODAR_data[])
}
