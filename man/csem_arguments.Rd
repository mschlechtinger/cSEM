% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zz_arguments.R
\name{csem_arguments}
\alias{csem_arguments}
\alias{cSEMArguments}
\title{cSEMArguments}
\arguments{
\item{.data}{A \code{data.frame} or a \code{matrix} containing the raw data.}

\item{.model}{A model in \code{\link[lavaan:model.syntax]{lavaan model syntax}}
or a \link{cSEMModel}-list.}

\item{.alpha}{An integer or a numeric vector of significance levels.
Defaults to \code{0.05}.}

\item{.approach}{Character string. The Kettenring approach to use. One of
"\emph{SUMCORR}", "\emph{MAXVAR}", "\emph{SSQCORR}", "\emph{MINVAR}" or "\emph{GENVAR}". Defaults to
"\emph{SUMCORR}".}

\item{.approach_nl}{Character string. Approach used to estimate nonlinear
structural relationships. One of: "\emph{sequential}" or "\emph{replace}".
Defaults to "\emph{sequential}".}

\item{.approach_paths}{Character string. Approach used to estimate the
structural coefficients. One of: "\emph{OLS}" or "\emph{2SLS}".
Defaults to "\emph{OLS}".}

\item{.approach_weights}{Character string. Approach used to
obtain composite weights. One of: "\emph{PLS}", "\emph{SUMCORR}", "\emph{MAXVAR}",
"\emph{SSQCORR}", "\emph{MINVAR}", "\emph{GENVAR}", "\emph{GSCA}", "\emph{fixed}", or "\emph{unit}".
Defaults to "\emph{PLS}".}

\item{.args_used}{A list of function argument names to \code{fun()} whose value
was modified by the user.}

\item{.C}{A (J x J) composite variance-covariance matrix.}

\item{.choices}{Logical. Should candidate values for the arguments be returned?
Defaults to \code{FALSE}.}

\item{.conv_criterion}{Character string. The criterion to use for the convergence check.
One of: "\emph{diff_absolute}", "\emph{diff_squared}", or "\emph{diff_relative}". Defaults
to "\emph{diff_absolute}".}

\item{.csem_model}{A (possibly incomplete) \link{cSEMModel}-list.}

\item{.disattenuate}{Logical. If possible, should composite correlations be disattenuated
if the construct is modeled as a common factor? Defaults to \code{TRUE}.}

\item{.distance}{Character string. A distance measure. One of: "\emph{geodesic}"
or "\emph{squared_euclidian}". Defaults to "\emph{geodesic}".}

\item{.dominant_indicators}{A character vector of \code{"name" = "value"} pairs,
where \code{"value"} is a character string giving the name of the dominant indicator
and \code{"name"} a character string of the corresponding construct name.
Dominant indicators may be specified for a subset of the constructs.}

\item{.drop_inadmissibles}{Logical. Should inadmissible solutions be dropped?
Defaults to \code{TRUE}.}

\item{.E}{A (J x J) matrix of inner weights.}

\item{.estimate_structural}{Logical. Should the structural coefficients
be estimated? Defaults to \code{TRUE}.}

\item{.H}{The (N x J) matrix of construct scores.}

\item{.id}{Character string. The name of the column of \code{.data} used to split
the data into groups. Defaults to \code{NULL}.}

\item{.iter_max}{Integer. The maximum number of iterations allowed.
If \code{iter_max = 1} and \code{.approach_weights = "PLS"} one-step weights are returned.
If the algorithm exceeds the specified number, weights of iteration step
\code{.iter_max - 1}  will be returned with a warning. Defaults to \code{100}.}

\item{.matrix1}{A \code{matrix} to compare.}

\item{.matrix2}{A \code{matrix} to compare.}

\item{.matrices}{A list of at least two matrices.}

\item{.modes}{A vector specifying the mode that should be used for
each construct in the form \code{"name" = "mode"}, where \code{"name"} refers to the
construct name and `"mode"`` is one of \emph{"ModeA"} or \emph{"ModeB"}.}

\item{.normality}{Logical. Should joint normality be assumed in the nonlinear model?
For details see: \insertCite{Dijkstra2014;textual}{cSEM}.
Defaults to \code{TRUE}. Ignored if the model is linear.}

\item{.object}{An R object of class \code{cSEM<class>} with corresponding method.}

\item{.only_dots}{Logical. Should only arguments to be passed to lower level
functions via the  \code{...} argument of the \code{fun} function be returned.
Defaults to \code{FALSE}.}

\item{.P}{A (J x J) construct variance-covariance matrix (possibly disattenuated).}

\item{.parallel}{Logical. Use parallel computing. Defaults to \code{FALSE}. Note:
requires the \code{doSNOW} and the \code{parallel} package to be installed.}

\item{.PLS_approach_cf}{Character string. Approach used to obtain the correction
factors for PLSc. One of: "\emph{dist_euclid}", "\emph{dist_euclid_weighted}",
"\emph{fisher_transformed}", "\emph{mean_arithmetic}", "\emph{mean_geometric}", "\emph{mean_harmonic}",
"\emph{geo_of_harmonic}". Defaults to "\emph{dist_euclid}".
Ignored if \code{.disattenuate = FALSE} or if \code{.approach_weights} is not PLS.}

\item{.PLS_ignore_structural_model}{Logical. Should the structural model be ignored
when calculating the inner weights of the PLS algorithm? Defaults to \code{FALSE}.
Ignored if \code{.approach_weights} is not PLS.}

\item{.PLS_modes}{Either a named vector specifying the mode that should be used for
each construct in the form \code{"name" = "mode"}, a single character
string giving the mode that should be used for all constructs, or \code{NULL}.
Possible choices are: "\emph{ModeA}" or "\emph{ModeB}". Defaults to \code{NULL}.
If \code{NULL}, \code{csem()} will choose the appropriate mode according to the type
of construct used. Ignored if \code{.approach_weight} is not PLS.}

\item{.PLS_weight_scheme_inner}{Character string. The inner weighting scheme
used in PLS. One of: "\emph{centroid}", "\emph{factorial}", or "\emph{path}".
Defaults to "\emph{centroid}". Ignored if \code{.approach_weight} is not PLS.}

\item{.Q}{A vector of composite-construct correlations with element names equal to
the names of the J construct names used in the measurement model. Note
Q^2 is also called the reliability coefficient.}

\item{.reliabilities}{A character vector of \code{"name" = value} pairs,
where \code{value} is a number between 0 and 1 and \code{"name"} a character string
of the corresponding construct name, or \code{NULL}. Reliabilities
may be given for a subset of the constructs. Defaults to \code{NULL} in which case
reliabilities are estimated by \code{csem()}.}

\item{.runs}{Integer. How many runs should be performed? Defaults to \code{499}.}

\item{.S}{The (K x K) empirical indicator correlation matrix.}

\item{.saturated}{Logical. Should a saturated structural model be used? Defaults to \code{FALSE}.}

\item{.show_progress}{Logical. Show progress bar. Defaults to \code{TRUE}.}

\item{.terms}{A vector of construct names to be classified.}

\item{.tolerance}{Double. The tolerance criterion for convergence.
Defaults to \code{1e-05}.}

\item{.verbose}{Logical. Should information be printed to the console? Defaults
to \code{TRUE}.}

\item{.W}{A (J x K) matrix of weights.}

\item{.W_new}{A (J x K) matrix of weights.}

\item{.W_old}{A (J x K) matrix of weights.}

\item{.which_fun}{Character string. The \code{...} argument names and values of which
function should be returned? One of: \code{"csem"} or \code{"cca"}. Defaults to \code{"csem"}.
Currently ignored if \code{.only_dots = FALSE}.}

\item{.X}{A matrix of processed data (scaled, cleaned and ordered).}
}
\description{
An alphabetical list of all arguments used by functions of the \code{cSEM} package,
including their description and defaults.
Mainly used for internal purposes (parameter inheritance). To list all arguments
and their defaults, use \code{\link[=args_default]{args_default()}}. To list only those arguments to be
passed down to lower level functions via the \code{...} argument of any
function having \code{...} as a formal argument, set the \code{.only_dots} argument
of the \code{\link[=args_default]{args_default()}} function to \code{TRUE}.
}
