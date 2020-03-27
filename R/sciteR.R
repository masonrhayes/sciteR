#' Get the scite journal-level tallies for a character vector of ISSNs
#'
#' @param issn A vector of ISSNs
#' @return A data frame of scite tallies of scite journal index (sji), total citations, total supporting citations, total contradicting citations, total mentioning citations
#' @description Each issn should be of the format "xxxx-xxxx". A vector of issns should be of the format c("xxxx-xxxx", "xxxx-xxxx", ...), respectively. If scite does not have data for a given ISSN, the function will not return any information.
#' If the function returns an error, try passing the list of ISSNs in smaller batches.
#' SJI is only calculated for journals where supporting citations + contradicting citations > 500.
#' @export
scite <- function (issn) {
  issn_string <- paste(issn, collapse = ",")
  api_response <- httr::VERB(verb = "GET", url = "https://api.scite.ai/issn-tallies",
             query = list(issn = issn_string))
  tallies <- api_response %>%
    content(type = "application/json") %>%
    as_tibble() %>%
    t() %>%
    as.data.frame() %>%
    setNames(., c("issn", "sji_all_years", "sji_five_years", "sji_two_years",
                  "total_cites", "total_contradicting_cites",
                  "total_mentioning_cites", "total_supporting_cites",
                  "total_unclassified"))
  return(tallies)
}
