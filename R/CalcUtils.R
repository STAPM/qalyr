
#' Calculate the average utility for each alcohol/tobacco-related condition \lifecycle{maturing}
#'
#' Due to small sample sizes, we first use this function to calculate
#' the average utility for each condition, without any demographic stratification.
#' \code{Adj_cond_utils()} is later used to stratify utilities by age and sex.
#'
#' For conditions where no utility data was available,
#' utilities were assumed to be similar to close conditions.
#' Thus, utilities for alcohol induced Cushing syndrome, alcoholic polyneuropathy and degeneration
#' were assumed to be similar to mental and behavioural disorders due to alcohol.
#' Utilities for psychosis were assumed to be similar to schizophrenia.
#' Utilities for alcoholic myopathy were assumed to be similar to utilities for alcohol cardiomyopathy.
#' The utility for excessive blood level of alcohol was assumed to be similar to evidence
#' of alcohol involvement determined by blood alcohol level.
#' Utilities for drowning were assumed to be similar to transport injuries.
#' Finally, utilities for other intentional injuries were assumed to be similar to other unintentional injuries.
#'
#'
#' @param data Data.table - the merged HODaR inpatient and survey data
#' @param lkup Data table of conditions and respective ICD10 codes
#'
#' @importFrom data.table data.table :=
#'
#' @return Returns a summary data table of condition-specific utilities,
#' including mean, standard deviation, and number of rows (to check for sample size).
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data <- qalyr::merge_data(
#'   inpatient_data = qalyr::read_inpatient_data(),
#'   survey_data = qalyr::read_survey_data(),
#'   lkup = qalyr::lkup)
#'
#' condition_utilities <- qalyr::CalcUtils(data = data, lkup = qalyr::lkup)
#'
#' }
#'
CalcUtils <- function(
  data,
  lkup = qalyr::lkup
) {

  conditions <- unique(lkup$Description)

  conditions <- as.character(conditions)

  n <- length(conditions)

  utils <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

    d <- as.numeric(data[get(conditionHeader) > 0, list(av = mean(Utility_value, na.rm = T))])

    #sd <- as.numeric(data[get(conditionHeader) > 0, .(sd = sd(Utility_value, na.rm = T))])

   # number_surveys <- as.numeric(data[get(conditionHeader) > 0, .(number_surveys = .N)])

    return(d)
  }

  )

  se_utils <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

    #se <- as.numeric(data[get(conditionHeader) > 0, .(se = se(Utility_value, na.rm = T))])
    se <- as.numeric(data[get(conditionHeader) > 0,
                          list(se = sqrt(var(Utility_value, na.rm = T) / length(Utility_value)))])

    return(se)
  }

  )

  n_utils <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

    number_surveys <- as.numeric(data[get(conditionHeader) > 0, list(number_surveys = .N)])

    return(number_surveys)
  }

  )



  util_data <- data.table(condition = conditions, utility = utils, se = se_utils, n = n_utils)

  # Missing data for Acute_pancreatitis_alcohol_induced, Alcohol_induced_pseudoCushings_syndrome, Alcoholic_myopathy,
  # Drowning, Excessive_Blood_Level_of_Alcohol, Maternal_care_for_suspected_damage_to_foetus_from_alcohol,
  # Other_intentional_injuries.



  temp <- util_data[condition == "Alcoholic_polyneuropathy", utility]
  util_data[condition %in% c("Alcohol_induced_pseudoCushings_syndrome"), `:=`(utility = temp)]

  temp <- util_data[condition == "Alcoholic_polyneuropathy", se]
  util_data[condition %in% c("Alcohol_induced_pseudoCushings_syndrome"), `:=`(se = temp)]



  temp <- util_data[condition == "Evidence_of_alcohol_involvement_determined_by_blood_alcohol_level", utility]
  util_data[condition %in% c("Excessive_Blood_Level_of_Alcohol"), `:=`(utility = temp)]

  temp <- util_data[condition == "Evidence_of_alcohol_involvement_determined_by_blood_alcohol_level", se]
  util_data[condition %in% c("Excessive_Blood_Level_of_Alcohol"), `:=`(se = temp)]



  temp <- util_data[condition == "Alcoholic_cardiomyopathy", utility]
  util_data[condition %in% c("Alcoholic_myopathy"), `:=`(utility = temp)]

  temp <- util_data[condition == "Alcoholic_cardiomyopathy", se]
  util_data[condition %in% c("Alcoholic_myopathy"), `:=`(se = temp)]



  temp <- util_data[condition == "Transport_injuries", utility]
  util_data[condition %in% c("Drowning"), `:=`(utility = temp)]

  temp <- util_data[condition == "Transport_injuries", se]
  util_data[condition %in% c("Drowning", "Fire_injuries"), `:=`(se = temp)]



  temp <- util_data[condition == "Other_unintentional_injuries", utility]
  util_data[condition %in% c("Other_intentional_injuries"), `:=`(utility = temp)]

  temp <- util_data[condition == "Other_unintentional_injuries", se]
  util_data[condition %in% c("Other_intentional_injuries"), `:=`(se = temp)]



  temp <- util_data[condition == "Other_unintentional_injuries", utility]
  util_data[condition %in% c("Maternal_care_for_suspected_damage_to_foetus_from_alcohol"), `:=`(utility = temp)]

  temp <- util_data[condition == "Other_unintentional_injuries", se]
  util_data[condition %in% c("Maternal_care_for_suspected_damage_to_foetus_from_alcohol"), `:=`(se = temp)]



  temp <- util_data[condition == "Acute_Pancreatitis", utility]
  util_data[condition %in% c("Acute_pancreatitis_alcohol_induced"), `:=`(utility = temp)]

  temp <- util_data[condition == "Acute_Pancreatitis", se]
  util_data[condition %in% c("Acute_pancreatitis_alcohol_induced"), `:=`(se = temp)]


  util_data <- util_data[ , utility := round(utility, 2)]
  util_data <- util_data[ , se := round(se, 2)]
  util_data <- util_data[ , n := round(n, 2)]


  return(util_data)
}
