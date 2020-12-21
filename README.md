
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Tobacco- and alcohol-related health state utility values <img src="logo.png" align="right" style="padding-left:10px;background-color:white;" width="100" height="100" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
<!-- badges: end -->

## Motivation

The motivation for `qalyr` was to standardised the way that health state
utility values for diseases related to tobacco and/or alcohol were
prepared for input to our decision-analytic models. Health state utility
values associated with tobacco- and alcohol-related disease diagnosis
codes are derived from the Health Outcomes Data Repository (HODaR) data
(Currie et al. [2005](#ref-currie2005routine)), and general population
utility values from the Health Survey for England (Ara and Brazier
[2010](#ref-Ara2010)). The suite of functions within `qalyr` wrangle the
data into the correct format and then calculate the health state utility
values, for which we use the `eq5d` R package (Morton and Nijjar
[2020](#ref-eq5dpackage)). See our [methodology
report](https://stapm.gitlab.io/model-inputs/utility_report/qaly_estimation_report.pdf).

`qalyr` was created as part of a programme of work on the health
economics of tobacco and alcohol at the School of Health and Related
Research (ScHARR), The University of Sheffield. This programme is based
around the construction of the Sheffield Tobacco and Alcohol Policy
Model (STAPM), which aims to use comparable methodologies to evaluate
the impacts of tobacco and alcohol policies, and investigate the
consequences of clustering and interactions between tobacco and alcohol
consumption behaviours.

## HODaR data

The following is a summary from Currie et
al. ([2005](#ref-currie2005routine)).

*HODaR supplements routine clinically coded data from the Cardiff and
Vale NHS Hospitals Trust, UK, with survey data covering sociodemographic
characteristics, QoL, utility, and resource use information. Data that
constitutes HODaR were collated from a prospective survey of subjects
treated as inpatients or outpatients. Details from the survey then need
to be linked to existing routine hospital health data. All inpatients
aged 18 years or older were surveyed. For inpatients, all subjects were
surveyed 6 weeks postdischarge by postal survey with a “freepost” return
envelope. For outpatients, all patients attending a selected clinic were
handed a survey pack by the clinic receptionist when they attend.*

We were provided with two datasets in the form of inpatient data and
survey data. The inpatient data includes a pseudo-anonymised patient
identification number and information on the type of admission including
the dates of admission and diagnostic and operation codes. The inpatient
data is provided at episode level and was filtered such that we were
only provided with episodes that had an alcohol or tobacco-related
ICD-10 code in one of the diagnostic positions remained.

## Information governance

The HODaR data are risk-bearing because they constitute patient-level
hospital records and survey data. Our data storage and processing takes
place on a restricted user-access CiCS virtual machine (VM). This is a
secure virtual computing environment on a centrally managed university
server. The VM is called `heta_study`. We follow [ScHARR’s Information
Governance
Policy](https://www.sheffield.ac.uk/scharr/research/igov/policy00).

## Usage

The `qalyr` package contains functions to calculate utilities using the
EQ-5D, for specific diseases and for the general population.

The **inputs** are the HODaR data and previously published estimates of
general population utility values by Ara and Brazier
([2010](#ref-Ara2010)), who analysed the Health Survey for England.

The **processes** are performed by functions that:

  - Read and link the HODaR survey and inpatient data  
  - Calculate and adjust the disease specific and general population
    utility values

The **outputs** are lookup tables of utility values ready for use in our
modelling.

## Installation

`qalyr` is currently available only to members of the project team (but
please contact Duncan Gillespie <duncan.gillespie@sheffield.ac.uk> to
discuss). To access you need to [sign-up for a GitLab
account](https://gitlab.com/). You will then need to be added to the
STAPM project team to gain access. Once that is sorted, you can install
the latest version or a specified version of `qalyr` from GitLab with:

``` r
#install.packages("devtools")
#install.packages("getPass")

devtools::install_git(
  "https://gitlab.com/stapm/r-packages/qalyr.git", 
  credentials = git2r::cred_user_pass("uname", getPass::getPass()),
  ref = "x.x.x",
  build_vignettes = TRUE
)

# Where uname is your Gitlab user name.
# ref = "x.x.x" is the version to install - remove this to install the latest version
# this should make a box pop up where you enter your GitLab password
```

Then load the package, and some other packages that are useful. Note
that the code within `qalyr` uses the `data.table::data.table()` syntax.

``` r
# Load the package
library(qalyr)
library(eq5d)

# Other useful packages
library(dplyr) # for data manipulation and summary
library(magrittr) # for pipes
library(ggplot2) # for plotting
```

## Citation

Please cite the latest version of the package using:  
“Duncan Gillespie, Laura Webster, Colin Angus and Alan Brennan (2020).
qalyr: Tobacco- and Alcohol-Related Health State Utility Value
Estimation. R package version x.x.x.
<https://stapm.gitlab.io/r-packages/qalyr>.”

## References

<div id="refs" class="references hanging-indent">

<div id="ref-Ara2010">

Ara, Roberta, and John E Brazier. 2010. “Populating an Economic Model
with Health State Utility Values: Moving Toward Better Practice.” *Value
in Health* 13 (5): 509–18.
<https://doi.org/10.1111/j.1524-4733.2010.00700.x>.

</div>

<div id="ref-currie2005routine">

Currie, Craig J, Phil McEwan, John R Peters, Tunia C Patel, and Simon
Dixon. 2005. “The Routine Collation of Health Outcomes Data from
Hospital Treated Subjects in the Health Outcomes Data Repository
(Hodar): Descriptive Analysis from the First 20,000 Subjects.” *Value in
Health* 8 (5): 581–90.
<https://doi.org/10.1111/j.1524-4733.2005.00046.x>.

</div>

<div id="ref-eq5dpackage">

Morton, Fraser, and Jagtar Singh Nijjar. 2020. *eq5d: Methods for
Calculating ’EQ-5D’ Utility Index Scores*.
<https://CRAN.R-project.org/package=eq5d>.

</div>

</div>
