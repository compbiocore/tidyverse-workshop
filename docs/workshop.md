
# Preamble

Most of this workshop is taken from Hadley's [R for Data Science](https://r4ds.had.co.nz/) book. You can find more examples, explanations and exercises there if you want.

## What this workshop covers and does not cover

In this workshop you'll learn principles behind exploratory data analysis and visualization, including tidying and transforming data to answer questions you might want to ask. What you will *not* learn is how to make specific plots.

# Package prerequisites

Packages that required in this workshop are **tidyverse**, which includes the packages **ggplot2**, **dplyr**, **purrr**, and others, **gridExtra** which helps with arranging plots next to each other, **ggrepel** which helps with plot labels and **maps** which is for map data.


```R
library(tidyverse)
library(gridExtra)
library(ggrepel)
library(maps)
```

    ── Attaching packages ─────────────────────────────────────── tidyverse 1.2.1 ──
    ✔ ggplot2 3.1.0       ✔ purrr   0.3.0  
    ✔ tibble  2.0.1       ✔ dplyr   0.8.0.1
    ✔ tidyr   0.8.2       ✔ stringr 1.4.0  
    ✔ readr   1.3.1       ✔ forcats 0.4.0  
    Warning message:
    “package ‘tibble’ was built under R version 3.5.2”Warning message:
    “package ‘purrr’ was built under R version 3.5.2”Warning message:
    “package ‘dplyr’ was built under R version 3.5.2”Warning message:
    “package ‘stringr’ was built under R version 3.5.2”Warning message:
    “package ‘forcats’ was built under R version 3.5.2”── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ✖ dplyr::filter() masks stats::filter()
    ✖ dplyr::lag()    masks stats::lag()
    
    Attaching package: ‘gridExtra’
    
    The following object is masked from ‘package:dplyr’:
    
        combine
    
    
    Attaching package: ‘maps’
    
    The following object is masked from ‘package:purrr’:
    
        map
    


If you get an error message “there is no package called ‘xyz’” then you need to install the packages first. (They should have been preloaded on your notebooks but if not it's ok, it won't take long.)


```R
#install.packages('tidyverse')
#install.packages('gridExtra')
#install.packages('ggrepel')
#install.packages('map')
```

# Visualizing Data

Core feature of exploratory data analysis is asking questions about data and searching for answers by visualizing and modeling data. Most questions around what type of variation or covariation occurs between variables.


```R
options(repr.plot.width=6, repr.plot.height=4)
# regular plot functions in R
plot(x=mpg$displ,y=mpg$hwy)
```


![png](workshop_files/workshop_5_0.png)



```R
# ggplot!
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy))
```


![png](workshop_files/workshop_6_0.png)


Basic syntax of ggplot:
```
ggplot(data=<DATA>) +
    <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)
```


```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(x="Engine displacement (L)",y="Heighway fuel economy (mpg)",
    title = "Fuel efficiency generally decreases with engine size",
    caption = "Data from fueleconomy.gov",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    colour = "Car type"
  ) + theme_classic()
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_8_1.png)


## But first...

```
ggplot(data=<DATA>) +
    <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)
```

How do we get data into a form appropriate for **ggplot2**?

# Tidying Data

Most datasets are data frames made up of **rows** and **columns**. However, talking about data frames just in terms of what rows and columns it has is not enough.

 * **Variable:** quantity, quality, property that can be measured.
 * **Value:** State of variable when measured.
 * **Observation:** Set of measurements made under similar conditions
 * **Tabular data:** Set of values, each associated with a variable and an observation.

Tidy data:
 * Each variable is its own column
 * Each observation is its own row
 * Each value is in a single cell
 
Benefits:
 * Easy to manipulate
 * Easy to model
 * Easy to visualize
 * Has a specific and consistent structure
 * Stucture makes it easy to tidy other data
 
Cons:
 * Data frame is not as easy to look at

Consider the following tables:


```R
table1 <- data.frame(makemodel=c("audi a4","audi a4","chevrolet corvette","chevrolet corvette","honda civic","honda civic"),
                    year=rep(c(1999,2008),3),
                    cty=c(18,21,15,15,24,25),
                    hwy=c(29,30,23,25,32,36))
table1
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td><td>29                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td><td>23                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td><td>32                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td><td>36                </td></tr>
</tbody>
</table>



This is tidy data, because each column is a variable, each observation is a row, and each value is in a single cell

Next we will look at some non-tidy data and operations from the **tidyr** package (part of **tidyverse**) to make the data tidy. Many of you might be more used to using operations from **reshape2** like melting and casting. It's a very useful package with more functionality including aggregating data, but syntax with **tidyr** commands is more simpler and intuitive for the purposes of tidying data.

## Gathering


```R
table2a <- data.frame(makemodel=c("audi a4","chevrolet corvette","honda civic"),`1999`=c(18,15,24),'2008'=c(21,15,25),check.names=FALSE)
table2b <- data.frame(makemodel=c("audi a4","chevrolet corvette","honda civic"),`1999`=c(29,23,32),'2008'=c(30,25,36),check.names=FALSE)
table2a
table2b
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>1999</th><th scope=col>2008</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>18                </td><td>21                </td></tr>
	<tr><td>chevrolet corvette</td><td>15                </td><td>15                </td></tr>
	<tr><td>honda civic       </td><td>24                </td><td>25                </td></tr>
</tbody>
</table>




<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>1999</th><th scope=col>2008</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>29                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>23                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>32                </td><td>36                </td></tr>
</tbody>
</table>



`table2a` column names `1999` and `2008` represent values of `year` variable. `table2b` is the same. Each row represents 2 observations, not 1. Need to gather columns into new pair of variables.

Parameters:
 * Set of columns that represent values, not variables.
 * `key`: name of variable whose values are currently column names.
 * `value`: name of variable whose values are currently spread out across multiple columns.

Experiments often report data in the format of `table4a` and `table4b`. One reason is for presentation purposes it's very easy to look at. Another is storage is efficient for completely crossed designs and can allow matrix operations.


```R
tidy2a <- gather(table2a,`1999`,`2008`,key="year",value="cty")
tidy2a
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td></tr>
</tbody>
</table>




```R
tidy2b <- gather(table2b, `1999`, `2008`, key = "year", value = "hwy")
tidy2b
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>29                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>23                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>32                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>36                </td></tr>
</tbody>
</table>



Merge tables using `left_join()` (many other types of [table joins](https://dplyr.tidyverse.org/reference/join.html) as well)


```R
left_join(tidy2a,tidy2b)
```

    Joining, by = c("makemodel", "year")



<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td><td>29                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td><td>23                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td><td>32                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td><td>36                </td></tr>
</tbody>
</table>



## Spreading


```R
table3 <- data.frame(makemodel=c(rep("audi a4",4),rep("chevrolet corvette",4),rep("honda civic",4)),
                    year=rep(c(1999,1999,2008,2008),3),
                    type=rep(c("cty","hwy"),6),
                     mileage=c(18,29,21,30,15,23,15,25,24,32,25,36))
table3
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>type</th><th scope=col>mileage</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>cty               </td><td>18                </td></tr>
	<tr><td>audi a4           </td><td>1999              </td><td>hwy               </td><td>29                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>cty               </td><td>21                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>hwy               </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>cty               </td><td>15                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>hwy               </td><td>23                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>cty               </td><td>15                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>hwy               </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>cty               </td><td>24                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>hwy               </td><td>32                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>cty               </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>hwy               </td><td>36                </td></tr>
</tbody>
</table>



`table3` has each observation in two rows. Need to spread observations across columns with appropriate variable names instead.

Parameters:
 * `key`: Column that contains variable names.
 * `value`: Column that contains values for each variable.


```R
spread(table3, key=type,value=mileage)
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td><td>29                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td><td>23                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td><td>32                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td><td>36                </td></tr>
</tbody>
</table>



## Separating


```R
table4 <- data.frame(makemodel=c("audi a4","audi a4","chevrolet corvette","chevrolet corvette","honda civic","honda civic"),
                     year=rep(c(1999,2008),3),
                    mileages=c('18/29','21/30','15/23','15/25','24/32','25/36'))
table4
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>mileages</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18/29             </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21/30             </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15/23             </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15/25             </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24/32             </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25/36             </td></tr>
</tbody>
</table>



`table4` has `mileages` column that actually contains two variables (`cty` and `hwy`). Need to separate into two columns.

Parameters:
 * column/variable that needs to be separated.
 * `into`: columns to split into
 * `sep`: separator value. Can be regexp or positions to split at. If not provided then splits at non-alphanumeric characters.


```R
separate(table4, mileages, into = c("cty", "hwy"), sep="/")
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td><td>29                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td><td>23                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td><td>32                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td><td>36                </td></tr>
</tbody>
</table>




```R
sep <- separate(table4, makemodel, into = c("make", "model"), sep = ' ')
sep
```


<table>
<thead><tr><th scope=col>make</th><th scope=col>model</th><th scope=col>year</th><th scope=col>mileages</th></tr></thead>
<tbody>
	<tr><td>audi     </td><td>a4       </td><td>1999     </td><td>18/29    </td></tr>
	<tr><td>audi     </td><td>a4       </td><td>2008     </td><td>21/30    </td></tr>
	<tr><td>chevrolet</td><td>corvette </td><td>1999     </td><td>15/23    </td></tr>
	<tr><td>chevrolet</td><td>corvette </td><td>2008     </td><td>15/25    </td></tr>
	<tr><td>honda    </td><td>civic    </td><td>1999     </td><td>24/32    </td></tr>
	<tr><td>honda    </td><td>civic    </td><td>2008     </td><td>25/36    </td></tr>
</tbody>
</table>



## Uniting

Now `sep` has `make` and `model` columns that can be combined into a single column. In other words, we want to unite them.

Parameters:
 * Name of united column/variable
 * Names of columns/variables to be united
 * `sep`: Separator value. Default is '_'



```R
unite(sep, new, make, model)
```


<table>
<thead><tr><th scope=col>new</th><th scope=col>year</th><th scope=col>mileages</th></tr></thead>
<tbody>
	<tr><td>audi_a4           </td><td>1999              </td><td>18/29             </td></tr>
	<tr><td>audi_a4           </td><td>2008              </td><td>21/30             </td></tr>
	<tr><td>chevrolet_corvette</td><td>1999              </td><td>15/23             </td></tr>
	<tr><td>chevrolet_corvette</td><td>2008              </td><td>15/25             </td></tr>
	<tr><td>honda_civic       </td><td>1999              </td><td>24/32             </td></tr>
	<tr><td>honda_civic       </td><td>2008              </td><td>25/36             </td></tr>
</tbody>
</table>




```R
unite(sep, makemodel, make, model, sep=' ')
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>mileages</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18/29             </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21/30             </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15/23             </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15/25             </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24/32             </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25/36             </td></tr>
</tbody>
</table>



## Piping

**dplyr** from **tidyverse** contains the 'pipe' (`%>%`) which allows you to combine multiple operations, directly taking output from a funtion as input to the next. Can save time and memory as well as make code easier to read. Can think of it this way: `x %>% f(y)` becomes `f(x,y)`, and `x %>% f(y) %>% g(z)` becomes `g(f(x,y),z)`, etc.


```R
unite(sep, makemodel, make, model, sep=' ') %>%
    separate(mileages, into=c("cty","hwy"))
```


<table>
<thead><tr><th scope=col>makemodel</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi a4           </td><td>1999              </td><td>18                </td><td>29                </td></tr>
	<tr><td>audi a4           </td><td>2008              </td><td>21                </td><td>30                </td></tr>
	<tr><td>chevrolet corvette</td><td>1999              </td><td>15                </td><td>23                </td></tr>
	<tr><td>chevrolet corvette</td><td>2008              </td><td>15                </td><td>25                </td></tr>
	<tr><td>honda civic       </td><td>1999              </td><td>24                </td><td>32                </td></tr>
	<tr><td>honda civic       </td><td>2008              </td><td>25                </td><td>36                </td></tr>
</tbody>
</table>



## Not all data should be tidy

Matrices, phylogenetic trees (although `ggtree` and `treeio` have tidy representations that help with annotating trees), etc.

# Transforming (Tidy) Data

Now we know how to get tidy data. At this point we can already start visualizing our data. However in many cases we will need to further transform our data to narrow down variables and observations we are really interested in or to create new variables that are functions of our existing variables and data. This is known as **transforming** data.

 * `filter()` to pick observations (rows) by their values
 * `arrange()` to reorder rows, default is by ascending value
 * `select()` to pick variables (columns) by their names
 * `mutate()` to create new variables with functions of existing variables
 * `summarise()` to collapes many values down to a single summary
 * `group_by()` to set up functions to operate on groups rather than the whole data set
 * `%>%` propagates the output from a function as input to another. eg: x %>% f(y) becomes f(x,y), and x %>% f(y) %>% g(z) becomes g(f(x,y),z).
 
All functions have similar structure:
 1. First argument is data frame
 2. Next arguments describe what to do with data frame using variable names
 3. Result is new data frame
 
Will be working with data frame **mpg** for rest of workshop which comes with the **tidyverse** library.


```R
head(mpg)
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>



## `filter()` rows/observations

As name suggests filters out rows. First argument is name of data frame, next arguments are expressions that filter the data frame.


```R
# filter out 2seater cars
no_2seaters <- filter(mpg, class != "2seater")
head(no_2seaters)
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>




```R
# filter out audis, chevys, and hondas
mpg %>% filter(!manufacturer %in% c("audi","chevrolet","honda")) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>2.4        </td><td>1999       </td><td>4          </td><td>auto(l3)   </td><td>f          </td><td>18         </td><td>24         </td><td>r          </td><td>minivan    </td></tr>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>3.0        </td><td>1999       </td><td>6          </td><td>auto(l4)   </td><td>f          </td><td>17         </td><td>24         </td><td>r          </td><td>minivan    </td></tr>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>3.3        </td><td>1999       </td><td>6          </td><td>auto(l4)   </td><td>f          </td><td>16         </td><td>22         </td><td>r          </td><td>minivan    </td></tr>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>3.3        </td><td>1999       </td><td>6          </td><td>auto(l4)   </td><td>f          </td><td>16         </td><td>22         </td><td>r          </td><td>minivan    </td></tr>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>3.3        </td><td>2008       </td><td>6          </td><td>auto(l4)   </td><td>f          </td><td>17         </td><td>24         </td><td>r          </td><td>minivan    </td></tr>
	<tr><td>dodge      </td><td>caravan 2wd</td><td>3.3        </td><td>2008       </td><td>6          </td><td>auto(l4)   </td><td>f          </td><td>17         </td><td>24         </td><td>r          </td><td>minivan    </td></tr>
</tbody>
</table>



## `arrange()` rows/observations

Changes order of rows. First argument is name of data frame, next arguments are column names (or more complicated expressions) to order by. Default column ordering is by ascending order, can use `desc()` to do descending order. Missing values get sorted at the end regardless of what column ordering is chosen.


```R
# arrange/reorder mpg by class
arrange(mpg, class) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>chevrolet </td><td>corvette  </td><td>5.7       </td><td>1999      </td><td>8         </td><td>manual(m6)</td><td>r         </td><td>16        </td><td>26        </td><td>p         </td><td>2seater   </td></tr>
	<tr><td>chevrolet </td><td>corvette  </td><td>5.7       </td><td>1999      </td><td>8         </td><td>auto(l4)  </td><td>r         </td><td>15        </td><td>23        </td><td>p         </td><td>2seater   </td></tr>
	<tr><td>chevrolet </td><td>corvette  </td><td>6.2       </td><td>2008      </td><td>8         </td><td>manual(m6)</td><td>r         </td><td>16        </td><td>26        </td><td>p         </td><td>2seater   </td></tr>
	<tr><td>chevrolet </td><td>corvette  </td><td>6.2       </td><td>2008      </td><td>8         </td><td>auto(s6)  </td><td>r         </td><td>15        </td><td>25        </td><td>p         </td><td>2seater   </td></tr>
	<tr><td>chevrolet </td><td>corvette  </td><td>7.0       </td><td>2008      </td><td>8         </td><td>manual(m6)</td><td>r         </td><td>15        </td><td>24        </td><td>p         </td><td>2seater   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>




```R
# arrange/reorder data frame with 2seaters filtered out by class
# 2seaters does not appear which is as it should be
arrange(no_2seaters, class) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>



What kinds of cars have the best highway and city gas mileage?


```R
# arrange mpg so that first hwy mileage is by descending order, then cty mileage is by descending order
arrange(mpg, desc(hwy), desc(cty)) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>volkswagen</td><td>new beetle</td><td>1.9       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>35        </td><td>44        </td><td>d         </td><td>subcompact</td></tr>
	<tr><td>volkswagen</td><td>jetta     </td><td>1.9       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>33        </td><td>44        </td><td>d         </td><td>compact   </td></tr>
	<tr><td>volkswagen</td><td>new beetle</td><td>1.9       </td><td>1999      </td><td>4         </td><td>auto(l4)  </td><td>f         </td><td>29        </td><td>41        </td><td>d         </td><td>subcompact</td></tr>
	<tr><td>toyota    </td><td>corolla   </td><td>1.8       </td><td>2008      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>28        </td><td>37        </td><td>r         </td><td>compact   </td></tr>
	<tr><td>honda     </td><td>civic     </td><td>1.8       </td><td>2008      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>25        </td><td>36        </td><td>r         </td><td>subcompact</td></tr>
	<tr><td>honda     </td><td>civic     </td><td>1.8       </td><td>2008      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>24        </td><td>36        </td><td>c         </td><td>subcompact</td></tr>
</tbody>
</table>



Example of missing data getting placed at bottom.


```R
df <- data.frame(x=c(5,2,NA,6))
df
```


<table>
<thead><tr><th scope=col>x</th></tr></thead>
<tbody>
	<tr><td> 5</td></tr>
	<tr><td> 2</td></tr>
	<tr><td>NA</td></tr>
	<tr><td> 6</td></tr>
</tbody>
</table>




```R
# arrange df by ascending order, NA will be at bottom
arrange(df, x)
```


<table>
<thead><tr><th scope=col>x</th></tr></thead>
<tbody>
	<tr><td> 2</td></tr>
	<tr><td> 5</td></tr>
	<tr><td> 6</td></tr>
	<tr><td>NA</td></tr>
</tbody>
</table>




```R
# arrange df by descending order, NA will be at bottom
arrange(df, desc(x))
```


<table>
<thead><tr><th scope=col>x</th></tr></thead>
<tbody>
	<tr><td> 6</td></tr>
	<tr><td> 5</td></tr>
	<tr><td> 2</td></tr>
	<tr><td>NA</td></tr>
</tbody>
</table>



If you want to bring `NA` to the top, you can instead use `!is.na(x)` which evaluates as a boolean, so FALSE/TRUE. The df gets arranged by FALSE first, so NA goes to the top. However the rest of the values are unsorted since they will all return TRUE, although you can add more arguments to sort by the same column. This can be done for any other variable you want to use to rearrange with boolean expressions instead.


```R
# rest of the values are unsorted because they are all T for !is.na(x)
arrange(df,!is.na(x))
```


<table>
<thead><tr><th scope=col>x</th></tr></thead>
<tbody>
	<tr><td>NA</td></tr>
	<tr><td> 5</td></tr>
	<tr><td> 2</td></tr>
	<tr><td> 6</td></tr>
</tbody>
</table>




```R
# can arrange by x again to get ascending order
arrange(df,!is.na(x),x)
```


<table>
<thead><tr><th scope=col>x</th></tr></thead>
<tbody>
	<tr><td>NA</td></tr>
	<tr><td> 2</td></tr>
	<tr><td> 5</td></tr>
	<tr><td> 6</td></tr>
</tbody>
</table>



## `select()` columns/variables

Selects columns, which can be useful when you have hundreds or thousands of variables in order to narrow down to what variables you're actually interested in. First argument is name of data frame, subsequent arguments are columns to select. Can use `a:b` to select all columns between `a` and `b`, or use `-a` to select all columns *except* a.


```R
# select manufacturer, model, year, cty, hwy
select(mpg, manufacturer, model, year, cty, hwy) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>audi</td><td>a4  </td><td>1999</td><td>18  </td><td>29  </td></tr>
	<tr><td>audi</td><td>a4  </td><td>1999</td><td>21  </td><td>29  </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2008</td><td>20  </td><td>31  </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2008</td><td>21  </td><td>30  </td></tr>
	<tr><td>audi</td><td>a4  </td><td>1999</td><td>16  </td><td>26  </td></tr>
	<tr><td>audi</td><td>a4  </td><td>1999</td><td>18  </td><td>26  </td></tr>
</tbody>
</table>




```R
# select all columns model thru hwy
select(mpg, model:hwy) %>% head
```


<table>
<thead><tr><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th></tr></thead>
<tbody>
	<tr><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td></tr>
	<tr><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td></tr>
	<tr><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td></tr>
	<tr><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td></tr>
	<tr><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td></tr>
	<tr><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td></tr>
</tbody>
</table>




```R
# select all columns except cyl thru drv and class
select(mpg, -(cyl:drv), -class) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th></tr></thead>
<tbody>
	<tr><td>audi</td><td>a4  </td><td>1.8 </td><td>1999</td><td>18  </td><td>29  </td><td>p   </td></tr>
	<tr><td>audi</td><td>a4  </td><td>1.8 </td><td>1999</td><td>21  </td><td>29  </td><td>p   </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2.0 </td><td>2008</td><td>20  </td><td>31  </td><td>p   </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2.0 </td><td>2008</td><td>21  </td><td>30  </td><td>p   </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2.8 </td><td>1999</td><td>16  </td><td>26  </td><td>p   </td></tr>
	<tr><td>audi</td><td>a4  </td><td>2.8 </td><td>1999</td><td>18  </td><td>26  </td><td>p   </td></tr>
</tbody>
</table>



## `mutate()` to add new variables or `transmute()` to keep only new variables

Adds new columns that are functions of existing columns. First argument is name of data frame, next arguments are of the form `new_column_name = f(existing columns)`.


```R
# add a new column that takes average mileage between city and highway
mutate(mpg, avg_mileage = (cty+hwy)/2) %>% head
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th><th scope=col>avg_mileage</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td><td>23.5      </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td><td>25.0      </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td><td>25.5      </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td><td>25.5      </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td><td>21.0      </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td><td>22.0      </td></tr>
</tbody>
</table>




```R
# keep only average mileage between city and highway
transmute(mpg,avg_mileage=(cty+hwy)/2) %>% head
```


<table>
<thead><tr><th scope=col>avg_mileage</th></tr></thead>
<tbody>
	<tr><td>23.5</td></tr>
	<tr><td>25.0</td></tr>
	<tr><td>25.5</td></tr>
	<tr><td>25.5</td></tr>
	<tr><td>21.0</td></tr>
	<tr><td>22.0</td></tr>
</tbody>
</table>



## `summarise()` and `group_by()` for grouped summaries

`summarise()` collapses a data frame into a single row, and `group_by()` changes analysis from entire data frame into individual groups.


```R
# get average mileage grouped by engine cylinder
m <- mutate(mpg, avg_mileage=(cty+hwy)/2)
# behavior is actually different in R/RStudio compared to notebooks
m %>% group_by(cyl) %>%
    summarise(avg=mean(avg_mileage)) %>%
    head
```


<table>
<thead><tr><th scope=col>cyl</th><th scope=col>avg</th></tr></thead>
<tbody>
	<tr><td>4       </td><td>24.90741</td></tr>
	<tr><td>5       </td><td>24.62500</td></tr>
	<tr><td>6       </td><td>19.51899</td></tr>
	<tr><td>8       </td><td>15.10000</td></tr>
</tbody>
</table>



**Note:** If you look at the output of `group_by` in R/RStudio you will actually be able to see what your groupings are as well as how many of them you have. For example if we did `group_by(mpg, cyl)` the output would include `cyl [4]` which shows that our grouping is by `cyl` and there are 4 groups. Jupyter notebook doesn't display this for reasons having to do with [how data frames are outputted](https://github.com/IRkernel/repr/issues/113). Some other differences exist between how certain objects from **tidyverse** are displayed as well.


```R
group_by(m, drv) %>%
    summarise(avg=mean(avg_mileage))
```


<table>
<thead><tr><th scope=col>drv</th><th scope=col>avg</th></tr></thead>
<tbody>
	<tr><td>4       </td><td>16.75243</td></tr>
	<tr><td>f       </td><td>24.06604</td></tr>
	<tr><td>r       </td><td>17.54000</td></tr>
</tbody>
</table>




```R
# df after group_by would show that we have 9 groups
drv_cyl <- group_by(m, drv, cyl) %>%
    summarise(avg=mean(avg_mileage)) %>%
    arrange(desc(avg))
drv_cyl
```


<table>
<thead><tr><th scope=col>drv</th><th scope=col>cyl</th><th scope=col>avg</th></tr></thead>
<tbody>
	<tr><td>f       </td><td>4       </td><td>26.26724</td></tr>
	<tr><td>f       </td><td>5       </td><td>24.62500</td></tr>
	<tr><td>4       </td><td>4       </td><td>21.47826</td></tr>
	<tr><td>r       </td><td>6       </td><td>21.25000</td></tr>
	<tr><td>f       </td><td>6       </td><td>21.12791</td></tr>
	<tr><td>f       </td><td>8       </td><td>20.50000</td></tr>
	<tr><td>4       </td><td>6       </td><td>17.14062</td></tr>
	<tr><td>r       </td><td>8       </td><td>16.83333</td></tr>
	<tr><td>4       </td><td>8       </td><td>14.22917</td></tr>
</tbody>
</table>



Can also run `ungroup` to ungroup your observations.


```R
drv_cyl %>% summarise(max=max(avg))
```


<table>
<thead><tr><th scope=col>drv</th><th scope=col>max</th></tr></thead>
<tbody>
	<tr><td>4       </td><td>21.47826</td></tr>
	<tr><td>f       </td><td>26.26724</td></tr>
	<tr><td>r       </td><td>21.25000</td></tr>
</tbody>
</table>




```R
ungroup(drv_cyl) %>% summarise(max=max(avg))
```


<table>
<thead><tr><th scope=col>max</th></tr></thead>
<tbody>
	<tr><td>26.26724</td></tr>
</tbody>
</table>



# Back to Visualizing Data

Basic syntax of ggplot:
```
ggplot(data=<DATA>) +
    <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)
```


```R
head(mpg) # automatically loaded when you load tidyverse
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>



Let's break down the components of ggplot. First, note that `ggplot(data=<DATA>)` on its own will not actually plot anything.


```R
ggplot(mpg)
```


![png](workshop_files/workshop_70_0.png)


This is because we need the `<GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)` to tell us what exactly to plot using our data. However, just `ggplot(data=<DATA>) + <GEOM_FUNCTION>()` on its own doesn't do anything either.


```R
ggplot(mpg) + geom_point()
```

    ERROR while rich displaying an object: Error: geom_point requires the following missing aesthetics: x, y
    
    Traceback:
    1. FUN(X[[i]], ...)
    2. tryCatch(withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler), error = outer_handler)
    3. tryCatchList(expr, classes, parentenv, handlers)
    4. tryCatchOne(expr, names, parentenv, handlers[[1L]])
    5. doTryCatch(return(expr), name, parentenv, handler)
    6. withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler)
    7. repr::mime2repr[[mime]](obj)
    8. repr_text.default(obj)
    9. paste(capture.output(print(obj)), collapse = "\n")
    10. capture.output(print(obj))
    11. evalVis(expr)
    12. withVisible(eval(expr, pf))
    13. eval(expr, pf)
    14. eval(expr, pf)
    15. print(obj)
    16. print.ggplot(obj)
    17. ggplot_build(x)
    18. ggplot_build.ggplot(x)
    19. by_layer(function(l, d) l$compute_geom_1(d))
    20. f(l = layers[[i]], d = data[[i]])
    21. l$compute_geom_1(d)
    22. f(..., self = self)
    23. check_required_aesthetics(self$geom$required_aes, c(names(data), 
      .     names(self$aes_params)), snake_class(self$geom))
    24. stop(name, " requires the following missing aesthetics: ", paste(missing_aes, 
      .     collapse = ", "), call. = FALSE)



![png](workshop_files/workshop_72_1.png)


So in fact we need *all* of the components described in the ggplot syntax.


```R
ggplot(mpg) + geom_point(mapping=aes(x=displ,y=hwy))
```


![png](workshop_files/workshop_74_0.png)


## `<MAPPINGS>`

```
ggplot(data=<DATA>) +
    <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)
```

Visual property of objects in plot, i.e. size, shape, color. Can display points from other variables (in this case class) in different ways by changing value of aesthetic properties. These are known as **levels**, which is done in order to distinguish aesthetic values from data values.


```R
head(mpg)
```


<table>
<thead><tr><th scope=col>manufacturer</th><th scope=col>model</th><th scope=col>displ</th><th scope=col>year</th><th scope=col>cyl</th><th scope=col>trans</th><th scope=col>drv</th><th scope=col>cty</th><th scope=col>hwy</th><th scope=col>fl</th><th scope=col>class</th></tr></thead>
<tbody>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>auto(l5)  </td><td>f         </td><td>18        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>1.8       </td><td>1999      </td><td>4         </td><td>manual(m5)</td><td>f         </td><td>21        </td><td>29        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>manual(m6)</td><td>f         </td><td>20        </td><td>31        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.0       </td><td>2008      </td><td>4         </td><td>auto(av)  </td><td>f         </td><td>21        </td><td>30        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>auto(l5)  </td><td>f         </td><td>16        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
	<tr><td>audi      </td><td>a4        </td><td>2.8       </td><td>1999      </td><td>6         </td><td>manual(m5)</td><td>f         </td><td>18        </td><td>26        </td><td>p         </td><td>compact   </td></tr>
</tbody>
</table>




```R
p1 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color=class))
p2 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=class))
p3 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,size=class))
p4 <- ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,alpha=class))
grid.arrange(p1,p2,p3,p4,nrow=2)
```

    Warning message:
    “The shape palette can deal with a maximum of 6 discrete values because
    more than 6 becomes difficult to discriminate; you have 7. Consider
    specifying shapes manually if you must have them.”Warning message:
    “Removed 62 rows containing missing values (geom_point).”Warning message:
    “Using size for a discrete variable is not advised.”Warning message:
    “Using alpha for a discrete variable is not advised.”


![png](workshop_files/workshop_77_1.png)


### Levels

**ggplot2** automatically assigns a unique level of an aesthetic to a unique value of the variable. This process is known as scaling. It will also automatically select a scale to use with the aesthetic (i.e. continuous or discrete) as well as add a legend explaining the mapping between levels and values. That's why in the size mapping there's no shape for suv, and why the following two pieces of code do different things:


```R
# for color property, all data points were assigned to 'blue', therefore ggplot2 assigns a single level to all of the
# points, which is red
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color='blue'))
```


![png](workshop_files/workshop_79_0.png)



```R
# here color is placed outside aesthetic mapping, so ggplot2 understands that we want color of points to be blue
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy),color='blue')
```


![png](workshop_files/workshop_80_0.png)



```R
# cty is a continuous variable, so when mapped to color we get a gradient with bins instead
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,color=cty))
```


![png](workshop_files/workshop_81_0.png)


### Continuous vs discrete scales

Generally continuous scales get chosen for numerical data and discrete scales are chosen for categorical data. If your data is numeric but in discrete categories you may have to use `as.factor()` in order to get proper levels.


```R
# if we try to map cyl to shape we get an error because shape is only for discrete variables
# even though we only have cyl=4,5,6 or 8
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=cyl))
```

    ERROR while rich displaying an object: Error: A continuous variable can not be mapped to shape
    
    Traceback:
    1. FUN(X[[i]], ...)
    2. tryCatch(withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler), error = outer_handler)
    3. tryCatchList(expr, classes, parentenv, handlers)
    4. tryCatchOne(expr, names, parentenv, handlers[[1L]])
    5. doTryCatch(return(expr), name, parentenv, handler)
    6. withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler)
    7. repr::mime2repr[[mime]](obj)
    8. repr_text.default(obj)
    9. paste(capture.output(print(obj)), collapse = "\n")
    10. capture.output(print(obj))
    11. evalVis(expr)
    12. withVisible(eval(expr, pf))
    13. eval(expr, pf)
    14. eval(expr, pf)
    15. print(obj)
    16. print.ggplot(obj)
    17. ggplot_build(x)
    18. ggplot_build.ggplot(x)
    19. by_layer(function(l, d) l$compute_aesthetics(d, plot))
    20. f(l = layers[[i]], d = data[[i]])
    21. l$compute_aesthetics(d, plot)
    22. f(..., self = self)
    23. scales_add_defaults(plot$scales, data, aesthetics, plot$plot_env)
    24. scales$add(find_scale(aes, datacols[[aes]], env))
    25. f(..., self = self)
    26. find_scale(aes, datacols[[aes]], env)
    27. scale_f()
    28. stop("A continuous variable can not be mapped to shape", call. = FALSE)



![png](workshop_files/workshop_83_1.png)



```R
# will transform into categorical variable with levels
as.factor(mpg$cyl)
```


<ol class=list-inline>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>8</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>8</li>
	<li>8</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>5</li>
	<li>5</li>
	<li>6</li>
	<li>6</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>5</li>
	<li>5</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>4</li>
	<li>6</li>
	<li>6</li>
	<li>6</li>
</ol>

<details>
	<summary style=display:list-item;cursor:pointer>
		<strong>Levels</strong>:
	</summary>
	<ol class=list-inline>
		<li>'4'</li>
		<li>'5'</li>
		<li>'6'</li>
		<li>'8'</li>
	</ol>
</details>



```R
# all is well when we use as.factor()
ggplot(data=mpg) + geom_point(mapping=aes(x=displ,y=hwy,shape=as.factor(cyl)))
```


![png](workshop_files/workshop_85_0.png)


Note that this means x and y are aesthetic mappings as well. In fact without them you will get an error.


```R
ggplot(data=mpg) + geom_point()
```

    ERROR while rich displaying an object: Error: geom_point requires the following missing aesthetics: x, y
    
    Traceback:
    1. FUN(X[[i]], ...)
    2. tryCatch(withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler), error = outer_handler)
    3. tryCatchList(expr, classes, parentenv, handlers)
    4. tryCatchOne(expr, names, parentenv, handlers[[1L]])
    5. doTryCatch(return(expr), name, parentenv, handler)
    6. withCallingHandlers({
     .     if (!mime %in% names(repr::mime2repr)) 
     .         stop("No repr_* for mimetype ", mime, " in repr::mime2repr")
     .     rpr <- repr::mime2repr[[mime]](obj)
     .     if (is.null(rpr)) 
     .         return(NULL)
     .     prepare_content(is.raw(rpr), rpr)
     . }, error = error_handler)
    7. repr::mime2repr[[mime]](obj)
    8. repr_text.default(obj)
    9. paste(capture.output(print(obj)), collapse = "\n")
    10. capture.output(print(obj))
    11. evalVis(expr)
    12. withVisible(eval(expr, pf))
    13. eval(expr, pf)
    14. eval(expr, pf)
    15. print(obj)
    16. print.ggplot(obj)
    17. ggplot_build(x)
    18. ggplot_build.ggplot(x)
    19. by_layer(function(l, d) l$compute_geom_1(d))
    20. f(l = layers[[i]], d = data[[i]])
    21. l$compute_geom_1(d)
    22. f(..., self = self)
    23. check_required_aesthetics(self$geom$required_aes, c(names(data), 
      .     names(self$aes_params)), snake_class(self$geom))
    24. stop(name, " requires the following missing aesthetics: ", paste(missing_aes, 
      .     collapse = ", "), call. = FALSE)



![png](workshop_files/workshop_87_1.png)


## `<GEOM_FUNCTION>`

```
ggplot(data=<DATA>) +
    <GEOM_FUNCTION>(mapping=aes(<MAPPINGS>)
```

**geom** geometrical object plot uses to represent data. Bar charts use bar geoms, line charts use line geoms, boxplots, etc. Scatterplots use point geoms. Full list of geoms provided with **ggplot2** can be seen in [ggplot2 reference](https://ggplot2.tidyverse.org/reference/#section-layer-geoms). Also exist other geoms created by [other packages](http://www.ggplot2-exts.org/gallery/).

Every geom function in ggplot2 takes a `mapping` argument with specific aesthetic mappings that are possible. Not every aesthetic will work with every geom. For example, can set shape of a point, but not shape of a line. However, can set linetype of a line.


```R
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_89_1.png)



```R
# data has been separated into three lines based on their drivetrain: 4 (4wd), f (front), r (rear)
ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_90_1.png)


Can display multiple geoms on same plot just by adding them


```R
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color=drv)) +
  geom_smooth(mapping = aes(x = displ, y = hwy, color=drv, linetype=drv))
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_92_1.png)


Geoms like `geom_smooth()` use single geometric object to display multiple rows of data. If you don't necessarily want to add other distinguishing features to the geom like color, can use `group` aesthetic (for a categorical variable) to draw multiple objects.


```R
ggplot(data=mpg) +
    geom_smooth(mapping=aes(x=displ,y=hwy,group=drv))
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_94_1.png)


### Global mappings vs local mappings

`ggplot()` function contains *global* mapping, while each geom has a local mapping

 * `lm` from **stats** for linear models (you can also fit other models)


```R
# global mapping of displ and hwy creates x and yaxis
ggplot(data=mpg, mapping=aes(x=displ,y=hwy))
```


![png](workshop_files/workshop_96_0.png)



```R
# mapping color to class for point geom while using global x and y mappings
ggplot(data=mpg, mapping=aes(x=displ,y=hwy)) + geom_point(mapping=aes(color=class))
```


![png](workshop_files/workshop_97_0.png)



```R
# geom_smooth doesn't need any mapping arguments if using global
ggplot(data=mpg, mapping=aes(x=displ,y=hwy)) +
    geom_point(mapping=aes(color=class))+
    geom_smooth()
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_98_1.png)



```R
# second geom_smooth uses same x and y mapping
# but mapping comes from no_2seaters data (from Transform section) instead
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth() +
  geom_smooth(data = no_2seaters)
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'
    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_99_1.png)


## More syntax

```{r}
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

## Facets

Subplots displaying one subset of data.

 * `facet_wrap()` for a single variable.
 * `facet_grid()` for along 2 variables.


```R
ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, nrow=2)
```


![png](workshop_files/workshop_102_0.png)



```R
ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, nrow=3)
```


![png](workshop_files/workshop_103_0.png)



```R
ggplot(data=mpg) +
    geom_point(mapping=aes(x=displ,y=hwy)) +
    facet_wrap(~ class, ncol=4)
```


![png](workshop_files/workshop_104_0.png)



```R
# some facets are empty because no observations have those combos
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
```


![png](workshop_files/workshop_105_0.png)


## Stats

```{r}
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

Algorithm used to calculate new values for a graph. Each geom object has a default stat, and each stat has a default geom. Geoms like `geom_point()` will leave data as is, known as `stat_identity()`. Graphs like bar charts and histograms will bin your data and compute bin counts, known as `stat_count()`. Can see full list of stats at [ggplot2 reference](https://ggplot2.tidyverse.org/reference/) under both Layer: geoms and Layer: stats.


```R
ggplot(data=mpg) +
    geom_bar(mapping=aes(x=class))
```


![png](workshop_files/workshop_107_0.png)


Since each stat comes with a default geom, can use stat to create geoms on plots as well.


```R
ggplot(data=mpg) +
    stat_count(mapping=aes(x=class))
```


![png](workshop_files/workshop_109_0.png)



```R
# because stat_count() computes count and prop, can use those as variables for mapping as well
ggplot(data=mpg) + geom_bar(mapping=aes(x=class, y=..prop..,group=1))
```


![png](workshop_files/workshop_110_0.png)



```R
# stat_summary is associated with geom_pointrange
# default is to compute mean and standard error
ggplot(data = mpg) + 
  stat_summary(mapping = aes(x=class,y=hwy))
```

    No summary function supplied, defaulting to `mean_se()



![png](workshop_files/workshop_111_1.png)



```R
# can change stat_summary to compute median and min/max instead
ggplot(data = mpg) +
  stat_summary(
    mapping = aes(x = class, y = hwy),
    fun.ymin = min,
    fun.ymax = max,
    fun.y = median
  )
```


![png](workshop_files/workshop_112_0.png)


## Position adjustments

```{r}
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

Each geom also comes with a default **position adjustment** specified by `position` argument. For geoms like `geom_point()` it is "identity" which is position as is.

Specifically for bar charts, have fill aesthetic. If fill aesthetic gets mapped to another variable, bars are automatically stacked under the "stack" position. Can see [list of positions](https://ggplot2.tidyverse.org/reference/#section-layer-position-adjustment) at ggplot2 reference.


```R
p1 <- ggplot(data = mpg, mapping=aes(x=class,fill=as.factor(cyl)))
p1 + geom_bar()
```


![png](workshop_files/workshop_114_0.png)



```R
# position = identity will place each object exactly where it falls in context of graph.
# Not useful for bar charts, better for scatterplots.
p1 + geom_bar(position="identity",alpha=0.2)
```


![png](workshop_files/workshop_115_0.png)



```R
# position = fill will make bars same height
p1 + geom_bar(position="fill")
```


![png](workshop_files/workshop_116_0.png)



```R
# position = "dodge" places objects directly beside one another. Easier to compare individual values.
p1 + geom_bar(position="dodge")
```


![png](workshop_files/workshop_117_0.png)


For `geom_point` one possible position is "jitter", which will add a small amount of random noise to each point. This spreads points out so that it's unlikely for points to overlap and therefore get plotted over each other. For example it's possible that majority of points are actually one combination of `hwy` and `displ` but they all get plotted at the exact same point so you can't tell. For very large datasets can help prevent overplotting to better see where mass of plot is or trends.


```R
# seems quite uniform which suggests multiple observations with same value of cty/hwy
# creating overlapping points
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point()
```


![png](workshop_files/workshop_119_0.png)



```R
# definitely the case
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position="jitter")
```


![png](workshop_files/workshop_120_0.png)


## Coordinate systems

```{r}
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
     mapping = aes(<MAPPINGS>),
     stat = <STAT>, 
     position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
```

Default coordinate system is Cartesian.

 * `coord_flip()` switches x and y axes.
 * `coord_quickmap()` sets aspect ratio for maps.
 * `coord_polar()` sets polar coordinates.


```R
p <- ggplot(data = mpg, mapping = aes(x = class, y = hwy))
p + geom_boxplot()
```


![png](workshop_files/workshop_122_0.png)



```R
# flipping coordinates
p + geom_boxplot() + coord_flip()
```


![png](workshop_files/workshop_123_0.png)



```R
# can reorder x axis by lowest to highest median hwy mileage
# allows easier comparisons
ggplot(data = mpg, mapping = aes(x = reorder(class,hwy,FUN=median), y = hwy)) + 
  geom_boxplot() +
  coord_flip()
```


![png](workshop_files/workshop_124_0.png)



```R
# Setting aspect ratio correctly
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()
```


![png](workshop_files/workshop_125_0.png)



![png](workshop_files/workshop_125_1.png)



```R
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
```


![png](workshop_files/workshop_126_0.png)


# Summary

Now that we've gone through tidying, transforming, and visualizing data let's review all of the different functions we've used and in some cases learned the inner workings of:

## Tidying

 * `gather()`
 * `spread()`
 * `separate()`
 * `unite()`
 * `%>%` propagates the output from a function as input to another. eg: x %>% f(y) becomes f(x,y), and x %>% f(y) %>% g(z) becomes g(f(x,y),z).
 
## Transforming

 * `filter()` to pick observations (rows) by their values
 * `arrange()` to reorder rows, default is by ascending value
 * `select()` to pick variables (columns) by their names
 * `mutate()` to create new variables with functions of existing variables
 * `summarise()` to collapes many values down to a single summary
 * `group_by()` to set up functions to operate on groups rather than the whole data set
 
## Visualizing

 * `ggplot` - global data and mappings
 * `geom_point` - geom for scatterplots
 * `geom_smooth` - geom for regressions
 * `geom_pointrange` - geom for vertical intervals defined by `x`, `y`, `ymin`, and `ymax`
 * `geom_bar` - geom for barcharts
 * `geom_boxplot` - geom for boxplots
 * `geom_polygon` - geom for polygons
 * `aes(color)` - color mapping
 * `aes(shape)` - shape mapping
 * `aes(size)` - size mapping
 * `aes(alpha)` - transparency mapping
 * `as.factor()` - transforming numerical values to categorical values with levels
 * `facet_grid`
 * `facet_wrap`
 * `stat_count` - default stat for barcharts, bins by x and counts
 * `stat_identity` - default stat for scatterplots, leaves data as is
 * `stat_summary` - default stat for pointrange, by default computes mean and se of y by x
 * `position="identity"`
 * `position="stacked"`
 * `position="fill"`
 * `position="dodge"`
 * `position="jitter"`
 * `coord_flip`
 * `coord_map`
 * `coord_polar`

# Publication Quality Graphs

Last piece with some additional functions to learn...

## Labels

`labs()` to add most kinds of labels: title, subtitle, captions, x-axis, y-axis, legend, etc.


```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
```

    `geom_smooth()` using method = 'loess' and formula 'y ~ x'



![png](workshop_files/workshop_129_1.png)


## Annotations

Can use `geom_text()` to add text labesls on the plot.


```R
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_text(aes(label = model), data = best_in_class)
```


![png](workshop_files/workshop_131_0.png)



```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_point(size = 3, shape = 1, data = best_in_class) +
  ggrepel::geom_label_repel(aes(label = model), data = best_in_class) +
  labs(
    caption = "Data from fueleconomy.gov",
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
```


![png](workshop_files/workshop_132_0.png)


## Scales

 * `breaks`: For the position of ticks
 * `labels`: For the text label associated with each tick.
 * Default scale is x continuous, y continuous but can also do x logarithmic, y logarithmic, change color scales.


```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
```


![png](workshop_files/workshop_134_0.png)



```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)
```


![png](workshop_files/workshop_135_0.png)



```R
p1 <- ggplot(diamonds, aes(carat, price)) +
  geom_bin2d()

p2 <- ggplot(diamonds, aes(log10(carat), log10(price))) +
  geom_bin2d()

p3 <- ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

grid.arrange(p1,p2,p3,nrow=2)
```


![png](workshop_files/workshop_136_0.png)



```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_brewer(palette = "Set1")
```


![png](workshop_files/workshop_137_0.png)



![png](workshop_files/workshop_137_1.png)



```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_colour_manual(values=c(`4`="red",f="blue",r="blue"))
```


![png](workshop_files/workshop_138_0.png)


## Legend positioning

`theme(legend.position)` to control legend position. `guides()` with `guide_legened()` or `guide_colourbar()` for legend display.


```R
base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))

p1 <- base + theme(legend.position = "left")
p2 <- base + theme(legend.position = "top")
p3 <- base + theme(legend.position = "bottom")
p4 <- base + theme(legend.position = "right")

grid.arrange(p1,p2,p3,p4, nrow=2)
```


```R
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  theme(legend.position = "bottom") +
  guides(colour = guide_legend(nrow = 1, override.aes = list(size = 4)))
```

## Zooming

Three ways to control plot limits:
 * Adjusting what data are plotted
 * Setting limits in each scale
 * Setting `xlim` and `ylim` in `coord_cartesian()`


```R
# asetting xlim and ylim in coord_cartesian
ggplot(mpg, mapping = aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth() +
  coord_cartesian(xlim = c(5, 7), ylim = c(10, 30))
```


```R
# adjusting what data are plotted
# however geom_smooth will plot regression over subsetted data
filter(mpg, displ >= 5, displ <= 7, hwy >= 10, hwy <= 30) %>%
  ggplot(aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth()
```


```R
# 2 plots use subsetted data therefore have different scales along hwy and displ
suv <- mpg %>% filter(class == "suv")
compact <- mpg %>% filter(class == "compact")

ggplot(suv, aes(displ, hwy, colour = drv)) +
  geom_point()

ggplot(compact, aes(displ, hwy, colour = drv)) +
  geom_point()
```


```R
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
```

## Themes

**ggplot2** has 8 themes by default, can get more in other packages like **ggthemes**. Generally prefer `theme_classic()`.


```R
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
```

## Saving your plots

 * `ggsave()` will save most recent plot to disk
 * `tiff()` will save next plot to disk
 * Other functions like `postscript()` for eps files, etc.
 * All can take `width`, `height`, `fonts`, `pointsize`, `res` (resolution) arguments


```R
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
```

# Some other useful visualization packages

We don't have time in this workshop to get in depth to other workshops, but here are some more useful visualization packages that may be helpful for your research.

## ggtree for phylogenetics

Resources and associated packages:
 * [Data Integration, Manipulation and Visualization of Phylogenetic Trees](https://yulab-smu.github.io/treedata-book/index.html)
 * [treeio](https://bioconductor.org/packages/release/bioc/html/treeio.html)
 * [tidytree](https://cran.r-project.org/web/packages/tidytree/index.html)
 
## cowplot

Meant to provide publication-ready theme for **gplot2** that requires minimum amount of fiddling with sizes of axis labels, plot backgrounds, etc. Auto-sets `theme_classic()` for all plots.

## Gviz for plotting data along genomic coordinates

Can be installed from [Bioconductor](https://bioconductor.org/packages/release/bioc/html/Gviz.html).

## phyloseq for metagenomics

Website is [very comprehensive](http://joey711.github.io/phyloseq/).


```R
sessionInfo()
```
