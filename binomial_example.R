library(tidyverse)
library(rstan)
options(mc.cores = parallel::detectCores())
rstan_options(auto_write = TRUE)

model_compiled <- 
  rstan::stan_model("~/Dropbox (Infectious Disease)/STAN/binomial_example.stan")

stan_input <- list(N = 100,
             r = 33,
             prior_for_p_alpha = 1,
             prior_for_p_beta = 1,
             calculate_likelihood = 1L)

stan_input_prior <- stan_input
stan_input$calculate_likelihood <- 0L

num_iter <- 100
num_chains <- 4
fit <- sampling(model_compiled,
                data = stan_input,
                iter = num_iter,
                chains = num_chains)
fit_prior <- sampling(model_compiled,
                      data = stan_input,
                      iter = num_iter,
                      chains = num_chains)

df_fit <- bind_rows(fit %>%
                      as.data.frame() %>% 
                      mutate(model = "posterior",
                             sample = row_number()),
                    fit_prior %>% 
                      as.data.frame() %>%
                      mutate(model = "prior",
                             sample = row_number())) %>%
  as_tibble() %>%
  pivot_longer(-c("model", "sample"), names_to = "parameter")

ggplot(df_fit) +
  geom_histogram(aes(value, fill = model), alpha = 0.6, position = "identity") +
  facet_wrap(~parameter, scales = "free") +
  theme_classic() +
  coord_cartesian(expand = F)
