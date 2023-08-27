
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Estimating health state utility values for conditions related to tobacco and alcohol <img src="logo.png" align="right" style="padding-left:10px;background-color:white;" width="100" height="100" />

<!-- badges: start -->

[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)

[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

[![](https://img.shields.io/badge/doi-10.17605/OSF.IO/8V5XJ-green.svg)](https://doi.org/10.17605/OSF.IO/8V5XJ)

<!-- badges: end -->

## The Sheffield Tobacco and Alcohol Policy Modelling Platform

This R package was developed as part of the Sheffield Tobacco and
Alcohol Policy Modelling <https://stapm.gitlab.io/> by the [Sheffield
Centre for Health and Related Research at the University of
Sheffield](https://www.sheffield.ac.uk/scharr).

The aim of the research programme is to identify and evaluate approaches
to reducing the harm from tobacco and alcohol, with the aim of improving
commissioning in a public health policy context, i.e. providing
knowledge to support benefits achieved by policymakers.

The two objectives of the research programme are:

- To evaluate the health and economic effects of past trends, policy
  changes or interventions that have affected alcohol consumption and/or
  tobacco smoking
- To appraise the health and economic outcomes of potential future
  trends, changes to alcohol and/or tobacco policy or new interventions

The STAPM modelling is not linked to the tobacco or alcohol industry and
is conducted without industry funding or influence.

## Purpose of making the code open source

The code has been made open source for the following two reasons:

- Transparency. Open science, allowing review and feedback to the
  project team on the code and methods used.
- Methodology sharing. For people to understand the code and methods
  used so they might use aspects of it in their own work, e.g., because
  they are doing something partially related that isn’t exactly the same
  job and might like to ‘dip into’ elements of this code for
  inspiration.

## Stage of testing and development

The code is actively being used in project work. It is being reviewed
and developed all the time; more tests and checks are being added.

The repository is not intended to be maintained by an open source
community wider than the development team.

## Code repositories

The code on Github (<https://github.com/STAPM/qalyr>) is a mirror of the
code in a private Gitlab repository where the actual development takes
place (<https://gitlab.com/stapm/r-packages/qalyr>). The code in the
Github repository is linked to a repository on the Open Science
Framework, which provides the doi for the package citation
(<https://osf.io/8v5xj/>).

## Citation

Gillespie D, Webster L, Angus C, Brennan A (\[YEAR\]). qalyr: An R
package for estimating health state utility values for conditions
related to tobacco and alcohol. R package version \[x.x.x\]. University
of Sheffield. <https://stapm.gitlab.io/r-packages/qalyr/>. doi:
<https://doi.org/10.17605/OSF.IO/8V5XJ>

## Motivation

The motivation for `qalyr` was to standardised the way that health state
utility values for diseases related to tobacco and/or alcohol were
prepared for input to our decision-analytic models. Health state utility
values associated with tobacco- and alcohol-related disease diagnosis
codes are derived from the Health Outcomes Data Repository (HODaR) data
([Currie et al. 2005](#ref-currie2005routine)), and general population
utility values from the Health Survey for England ([Ara and Brazier
2010](#ref-Ara2010)). The suite of functions within `qalyr` wrangle the
data into the correct format and then calculate the health state utility
values, for which we use the `eq5d` R package ([Morton and Nijjar
2020](#ref-eq5dpackage)).

`qalyr` was created as part of a programme of work on the health
economics of tobacco and alcohol at the School of Health and Related
Research (ScHARR), The University of Sheffield. This programme is based
around the construction of the Sheffield Tobacco and Alcohol Policy
Model (STAPM), which aims to use comparable methodologies to evaluate
the impacts of tobacco and alcohol policies, and investigate the
consequences of clustering and interactions between tobacco and alcohol
consumption behaviours.

## HODaR data

The following is a summary from Currie et al.
([2005](#ref-currie2005routine)).

“HODaR supplements routine clinically coded data from the Cardiff and
Vale NHS Hospitals Trust, UK, with survey data covering sociodemographic
characteristics, QoL, utility, and resource use information. Data that
constitutes HODaR were collated from a prospective survey of subjects
treated as inpatients or outpatients. Details from the survey then need
to be linked to existing routine hospital health data. All inpatients
aged 18 years or older were surveyed. For inpatients, all subjects were
surveyed 6 weeks postdischarge by postal survey with a ‘freepost’ return
envelope. For outpatients, all patients attending a selected clinic were
handed a survey pack by the clinic receptionist when they attend.”

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
place on a restricted user-access University of Sheffield managed
virtual machine. Data storage and processing follows [SCHARR’s
Information Governance
Policy](https://www.sheffield.ac.uk/scharr/division-population-health-information-governance-policy).

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

`qalyr` is publicly available via Github.

By default the user should install the latest tagged version of the
package. Otherwise, if you want to reproduce project work and know the
version of the package used, install that version.

If on a University of Sheffield managed computer, install the R, RStudio
and Rtools bundle from the Software Centre. Install Rtools - using the
[installr](https://cran.r-project.org/web/packages/installr/index.html)
package can make this easier. Then install the latest or a specified
version of `qalyr` from Github with:

``` r
#install.packages("devtools")

devtools::install_git(
  "https://github.com/stapm/qalyr.git", 
  ref = "x.x.x",
  build_vignettes = FALSE)

# ref = "x.x.x" is the version to install - change to the version you want e.g. "1.2.3"
```

Or clone the package repo locally and use the ‘install and restart’
button in the Build tab of RStudio. This option is more convenient when
testing development versions.

Then load the package, and some other packages that are useful. Note
that the code within `qalyr` uses the `data.table::data.table()` syntax.

``` r
# Load the package
library(qalyr)

# Other useful packages
library(dplyr) # for data manipulation and summary
library(magrittr) # for pipes
library(ggplot2) # for plotting
```

## References

<div id="refs" class="references csl-bib-body hanging-indent">

<div id="ref-Ara2010" class="csl-entry">

Ara, Roberta, and John E Brazier. 2010. “Populating an Economic Model
with Health State Utility Values: Moving Toward Better Practice.” *Value
in Health* 13 (5): 509–18.
<https://doi.org/10.1111/j.1524-4733.2010.00700.x>.

</div>

<div id="ref-currie2005routine" class="csl-entry">

Currie, Craig J, Phil McEwan, John R Peters, Tunia C Patel, and Simon
Dixon. 2005. “The Routine Collation of Health Outcomes Data from
Hospital Treated Subjects in the Health Outcomes Data Repository
(HODaR): Descriptive Analysis from the First 20,000 Subjects.” *Value in
Health* 8 (5): 581–90.
<https://doi.org/10.1111/j.1524-4733.2005.00046.x>.

</div>

<div id="ref-eq5dpackage" class="csl-entry">

Morton, Fraser, and Jagtar Singh Nijjar. 2020. *<span
class="nocase">eq5d: Methods for Calculating ’EQ-5D’ Utility Index
Scores</span>*. <https://CRAN.R-project.org/package=eq5d>.

</div>

</div>
