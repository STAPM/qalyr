

#' Calculate mean age and proportion of males for each condition in HODAR
#'
#' In order to calculate the  average utility for each alcohol/tobacco-related condition
#' by age and sex, we need to calculate the mean age and proportion of males for each condition
#' in the HODAR data. This function uses the merged HoDAR and inpatient data to estimate the
#' average age and mean proportion of males admitted for each condition.
#'
#'
#'
#' @param data the merged HODAR and inpatient data
#'
#' @param lkup table of conditions and respective ICD10 codes - default stored in package as qalyr::lkup
#'
#' @return Returns a summary table of condition-specific mean ages and male proportions
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' data <- merge_data(read_data())
#'
#' age_sex_condition <- MeanAge_Sex(data = data, lkup = qalyr::lkup)
#'
#' }
#'

MeanAge_Sex <- function(
  data,
  lkup = qalyr::lkup
) {

  conditions <- unique(lkup$Description)

  conditions <- as.character(conditions)

  n <- length(conditions)

  Size <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

    s <- data[get(conditionHeader) > 0, .(Size = .N)]

    return(as.numeric(s))
  }

  )


  AvAge <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

    a <- data[get(conditionHeader) > 0, .(av_age = mean(Age, na.rm = T))]

    return(as.numeric(a))
  }

  )


  PropMale <- sapply(1:n, function(x) {

    conditionHeader <- conditions[x]

        m <- data[get(conditionHeader) > 0, .(prop_male = sum(gender == 0)/.N)]

    return(as.numeric(m))
  }

  )

  Age_Sex_data <- data.table(condition = conditions, Size = Size, Av_Age = AvAge, Prop_male = PropMale)



  # Missing data for Acute_pancreatitis_alcohol_induced, Alcohol_induced_pseudoCushings_syndrome, Alcoholic_myopathy,
  # Drowning, Excessive_Blood_Level_of_Alcohol, Maternal_care_for_suspected_damage_to_foetus_from_alcohol,
  # Other_intentional_injuries.

  # Small samples sizes for: fire injuries (1), Alcoholic_polyneuropathy (3), Degeneration (2), Psychosis (4), Influenza_microbiologically_confirmed(7),
  # Bulimia (2), which will be skewing the data. Making the gender proportions either 100% female/male.

  temp <- Age_Sex_data[condition == "Mental_and_behavioural_disorders_due_to_use_of_alcohol", Av_Age]
  Age_Sex_data[condition %in% c("Alcohol_induced_pseudoCushings_syndrome", "Alcoholic_polyneuropathy", "Degeneration"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Mental_and_behavioural_disorders_due_to_use_of_alcohol", Prop_male]
  Age_Sex_data[condition %in% c("Alcohol_induced_pseudoCushings_syndrome", "Alcoholic_polyneuropathy", "Degeneration"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Evidence_of_alcohol_involvement_determined_by_blood_alcohol_level", Av_Age]
  Age_Sex_data[condition %in% c("Excessive_Blood_Level_of_Alcohol"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Evidence_of_alcohol_involvement_determined_by_blood_alcohol_level", Prop_male]
  Age_Sex_data[condition %in% c("Excessive_Blood_Level_of_Alcohol"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Alcoholic_cardiomyopathy", Av_Age]
  Age_Sex_data[condition %in% c("Alcoholic_myopathy"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Alcoholic_cardiomyopathy", Prop_male]
  Age_Sex_data[condition %in% c("Alcoholic_myopathy"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Transport_injuries", Av_Age]
  Age_Sex_data[condition %in% c("Drowning", "Fire_injuries"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Transport_injuries", Prop_male]
  Age_Sex_data[condition %in% c("Drowning", "Fire_injuries"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Other_unintentional_injuries", Av_Age]
  Age_Sex_data[condition %in% c("Other_intentional_injuries"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Other_unintentional_injuries", Prop_male]
  Age_Sex_data[condition %in% c("Other_intentional_injuries"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Other_unintentional_injuries", Av_Age]
  Age_Sex_data[condition %in% c("Maternal_care_for_suspected_damage_to_foetus_from_alcohol"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Other_unintentional_injuries", Prop_male]
  Age_Sex_data[condition %in% c("Maternal_care_for_suspected_damage_to_foetus_from_alcohol"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Acute_Pancreatitis", Av_Age]
  Age_Sex_data[condition %in% c("Acute_pancreatitis_alcohol_induced"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Acute_Pancreatitis", Prop_male]
  Age_Sex_data[condition %in% c("Acute_pancreatitis_alcohol_induced"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Influenza_clinically_diagnosed", Av_Age]
  Age_Sex_data[condition %in% c("Influenza_microbiologically_confirmed"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Influenza_clinically_diagnosed", Prop_male]
  Age_Sex_data[condition %in% c("Influenza_microbiologically_confirmed"), `:=`(Prop_male = temp)]


  temp <- Age_Sex_data[condition == "Schizophrenia", Av_Age]
  Age_Sex_data[condition %in% c("Psychosis"), `:=`(Av_Age = temp)]

  temp <- Age_Sex_data[condition == "Schizophrenia", Prop_male]
  Age_Sex_data[condition %in% c("Psychosis"), `:=`(Prop_male = temp)]


  Age_Sex_data <- Age_Sex_data[ , Av_Age := round(Av_Age, 2)]
  Age_Sex_data <- Age_Sex_data[ , Prop_male := round(Prop_male, 3)]

  Age_Sex_data <- Age_Sex_data[ , Size := NULL]

  # Embed the data within the package
  usethis::use_data(Age_Sex_data, overwrite = TRUE)

  return(Age_Sex_data)
}
