#import dataset
BJ <- read.csv("./dataset.csv")
BJ <- na.omit(BJ)
BJ <- BJ[-c(7:9)]
BJ$cbwd <- as.numeric(as.factor(BJ$cbwd))
BJ
#spilt train test set 
n <- sample(1:nrow(BJ), nrow(BJ) / 2)
set.seed(1)
train <- BJ[n, ]
test <-BJ[-n, ]

## Linear Regression 
lm.fit <- lm(PM_US.Post~., data=train)
summary(lm.fit)
mean(lm.fit$residuals^2)
mean((test$PM_US.Post - predict.lm(lm.fit, test)) ^ 2)

## Best Subset Selection
library(leaps)
regfit.full <- regsubsets(PM_US.Post~., data=train, nvmax=14)
summary(regfit.full)
reg.summary <- summary(regfit.full)
reg.summary$rsq
par(mfrow=c(2, 2))
plot(reg.summary$rss, xlab="Number of Variables", ylab="RSS", type="l")
which.min(reg.summary$rss)
points(14, reg.summary$rss[14], col="red", cex=2, pch=20)
plot(reg.summary$adjr2, xlab="Number of Variables", ylab="Adjusted RSq", type="l")
which.max(reg.summary$adjr2)
points(12, reg.summary$adjr2[14], col="red", cex=2, pch=20)
plot(reg.summary$cp, xlab="Number of Variables", ylab="Cp", type="l")
which.min(reg.summary$cp)
points(12, reg.summary$cp[14], col="red", cex=2, pch=20)
which.min(reg.summary$bic)
plot(reg.summary$bic, xlab="Number of Variables", ylab="BIC", type="l")
points(10, reg.summary$bic[14], col="red", cex=2, pch=20)
test.mat <- model.matrix(PM_US.Post~., data=test)
val.errors <- rep(NA, 14)
for (i in 1:14) {
  coefi <- coef(regfit.full, id=i)
  pred <- test.mat[,names(coefi)] %*% coefi
  val.errors[i] <- mean((test$PM_US.Post - pred)^2)
}
val.errors
which.min(val.errors)
regfit.best <- regsubsets(PM_US.Post ~ ., data=BJ, nvmax=14)
summary(regfit.best)
coef(regfit.best, 14)

## LASSO 
library(glmnet)
x <- model.matrix(PM_US.Post~., BJ)[,-1]
y <- BJ$PM_US.Post
train <- sample(1:nrow(x), nrow(x) / 2)
test <- (-train)
y.test <- y[test]
grid <- 10^seq(10, -2, length=100)
lasso.mod <- glmnet(x[train,], y[train], alpha=1, lambda=grid)
par(mfrow=c(1, 1))
plot(lasso.mod)
cv.out <- cv.glmnet(x[train,], y[train], alpha=1)
plot(cv.out)
bestlam <- cv.out$lambda.min
lasso.pred <- predict(lasso.mod, s=bestlam, newx=x[test,])
mean((lasso.pred - y.test)^2)
out <- glmnet(x, y, alpha=1, lambda=grid)
lasso.coef <- predict(out,  type="coefficients", s=bestlam)[1:15,]
lasso.coef
lasso.coef[lasso.coef!=0]

## Regression tree
library(tree)
train <- sample(1:nrow(BJ), nrow(BJ)/2)
tree.BJ <- tree(PM_US.Post~., BJ, subset=train)
summary(tree.BJ)
par(mfrow=c(1, 1))
plot(tree.BJ)
text(tree.BJ, pretty=0)
cv.BJ <- cv.tree(tree.BJ)
plot(cv.BJ$size, cv.BJ$dev, type="b")
yhat <- predict(tree.BJ, newdata=BJ[-train,])
mean((yhat - BJ[-train, "PM_US.Post"])^2)

#Bagging
library(randomForest)
bag.BJ <- randomForest(PM_US.Post~., data=BJ, subset=train, mtry=14, importance=TRUE)
bag.BJ
yhat.bag <- predict(bag.BJ, newdata=BJ[-train,])
mean((yhat.bag - BJ[-train, "PM_US.Post"])^2)
rf.BJ <- randomForest(PM_US.Post~., data=BJ, subset=train, mtry=14, importance=TRUE)
yhat.rf <- predict(rf.BJ,newdata=BJ[-train,])
mean((yhat.rf - BJ[-train, "PM_US.Post"])^2)
importance(rf.BJ)
varImpPlot(rf.BJ)

# Boosting
library(gbm)
train <- sample(1:nrow(BJ), nrow(BJ)/2)
BJ.test <- BJ[-train, "PM_US.Post"]
boost.BJ <- gbm(PM_US.Post~., data=BJ[train,], distribution="gaussian", 
                    n.trees=1000, interaction.depth=4, shrinkage=0.2, verbose=F)
summary(boost.BJ) 
yhat.boost <- predict(boost.BJ, newdata=BJ[-train,], n.trees=1000)
mean((yhat.boost - BJ.test)^2)

#PCR
library(pls)
x <- model.matrix(PM_US.Post~., BJ)[,-1] 
y <- BJ$PM_US.Post
pcr.fit <- pcr(PM_US.Post~., data=BJ, scale=TRUE, validation="CV")
summary(pcr.fit)
train <- sample(1:nrow(x), nrow(x) / 2)
test <- (-train)
y.test <- y[test]
pcr.fit <- pcr(PM_US.Post~., data=BJ, subset=train, scale=TRUE, validation="CV")
validationplot(pcr.fit, val.type="MSEP")

pcr.pred <- predict(pcr.fit, x[test,], ncomp=14)
mean((pcr.pred - y.test)^2)
# Perform PCR with ncomp=5 on full data set
pcr.fit <- pcr(y~x, scale=TRUE, ncomp=14)
summary(pcr.fit)
