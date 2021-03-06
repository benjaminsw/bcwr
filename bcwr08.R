# Bayesian Computation with R (Second Edition)
# by Jim Albert

library(LearnBayes)

# 8 Model Comparison

# 8.1 Introduction

# 8.2 Comparison of Hypotheses

# 8.3 A One-Sided Test of a Normal Mean

pmean <- 170
pvar <- 25
probH <- pnorm(175, pmean, sqrt(pvar))
probA <- 1 - probH
prior.odds <- probH/probA
prior.odds

weights <- c(182, 172, 173, 176, 176, 180, 173, 174, 179, 175)
xbar <- mean(weights)
sigma2 <- 3^2/length(weights)

post.precision <- 1/sigma2 + 1/pvar
post.var <- 1/post.precision

post.mean <- (xbar/sigma2 + pmean/pvar)/post.precision
c(post.mean, sqrt(post.var))

pnorm175 <- pnorm(175, post.mean, sqrt(post.var))
post.odds <- pnorm175/(1 - pnorm175)
post.odds

BF <- post.odds/prior.odds
BF

postH <- probH*BF/(probH*BF + probA)
postH

z <- sqrt(length(weights))*(mean(weights) - 175)/3
1 - pnorm(z)

weights <- c(182, 172, 173, 176, 176, 180, 173, 174, 179, 175)
data <- c(mean(weights), length(weights), 3)
prior.par <- c(170, 1000)
mnormt.onesided(175, prior.par, data)

# 8.4 A Two-Sided Test of a Normal Mean

weights <- c(182, 172, 173, 176, 176, 180, 173, 174, 179, 175)
data <- c(mean(weights), length(weights), 3)
t <- c(0.5, 1, 2, 4, 8)
mnormt.twosided(170, 0.5, t, data)

# 8.5 Comparing Two Models

# 8.6 Models for Soccer Goals

# Fig. 8.1. The likelihood function and four priors on θ = log λ for the soccer goal example.

str(soccergoals)
#data(soccergoals)
#attach(soccergoals)
datapar <- list(data = soccergoals$goals, par = c(4.57, 1.43))
fit1 <- laplace(logpoissgamma, 0.5, datapar)
datapar <- list(data = soccergoals$goals, par = c(1, 0.5))
fit2 <- laplace(logpoissnormal, 0.5, datapar)
datapar <- list(data = soccergoals$goals, par = c(2, 0.5))
fit3 <- laplace(logpoissnormal, 0.5, datapar)
datapar <- list(data = soccergoals$goals, par = c(1, 2))
fit4 <- laplace(logpoissnormal, 0.5, datapar)

postmode <- c(fit1$mode, fit2$mode, fit3$mode, fit4$mode)
postsd <- sqrt(c(fit1$var, fit2$var, fit3$var, fit4$var))
logmarg <- c(fit1$int, fit2$int, fit3$int, fit4$int)
cbind(postmode, postsd, logmarg)

# 8.7 Is a Baseball Hitter Really Streaky?

str(jeter2004)
#data(jeter2004)
#attach(jeter2004)
data <- cbind(H, AB)
data1 <- regroup(data, 5)

log.marg <- function(logK) 
  laplace(bfexch, 0, list(data = data1, K = exp(logK)))$int

log.K <- seq(2, 6)
K <- exp(log.K)
log.BF <- sapply(log.K, log.marg)
BF <- exp(log.BF)
round(data.frame(log.K, K, log.BF, BF), 2)

# 8.8 A Test of Independence in a Two-Way Contingency Table

data <- matrix(c(11, 9, 68, 23, 3, 5), c(2, 3))
data

chisq.test(data)

a <- matrix(rep(1, 6), c(2, 3))
a

ctable(data, a)

log.K <- seq(2, 7)
compute.log.BF <- function(log.K)
  log(bfindep(data, exp(log.K), 100000)$bf)
log.BF <- sapply(log.K, compute.log.BF)
BF <- exp(log.BF)

round(data.frame(log.K, log.BF, BF), 2)

# 8.9 Further Reading

# 8.10 Summary of R Functions

# 8.11 Exercises
