% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/MeanAge_Sex.R
\name{MeanAge_Sex}
\alias{MeanAge_Sex}
\title{Calculate mean age and proportion of males for each condition in HODAR \lifecycle{maturing}}
\usage{
MeanAge_Sex(data, lkup = qalyr::lkup)
}
\arguments{
\item{data}{Data table - the merged HODAR and inpatient data.}

\item{lkup}{Data table of conditions and respective ICD10 codes -
default stored in package as \code{qalyr::lkup}.}
}
\value{
Returns a summary table of condition-specific mean ages and male proportions
}
\description{
In order to calculate the  average utility for each alcohol/tobacco-related condition
by age and sex, we need to calculate the mean age and proportion of males for each condition
in the HODAR data. This function uses the merged HoDAR survey and inpatient data to estimate the
average age and mean proportion of males admitted for each condition.
}
\examples{

\dontrun{

data <- qalyr::merge_data(
  inpatient_data = qalyr::read_inpatient_data(),
  survey_data = qalyr::read_survey_data(),
  lkup = qalyr::lkup)

age_sex_condition <- qalyr::MeanAge_Sex(data = data, lkup = qalyr::lkup)

}

}
