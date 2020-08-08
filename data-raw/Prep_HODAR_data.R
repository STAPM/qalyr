library(eq5d)

# clean HODAR data
HODAR_data <- fread("D:/QALYs/Raw/routine_survey_data.csv")

HODAR_data <- na.omit(HODAR_data, cols = c("Mobility", "Self_Care", "Usual_Activities", "Pain", "Depressed", "Age", "gender"))

# Create age variable
HODAR_data <- HODAR_data[ , Year := format(as.Date(Date_Survey_Sent, format = "%d/%m/%Y"), "%Y")]
HODAR_data <- HODAR_data[ , Age := as.numeric(Year) - as.numeric(Year_of_birth)]

# Add utility column
scores <- data.frame(MO = (HODAR_data$Mobility), SC = c(HODAR_data$Self_Care), UA = c(HODAR_data$Usual_Activities), PD = c(HODAR_data$Pain), AD = c(HODAR_data$Depressed))

# Error in get(type) : object 'TTO' not found - only happens when run in package.
HODAR_data <- HODAR_data[ , Utility_value := eq5d(scores = scores,
                                                        country = "UK",
                                                        version = "3L",
                                                        type = "TTO")]


# Embed the data within the package
usethis::use_data(HODAR_data, overwrite = TRUE)
