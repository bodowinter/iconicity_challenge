## Bodo Winter
## August 9, 2019
## Bayesian analysis for both experiments

## This is the only script where the paths aren't relative, please reset working directories

## Load packages:

library(tidyverse)
library(brms)

## Load data:

field <- read_csv('../data/field_cleaned.csv')
web <- read_csv('../data/online_cleaned.csv')

## Fix Armenian / Amharic issue (this miscoding was something we noted after submission of the first version):

web <- mutate(web,
              Genus = ifelse(Genus == 'Afro-Asiatic', 'IE', Genus))

## For parallel processing:

options(mc.cores=parallel::detectCores())

## Set weakly informative prior for animacy effect and uniform prior for intercept:

my_priors <- prior('uniform(-10, 10)',
                   class = 'Intercept')
my_priors_with_beta <- c(prior('uniform(-10, 10)',
                             class = 'Intercept'),
                         prior('normal(0, 2)',
                               class = 'b'))

## For the field model we fit animacy as it's balanced and they are all nouns:

field <- mutate(field,
                AnimacyCat = factor(Animacy, levels = c('inanimate', 'animate')))
contrasts(field$AnimacyCat) <- contr.sum(2) * -1

## Check that inanimate = -1:

contrasts(field$AnimacyCat)

## Fit the main model:

main_mdl <- brm(ACC ~ 1 +
                  (1|ID) +
                  (1|Meaning) +(1|UniqueItem) +
                  (1|Team) +
                  (1|Language) +
                  (1|Genus),
                data = web,
                family = bernoulli,
                init = 0, seed = 42,
                cores = 4, chains = 4,
                warmup = 2000, iter = 4000,
                prior = my_priors,
                control = list(adapt_delta = 0.99,
                               max_treedepth = 13))
save(main_mdl, file = 'main_mdl.RData',
     compress = 'xz', compression_level = 9)

## Fit the model without animacy:

field_mdl <- brm(ACC ~ 1 +
                   (1|ID) +
                   (1|Meaning) + (1|UniqueItem) +
                   (1|Team) +
                   (1|Language),
                 data = field,
                 family = bernoulli,
                 init = 0, seed = 42,
                 cores = 4, chains = 4,
                 warmup = 2000, iter = 4000,
                 prior = my_priors,
                 control = list(adapt_delta = 0.99,
                                max_treedepth = 13))
save(field_mdl, file = 'field_mdl.Rdata',
     compress = 'xz', compression_level = 9)

## Fit the model with animacy:

field_animacy_mdl <- brm(ACC ~ 1 + Animacy +
                   (1 + Animacy|ID) +
                   (1|Meaning) + (1|UniqueItem) +
                   (1|Team) +
                   (1 + Animacy|Language),
                 data = field,
                 family = bernoulli,
                 init = 0, seed = 42,
                 cores = 4, chains = 4,
                 warmup = 2000, iter = 4000,
                 prior = my_priors_with_beta,
                 control = list(adapt_delta = 0.99,
                                max_treedepth = 13))
save(field_animacy_mdl, file = 'field_animacy_mdl.Rdata',
     compress = 'xz', compression_level = 9)




