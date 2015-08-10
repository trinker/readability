
flesch_kincaid_ <- function(n.words, n.sents, n.sylls, ...){
    (.39*(n.words/n.sents)) + (11.8*(n.sylls/n.words)) - 15.9
}

gunning_fog_ <- function(n.words, n.sents, n.complexes, ...){
    .4*((n.words/n.sents) + (100*(n.complexes/n.words)))
}

coleman_liau_ <- function(n.words, n.sents, n.chars, ...) {
    (0.0588 * ((100 * n.chars)/n.words)) - (0.296 * ((100 * n.sents)/n.words)) - 15.8
}

smog_ <- function(n.sents, n.polys) {
    (1.043 * sqrt(n.polys * (30/n.sents))) + 3.1291
}


automated_readability_index_  <- function(n.words, n.sents, n.chars){
    4.71 * (n.chars/n.words) + 0.5 * (n.words/n.sents) - 21.43
}

SE <- function(x) sqrt(stats::var(x)/length(x))

digit_format <- function (x, digits = 1) {
    if (is.null(digits))
        digits <- 3
    if (length(digits) > 1) {
        digits <- digits[1]
        warning("Using only digits[1]")
    }
    x <- round(as.numeric(x), digits)
    if (digits > 0)
        x <- sprintf(paste0("%.", digits, "f"), x)
    out <- gsub("^0(?=\\.)|(?<=-)0", "", x, perl = TRUE)
    out[out == "NA"] <- NA
    out
}

