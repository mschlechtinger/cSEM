#' cSEMModel
#'
#' A standardized list containing model-related information. To convert a
#' a model written in \href{http://lavaan.ugent.be/tutorial/syntax1.html}{lavaan model syntax}
#' to a cSEMModel list use [parseModel].
#'
#' An object of class cSEMModel is a standardized list containing the following
#' components (assume in the following that there are J constructs and K indicators)
#' \describe{
#'   \item{`$structural`}{A matrix mimicking the structural relationship between
#'      constructs. If constructs are only linearly related, `structural` is
#'      of dimension (J x J) with row- and column names equal to the construct
#'      names. If the structural model contains non-linear relationships
#'      `structural` is (J x (J + J\*)) where J\* is the number of
#'      non-linear terms.}
  # \item{`$structural_ordered`}{A matrix of the same dimension as `structural`
  #   with rows rearranged to satisfy the following criteria. 1. the construct
  #   in the first row depends on exogenous constructs only. 2. the constructs
  #   of the following rows depend only on exogenous constructs or those
  #   of previous rows. This is required to estimate non-linear structural equation
  #   model relationships using the replacement approach.
  #   }
#'   \item{`$measurement`}{A (J x K) matrix mimicking the measurement relationship
#'     between constructs and their related indicators with row names equal to
#'     the construct names and column names equal to the indicator names.}
#'   \item{`$error_cor`}{A (K x K) matrix mimicking the measurement error
#'     correlation relationship.}
#'   \item{`$construct_type`}{A named vector containing the names of each construct
#'    and their respective type (**"Common factor"** or **"Composite"**).}
#'   \item{`$model_type`}{The type of model (linear or nonlinear).}
#'   \item{`$vars_endo`}{A vector of names of the endogenous constructs.}
#'   \item{`$vars_exo`}{A vector of names of the exogenous constructs (incudes
#'     possible interaction and exponential terms).}
#'   \item{`$vars_explana`}{ A vector of names of the constructs that appear as
#'     explanatory variables in at least one structural equation (incudes
#'     possible interaction and exponential terms).}
#'   \item{`$explained_by_exo`}{A vector of names of the constructs that are
#'     solely explained by exogenous constructs.}
#' }
#' Note: it is possible to supply an incomplete cSEMModel list
#' to all functions that require `.csem_model` as a mandatory argument. Currently,
#' only the structural and the measurement matrix are required.
#' However, specifying an incomplete cSEMModel list may lead to unexpected behaviour 
#' and errors so do use this technique with caution.
#'
#' @seealso [parseModel]
#' @name csem_model
#' @aliases cSEMModel
NULL

#' cSEMResults
#'
#' @return
#' An object of class `cSEMResults` for which the following methods exist:
#' \describe{
#'   \item{`print.cSEMResults`}{Prints a message to inform the user
#'   whether estimation has been successful and what functions may be used
#'   to examine the object.}
#'   \item{`summary.cSEMResults`}{Print and return a comprehensive summary of the results.}
#' }
#' Technically `cSEMResults` is a named list containing the following list elements:
#' \describe{
#'   \item{`$Estimates`}{A list containing the estimated quantities.}
#'   \item{`$Information`}{A list of additional information. (incomplete)}
#' }
#'
#' @name csem_results
#' @aliases cSEMResults
NULL

#' cSEMResultssummary
#'
#' @return
#' An object of class `cSEMResultssummary` for which the following methods exist:
#' \describe{
#'   \item{`print.cSEMResultssummary`}{Prints a summary.}
#' }
#' Technically `cSEMResultssummary` is a named list containing the following list elements:
#' \describe{
#'   \item{`...}{Not finished yet.}
#' }
#'
#' @name csem_resultssummary
#' @aliases cSEMResultssummary
NULL