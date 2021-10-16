# MCMC can be calculated correctly.

    Code
      unclass(summary(mcmc_res1))
    Output
      $call
      mem_mcmc(responses = vemu_wide1$responders, size = vemu_wide1$evaluable, 
          name = vemu_wide1$baskets, p0 = 0.15, mcmc_iter = 100, mcmc_burnin = 100, 
          cluster_analysis = TRUE)
      
      $basket
      
      The Null Response Rates (alternative is greater):
                     NSCLC ECD or LCH   ATC
      Null            0.15       0.15 0.150
      Posterior Prob  1.00       1.00 0.996
      
      Posterior Mean and Median Response Rates:
             NSCLC ECD or LCH   ATC
      Mean   0.405      0.405 0.397
      Median 0.404      0.403 0.397
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  NSCLC ECD or LCH   ATC
      Lower Bound 0.250      0.253 0.233
      Upper Bound 0.556      0.556 0.563
      
      Posterior Effective Sample Size:
       NSCLC ECD or LCH   ATC
       38.34     38.766 32.36
      
      
      $cluster
      
      Cluster 1                           
       "NSCLC" "ECD or LCH" "ATC"
      
      The Null Response Rates (alternative is greater):
                                 Cluster 1
      Posterior for null of 0.15     0.999
      
      Posterior Mean and Median Response Rates:
             Cluster 1
      Mean       0.402
      Median     0.401
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  Cluster 1
      Lower Bound     0.248
      Upper Bound     0.561
      
      Posterior Effective Sample Size:
       Cluster 1
          36.304
      
      

# Exact corner case models

    Code
      summary(mem_mcmc(responses = c(4, 3, 0), size = c(10, 3, 0), name = letters[1:3],
      cluster_analysis = TRUE, mcmc_iter = 100, mcmc_burnin = 100, p0 = 0.25))
    Output
      
      -- The MEM Model Call ----------------------------------------------------------
      
      mem_mcmc(responses = c(4, 3, 0), size = c(10, 3, 0), name = letters[1:3], 
          p0 = 0.25, mcmc_iter = 100, mcmc_burnin = 100, cluster_analysis = TRUE)
      
      -- The Basket Summary ----------------------------------------------------------
      
      The Null Response Rates (alternative is greater):
                         a     b     c
      Null           0.250 0.250 0.250
      Posterior Prob 0.867 0.997 0.852
      
      Posterior Mean and Median Response Rates:
                 a     b     c
      Mean   0.414 0.862 0.602
      Median 0.408 0.927 0.603
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                      a    b     c
      Lower Bound 0.148 0.51 0.056
      Upper Bound 0.694 1.00 1.000
      
      Posterior Effective Sample Size:
            a     b     c
       11.042 5.602 1.947
      
      -- The Cluster Summary ---------------------------------------------------------
      
      Cluster 1    
       "a"
      Cluster 2    
       "b"
      Cluster 3    
       "c"
      
      The Null Response Rates (alternative is greater):
                                 Cluster 1 Cluster 2 Cluster 3
      Posterior for null of 0.25     0.867     0.997     0.852
      
      Posterior Mean and Median Response Rates:
             Cluster 1 Cluster 2 Cluster 3
      Mean       0.414     0.862     0.602
      Median     0.408     0.927     0.603
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  Cluster 1 Cluster 2 Cluster 3
      Lower Bound     0.148      0.51     0.056
      Upper Bound     0.694      1.00     1.000
      
      Posterior Effective Sample Size:
       Cluster 1 Cluster 2 Cluster 3
          11.042     5.602     1.947
      

---

    Code
      summary(mem_mcmc(responses = c(4, 3), size = c(10, 3), name = letters[1:2],
      cluster_analysis = TRUE, mcmc_iter = 100, mcmc_burnin = 100, p0 = 0.25))
    Output
      
      -- The MEM Model Call ----------------------------------------------------------
      
      mem_mcmc(responses = c(4, 3), size = c(10, 3), name = letters[1:2], 
          p0 = 0.25, mcmc_iter = 100, mcmc_burnin = 100, cluster_analysis = TRUE)
      
      -- The Basket Summary ----------------------------------------------------------
      
      The Null Response Rates (alternative is greater):
                         a     b
      Null           0.250 0.250
      Posterior Prob 0.871 0.997
      
      Posterior Mean and Median Response Rates:
                 a     b
      Mean   0.417 0.851
      Median 0.412 0.921
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                      a     b
      Lower Bound 0.146 0.483
      Upper Bound 0.695 1.000
      
      Posterior Effective Sample Size:
            a     b
       10.916 5.321
      
      -- The Cluster Summary ---------------------------------------------------------
      
      Cluster 1    
       "a"
      Cluster 2    
       "b"
      
      The Null Response Rates (alternative is greater):
                                 Cluster 1 Cluster 2
      Posterior for null of 0.25     0.871     0.997
      
      Posterior Mean and Median Response Rates:
             Cluster 1 Cluster 2
      Mean       0.417     0.851
      Median     0.412     0.921
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  Cluster 1 Cluster 2
      Lower Bound     0.146     0.483
      Upper Bound     0.695     1.000
      
      Posterior Effective Sample Size:
       Cluster 1 Cluster 2
          10.916     5.321
      

---

    Code
      summary(mem_mcmc(responses = c(4, 3), size = c(10, 3), name = letters[1:2],
      cluster_analysis = FALSE, mcmc_iter = 100, mcmc_burnin = 100, p0 = 0.25))
    Output
      
      -- The MEM Model Call ----------------------------------------------------------
      
      mem_mcmc(responses = c(4, 3), size = c(10, 3), name = letters[1:2], 
          p0 = 0.25, mcmc_iter = 100, mcmc_burnin = 100, cluster_analysis = FALSE)
      
      -- The Basket Summary ----------------------------------------------------------
      
      The Null Response Rates (alternative is greater):
                         a     b
      Null           0.250 0.250
      Posterior Prob 0.871 0.997
      
      Posterior Mean and Median Response Rates:
                 a     b
      Mean   0.417 0.851
      Median 0.412 0.921
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                      a     b
      Lower Bound 0.146 0.483
      Upper Bound 0.695 1.000
      
      Posterior Effective Sample Size:
            a     b
       10.916 5.321
      

