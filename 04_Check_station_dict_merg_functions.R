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



#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o
#
# Get official station names (per 2019)
# 
# From "06a. List of station names" in "Milkys/13_Make_big_excel_file.R"
#
#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o#o

get_station_names <- function(){
  data_stations <- readxl::read_excel("C:/Data/Seksjon 212/Milkys/Input_data/Kartbase.xlsx",
                                      range = "AM1:AP72")
  
  # Note that 
  #     the current station code is 'stasjonskode', not "STATION_CODE"
  #     `catch LAT__1` and `catch LONG__1` are currect (planned?) positions
  #     the current station name is 'stasjonsnavn', not "STATION_CODE"
  #     but station name for report is `Til Rapport`
  #         station name for maps are `Til Kart`
  
  # Check the two station code columns
  # data_stations %>%
  #   filter(STATION_CODE != stasjonskode)    # zero rows
  
  data_stations <- data_stations %>%
    rename(STATION_CODE = stasjonskode,
           Lat = `catch LAT`, Long = `catch LONG`, 
           STATION_NAME = stasjonsnavn) %>%
    filter(!is.na(STATION_CODE))
  
  # One duplicate (different names), we just remove one of them
  data_stations <- data_stations %>%
    filter(!STATION_NAME %in% "Risøy, Østerfjord")
  
  data_stations <- data_stations %>%
    rename(Station_name = STATION_NAME)
  
  data_stations
}

# Test
# debugonce(get_station_names)
# get_station_names() %>% head()

leaflet_stationdict <- function(search_string, station_dict = dat_stdict, ...){
  library(leaflet)
  sel <- grepl(search_string, station_dict$Station_Name, ...) &
    station_dict$Country %in% "Norway"
  if (sum(sel) > 0){
    df <- station_dict[sel,]
    df$Popup = paste0("<b>", df$Station_Name, "</b><br>", df$StartYear, "-", df$EndYear)
    # Leaflet map
    leaflet() %>%
      addTiles() %>%
      addMarkers(lng = df$Lon, lat = df$Lat, popup = df$Popup) 
  } else {
    cat("No stations found\n")
  }
}

# leaflet_stationdict("30B")
