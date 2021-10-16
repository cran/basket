# Plotting works.

    Code
      summary(mh1)
    Output
      
      -- The MEM Model Call ----------------------------------------------------------
      
      mem_mcmc(responses = vemu_wide$responders, size = vemu_wide$evaluable, 
          name = vemu_wide$baskets, p0 = c(0.15, 0.15, 0.15, 0.2, 0.15, 
              0.15), mcmc_iter = 1000, mcmc_burnin = 10, cluster_analysis = TRUE)
      
      -- The Basket Summary ----------------------------------------------------------
      
      The Null Response Rates (alternative is greater):
                     NSCLC CRC (vemu) CRC (vemu+cetu) Bile Duct ECD or LCH   ATC
      Null            0.15      0.150           0.150     0.200      0.150 0.150
      Posterior Prob  1.00      0.028           0.019     0.147      0.999 0.998
      
      Posterior Mean and Median Response Rates:
             NSCLC CRC (vemu) CRC (vemu+cetu) Bile Duct ECD or LCH   ATC
      Mean   0.400      0.054           0.055     0.109      0.402 0.378
      Median 0.398      0.045           0.047     0.076      0.400 0.376
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  NSCLC CRC (vemu) CRC (vemu+cetu) Bile Duct ECD or LCH   ATC
      Lower Bound 0.249      0.000           0.001     0.002      0.247 0.219
      Upper Bound 0.554      0.129           0.124     0.336      0.560 0.545
      
      Posterior Effective Sample Size:
        NSCLC CRC (vemu) CRC (vemu+cetu) Bile Duct ECD or LCH    ATC
       38.326     49.614          55.301    11.213     36.319 32.711
      
      -- The Cluster Summary ---------------------------------------------------------
      
      Cluster 1                                           
       "CRC (vemu)" "CRC (vemu+cetu)" "Bile Duct"
      Cluster 2                           
       "NSCLC" "ECD or LCH" "ATC"
      
      The Null Response Rates (alternative is greater):
                                 Cluster 1 Cluster 2
      Posterior for null of 0.15     0.086     0.999
      Posterior for null of 0.2      0.053     0.993
      
      Posterior Mean and Median Response Rates:
             Cluster 1 Cluster 2
      Mean       0.073     0.393
      Median     0.054     0.391
      
      Highest Posterior Density Interval with Coverage Probability 0.95:
                  Cluster 1 Cluster 2
      Lower Bound     0.000     0.237
      Upper Bound     0.207     0.554
      
      Posterior Effective Sample Size:
       Cluster 1 Cluster 2
          22.269    35.024
      

