#' Grade Level Readability by Grouping Variables
#'
#' Calculate the Flesch Kincaid, Gunning Fog Index, Coleman Liau, SMOG,
#' Automated Readability Index and an average of the 5 readability scores.
#'
#' @param x A character vector.
#' @param grouping.var The grouping variable(s).  Takes a single grouping
#' variable or a list of 1 or more grouping variables.
#' @param order.by.readability logical.  If \code{TRUE} orders the results
#' descending by readability score.
#' @param group.names A vector of names that corresponds to group.  Generally
#' for internal use.
#' @param \ldots ignored
#' @return Returns a \code{\link[base]{data.frame}}
#' (\code{\link[data.table]{data.table}}) readability scores.
#' @export
#' @references Coleman, M., & Liau, T. L. (1975). A computer readability formula
#' designed for machine scoring. Journal of Applied Psychology, Vol. 60,
#' pp. 283-284.
#'
#' Flesch R. (1948). A new readability yardstick. Journal of Applied Psychology.
#' Vol. 32(3), pp. 221-233. doi: 10.1037/h0057532.
#'
#' Gunning, Robert (1952). The Technique of Clear Writing. McGraw-Hill. pp. 36-37.
#'
#' McLaughlin, G. H. (1969). SMOG Grading: A New Readability Formula.
#' Journal of Reading, Vol. 12(8), pp. 639-646.
#'
#' Smith, E. A. & Senter, R. J. (1967) Automated readability index.
#' Technical Report AMRLTR-66-220, University of Cincinnati, Cincinnati, Ohio.
#' @keywords readability, Automated Readability Index, Coleman Liau, SMOG,
#' Flesch-Kincaid, Fry, Linsear Write
#' @export
#' @importFrom data.table :=
#' @examples
#' \dontrun{
#' library(syllable)
#'
#' (x1 <- with(presidential_debates_2012, readability(dialogue, NULL)))
#'
#' (x2 <- with(presidential_debates_2012, readability(dialogue, list(person, time))))
#' plot(x2)
#'
#' (x2b <- with(presidential_debates_2012, readability(dialogue, list(person, time),
#'     order.by.readability = FALSE)))
#'
#' (x3 <- with(presidential_debates_2012, readability(dialogue, TRUE)))
#' }
readability <- function(x, grouping.var, order.by.readability = TRUE, group.names, ...){

    n.sents <- n.words <- n.complexes <- n.polys <- n.chars <- Flesch_Kincaid <-
        Gunning_Fog_Index <- Coleman_Liau <- SMOG <- Automated_Readability_Index <-
        Average_Grade_Level <- n.sylls <- NULL

    if(is.null(grouping.var)) {
        G <- "all"
        grouping <- rep("all", length(x))
    } else {

         if (isTRUE(grouping.var)) {
                G <- "id"
                grouping <- seq_along(x)
        } else {

            if (is.list(grouping.var) & length(grouping.var) > 1) {
                m <- unlist(as.character(substitute(grouping.var))[-1])
                G <- sapply(strsplit(m, "$", fixed=TRUE), function(x) {
                        x[length(x)]
                    }
                )
                grouping <- grouping.var
            } else {
                G <- as.character(substitute(grouping.var))
                G <- G[length(G)]
                grouping <- unlist(grouping.var)
            }
        }

    }

    if(!missing(group.names)) {
        G <- group.names
    }

    y <- syllable::readability_word_stats_by(x, grouping, group.names = G)

    grouping <- attributes(y)[["groups"]]

    out <- y[, list(
        Flesch_Kincaid = flesch_kincaid_(n.words, n.sents, n.sylls),
        Gunning_Fog_Index = gunning_fog_(n.words, n.sents, n.complexes),
        Coleman_Liau  =  coleman_liau_(n.words, n.sents, n.chars),
        SMOG  =  smog_(n.sents, n.polys),
        Automated_Readability_Index = automated_readability_index_(n.words, n.sents, n.chars)
    ), by = grouping][, list(
        Average_Grade_Level = mean(c(Flesch_Kincaid, Gunning_Fog_Index, Coleman_Liau, SMOG, Automated_Readability_Index), na.rm=TRUE)
    ), by = c(
        grouping, "Flesch_Kincaid", "Gunning_Fog_Index", "Coleman_Liau", "SMOG", "Automated_Readability_Index"
    )]

    if (isTRUE(order.by.readability)){
        data.table::setorder(out, -Average_Grade_Level)
    }

    class(out) <- unique(c("readability", class(out)))
    attributes(out)[["groups"]] <- grouping
    out

}

#' Plots a readability Object
#'
#' Plots a readability object
#'
#' @param x A \code{readability} object.
#' @param \ldots ignored.
#' @method plot readability
#' @export
plot.readability <- function(x, ...){

    Value <- NULL

    x[["grouping.var"]] <- apply(x[, attributes(x)[["groups"]], with = FALSE], 1, paste, collapse = ".")
    x[["grouping.var"]] <- factor(x[["grouping.var"]], levels = rev(x[["grouping.var"]]))
    x <- x[, attributes(x)[["groups"]]:=NULL]
    y <- tidyr::gather_(x, "Measure", "Value", c("Flesch_Kincaid", "Gunning_Fog_Index",
        "Coleman_Liau", "SMOG", "Automated_Readability_Index"))

    y[["Measure"]] <- gsub("_", " ", y[["Measure"]])
    data.table::setDT(y)

    center_dat <- y[, list(upper = mean(Value) + SE(Value), lower = mean(Value) - SE(Value),
        means = mean(Value)), keyby = "grouping.var"]

    nms <- gsub("(^|[[:space:]])([[:alpha:]])", "\\1\\U\\2", attributes(x)[["groups"]], perl=TRUE)

    xaxis <- floor(min(y[["Value"]])):ceiling(max(y[["Value"]]))

    ggplot2::ggplot(y, ggplot2::aes_string(y = "grouping.var")) +
        ggplot2::geom_vline(xintercept = mean(center_dat[["means"]]), size=.75, alpha = .25, linetype="dashed") +
       # ggplot2::geom_point(ggplot2::aes_string(color = "Measure", x = "Value"), size=1.4) +
        ggplot2::geom_point(ggplot2::aes_string(color = "Measure", x = "Value"), size=2, shape=1) +
        ggplot2::geom_errorbarh(data = center_dat, size=.75, alpha=.4,
            ggplot2::aes_string(x = "means", xmin="upper", xmax="lower"), height = .3) +
        ggplot2::geom_point(data = center_dat, ggplot2::aes_string(x = "means"), alpha = .5, shape=15, size=3) +
        ggplot2::geom_point(data = center_dat, ggplot2::aes_string(x = "means"), size=1) +
        ggplot2::scale_x_continuous(breaks = xaxis) +
        ggplot2::ylab(paste(nms, collapse = " & ")) +
        ggplot2::xlab("Grade Level") +
        ggplot2::theme_bw() +
        ggplot2::scale_color_discrete(name="Readability\nScore")

}


#' Prints a readability Object
#'
#' Prints a readability object
#'
#' @param x A \code{readability} object.
#' @param digits The number of digits to print.
#' @param \ldots ignored.
#' @method print readability
#' @export
print.readability <- function(x, digits = 1, ...){

    key_id <- NULL

    colord <-colnames(x)
    cols <- c("Flesch_Kincaid", "Gunning_Fog_Index", "Coleman_Liau",
       "SMOG", "Automated_Readability_Index", "Average_Grade_Level")

    x[["key_id"]] <- 1:nrow(x)
    y <- tidyr::gather_(x, "measure", "value", cols)

    y[["value"]] <- digit_format(y[["value"]], digits)
    y <- tidyr::spread_(y, "measure", "value")
    data.table::setDT(y)
    y <- y[order(key_id)]
    y[, "key_id"] <- NULL
    data.table::setcolorder(y, colord)
    print(y)
}
