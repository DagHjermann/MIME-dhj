make_stationtable <- function(stations){
  
  stations <- stringr::str_extract(stations, "([^[[:blank:]]]+)")  
  
  # Stations and years in the database
  data_yrs <- dat01 %>% 
    filter(STATION_CODE %in% stations) %>%
    group_by(MYEAR, STATION_CODE) %>%
    summarise(n_data = n())
  
  # Big excel file - put on long format
  datxl_long <- datxl %>%
    filter(`Station Code` %in% stations) %>%
    select(`Parameter Code`, `Station Code`, `Species`, `Tissue`, `Basis`, `1980`:`2015`) %>%
    pivot_longer(cols = `1980`:`2015`, names_to = "MYEAR", values_to = "VALUE") %>%
    mutate(MYEAR = as.numeric(MYEAR)) %>%
    rename(STATION_CODE = `Station Code`)
  
  # Stations and years in the big excel file
  xlfile_yrs <- datxl_long %>%
    filter(VALUE != "") %>%
    group_by(MYEAR, STATION_CODE) %>%
    summarise(n_xl = n())
  
  # Stations and years in the database and in the big excel file, combined
  compare_yrs <- full_join(data_yrs, xlfile_yrs, by = c("MYEAR", "STATION_CODE")) %>%
    ungroup()
  
  compare_yrs
  
}

make_stationtable_shortcode <- function(short_code){
  no_letters <- nchar(short_code)
  
  # Stations and years in the database
  data_yrs <- dat01 %>% 
    filter(substr(STATION_CODE,1, no_letters) %in% short_code) %>%
    group_by(MYEAR, STATION_CODE) %>%
    summarise(n_data = n())
  
  # Big excel file - put on long format
  datxl_long <- datxl %>%
    filter(substr(`Station Code`, 1, no_letters) %in% short_code) %>%
    select(`Parameter Code`, `Station Code`, `Species`, `Tissue`, `Basis`, `1980`:`2015`) %>%
    pivot_longer(cols = `1980`:`2015`, names_to = "MYEAR", values_to = "VALUE") %>%
    mutate(MYEAR = as.numeric(MYEAR)) %>%
    rename(STATION_CODE = `Station Code`)
  
  # Stations and years in the big excel file
  xlfile_yrs <- datxl_long %>%
    filter(VALUE != "") %>%
    group_by(MYEAR, STATION_CODE) %>%
    summarise(n_xl = n())
  
  # Stations and years in the database and in the big excel file, combined
  compare_yrs <- full_join(data_yrs, xlfile_yrs, by = c("MYEAR", "STATION_CODE")) %>%
    ungroup()
  
  compare_yrs
}

# check_stations("227G")

#
# Makes plot with 2 subplots: "year-station" overview, and time series for some variables
#
check_data_shortcode <- function(short_code){
  no_letters <- nchar(short_code)
  
  gg1 <- make_stationtable_shortcode(short_code) %>%
    ggplot(aes(MYEAR, STATION_CODE, color = STATION_CODE)) + geom_point(size = rel(3))
  
  # Select some parameters
  df <- dat %>% 
    filter(substr(STATION_CODE, 1, no_letters) %in% short_code) %>%
    filter(PARAM %in% c("CD", "HG", "CB101", "CB118", "DDEPP", "HBCDA"))
  
  # Show medians, graph
  gg2 <- df %>%
    group_by(MYEAR, STATION_CODE, TISSUE_NAME, PARAM, UNIT) %>%
    summarize(Conc = median(VALUE_WW)) %>%
    ggplot(aes(MYEAR, Conc, color = STATION_CODE, shape = UNIT)) +
    geom_point() +
    # scale_y_log10() +
    facet_wrap(vars(TISSUE_NAME, PARAM), scales = "free_y")
  
  gg <- cowplot::plot_grid(gg1, gg2, ncol = 1)
  gg
  # print(gg1)
  # print(gg2)

  }
  
  
no_of_years <- function(mergedstation){
    sel <- dat_merge$Notes %in% mergedstation
    tb <- make_stationtable(dat_merge$Station_Name[sel])
    data.frame(Station_name = mergedstation, 
               N_years = length(unique(tb$MYEAR)),
               stringsAsFactors = FALSE)
  }
  