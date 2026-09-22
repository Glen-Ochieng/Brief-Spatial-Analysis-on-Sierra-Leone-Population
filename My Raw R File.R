
# Loading necessary packages ----------------------------------------------

packages= c("tidyverse","sf", "ggspatial")
lapply(packages, library, character.only = T)


# Importing the data and shapefile  ---------------------------------------

sle_sf = st_read("who_shapefile_sle_adm2_latest.gpkg")
sle_pop = read.csv("sle_pop_2020_2025.csv")

glimpse(sle_sf)
glimpse(sle_pop)


# Data Cleaning -----------------------------------------------------------

# checking the unique entries of the columns to better understand the dataset

unique(sle_pop$adm0) # adm0 seems okay
unique(sle_pop$adm1) #adm1 seems good - just the 4
unique(sle_pop$year) # years seem good - just the 4
unique(sle_pop$adm2) # adm2 seems to have a NA's
unique(sle_pop$pop) # plenty of issues spotted

# Cleaning the adm2 column
# After checking manually the dataset for context, I can fill the NA with the 
# the approriate values

sle_pop$adm2[sle_pop$adm1 == "NORTHERN" &
               sle_pop$year == 2023 &
               is.na(sle_pop$adm2)] = "KAMBIA"

sle_pop$adm2[sle_pop$adm1 == "NORTHERN" &
               sle_pop$year == 2025 &
               is.na(sle_pop$adm2)] = "KOINADUGU"
  

## Cleaning the pop col

# removing the commas
sle_pop$pop = gsub(",", "", sle_pop$pop)

# replacing the O with 0
sle_pop$pop = gsub("O", 0, sle_pop$pop)

# correcting the extra large numbers
sle_pop$pop[sle_pop$adm2 == "KOINADUGU" & sle_pop$year == 2020] <- "415887"
sle_pop$pop[sle_pop$adm2 == "PORT LOKO" & sle_pop$year == 2025] <- "752462"

# checking for duplicates basing of the knowledge the adm1,adm2 and year have
# to be unique

sle_pop |>
  group_by(adm1, adm2, year) |>
  summarise(n = n()) |>
  arrange(desc(n)) # anything above n =1 is a duplicate

# so far we have 2 duplicates in our dataset : Kambia 2021 and 
# Western Area Rural 2023. 

# Dropping the dups

sle_pop = sle_pop |>
  distinct()

glimpse(sle_pop) # new dataset less 2 rows. Great


# Lastly , changing year and pop to the correct ones 
sle_pop$year = as.integer(sle_pop$year)
sle_pop$pop = as.integer(sle_pop$pop)

# Pop Dataset is clean
glimpse(sle_pop)


# Checking the shape file
# Checking values are in and no NA's
unique(sle_sf$adm0_code) # seems okay
unique(sle_sf$adm0) # seems okay 
unique(sle_sf$adm1) # seems okay 
unique(sle_sf$adm2) # seems okay 
unique(sle_sf$start_date) # seems okay 
unique(sle_sf$end_date) #seems okay

# checking duplicates
any(duplicated(sle_sf))

# The shape file is clean as well and the data is in the correct format.


# Merging the 2 datasets --------------------------------------------------

glimpse(sle_pop)

sle_complete = sle_sf |>
  left_join(sle_pop, join_by(adm0,adm1,adm2))


# Analysis ----------------------------------------------------------------

# calculating population growth from 2020 to 2025

total_pop_2020 = sum(sle_complete$pop[sle_complete$year == 2020])
total_pop_2025 = sum(sle_complete$pop[sle_complete$year == 2025])

growth_rate=total_pop_2025/total_pop_2020

growth_rate

# Sierra Leone's population grew from 7.77 million in 2020 
#to 8.58 million in 2025; a total increase of 10.4% 


# calculating distribution per region
sle_complete |>
  group_by(adm1) |>
  summarise(total_pop = sum(pop)) |>
  arrange(desc(total_pop))

# Throughout the years, the NORTHERN REGION has the largest population, 
# approximately 3.4 million more to the second most densely populated region
# which is the SOUTHERN region.

# calculating distribution per district
sle_complete |>
  group_by(adm2) |>
  summarise(total_pop = sum(pop)) |>
  arrange(desc(total_pop))

# Western Area Urban, Kenema, and Bo are the three most populous districts, 
# accounting for about 15% the total population.

# Creating Supporting Visuals ---------------------------------------------------

# keeps the scientific notation from showing up on the scale
options(scipen = 10000) 

sle_complete |>
  group_by(year) |>
  summarise(total_pop = sum(pop)) |>
  ggplot(aes(x = factor(year), y = total_pop))+
  geom_col(fill = "red3") +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Sierra Leone Population Growth",
    subtitle = "By Year",
    x = "Year", 
    y = "Population") +
  theme_bw()

ggplot(sle_complete)+
  geom_sf(aes(fill = pop))+
  facet_wrap(~year)+
  theme_void() +
  scale_fill_continuous(low = "green2", high = "red")+
  labs(title = "Sierra Leone Population Distribution by Year")



