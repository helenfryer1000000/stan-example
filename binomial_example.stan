data {
  // ACTUAL DATA
  int<lower = 1> N; // number of trials
  int<lower = 0> r; // number of successes
  
  // ANYTHING ELSE YOU WANT TO KEEP FIXED OVER A SINGLE ROUND OF INFERENCE WITH
  // THE MODEL, BUT WHICH YOU MIGHT WANT TO CHANGE BETWEEN ROUNDS WITHOUT
  // RECOMPILING THE CODE.
  real<lower = 0> prior_for_p_alpha;
  real<lower = 0> prior_for_p_beta;
  int<lower = 0> calculate_likelihood; // 0 for no, i.e. calculate the prior;
                                       // 1 for yes, i.e. calculater the posterior
}

parameters {
  real<lower = 0, upper = 1> p; // success probability
}

model {
  
  // ANYTHING RELATED TO THE PRIOR HERE:
  p ~ beta(prior_for_p_alpha, prior_for_p_beta);
  
  // ANYTHING RELATED TO THE LIKELIHOOD HERE:
  if (calculate_likelihood) {
    r ~ binomial(N, p);
  }
}

generated quantities {
  int<lower = 1> r_generated;
  r_generated = binomial_rng(N, p);
}