

#' Collapse admissions into surveys
#'
#' This function is used within the function *merge_data()* to collapse the data to assign a survey to each admission. Multiple admissions can be allocated
#' to the same survey, but the admission has to have been in the year before the survey was sent.
#'
#'
#'
#' @param data merged admission level inpatient data with survey data
#'
#' @return Returns the data at survey level, with a column for each condition indicating
#' whether the utility from the survey should be allocated to that condition.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' inpatient_data <- read_data()
#'
#' Collapse_adm_survey(inpatient_data)
#'
#' }
#'

Collapse_adm_survey <- function(
    data
) {

  # Retain only unique surveys. This will match back up with data
  keep_unique_surveys <- unique(data, by = c("Patient_Number", "Date_Survey_Sent", "Date_Survey_Returned"))
  keep_unique_surveys <- keep_unique_surveys[ , . (Utility_value, Age, gender)]

  # Remove columns that cannot be added
  keep <- data[ , c("PS_Admit", "PS_Disch", "Smoke", "Alcohol", "Utility_value", "Age", "gender") := NULL]

  # Collapse admissions into surveys. Add rows together.
  surv_data <- keep[, lapply(.SD, base::sum, na.rm = TRUE), by = c("Patient_Number", "Date_Survey_Sent", "Date_Survey_Returned")]
  data <- cbind(surv_data, keep_unique_surveys)



  return(data)
}
