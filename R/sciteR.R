#' Get the scite journal-level tallies for a character vector of ISSNs
#'
#' @param issn A vector of ISSNs
#' @param keep_null Either TRUE or FALSE; defaults to FALSE
#' @return A data frame of scite tallies of scite journal index (sji), total citations, total supporting citations, total contradicting citations, total mentioning citations
#' @description Each issn should be of the format "xxxx-xxxx". A vector of issns should be of the format c("xxxx-xxxx", "xxxx-xxxx", ...), respectively. If scite does not have data for a given ISSN, the function will not return any information.
#'
#' If the function returns an error, try passing the list of ISSNs in smaller batches.
#'
#' SJI is only calculated for journals where supporting citations + contradicting citations > 500.
#'
#' Warning: setting keep_null to TRUE will result in cell values that need to be unlisted
#'
#' @export

scite <- function (issn, keep_null) {
  issn_string <- paste(issn, collapse = ",")
  api_response <- httr::VERB(verb = "GET", url = "https://api.scite.ai/issn-tallies", query = list(issn = issn_string))
  tallies <- api_response %>%
    content(type = "application/json") %>%
    as.data.table() %>%
    t() %>%
    as.data.frame() %>%
    setNames(., c("totalCites","totalSupportingCites", "totalMentioningCites", "totalContradictingCites",  "totalUnclassifiedCites", "journal", "issns", "journalSlug")) %>%
    select(-c(journalSlug, totalUnclassifiedCites)) %>%
    select(issns, journal, everything())

  ## Some journals have multiple ISSNs which are return in a list. Unlist all of these and just keep the first one.

  for(i in 1:dim(tallies)[1]){
    tallies$issns[i] = unlist(tallies$issns[i])
    }

  if (missing(keep_null)) {
    keep_null <- FALSE
    for (i in 1:length(tallies)) {
      tallies[,i] <- unlist(tallies[,i])
    }
  }
  if (keep_null == FALSE) {
    for (i in 1:length(tallies)) {
      tallies <- tallies %>%
        filter(tallies[,i] != "NULL")
      tallies[,i] <- unlist(tallies[,i])
    }
  }
  return(tibble(tallies))
}

