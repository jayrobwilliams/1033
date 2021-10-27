library(tidyverse)
library(lubridate)

## read in data
equipment <- rio::import_list(commandArgs(trailingOnly = T)[1])

## drop one 1980 observation
equipment <- lapply(equipment, function(x) filter(x, year(`Ship Date`) >= 1990))

## territories to exclude
terr <- c('GUAM', 'NORTHERN MARIANA ISLANDS',
          'PUERTO RICO', 'VIRGIN ISLANDS OF THE U.S.')

## get total number of MRAPs transferred for ymax of suspension rectangle
bind_rows(equipment[!(names(equipment) %in% terr)], .id = 'State Name') %>% 
  group_by(year(`Ship Date`), State) %>% 
  summarize(mrap = sum(grepl('MINE RESISTANT', `Item Name`))) %>% 
  rename(year = "year(\`Ship Date\`)") %>% 
  group_by(State) %>%
  mutate(mrap_ct = cumsum(mrap)) %>% 
  slice(n()) %>% 
  select(-year) %>% 
  ungroup() %>% 
  mutate(rect_t = max(mrap_ct), rect_b = 0,
         rect_l = date('2015-05-18'), rect_r = date('2017-08-28')) -> suspension

## total number of MRAPs transferred
bind_rows(equipment[!(names(equipment) %in% terr)], .id = 'State Name') %>%
  group_by(date(`Ship Date`), State) %>% 
  summarize(mrap = sum(grepl('MINE RESISTANT', `Item Name`))) %>% 
  rename(date = "date(\`Ship Date\`)") %>% 
  group_by(State) %>%
  mutate(mrap_ct = cumsum(mrap)) %>% 
  complete(date = seq(min(date), max(date), by = 1)) %>% 
  fill(mrap, mrap_ct, .direction = 'down') -> transfers

## total number of MRAPs transferred
png('mrap.png', width = 2048, height = 1536, res = 150)
ggplot(transfers, aes(x = date, y = mrap_ct)) +
  geom_line() +
  geom_rect(aes(xmin = rect_l, xmax = rect_r, ymin = rect_b, ymax = rect_t),
            alpha = .25, data = suspension, inherit.aes = F) +
  scale_x_date(date_breaks = '8 years', date_labels = '%Y') +
  labs(x = element_blank(), y = element_blank(),
       title = paste('Total Mine-Resistant Ambush Protected Vehicles Transferred to States,',
                     bind_rows(equipment[1:49]) %>% pull(`Ship Date`) %>% year() %>% min(),
                     'to',
                     bind_rows(equipment[1:49]) %>% pull(`Ship Date`) %>% year() %>% max()),
       subtitle = 'Grey region denotes suspension of 1033 program',
       caption = paste('Source: Defense Logistics Agency\nLast updated: ', format(Sys.time(), '%B %d, %Y'))) +
  facet_wrap(~ State)
dev.off()

quit(save ='no')