# Like a geom_pointrange but with sensible defaults for displaying multiple intervals
#
# Author: mjskay
###############################################################################


# Names that should be suppressed from global variable check by codetools
# Names used broadly should be put in _global_variables.R
globalVariables(c(".lower", ".upper", ".width"))


#' Point + multiple uncertainty interval plots (ggplot geom)
#'
#' Combined point + multiple interval geoms with default aesthetics
#' designed for use with output from [point_interval()].
#' Wrapper around [geom_slabinterval()].
#'
#' These geoms are wrappers around [geom_slabinterval()] with defaults designed to produce
#' points+interval plots. These geoms set some default aesthetics equal
#' to the `.lower`, `.upper`, and `.width` columns generated by the `point_interval` family
#' of functions, making them often more convenient than vanilla [geom_pointrange()] when used with
#' functions like [median_qi()], [mean_qi()], [mode_hdi()], etc.
#'
#' Specifically, `geom_pointinterval` acts as if its default aesthetics are
#' `aes(size = -.width)`.
#'
#' @eval rd_slabinterval_aesthetics(geom = GeomPointinterval, geom_name = "geom_pointinterval")
#' @inheritParams geom_slabinterval
#' @inheritDotParams geom_slabinterval
#' @param position The position adjustment to use for overlapping points on this layer. Setting this equal to
#' `"dodge"` can be useful if you have overlapping intervals.
#' @param show.legend Should this layer be included in the legends? Default is `c(size = FALSE)`, unlike most geoms,
#' to match its common use cases. `FALSE` hides all legends, `TRUE` shows all legends, and `NA` shows only
#' those that are mapped (the default for most geoms).
#' @return A [ggplot2::Geom] representing a point+multiple uncertainty interval geometry which can
#' be added to a [ggplot()] object.
#' @author Matthew Kay
#' @seealso See [geom_slabinterval()] for the geom that these geoms wrap. All parameters of that geom are
#' available to these geoms.
#' @seealso See [stat_pointinterval()] for the stat version, intended
#' for use on samples from a distribution.
#' See [geom_interval()] for a similar stat intended for intervals without
#' point summaries.
#' See [stat_sample_slabinterval()] for a variety of other
#' stats that combine intervals with densities and CDFs.
#' See [geom_slabinterval()] for the geom that these geoms wrap. All parameters of that geom are
#' available to these geoms.
#' @examples
#'
#' library(dplyr)
#' library(ggplot2)
#'
#' data(RankCorr_u_tau, package = "ggdist")
#'
#' # orientation is detected automatically based on
#' # use of xmin/xmax or ymin/ymax
#'
#' RankCorr_u_tau %>%
#'   group_by(i) %>%
#'   median_qi(.width = c(.8, .95)) %>%
#'   ggplot(aes(y = i, x = u_tau, xmin = .lower, xmax = .upper)) +
#'   geom_pointinterval()
#'
#' RankCorr_u_tau %>%
#'   group_by(i) %>%
#'   median_qi(.width = c(.8, .95)) %>%
#'   ggplot(aes(x = i, y = u_tau, ymin = .lower, ymax = .upper)) +
#'   geom_pointinterval()
#'
#' @import ggplot2
#' @export
geom_pointinterval = function(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,

  side = "both",
  orientation = NA,
  show_slab = FALSE,

  show.legend = c(size = FALSE)
) {

  layer_geom_slabinterval(
    data = data,
    mapping = mapping,
    default_mapping = aes(size = -.width),
    stat = stat,
    geom = GeomPointinterval,
    position = position,
    ...,

    side = side,
    orientation = orientation,
    show_slab = show_slab,

    datatype = "interval",

    show.legend = show.legend
  )
}

#' @rdname ggdist-ggproto
#' @format NULL
#' @usage NULL
#' @import ggplot2
#' @export
GeomPointinterval = ggproto("GeomPointinterval", GeomSlabinterval,
  default_aes = defaults(aes(
    datatype = "interval"
  ), GeomSlabinterval$default_aes),

  default_key_aes = defaults(aes(
    fill = NA
  ), GeomSlabinterval$default_key_aes),

  default_params = defaults(list(
    side = "both",
    orientation = NA,
    show_slab = FALSE
  ), GeomSlabinterval$default_params),

  default_datatype = "interval"
)
