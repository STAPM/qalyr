

#' Merge the inpatient and survey data together
#'
#' As the inpatient data and survey data were provided separately, this function merges the two datasets, matching the survey information
#' to the inpatient data.
#'
#' This function follows a set of rules to match the survey data to the inpatient data. The only field available to match the two datasets
#' is the Patient ID variable 'Patient_Number'. We have the date of admission and discharge in the inpatient data, and the date the survey
#' was sent and returned in the survey data.
#'
#'
#' @param inpatient_data inpatient data containing data on the patient's admission and discharge dates, and diagnosis codes.
#'
#' @param lkup lkup table in the format (icd_code, Description) (default stored in package as qalyr::lkup - this contains all
#' alcohol and tobacco related conditions).
#'
#' @return Returns a table with the survey data and inpatient data merged, with all admissions allocated to a survey,
#' ready for calculating condition-specific utilities.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' inpatient_data <- read_data()
#'
#' merge_data(inpatient_data, lkup = qalyr::lkup)
#'
#' }
#'

merge_data <- function(
  inpatient_data,
  lkup
) {

  # Want to scan the diagnostic fields for tob/alc related conditions, and create a new column for each condition with a binary outcome.
  diagnoses <- c("Diagno1", "Diagno2", "Diagno3", "Diagno4", "Diagno5", "Diagno6",
                 "Diagno7", "Diagno8", "Diagno9", "Diagno10", "Diagno11", "Diagno12", "Diagno13")


  # A numerical index of those diagnosis codes.
  diagnosisPosition <- 1:length(diagnoses)

  # Loop through each diagnosis column and search for ICD-10 codes that match alcohol/tobacco-related conditions.
  # Then create new columns that store a binary variable 1 if included/0 if not.

  # 3 character ICD-10 matching for each diagnosis code column.

  cat("\tscanning 3 chr codes\n")

  for(i in diagnosisPosition) {

    # Grab the name of that column.
    diagnosisHeader <- diagnoses[i]

    # Create a new column that has just the first 3 characters of the ICD-10 code.
    inpatient_data[ , icd_code := substr(get(diagnosisHeader), 1, 3)]

    # Merge the inpatient_data with the lookup data.
    inpatient_data <- merge(inpatient_data, lkup, by = c("icd_code"), all.x = T, all.y = F, sort = F)

    # Create new variables that store the 3 character ICD-10 code for each diagnosis code column
    # i.e. any matches of ICD-10 for diag_01 etc.
    inpatient_data[ , (paste0("d3_cause_", i)) := Description]

    # Delete the working columns above ready for the next iteration of the loop.
    inpatient_data[ , Description := NULL]

  }

  # 4 character ICD-10 matching for each diagnosis code column.
  cat("\tscanning 4 chr codes\n")

  for(i in diagnosisPosition) {

    # Grab the name of that column.
    diagnosisHeader <- diagnoses[i]

    # Create a new column that has just the first 4 characters of the ICD-10 code.
    inpatient_data[ , icd_code := substr(get(diagnosisHeader), 1, 4)]

    # Merge the inpatient_data with the data on alcohol attributable fractions (AAFs in lkup).
    inpatient_data <- merge(inpatient_data, lkup, by = c("icd_code"), all.x = T, all.y = F, sort = F)

    # Create new variables that store the 4 character ICD-10 code and the corresponding AAF for each diagnosis code column
    inpatient_data[ , (paste0("d4_cause_", i)) := Description]

    # Delete the working columns above ready for the next iteration of the loop.
    inpatient_data[ , Description := NULL]

  }

  # Names of the variables where the corresponding SAPM3 disease groups are stored.
  causes <- c("d4_cause_1", "d3_cause_1", "d4_cause_2", "d3_cause_2", "d4_cause_3",
              "d3_cause_3", "d4_cause_4", "d3_cause_4", "d4_cause_5", "d3_cause_5", "d4_cause_6", "d3_cause_6",
              "d4_cause_7", "d3_cause_7", "d4_cause_8", "d3_cause_8", "d4_cause_9", "d3_cause_9", "d4_cause_10",
              "d3_cause_10", "d4_cause_11", "d3_cause_11", "d4_cause_12", "d3_cause_12", "d4_cause_13",
              "d3_cause_13")

  inpatient_data <- as.data.frame(inpatient_data)

  # Create subsets of the data that contain just the columns above.
  broad_cause  <- inpatient_data[causes]

  conditions <- unique(lkup$Description)

  # A numerical index of those diagnosis codes.
  conditionPosition <- 1:length(conditions)

  setDT(broad_cause)

  cat("\tcreating column for each condition\n")
  for(i in conditionPosition) {

    # Create a new column that has the name of the condition in each row
    broad_cause[ , (paste0("Cause", i)) := apply(broad_cause, 1, function(r) any(r %in% conditions[i]))]

  }


  broad_cause <- broad_cause[, 27:110]

  colnames(broad_cause) <- as.character(unique(lkup$Description))
  broad_cause <- broad_cause * 1

  inpatient_data <- cbind(inpatient_data[, 2:5], broad_cause)
  setDT(inpatient_data)

  # Need to collapse episodes into admissions whilst adding columns
  inpatient_data <- inpatient_data[, lapply(.SD, sum, na.rm = TRUE), by = c("Patient_Number", "PS_Admit", "PS_Disch")]

  cat("\tread in HODAR data\n")
  # HODAR data
  HODAR_data <- qalyr::HODAR_data[ , . (Patient_Number, Date_Survey_Sent, Date_Survey_Returned, Age, gender, Smoke, Alcohol, Utility_value)]

  inpatient_data <- merge(inpatient_data, HODAR_data, by = "Patient_Number", all = T, allow.cartesian = TRUE)

  # Need to create an algorithm that chooses only the rows that make sense (i.e. PS_Disch < Date_Survey_Sent, but not years before).
  inpatient_data <- inpatient_data[, Date_Survey_Sent := as.Date(Date_Survey_Sent, "%d/%m/%Y")]
  inpatient_data <- inpatient_data[, PS_Disch := as.Date(PS_Disch, "%d/%m/%Y")]

  inpatient_data <- inpatient_data[Date_Survey_Sent > PS_Disch, ]
  inpatient_data <- inpatient_data[Date_Survey_Sent - PS_Disch < 366, ]

  setorder(inpatient_data, Patient_Number, PS_Disch, Date_Survey_Sent)

  inpatient_data <- unique(inpatient_data, by = c("Patient_Number", "PS_Admit", "PS_Disch"))

  # Collapse into survey dates
  cat("\tcollapse into survey dates\n")
  inpatient_data <- Collapse_adm_survey(inpatient_data)


 return(inpatient_data)
}




