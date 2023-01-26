library(cmdstanr)
check_cmdstan_toolchain(fix = TRUE, quiet = TRUE)
options(mc.cores = parallel::detectCores())


# Generating data:
data <- list(J = 8,                              # number of schools
             y = c(28, 8, -3, 7, -1, 1, 18, 12), 
             sigma = c(15, 10, 16, 11, 9, 11, 10, 18))


# Compiling the model
mod1  <- cmdstan_model( "./stan/eight_schools_centered.stan" )

mod1$print()

# Running MCMC
fit1_stan <- mod1$sample(
  data = data,
  seed = 1,
  refresh = 500,          # print update every 500 iters
  chains=4, 
  parallel_chains=4,
  iter_warmup = 1000,
  iter_sampling = 1000,
  adapt_delta = 0.9,
  show_messages = TRUE)

# Diagnosing fitting
fit1_stan$cmdstan_diagnose()

fit1_stan$print()

fit1_stan$sampler_diagnostics()

fit1_stan$diagnostic_summary()


mod2  <- cmdstan_model( "./stan/eight_schools_noncentered.stan" )

