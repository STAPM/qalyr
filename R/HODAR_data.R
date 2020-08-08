
#' HODAR data with utility field
#'
#' The Health Outcomes Data Repository (HODAR) measures utilities using the EQ-5D, a widely used generic quality of life instrument as recommended
#' by NICE for health economic evaluation. This data does not come with the utility scores estimated, only the raw outcomes from the survey.
#' We estimate the utility score from the five fields: Mobility, Self_Care, Usual_Activities, Pain, Depressed. We use the package 'eq5d' to do this.
#'
#' @docType data
#'
#' @format A data table (Patient_Number, Date_Survey_Sent, Date_Survey_Returned, Survey_version, Year_of_birth, Height, Height_Feet, Height_Inches,
#' Weight, Weight_Stones, Weight_Pounds, Waist_size, Weight_change, Smoke, Smoke_per_Day, Ever_Smoked, Smoked_Years, Alcohol, Exercise,
#' Exercise_Amount, Occupation, Ethnic_Group, Ethnic_Group_Elsewhere, Rate_Health_months_ago, Rate_Health_today, Health_changed, Mobility, Self_Care,
#' Usual_Activities, Pain, Depressed, Wheelchair, gender, Utility_value).
#'
#' @source
#'
#'
#'
"HODAR_data"
