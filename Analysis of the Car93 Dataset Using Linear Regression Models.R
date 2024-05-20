library(MASS)
library("PerformanceAnalytics")
library(ggplot2)
library(RcmdrMisc)
library(olsrr)
library(pheatmap)
library(reshape2)

data(Cars93,package="MASS")
data = Cars93
str(data)
summary(data)
is.na(data)
#data_cont = data[,c(3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,25,26)]
data_cont = data[,c(3,5,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,25,26)] #remove prices and rooms
#remove rotary
data_cont<-data_cont[!(data_cont$Cylinders == "rotary"),]
data_cont$Cylinders = as.numeric(data_cont$Cylinders)
data_cont$MPG = (data_cont$MPG.city+data_cont$MPG.highway)/2

cor(data_cont)
pairs(data_cont)
chart.Correlation(data_cont, histogram=TRUE)

# Heatmap
cormat <- cor(data_cont)
cormat = round(cormat,2)
melted_cormat <- melt(cormat)

ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile()


get_lower_tri<-function(cormat){ 
  cormat[upper.tri(cormat)] <- NA
  return(cormat)
}
get_upper_tri <- function(cormat){ 
  cormat[lower.tri(cormat)]<- NA
  return(cormat)
}
reorder_cormat <- function(cormat){
  # Use correlation between variables as distance
  dd <- as.dist((1-cormat)/2)
  hc <- hclust(dd)
  cormat <-cormat[hc$order, hc$order]
}

cormat <- reorder_cormat(cormat)
upper_tri <- get_upper_tri(cormat)
# Melt the correlation matrix
melted_cormat <- melt(upper_tri, na.rm = TRUE)
# Create a ggheatmap
ggheatmap <- ggplot(melted_cormat, aes(Var2, Var1, fill = value))+
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = 0, limit = c(-1,1), space = "Lab", 
                       name="Pearson\nCorrelation") +
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 12, hjust = 1))+
  coord_fixed() + 
  geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.grid.major = element_blank(),
    panel.border = element_blank(),
    panel.background = element_blank(),
    axis.ticks = element_blank(),
    legend.justification = c(1, 0),
    legend.position = c(0.6, 0.7),
    legend.direction = "horizontal")+
  guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                               title.position = "top", title.hjust = 0.5))
# Print the heatmap
print(ggheatmap)


#historgram
ggplot(data = data_cont, aes(x = MPG.city)) + geom_histogram( fill = "blue")
ggplot(data = data_cont, aes(x = MPG.highway )) + geom_histogram( fill = "blue")
ggplot(data = data_cont, aes(x = MPG )) + geom_histogram( fill = "blue")
ggplot(data = data_cont, aes(x = log(MPG.city+ MPG.highway)/2 )) + geom_histogram( fill = "blue") #log



all = lm(MPG ~ .-MPG.highway-MPG.city, data=data_cont)
summary(all)
par(mfrow=c(2,2))
plot(all)

# box-cox
bc <- boxcox(all)
lambda <- bc$x[which.max(bc$y)]
ggplot(data = data_cont, aes(x = (MPG^lambda-1)/lambda) ) + geom_histogram( fill = "blue")

all_new <- lm(((MPG^lambda-1)/lambda) ~ .-MPG.highway-MPG.city, data=data_cont)
summary(all_new)
par(mfrow=c(2,2))
plot(all_new)

#stepwise selection
backward_AIC = stepwise(all_new, direction = c("backward"), 
         criterion = c("AIC"))
#ols_step_backward_aic(all_new, details = FALSE, penter = 0.05)


summary(backward_AIC)

backward_BIC = stepwise(all_new, direction = c("backward"), 
                      criterion = c("BIC"))
summary(backward_BIC)

forward_AIC = stepwise(all_new, direction = c("forward"), 
                      criterion = c("AIC"))
summary(forward_AIC)
forward_BIC = stepwise(all_new, direction = c("forward"), 
                      criterion = c("BIC"))
summary(forward_BIC)

#multicolinearity
vif(backward_AIC)
vif(backward_BIC)
vif(forward_AIC)
vif(forward_BIC)

model1 = lm(((MPG^lambda-1)/lambda) ~ Weight +
              Length + Fuel.tank.capacity -MPG.city-MPG.highway, data=data_cont)
summary(model1)
vif(model1)
par(mfrow=c(2,2))
plot(model1)

#create vector of VIF values
vif_values1 <- vif(model1)

#create horizontal bar chart to display each VIF value
par(mfrow=c(1,1))
barplot(vif_values1, main = "VIF Values", horiz = TRUE, col = "steelblue")

#add vertical line at 5
abline(v = 10, lwd = 3, lty = 2)

model2 = lm(((MPG^lambda-1)/lambda) ~ Weight + Cylinders + Passengers +
            Length + Fuel.tank.capacity-MPG.city-MPG.highway, data=data_cont)
summary(model2)
vif(model2)
par(mfrow=c(2,2))
plot(model2)

#create vector of VIF values
vif_values2 <- vif(model2)
names(vif_values2) = c("Weight", "Cylinders", "Passengers", "Length", "Tank capacity")
#create horizontal bar chart to display each VIF value
par(mfrow=c(1,1))
barplot(vif_values2, main = "VIF Values", horiz = TRUE, col = "steelblue")

#add vertical line at 5
abline(v = 10, lwd = 3, lty = 2)

#scatter plot
my_graph <- ggplot(data_cont, aes(x = ((MPG^lambda1-1)/lambda1), y = Weight)) +
  geom_point() +
  stat_smooth(method = "lm",
              col = "#C42126",
              se = FALSE,
              size = 1)
my_graph

