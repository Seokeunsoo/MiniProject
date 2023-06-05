# 
# install.packages("DT")
# install.packages("markdown")
# install.packages("rpart")
# install.packages("rpart.plot")
# install.packages("corrplot")
# install.packages("png")
library(dplyr)
library(png)
library(grid)
birth_data <- read.csv("teamproject6\\2015출생.csv")

head(birth_data)
str(birth_data$출생자성별코드)

# 필요한 부, 모의 나이, 출생아체중량, 임신주수만 가져오기
birth_data= birth_data[,2:6]

str(birth_data)

birth_data <- birth_data[!(birth_data$임신주 == 0 | birth_data$출생아체중량 == 0), ]

# 출생자 성별코드를 남자(male) 또는 여자(female)로 변환
birth_data$출생자성별코드 <- ifelse(birth_data$출생자성별코드 == 1, "여자", "남자")

# 성별별 임신주수와 출생아의 체중량 분석


sex = birth_data %>%
  group_by(출생자성별코드) %>%
  summarize(avg_임신주수 = mean(임신주수),
            avg_출생아체중량 = mean(출생아체중량))

str(sex)
sum(is.na(birth_data))
plot(birth_data)
par(mfrow = c(2,5))
plot(출생아체중량 ~ ., birth_data= birth_data)
cor(birth_data)
cor.test(birth_data$출생아체중량, birth_data$부_연령)

# 종속변수 출생아체중량
week_mom = lm(임신주수 ~ 모_연령, data=birth_data)
kg_week <- lm(출생아체중량 ~ 임신주수, data = birth_data)
kg_mom = lm(출생아체중량 ~ 모_연령, data=birth_data)
kg_all = lm(출생아체중량 ~ ., data=birth_data)


# 분석 결과 요약
summary(kg_all)
summary(kg_week)
summary(week_mom)
summary(age)
summary(kg_mom)

par(mfrow = c(2,4))
plot(kg_week)
plot(kg_mom)
plot(week_mom)

birth_data[416124,]
max(birth_data$출생아체중량)
max(birth_data$부_연령)
max(birth_data$모_연령)
nrow(birth_data[birth_data$임신주수 == 0, ])
nrow(birth_data[birth_data$출생아체중량 == 0.00,])
nrow(birth_data[birth_data$모_연령 == 99,])
nrow(birth_data[birth_data$부_연령 == 99,])
sum(birth_data$임신주수 == 0 & birth_data$출생아체중량 == 0)

birth_data <- birth_data[!(birth_data$임신주 == 0 | birth_data$출생아체중량 < 0.5), ] 
birth_data <- birth_data[!(birth_data$모_연령 == 99 | birth_data$부_연령 == 99), ]

