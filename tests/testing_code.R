# Code for testing functions

# When creating a package
# depends means you don't need to call it.
#install.packages("usethis")
#install.packages("eq5d")


#library(usethis)
#usethis::use_package("data.table", type = "depends")
#usethis::use_package("bit64", type = "depends")
#usethis::use_package("Hmisc")
#usethis::use_package("readxl")
#usethis::use_package("stringr")
#usethis::use_package("dplyr")
#usethis::use_package("plyr")
#usethis::use_package("eq5d")

library(roxygen2)
roxygenise()


inpatient_data <- read_data()


# Need to add age variable before running. sex in gender column

inpatient_data <- merge_data(inpatient_data, lkup = qalyr::lkup)

#write.csv(inpatient_data, "D:/QALYs/Cleaned/Survey_data_by_ConditionAgeSex.csv", row.names = FALSE)

inpatient_data <- fread("D:/QALYs/Cleaned/Survey_data_by_ConditionAgeSex.csv")

condition_utilities <- CalcUtils(inpatient_data, lkup = qalyr::lkup)
# Calculate mean age and % male for each condition in HODAR.

write.csv(condition_utilities, "data-raw/condition_specific_utilities.csv", row.names = FALSE)


age_sex_condition_utilities <- Adj_cond_utils(Age_Sex_data = qalyr::Age_Sex_data,
                                              Condition_utilities = qalyr::util_data,
                                              GenPopUtil = qalyr::GenPopUtil)

AgeSexCondUtils <- qalyr::AgeSexCondUtil
write.csv(AgeSexCondUtils, "data-raw/age-sex-condition-GP-utilities.csv", row.names = FALSE)


# Plot of GP against condition
cond <- qalyr::AgeSexCondUtil

library(ggplot2)

Pneumonia <- cond[condition == "Pneumonia" & sex == 2, ]
Pneumonia <- Pneumonia[ , GeneralPop := GenPop_utility]
Pneumonia <- Pneumonia[ , Pneumonia := ConditionUtil]

Pneumonia_plot <- ggplot(Pneumonia) +
  geom_line(aes(x = age, y = GeneralPop, colour = "GeneralPop")) +
  geom_line(aes(x = age, y = Pneumonia, colour = "Pneumonia")) +
  ylim(0, 1) +
  ylab("HSUV") +
  theme_classic()




