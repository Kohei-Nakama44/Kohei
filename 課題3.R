library(ggplot2)
アヤメデータ
head(iris, n = 3)
p_box <- ggplot(data = iris,
       　mapping = aes(x=Species, y=Sepal.Width))+
  geom_boxplot()+
  labs(title = "箱ひげ図")
p_box
