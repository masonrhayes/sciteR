# sciteR
`sciteR` is an R package to access the [scite](https://scite.ai) API . It contains only one function, `scite()`, which takes a list of [ISSNs](http://www.issn.org/understanding-the-issn/what-is-an-issn/) as input and returns scite's journal-level data for each ISSN: total citations, supporting citations, contradicting citations. 

**Update, May 2020:** the scite API no longer returns any scite journal index data, but this can be manually calculated if you wish with the simple formula (# of supporting citations)/(# of supporting + contradicting citations).

scite only calculates the sji for journals where the combined number of supporting citations and contradicting citations is greater than 500. If less than 500, scite's api returns `NULL`. To avoid this issue, the `scite()` function also takes the argument `keep_null`, which can be either `TRUE` or `FALSE` and defaults to `FALSE`. 

To install `sciteR`, first install the devtools package using the command `install.packages("devtools")`, then initialize the library with `library(devtools)`.

Secondly, use the command `install_github("https://github.com/masonrhayes/sciteR")` and load the library with `library(sciteR)`.

The `sciteR` package requires the packages `tidyverse`, `httr`, `data.table`, and `curl`. 


# Example  #

`library(sciteR)`

`my_issns <- c("1029-8479", "0092-8674", "0028-0836", "0036-8075")`

`scite_df <- scite(my_issns)`
