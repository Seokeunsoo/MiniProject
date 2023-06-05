Tips = read.csv(file = 'teamproject5\\tips.csv')

# 데이터 탐색
str(Tips)

# 결측치 0개
sum(is.na(Tips))

# 남녀의 인원수
library(ggplot2)
ggplot(Tips, aes(x = sex, fill = sex)) +
  geom_bar(stat = "count") +
  coord_flip() +
  labs(title = "성별 인원수 비교 ", x = "Gender", y = "Count")

# 남녀 인원수의 비율
ggplot(Tips, aes(x = "", fill = sex)) +
  geom_bar(stat = "count", position = "fill") +
  coord_polar("y", start=0) +
  scale_fill_brewer(palette = "Dark3") +
  labs(title = "남녀의 비율", fill = "Gender")

# 흡연자와 비흡연자의 인원수 차이
ggplot(Tips, aes(x = smoker, fill = smoker)) +
  geom_bar(stat = "count") +
  coord_flip() +
  labs(title = "흡연자와 비흡연자의 인원수", x = "Smoker", y = "Count")

# 성별과 흡연 여부에 따른 인원 수를 계산
smoker_counts <- table(Tips$sex, Tips$smoker)
names(dimnames(smoker_counts)) <- c("성별", "흡연자")

# 전체 인원 수를 계산 & 비율을 계산합니다
total_count <- sum(smoker_counts)
group_percentages <- round(smoker_counts / total_count * 100, 1)

# 성별과 흡연자 비율
pie(smoker_counts, labels = paste0(rownames(smoker_counts), ", ", 
colnames(smoker_counts), " (", group_percentages, "%)"), main = "성별과 흡연자별 비율")

# 요일별 인원 수
day_counts <- table(Tips$day)

# 시간대별 인원 수
time_counts <- table(Tips$time)

# 요일별, 시간대별 인원수 그래프
par(mfrow=c(1,2)) # 두 개의 그래프를 옆으로 나란히 그리기 위해 행렬 모양을 지정합니다
barplot(day_counts, main = "요일별 인원 수", xlab = "요일", ylab = "인원 수")
barplot(time_counts, main = "식사 시간별 인원 수", xlab = "식사 시간", ylab = "인원 수")

# 점심.저녁 total_bill별 tip
# library(ggplot2)
# ggplot(Tips, aes(x=total_bill, y=tip, color=time))+
# geom_point()+
# geom_smooth(method = 'lm', se=FALSE)

# 음식값과 팁의 상관관계를 알아보기 위한 계산
# 기술통계 계산
summary(Tips$total_bill)
summary(Tips$tip)

# 음식값과 팁의 산점도 그래프
ggplot(data = Tips, aes(x = total_bill, y = tip)) + 
    geom_point() + 
    ggtitle("음식값과 팁의 산점도 그래프")

# cor함수로 확인해보기
cor(Tips$tip, Tips$total_bill)
# cor.test로 p값 확인
cor.test(Tips$tip, Tips$total_bill)

# smoker 열을 기준으로 tip 열과의 상관관계 계산하기
# 흡연 여부 그룹별로 나누기
Tips_smoker = split(Tips$tip, Tips$smoker)

# 그룹별 평균 비교
mean(Tips_smoker$No)
mean(Tips_smoker$Yes)

# tip차이가 없다
t.test(formula=tip ~ smoker, data=Tips)

# 두 집단의(남녀)간의 tip 차이 검정
# 성별 그룹별로 나누기
Tips_male <- subset(Tips, sex == "Male")
Tips_female <- subset(Tips, sex == "Female")

# 그룹별 평균 비교
mean(Tips_male$tip)
mean(Tips_female$tip)

# tip차이가 없다
t.test(formula=tip ~ sex, data=Tips)

# 요일별 팁의 차이
Tipsmeans <- aggregate(Tips$tip, by=list(Tips$day), FUN=mean)
barplot(Tipsmeans$x, names.arg=Tipsmeans$Group.1, 
ylab="Tip Mean", xlab="Day")

# 요일별 총 금액평균
day_bill = aggregate(total_bill ~ day, Tips, mean)
day_bill

# aov() 함수를 사용하여 일원분산분석 수행하기(평균이 동일한지)
day_aov = aov(total_bill ~ day, data = Tips)
day_aov

# 요약 - P값이 0.05보다 작아서 차이가 없다는 귀무가설을 기각
summary(day_aov)

# 다중비교 = 두개씩 쌍으로 비교하면 요일별로 차이가 없는것으로 보인다. 
# TukeyHSD() 함수를 사용하여 다중비교 수행하기
TukeyHSD(day_aov)

# 전체 평균에서 요일별 평균을 뺀값을 비교
model.tables(day_aov, type='effects')
model.tables(day_aov, type='mean')

# 일원분산분석 실행
Tips$size = as.character(Tips$size)
Tipssize = lm(tip ~ size, data = Tips)
Tipssize
anova(Tipssize)
ano_Tipssize= aov(tip ~ size, data = Tips)
ano_Tipssize
# 사후 검정
TukeyHSD(ano_Tipssize) 

# size 열 int 타입으로 변환
Tips$size <- as.integer(Tips$size)

# 인원수 별 금액
Tips$total_per_person <- Tips$total_bill / Tips$size

# size별 total_per_person 평균값 계산
total_per_person_mean <- aggregate(total_per_person ~ size, Tips, mean)

# 인원수 별 금액
Tips$total_per_person <- Tips$total_bill / Tips$size

# size별 total_per_person 평균값 계산
total_per_person_mean <- aggregate(total_per_person ~ size, Tips, mean)

# 막대그래프 시각화
ggplot(total_per_person_mean, aes(x = size, y = total_per_person)) +
  geom_bar(stat = "identity") +
  ggtitle("인원수 별 일인당 음식값 비교")

# 인원수 별 팁
Tips$tip_per_person <- Tips$tip / Tips$size

# size별 tip 평균값 계산
tip_per_person_mean <- aggregate(tip_per_person ~ size, Tips, mean)

# 막대그래프 시각화
ggplot(tip_per_person_mean, aes(x = size, y = tip_per_person)) +
  geom_bar(stat = "identity") +
  ggtitle("인원수 별 일인당 팁 비교")

# 평균도표
library(gplots)
boxplot(total_bill ~ day, data=Tips, col="blue",
xlab="type of day", ylab = 'total_bill', 
main= '요일별 금액 사용 차이')
