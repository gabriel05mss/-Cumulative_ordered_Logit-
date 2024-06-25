setwd("C:/Users/gmore/OneDrive/Desktop/MCCD/stan")
#criar os dados

# se (alfa + beta * vetor_x) >= 7 garante que a acumulada seja >= 0.999

alfa_1 <- -1.43
alfa_2 <- -0.1
alfa_3 <- 7
beta <- 1

x <- rnorm(1000 , 1 , 1)
vetor_x <- abs(x)

prob_1 <- exp(alfa_1 + beta * vetor_x)/(1 + exp(alfa_1 + beta * vetor_x))

prob_2 <- (exp(alfa_2 + beta * vetor_x)/(1 + exp(alfa_2 + beta * vetor_x)))-prob_1

prob_3 <- (exp(alfa_3 + beta * vetor_x)/(1 + exp(alfa_3 + beta * vetor_x)))-(prob_2 + prob_1)

dados <- data.frame(cbind(prob_1,prob_2,prob_3))

resultados_sorteio <- vector("integer", length(dados))
class <- for (i in 1 : nrow(dados)) {
  prob <- dados[i,]
  sorteio <- sample(c("1","2","3") , size = 1 , prob = prob)
  resultados_sorteio[i] <- sorteio
}

dados <- cbind( x = vetor_x , dados , class = resultados_sorteio)

barplot(table(dados$class))

dados$class <- as.numeric(dados$class)

matriz_x <- matrix(vetor_x ,nrow = 1000, ncol = 1)

data_stan <- list(K = 3 , N = 1000 , D = 1 , y = dados$class , X= matriz_x)

library(rstan)
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

modelo<- stan_model(file = "logit.stan")
fit <- sampling(modelo, data = data_stan, cores = 2, chains = 2)
fit

shinystan::launch_shinystan(fit)

# modelo estima beta negativo
# os pontos de corte da variavel latente se aproxima do alfa

