
#' @title Fit the MEM Model using MCMC
#'
#' @description Fit the MEM model using Bayesian Metropolis-Hasting MCMC
#' inference.
#' @param responses the number of responses in each basket.
#' @param size the size of each basket.
#' @param name the name of each basket.
#' @param p0 the null response rate for the poster probability calculation
#' (default 0.15).
#' @param shape1 the first shape parameter(s) for the prior of each basket
#' (default 0.5).
#' @param shape2 the second shape parameter(s) for the prior of each basket
#' (default 0.5).
#' @param prior the matrix giving the prior inclusion probability
#' for each pair of baskets. The default is on on the main diagonal and 0.5
#' elsewhere.
#' @param hpd_alpha the highest posterior density trial significance.
#' @param alternative the alternative case definition (default greater)
#' @param mcmc_iter the number of MCMC iterations.
#' @param initial_mem the initial MEM matrix.
#' @param seed the random number seed.
#' @param call the call of the function.
#' @importFrom stats rbinom
#' @examples
#' \donttest{
#' # 3 baskets, each with enrollement size 5
#' trial_sizes <- rep(5, 3)
#'
#' # The response rates for the baskets.
#' resp_rate <- 0.15
#'
#' # The trials: a column of the number of responses and a column of the
#' # the size of each trial.
#' trials <- data.frame(
#'   responses = rbinom(trial_sizes, trial_sizes, resp_rate),
#'   size = trial_sizes,
#'   name = letters[1:3]
#' )
#' res <- mem_mcmc(trials$responses, trials$size)
#' }
#' @importFrom stats median
#' @importFrom igraph graph_from_adjacency_matrix cluster_louvain E
#' @importFrom crayon red
#' @importFrom itertools isplitVector
#' @export
mem_mcmc <- function(responses,
                     size,
                     name,
                     p0 = 0.15,
                     shape1 = 0.5,
                     shape2 = 0.5,
                     prior = diag(length(responses)) / 2 +
                       matrix(0.5,
                              nrow = length(responses),
                              ncol = length(responses)),
                     hpd_alpha = 0.05,
                     alternative = "greater",
                     mcmc_iter = 10000,
                     initial_mem = round(prior - 0.001),
                     seed = 1000,
                     call = NULL) {
  set.seed(seed)
  k <- NULL
  if (is.null(getDoParName())) {
    registerDoSEQ()
  }
  if (length(responses) != length(size)) {
    stop(red(
      "The length of the responses and size parameters",
      "must be equal."
    ))
  }
  
  # If the shape and p0 argument is a single value, make it a vector of
  # appropriate length.
  if (length(shape1) == 1) {
    shape1 <- rep(shape1, length(responses))
  }
  if (length(shape2) == 1) {
    shape2 <- rep(shape2, length(responses))
  }
  
  if (length(p0) == 1) {
    p0 <- rep(p0, length(responses))
  }
 
  if (!isTRUE(all.equal(diag(prior), rep(1, ncol(prior))))) {
    stop(red("Elements on the main diagonal of `prior` must be 1."))
  }
  ### Produce sample space of MEM ###
  mod_mat <- foreach(k = rev(seq_len(length(responses) - 1))) %do% {
    mem_sample_space <- as.matrix(expand.grid(rep(list(c(
      0, 1
    )), k)))
    mem_sample_space[order(rowSums(mem_sample_space)),]
  }

  # Error if the inital_mem isn't symmetric.
  if (!isTRUE(all.equal(initial_mem, t(initial_mem)))) {
    stop(red("The `initial_mem` matrix must be symmetric."))
  }
  if (!isTRUE(all(diag(initial_mem) == 1))) {
    stop(red("The main diagonal of the `initial_mem` matrix must be 1's."))
  }
  
  M.init <- initial_mem
  MOld <- M.init
  
  ### Create Map for Proposal Distribution ###
  M <- diag(NA, nrow(MOld))
  K <- 1
  for (ii in seq_len(nrow(MOld) - 1)) {
    for (jj in (ii + 1):ncol(MOld)) {
      M[ii, jj] <- M[jj, ii] <- K
      K <- K + 1
    }
  }
  ### Implement Metropolis-Hastings Alg ###
  n.chg <- 0
  mod_mat[[1]] <- as.matrix(mod_mat[[1]])
  models <- cbind(rep(1, dim(mod_mat[[1]])[1]), mod_mat[[1]])
  mweights <- matrix(0, nrow(models), length(responses))
  if (missing(name)) {
    name <- paste("basket", seq_along(size))
  }
  if (is.factor(name)) {
    name <- as.character(name)
  }
  colnames(mweights) <- name
  mem.Samp <- list(MOld)
  mweights <- mweights + models.Count(Samp = mem.Samp[[1]], models = models)
  MAP.list <- list(mem.Samp[[1]])
  MAP.count <- c(1)
  
  mapHash <- new.env()
  mapHash[[toString(MOld)]] <- 1
  
  oldDens <- NA
  xvec <- responses
  nvec <- size
  betaV <- beta(shape1, shape2)
  prod.vec <- beta(xvec + shape1, nvec + shape2 - xvec) / beta(shape1, shape2)

  t <- update.MH(MOld, M, responses, size,
                shape1, shape2, mod_mat, prior, betaV, oldDens, prod.vec)
  mem.Samp[[2]] <- t[[1]]
  oldDens <- t[[2]]
  mweights <- mweights + models.Count(Samp = mem.Samp[[2]], models = models)
  Samp.Sum <- mem.Samp[[1]] + mem.Samp[[2]]
  
  if (sum(mem.Samp[[2]] == mem.Samp[[1]]) < length(mem.Samp[[2]])) {
    n.chg <- n.chg + 1
  }
  
  new <- mem.Samp[[2]]
  key <- toString(new)
  if (!is.null(mapHash[[key]])) {
    index <- mapHash[[key]]
    MAP.count[index] <- MAP.count[index] + 1
  } else {
    MAP.list[[length(MAP.list) + 1]] <-
      mem.Samp[[2]]
    MAP.count <- c(MAP.count, 1)
    mapHash[[key]] <- length(MAP.list) 
  }

  
  for (KK in seq_len(mcmc_iter)[-(1:2)]) {
    t <- update.MH(mem.Samp[[KK - 1]], M, responses, size,
                  shape1, shape2, mod_mat, prior, betaV, oldDens, prod.vec)
    mem.Samp[[KK]] <- t[[1]]
    oldDens <- t[[2]]
  }
  
  it <- NULL
  models_count <- foreach(it = isplitVector(seq_len(mcmc_iter)[-(1:2)],
                          chunks = num_workers()),
                          .combine = c) %dopar% {
    foreach(k = it) %do% {
      models.Count(Samp = mem.Samp[[k]], models = models)
    }
  }

  for (KK in seq_len(mcmc_iter)[-(1:2)]) {
    mweights <- mweights + models_count[[KK - 2]]
    Samp.Sum <- Samp.Sum + mem.Samp[[KK]]
    if (sum(mem.Samp[[KK]] == mem.Samp[[KK - 1]]) <
        length(mem.Samp[[KK - 1]])) {
      n.chg <- n.chg + 1
    }
    
    new <- mem.Samp[[KK]]
    key <- toString(new)
    if (!is.null(mapHash[[key]]))
    {
      index <- mapHash[[key]]
      MAP.count[index] <- MAP.count[index] + 1
    } else {
      MAP.list[[length(MAP.list) + 1]] <-
        mem.Samp[[KK]]
      MAP.count <- c(MAP.count, 1)
      mapHash[[key]] <- length(MAP.list) 
    }    
  }

  ### Compute Posterior Model Weights ###
  pweights <- list()
  for (KK in seq_len(ncol(mweights))) {
    pweights[[KK]] <- mweights[, KK] / mcmc_iter
  }
  
  ### List for post-processing ###
  MODEL <-
    list(
      responses = responses,
      size = size,
      name = name,
      shape1 = shape1,
      shape2 = shape2,
      models = models,
      pweights = pweights,
      p0 = p0,
      alpha = hpd_alpha,
      alternative = alternative
    )
  
  ### Compute and output results ###
  PEP <- Samp.Sum / mcmc_iter
  rownames(PEP) <- colnames(PEP) <- MODEL$name
  MAP <- MAP.list[[order(MAP.count, decreasing = TRUE)[1]]]
  rownames(MAP) <- colnames(MAP) <- MODEL$name
  
  if (is.null(call)) {
    call <- match.call()
  }
  
  ret <-
    list(
      responses = responses,
      size = size,
      name = name,
      p0 = p0,
      alpha = hpd_alpha,
      alternative = alternative,
      shape1 = shape1,
      shape2 = shape2,
      prior = prior,
      call = call
    )
  ret$mod_mat <- mod_mat
  ret$Inital <- M.init
  
  rownames(ret$Inital) <- colnames(ret$Inital) <- MODEL$name
  ret$models <- models
  ret$pweights <- pweights

  # Ret doesn't have class information yet so, we'll call
  # sample_posterior.exchangeability_model directly.
  ret$samples <- sample_posterior_model(MODEL)
  ret$accept.rate <- (n.chg) / mcmc_iter
  ret$mean_est <- colMeans(ret$samples)
  ret$median_est <- apply(ret$samples, 2, median)
  ret$PEP <- PEP
  ret$MAP <- MAP
  ret$HPD <- apply(ret$samples, MARGIN = 2, FUN = boa.hpd, alpha = MODEL$alpha)
  ret$post.prob <- mem.PostProb(MODEL, fit = ret)
  ret$ESS <- calc.ESS.from.HPD(fit = ret, alpha = MODEL$alpha)
  names(ret$ESS) <- MODEL$name
  class(ret) <- c("mem_basket", "mem")
  
  clusterRet <- clusterComp(ret)
  class(clusterRet) <- c("mem_cluster", "mem")
  result <- list(call = call, basket = ret, cluster = clusterRet, seed = seed)
  class(result) <- c("mem_mcmc", "exchangeability_model")
  result
}

