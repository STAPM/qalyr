# Create a new data sheet where all combinations of age and sex are present.
# Calculate age-sex-specific general population utilities.

GenPopUtil <- data.frame(expand.grid(
  sex = c(1, 0),
  age =  c(12:89)
))

setDT(GenPopUtil)

GenPopUtil[ , GenPop_utility := 0.9508566 + 0.0212126*sex - 0.0002587*age - 0.0000332*(age^2)]

GenPopUtil[sex == 0, sex := 2]

# Embed the data within the package
usethis::use_data(GenPopUtil, overwrite = TRUE)
