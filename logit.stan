data {
  int<lower=2> K; // numero de classes
  int<lower=0> N; //numero de observações
  int<lower=1> D; // quantidade de variaveis explicativas
  int<lower=1,upper=K> y[N]; //vetor que contem as categorias 
  matrix[N , D] X; // variaveis explicativas
}
parameters {
  vector[D] beta; //estimar beta de cada variavel explicativa
  ordered[K-1] c; //pontos de corte
  // adicionar alfa ?
}
model {
  beta ~ normal(0, 100); // adcionado priori para verificar se estima melhor
  for (n in 1:N) {
    y[n] ~ ordered_logistic(X[n] * beta, c);
  }
  
}

