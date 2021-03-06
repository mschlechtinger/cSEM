#' Internal: Calculate PLSc correction factors
#'
#' Calculates the correction factor used by PLSc.
#'
#' Currently, seven approaches are available:
#'
#' \itemize{
#' \item "dist_euclid" (default)
#' \item "dist_euclid_weighted"
#' \item "fisher_transformed"
#' \item "mean_geometric"
#' \item "mean_harmonic"
#' \item "mean_arithmetic"
#' \item "geo_of_harmonic" (not yet implemented)
#' }
#'
#' See \insertCite{Dijkstra2013}{cSEM} for details.
#' @usage calculateCorrectionFactors(
#'  .S               = args_default()$.S,
#'  .W               = args_default()$.W,
#'  .modes           = args_default()$.modes,
#'  .csem_model      = args_default()$.csem_model,
#'  .PLS_approach_cf = args_default()$.PLS_approach_cf
#'  )
#' @inheritParams csem_arguments
#'
#' @return A numeric vector of correction factors with element names equal
#'   to the names of the J constructs used in the measurement model
#' @references
#'   \insertAllCited{}
#' @keywords internal

calculateCorrectionFactors <- function(
  .S               = args_default()$.S,
  .W               = args_default()$.W,
  .modes           = args_default()$.modes,
  .csem_model      = args_default()$.csem_model,
  .PLS_approach_cf = args_default()$.PLS_approach_cf
) {
  
  ### Compute correction factors  ----------------------------------------------
  correction_factors <- vector(mode = "double", length = nrow(.W))
  names(correction_factors) <- rownames(.W)
  
  L <- .W %*% .S * .csem_model$measurement
  
  for(j in rownames(.W)) {
    
    ## Depending on the mode: extract vector of weights or indicator-proxy
    # correlations (composite loadings) of block j 
    if(.modes[j] == "ModeA") {
      w_j <- .W[j, ] %>%
        .[. != 0] %>%
        as.matrix(.)
    } else {
      w_j <- L[j, ] %>%
        .[. != 0] %>%
        as.matrix(.)
    }
    
    ## Check if single indicator block or composite; If yes, set cf to 1
    if(nrow(w_j) == 1 | .csem_model$construct_type[j] == "Composite") {
      correction_factors[j] <- 1
      
    } else {
      ## Extract relevant objects
      E_jj <- .csem_model$error_cor[rownames(w_j), rownames(w_j)]
      S_jj <- .S[rownames(w_j), rownames(w_j)]
      W_jj <- w_j %*% t(w_j)
      
      ## Set indicator pairs whose measurement errors are correlated to zero and
      ## extract non-zero off-diagonal elements of S_jj (result is vectorized)
      S_vect <- replace(S_jj, which(E_jj == 1), 0) %>%
        .[lower.tri(.) | upper.tri(.)] %>%
        .[. != 0]
      
      ## Set indicator pairs whose measurement errors are correlated to zero and
      ## extract non-zero off-diagonal elements of W_jj (vectorized)
      W_vect <- replace(W_jj, which(E_jj == 1), 0)  %>%
        .[lower.tri(.) | upper.tri(.)] %>%
        .[. != 0]
      
      if(length(S_vect) == 0) {
        stop("At least one pair of indicators with uncorrelated measurement
             errors required.\n Please revise your model.",
             call. = FALSE)
      }
      
      ## Do the actual computation ---------------------------------------------
      switch (.PLS_approach_cf,
              "dist_euclid"          = {
                cf <- sum(W_vect * S_vect) / sum(W_vect^2)
              },
              "dist_euclid_weighted" = {
                weights <- 1 / (1 - S_vect^2)
                cf      <- sum(W_vect * S_vect * weights) / sum(W_vect^2 * weights)
              },
              "fisher_transformed"   = {
                # Function to be minimized
                temp_fun <- function(.c, .W_vect, .S_vect){
                  sum((0.5*log((1 + .S_vect) / (1 - .S_vect)) -
                         0.5*log((1 + .c*.W_vect) / (1 - .c*W_vect)))^2)
                }
                
                # Optimaziation
                temp_optim <- optim(fn = temp_fun, par = 0.5, method = "BFGS",
                                    .W_vect = W_vect, .S_vect = S_vect)
                cf <- temp_optim$par
              },
              "mean_geometric"       = {
                cf <- prod(S_vect/W_vect)^(1/length(S_vect))
              },
              "mean_arithmetic"      = {
                cf <- mean(S_vect/W_vect)
              },
              "mean_harmonic"        = {
                cf <- 1/mean(1/(S_vect/W_vect))
              },
              "geo_of_harmonic"      = {stop("not implemented yet")}
      )
      
      ## Compute absolute value and take the sqrt since cf = c^2
      correction_factors[j] <- sqrt(abs(cf))
    }
    }
  return(correction_factors)
  ### For maintenance: ### -------------------------------------------------------------------------
  # w_j (K_j x 1)      := Column vector of indicator weights of block j
  # W_vect (1 x 2*K_j) := Vector of off-diagonal elements of w_jw'_j
  # S_vect (1 x 2*K_j) := Vector of off-diagonal elements of S_jj
}


#' Internal: Calculate factor, composite, and cross-loadings
#'
#' Calculates factor loadings (for constructs modeled as common factors),
#' composite loadings (for constructs modeled as composites), and cross-loadings.
#'
#' @usage calculateLoadings(
#'  .S              = args_default()$.S,
#'  .W              = args_default()$.W,
#'  .Q              = args_default()$.Q,
#'  .csem_model     = args_default()$.csem_model,
#'  .disattenuate   = args_default()$.disattenuate,
#'  .modes          = args_default()$.modes
#'  )
#' @inheritParams 
#' csem_arguments
#'
#' @return The (J x K) matrix of loadings and cross-loadings (attenuated if required).
#' @keywords internal

calculateLoadings <- function(
  .S              = args_default()$.S,
  .W              = args_default()$.W,
  .Q              = args_default()$.Q,
  .csem_model     = args_default()$.csem_model,
  .disattenuate   = args_default()$.disattenuate,
  .modes          = args_default()$.modes
) {
  
  ## Matrix of (composite) loadings and cross-loadings
  Lambda <- .W %*% .S
  
  if(.disattenuate) {
    
    ## Get names of constructs modeled as composites
    names_c  <- names(.csem_model$construct_type[.csem_model$construct_type == "Composite"])
    ## Get names of constructs modeled as common factors
    names_cf <- setdiff(rownames(.csem_model$structural), names_c)
    ## Get names of the common factors whose weights were estimated with "ModeA"
    names_modeA <- intersect(names(.modes[.modes == "ModeA"]), names_cf)
    ## Get names of the common factors whose weights were estimated with "ModeB"
    names_modeB <- intersect(names(.modes[.modes == "ModeB"]), names_cf)
    
    if(length(names_cf) > 0) {
      if(length(names_modeA) > 0) {
        ## Disattenuate loadings and cross-loadings ------------------------------
        for(i in names_modeA) {
          temp  <- .W[i, ] # becomes a vector!
          temp1 <- temp[which(temp != 0)]
          temp2 <- temp[which(temp == 0)]
          
          Lambda[i, names(temp1)] <- .Q[i] * temp1 / c(t(temp1) %*% temp1)
          Lambda[i, names(temp2)] <- Lambda[i, names(temp2)] / .Q[i]
          
        }
      }
      if(length(names_modeB) > 0) {
        # Composite loading estimates 
        L <- Lambda*(.W != 0)
        
        for(i in names_modeB){
          temp  <- L[i, ] # becomes a vector!
          temp1 <- temp[which(temp != 0)]
          temp2 <- temp[which(temp == 0)]
          
          Lambda[i, names(temp1)] <- temp1*.Q[i] #* temp1 / c(t(temp1) %*% temp1)
          Lambda[i, names(temp2)] <- Lambda[i, names(temp2)] / .Q[i]
        }
      }
    } else {# all constructs are modeled as composites
      return(Lambda)
    }
  } # END .disattentuate == TRUE
  return(Lambda)
}

#' Internal: Calculate composites
#'
#' Calculates composite values for the J constructs of the structural model.
#'
#' @usage calculateComposites(
#'  .X  = args_default()$.X,
#'  .W  = args_default()$.W
#'  )
#'  
#' @inheritParams csem_arguments
#'
#' @return The (N x J) matrix of proxy values with column names equal to
#'   the names of the J constructs.
#' @keywords internal

calculateComposites <- function(
  .X = args_default()$.X, 
  .W = args_default()$.W
  ){

  ## Proxies for the linear terms/latent variables
  H <- .X %*% t(.W)
  
  ## Alternative 
  # Note: functions like var, sd, scale, and cov use n-1. 
  # H <- apply(.X, 2, function(x) {(x - mean(x)) / (sd(x) * sqrt((length(x) - 1) / length(x)))}) %*% t(.W)
  return(H)
}

#' Internal: Calculate composite variance-covariance matrix
#'
#' Calculate the variance-covariance (VCV) matrix of the composites.
#'
#' @usage calculateCompositeVCV(
#'  .S  = args_default()$.S,
#'  .W  = args_default()$.W
#'  )
#'  
#' @inheritParams csem_arguments
#'
#' @return A (J x J) composite VCV matrix.
#' @keywords internal

calculateCompositeVCV <- function(
  .S = args_default()$.S, 
  .W = args_default()$.W
  ){

  x <- .W %*% .S %*% t(.W)

  # Due to floting point errors may not be symmetric anymore. In order
  # prevent that replace the lower triangular elements by the upper
  # triangular elements

  x[lower.tri(x)] <- t(x)[lower.tri(x)]

  ## Return
  x
}

#' Internal: Calculate composite-construct correlation
#'
#' Calculate the correlation between composite and construct (usually called Q).
#' Note: Q_i^2 := R^2(eta_i; eta_bar_i) is also called the reliability coefficient
#' rho_A \insertCite{Dijkstra2015a}{cSEM}.
#'
#' @usage calculateCompositeConstructCV(
#'  .W                  = args_default()$.W,
#'  .csem_model         = args_default()$.csem_model,
#'  .disattenuate       = args_default()$.disattenuate,
#'  .modes              = args_default()$.modes,
#'  .correction_factors = args_default()$.correction_factors,
#'  .reliabilities      = args_default()$.reliabilities
#'  )
#'  
#' @inheritParams csem_arguments
#'
#' @return A vector of composite-construct correlations.
#' @references
#'   \insertAllCited{}
#' @keywords internal

calculateCompositeConstructCV <- function(
  .W                  = args_default()$.W,
  .csem_model         = args_default()$.csem_model,
  .disattenuate       = args_default()$.disattenuate,
  .modes              = args_default()$.modes,
  .correction_factors = args_default()$.correction_factors,
  .reliabilities      = args_default()$.reliabilities
  ) {

  x <- rep(1, times = nrow(.W))
  names(x) <- rownames(.W)

  if(is.null(.reliabilities) & .disattenuate == TRUE) {
    ## Get names of constructs modeled as composites
    names_c  <- names(.csem_model$construct_type[.csem_model$construct_type == "Composite"])
    ## Get names of constructs modeled as common factors
    names_cf <- setdiff(rownames(.csem_model$structural), names_c)
    ## Get names of the common factors whose weights where estimated with "ModeA"
    names_modeA <- intersect(names(.modes[.modes == "ModeA"]), names_cf)
    ## Get names of the common factors whose weights where estimated with "ModeB"
    names_modeB <- intersect(names(.modes[.modes == "ModeB"]), names_cf)

    if(length(names_modeA) > 0) {
      
      x_modeA <- c(diag(.W[names_modeA, , drop = FALSE] %*% t(.W[names_modeA, ,drop = FALSE])) %*%
                     diag(.correction_factors[names_modeA], nrow = length(names_modeA)))
      x[names_modeA] <- x_modeA
    }
    
    if(length(names_modeB) > 0) {
      x_modeB <- .correction_factors[names_modeB]
      x[names_modeB] <- x_modeB
    }
  
  } else if(is.null(.reliabilities) & .disattenuate == FALSE) {
    
    return (x)
    
  } else if(!is.null(.reliabilities)) {
    
    ## Check construct names:
    # Do all construct names in .reliabilities match the construct
    # names used in the model?
    tmp <- setdiff(names(.reliabilities), rownames(.W))
    
    if(length(tmp) != 0) {
      stop("Construct name(s): ", paste0("`", tmp, "`", collapse = ", "), 
           " provided to `.reliabilities`", 
           ifelse(length(tmp) == 1, " is", " are"), " unknown.", call. = FALSE)
    }
    
    # Check whether defined external reliabilities are correctly defined
    if(any(.reliabilities > 1 | .reliabilities < 0)) {
      stop('Reliabilities must be between 0 and 1.', call. = FALSE)
    }
    
    x[names(.reliabilities)] <- sqrt(.reliabilities)
  } # END if
  
  return(x)
}

#' Internal: Calculate construct VCV matrix
#'
#' Calculate the covariance matrix of the constructs.
#'
#' @usage calculateConstructVCV(
#'  .C          = args_default()$.C, 
#'  .Q          = args_default()$.Q, 
#'  .csem_model = args_default()$.csem_model
#'  )
#' @inheritParams csem_arguments
#'
#' @return The (J x J) construct VCV matrix. Disattenuated if requested.
#' @keywords internal

calculateConstructVCV <- function(
  .C          = args_default()$.C, 
  .Q          = args_default()$.Q, 
  .csem_model = args_default()$.csem_model
  ) {

  f <- function(.i, .j) { .C[.i, .j] / (.Q[.i] * .Q[.j]) }
  m <- rownames(.csem_model$measurement)

  x <- outer(m, m, FUN = Vectorize(f))
  diag(x) <- 1
  rownames(x) <- colnames(x) <- m

  ## Return
  return(x)
}




