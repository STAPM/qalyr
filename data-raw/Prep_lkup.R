



# Code needs updating


library(data.table)


#Read in alc and tob ICD10 codes
lkup <- read.csv("//tsclient/X/ScHARR/PR_Disease_Risk_TA/Disease_Lists/ICD_10_lookup.csv")
setDT(lkup)

setnames(lkup,
         c("ICD10_lookups", "condition"),
         c("icd_code", "Description"))

lkup <- unique(lkup)


# Don't want to split oesophageal AC and SCC, remove these rows and replace with oesophageal C15.
lkup <- lkup[!Description %in% c("Oesophageal_AC", "Oesophageal_SCC"), ]

lkup <- rbind(lkup, list("Oesophageal", "C15"))


# Embed the data within the package
usethis::use_data(lkup, overwrite = TRUE)
