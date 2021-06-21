#パッケージの読み込み
library(rstan)
library(brms)
#計算の高速化
rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

#分析対象のデータ
fish_num_climate_3 <- read.csv("4-2-1-fish-num-3.csv")
head(fish_num_climate_3, n = 3)

#データの要約
summary(fish_num_climate_3)

#brmsによるGLMMの推定
glmm_pois_brms_human <- brm(
  formula = fish_num ~ weather + temperature + (1|human),
  family = poisson(),
  data = fish_num_climate_3,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "sd"))
)

#参考：トレースプロットなど
plot(glmm_pois_brms_human)

#参考:収束の確認
stanplot(glmm_pois_brms_human, type = "rhat")

# 結果の表示
glmm_pois_brms_human

#各々の調査者の影響の大きさ
ranef(glmm_pois_brms_human)

#調査者ごとにグラフを分けて,回帰曲線を描く
conditions <- data.frame(
  human = c("A", "B", "C", "D", "E", "F", "G", "H", "I", "J"))

eff_glmm_human <- marginal_effects(
  glmm_pois_brms_human,
  effects = "temperature:weather",
  re_formula = NULL,
  conditions = conditions)

plot(eff_glmm_human, points = TRUE)

#当てはめ値と99%予測区間の計算
set.seed(1)
eff_glm_pre <- marginal_effects(
  glmm_pois_brms_human,
  method = "predict",
  effects = "temperature:weather",
  probs = c(0.005, 0.995))
#結果の表示
plot(eff_glm_pre, points = TRUE)
