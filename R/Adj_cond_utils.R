

#' Adjust the condition-specific utility for age and sex
#'
#' Calculates an average utility for each alcohol/tobacco-related condition by age and sex.
#' Need to calculate the mean age and proportion of males for each condition in the HODAR data.
#' Need to calculate the matched age-sex specific general population utility using the Ara
#' and Brazier 2011 formula. Dividing these will give the multiplier by which to adjust the
#' general population utility score by, to get age-adjusted condition-specific utilities.
#'
#'
#'
#' @param Age_Sex_data mean age and proportion of males for in condition in data. Calculated using function *MeanAge_Sex()* - data stored in package
#' as qalyr::Age_Sex_data.
#'
#' @param Condition_utilities condition-specific utilities. Calculated using function *CalcUtils()* - default stored in package as qalyr::util_data.
#'
#' @param GenPopUtil table of general population utilities by age and sex. Default stored in package as qalyr::GenPopUtil
#'
#' @return Returns a summary table of condition-specific utilities.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#'
#' age_sex_condition_utilities <- Adj_cond_utils(Age_Sex_data = qalyr::Age_Sex_data, Condition_utilities = qalyr::util_data, GenPopUtil = qalyr::GenPopUtil)
#'
#' }
#'

Adj_cond_utils <- function(
    Age_Sex_data = qalyr::Age_Sex_data,
    Condition_utilities = qalyr::util_data,
    GenPopUtil = qalyr::GenPopUtil
  ) {

  Age_Sex_data[ , Matched_GenPop := 0.9508566 + 0.0212126*Prop_male - 0.0002587*Av_Age - 0.0000332*(Av_Age^2)]

  Age_Sex_data <- merge(Age_Sex_data, Condition_utilities, by = c("condition"))

  Age_Sex_data[ , Multiplier := utility / Matched_GenPop]

  Age_Sex_data <- Age_Sex_data[ , .(condition, Multiplier)]

  domain <- data.frame(expand.grid(
    age = 12:89,
    sex = 1:2,
    condition = unique(Age_Sex_data$condition)
  ))
  setDT(domain)

  AgeSexCondUtil <- merge(domain, Age_Sex_data, by = "condition")
  AgeSexCondUtil <- merge(AgeSexCondUtil, GenPopUtil, by = c("sex", "age"))

  AgeSexCondUtil[ , ConditionUtil := Multiplier * GenPop_utility]

  AgeSexCondUtil[ , Multiplier := NULL]


  # Embed the data within the package
  usethis::use_data(AgeSexCondUtil, overwrite = TRUE)


  return(AgeSexCondUtil)
}









