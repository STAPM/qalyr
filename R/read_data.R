

#' Reads in inpatient data
#'
#' Reads in the inpatient data, retaining required columns: patient number, admission date, discharge date, episode number, diagnoses codes 1-13.
#'
#'
#' @return Returns a table of the inpatient data.
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' read_data()
#'
#' }
#'

read_data <- function(
  file = "D:/QALYs/Raw/inpatient_data.csv"
) {

  inpatient_data <- fread(file)

  inpatient_data <- inpatient_data[,.(Patient_Number, PS_Admit, PS_Disch, EP, Diagno1, Diagno2, Diagno3, Diagno4, Diagno5,
                                      Diagno6, Diagno7, Diagno8, Diagno9, Diagno10, Diagno11, Diagno12, Diagno13)]


  return(inpatient_data)

}
