
library(tidyverse)
library(gridExtra)
library(ggrepel)
library(maps)

#install.packages('tidyverse')
#install.packages('gridExtra')
#install.packages('ggrepel')
#install.packages('map')

options(repr.plot.width=6, repr.plot.height=4)
# regular plot functions in R
plot(x=mpg$displ,y=mpg$hwy)

# ggplot!
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(x="Engine displacement (L)",y="Heighway fuel economy (mpg)",
    title = "Fuel efficiency generally decreases with engine size",
    caption = "Data from fueleconomy.gov",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    colour = "Car type"
  ) + theme_classic()

table1 <- data.frame(makemodel=c("audi a4","audi a4","chevrolet corvette","chevrolet corvette","honda civic","honda civic"),
                    year=rep(c(1999,2008),3),
                    cty=c(18,21,15,15,24,25),
                    hwy=c(29,30,23,25,32,36))
table1

table2a <- data.frame(makemodel=c("audi a4","chevrolet corvette","honda civic"),`1999`=c(18,15,24),'2008'=c(21,15,25),check.names=FALSE)
table2b <- data.frame(makemodel=c("audi a4","chevrolet corvette","honda civic"),`1999`=c(29,23,32),'2008'=c(30,25,36),check.names=FALSE)
table2a
table2b

tidy2a <- gather(table2a,`1999`,`2008`,key="year",value="cty")
tidy2a

tidy2b <- gather(table2b, `1999`, `2008`, key = "year", value = "hwy")
tidy2b

right_join(tidy2a,tidy2b)

table3 <- data.frame(makemodel=c(rep("audi a4",4),rep("chevrolet corvette",4),rep("honda civic",4)),
                    year=rep(c(1999,1999,2008,2008),3),
                    type=rep(c("cty","hwy"),6),
                     mileage=c(18,29,21,30,15,23,15,25,24,32,25,36))
table3

spread(table3, key=type,value=mileage)

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks

stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")

people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

table4 <- data.frame(makemodel=c("audi a4","audi a4","chevrolet corvette","chevrolet corvette","honda civic","honda civic"),
                     year=rep(c(1999,2008),3),
                    mileages=c('18/29','21/30','15/23','15/25','24/32','25/36'))
table4

separate(table4, mileages, into = c("cty", "hwy"), sep="/")

sep <- separate(table4, makemodel, into = c("make", "model"), sep = ' ')
sep

unite(sep, new, make, model)

unite(sep, makemodel, make, model, sep=' ')

unite(sep, makemodel, make, model, sep=' ') %>%
    separate(mileages, into=c("cty","hwy"))

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

head(mpg)

# filter out 2seater cars
no_2seaters <- filter(mpg, class != "2seater")
head(no_2seaters)

# filter out audis, chevys, and hondas
mpg %>% filter(!manufacturer %in% c("audi","chevrolet","honda")) %>% head

# arrange/reorder mpg by class
arrange(mpg, class) %>% head

# arrange/reorder data frame with 2seaters filtered out by class
# 2seaters does not appear which is as it should be
arrange(no_2seaters, class) %>% head

# arrange mpg so that first hwy mileage is by descending order, then cty mileage is by descending order
arrange(mpg, desc(hwy), desc(cty)) %>% head

df <- data.frame(x=c(5,2,NA,6))
df

# arrange df by ascending order, NA will be at bottom
arrange(df, x)

# arrange df by descending order, NA will be at bottom
arrange(df, desc(x))

# rest of the values are unsorted because they are all T for !is.na(x)
arrange(df,!is.na(x))

# can arrange by x again to get ascending order
arrange(df,!is.na(x),desc(x))

# select manufacturer, model, year, cty, hwy
select(mpg, manufacturer, model, year, cty, hwy) %>% head

# select all columns model thru hwy
select(mpg, model:hwy) %>% head
head(mpg)

# select all columns except cyl thru drv and class
select(mpg, -(cyl:drv), -class) %>% head

# add a new column that takes average mileage between city and highway
mutate(mpg, avg_mileage = (cty+hwy)/2) %>% head

# keep only average mileage between city and highway
transmute(mpg,cty,avg_mileage=(cty+hwy)/2) %>% head

# get average mileage grouped by engine cylinder
m <- mutate(mpg, avg_mileage=(cty+hwy)/2)
# behavior is actually different in R/RStudio compared to notebooks
m %>% group_by(cyl) %>%
    summarise(avg=mean(avg_mileage)) %>%
    head

group_by(m, drv) %>%
    summarise(avg=mean(avg_mileage))

# df after group_by would show that we have 9 groups
drv_cyl <- group_by(m, drv, cyl) %>%
    summarise(avg=mean(avg_mileage)) %>%
    arrange(desc(avg))
drv_cyl

drv_cyl %>% summarise(max=max(avg))

ungroup(drv_cyl) %>% summarise(max=max(avg))

ex2_df <- data.frame(x=c(5,2,NA,6),y=c(NA,5,10,3))

head(mpg) # automatically loaded when you load tidyverse

ggplot(mpg)

ggplot(mpg) + geom_point()

ggplot(mpg) + geom_point(mapping=aes(x=displ,y=hwy))

head(mpg)

p1 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color=class))
p2 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=class))
p3 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,size=class))
p4 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,alpha=class))
grid.arrange(p1,p2,p3,p4,nrow=2)

# for color property, all data points were assigned to 'blue', therefore ggplot2 assigns a single level to all of the
# points, which is red
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color='blue'))

# here color is placed outside aesthetic mapping, so ggplot2 understands that we want color of points to be blue
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy),color='blue')

# cty is a continuous variable, so when mapped to color we get a gradient with bins instead
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color=cty))

# if we try to map cyl to shape we get an error because shape is only for discrete variables
# even though we only have cyl=4,5,6 or 8
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=cyl))

# will transform into categorical variable with levels
as.factor(mpg$cyl)

# all is well when we use as.factor()
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=as.factor(cyl)))

ggplot(data=mpg) + geom_point()

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

# data has been separated into three lines based on their drivetrain: 4 (4wd), f (front), r (rear)
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = as.factor(cyl)))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color=drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color=drv, linetype=drv))

ggplot(data=mpg) +
    geom_smooth(mapping=aes(x=displ,y=hwy,group=drv))

# global mapping of displ and hwy creates x and yaxis
ggplot(data=mpg, mapping=aes(x=displ,y=hwy))

# mapping color to class for point geom while using global x and y mappings
ggplot(data=mpg, mapping=aes(x=displ,y=hwy)) + geom_point(mapping=aes(color=class))

# geom_smooth doesn't need any mapping arguments if using global
ggplot(data=mpg, mapping=aes(x=displ,y=hwy)) +
    geom_point(mapping=aes(color=class))+
    geom_smooth()

# second geom_smooth uses same x and y mapping
# but mapping comes from no_2seaters data (from Transform section) instead
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth() +
  geom_smooth(data = no_2seaters)

ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, nrow=2)

ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, nrow=3)

ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, ncol=4)

# some facets are empty because no observations have those combos
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data=mpg) +
    geom_bar(mapping=aes(x=class))

ggplot(data=mpg) +
    stat_count(mapping=aes(x=class))
?geom_bar

# because stat_count() computes count and prop, can use those as variables for mapping as well
ggplot(data=mpg) + geom_bar(mapping=aes(x=class, y=..prop..,group=1))

# stat_summary is associated with geom_pointrange
# default is to compute mean and standard error
ggplot(data = mpg) + 
  stat_summary(mapping = aes(x=class,y=hwy))

# can change stat_summary to compute median and min/max instead
ggplot(data = mpg) +
  stat_summary(
    mapping = aes(x = class, y = hwy),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )

p1 <- ggplot(data = mpg, mapping=aes(x=class,fill=as.factor(cyl)))
p1 + geom_bar()

# position = identity will place each object exactly where it falls in context of graph.
# Not useful for bar charts, better for scatterplots.
p1 + geom_bar(position="identity", alpha=0.2)

# position = fill will make bars same height
p1 + geom_bar(position="fill")

# position = "dodge" places objects directly beside one another. Easier to compare individual values.
p1 + geom_bar(position="dodge")

# seems quite uniform which suggests multiple observations with same value of cty/hwy
# creating overlapping points
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()

# definitely the case
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position="jitter")

p <- ggplot(data = mpg, mapping = aes(x = class, y = hwy))
p + geom_boxplot()

# flipping coordinates
p + geom_boxplot() + coord_flip()

# can reorder x axis by lowest to highest median hwy mileage
# allows easier comparisons
ggplot(data = mpg, mapping = aes(x = reorder(class,hwy,FUN=median), y = hwy)) + 
  geom_boxplot() +
  coord_flip()

# Setting aspect ratio correctly
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# polar coordinates
bar <- ggplot(data = mpg) + 
  geom_bar(
    mapping = aes(x = class, fill = as.factor(cyl)), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

p1 <- bar + coord_flip()
p2 <- bar + coord_polar()
grid.arrange(p1,p2, nrow=1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally\n decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    color = "Car type"
  )

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class) +
  labs(
    caption = "Data from fueleconomy.gov",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  ) +
  geom_point(size = 3, shape = 1, data = best_in_class)

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

p1 <- ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_manual(values=c(`4`="red",f="blue",r="blue"))

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

#p1 <- base + theme(legend.position = "left")
#p2 <- base + theme(legend.position = "top")
#p3 <- base + theme(legend.position = "bottom")
#p4 <- base + theme(legend.position = "right")

#?theme
base + theme(text=element_text(color="blue",size=4))

#grid.arrange(p1,p2,p3,p4, nrow=2)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 4)))

# asetting xlim and ylim in coord_cartesian
ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))

# adjusting what data are plotted
# however geom_smooth will plot regression over subsetted data
filter(mpg, displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()

# 2 plots use subsetted data therefore have different scales along hwy and displ
suv <- mpg %>% filter(class == "suv")
compact <- mpg %>% filter(class == "compact")
ggplot(suv, aes(displ, hwy, colour = drv)) +
  geom_point()

ggplot(compact, aes(displ, hwy, colour = drv)) +
  geom_point()

# can set limits in each scale
x_scale <- scale_x_continuous(limits = range(mpg$displ))
y_scale <- scale_y_continuous(limits = range(mpg$hwy))
col_scale <- scale_colour_discrete(limits = unique(mpg$drv))

ggplot(suv, aes(displ, hwy, colour = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

ggplot(compact, aes(displ, hwy, colour = drv)) +
  geom_point() +
  x_scale +
  y_scale +
  col_scale

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE)

p1 <- base + theme_bw()
p2 <- base + theme_light()
p3 <- base + theme_classic()
p4 <- base + theme_linedraw()
p5 <- base + theme_dark()
p6 <- base + theme_minimal()
p7 <- base + theme_void()

grid.arrange(base,p1,p2,p3,p4,p5,p6,p7,nrow=4)

p1 <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(x="Engine displacement (L)",y="Heighway fuel economy (mpg)",
    title = "Fuel efficiency generally decreases with engine size",
    caption = "Data from fueleconomy.gov",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    colour = "Car type"
  ) + x_scale + y_scale + theme_classic()
p1
ggsave("my_plot.pdf")

tiff("my_plot.tiff",width=7,height=5,units="in",pointsize=8,res=350)
p1
dev.off()

rowMeans(ex2_df)
rowMeans(ex2_df,na.rm=TRUE)
mutate(mpg, avg_mileage = rowMeans(select(mpg,cty,hwy),na.rm=TRUE)) %>%
    head

separate(mpg,trans,into=c('trans',NA),sep='\\(') %>%
    group_by(manufacturer, model, cyl,trans) %>%
    mutate(imp=cty-mean(cty)) %>%
    filter(year==2008,imp>1)

ggplot(mpg) + geom_point(aes(x=cyl,y=hwy))

sessionInfo()


