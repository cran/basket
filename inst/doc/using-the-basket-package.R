## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- echo = FALSE-------------------------------------------------------
library(basket)
vw <- vemu_wide
names(vw) <- c("Basket", "Enrolled", "Evauable", "Responders", "Prior Thrpy <= 1", "Prior Thrpy = 2", "Prior Thrpy >= 3")
knitr::kable(vw)

## ------------------------------------------------------------------------
# Load the basket library.
library(basket)

# Load the vemurafenib data.
data(vemu_wide) 

# Perform the analysis.
vemu_basket <- mem_mcmc(responses = vemu_wide$responders,
                        size = vemu_wide$evaluable,
                        name = vemu_wide$baskets,
                        p0 = 0.15)

# Show the trial diagnostics.
summary(vemu_basket)

## ----out.width='90%',fig.width= 8, fig.height=5,fig.align= "center"------
plot_density(vemu_basket)

## ----out.width='100%',fig.width= 8, fig.height=5, fig.align= "center"----
# Move the basket name labels to the left using 
# the basket_name_hoffest option
plot_mem(vemu_basket, text_size = 1.75, expand = c(0.5, 0.5), basket_name_hjust = 0.85)
