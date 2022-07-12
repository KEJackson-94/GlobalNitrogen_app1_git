library(dplyr) # I think this is for filter()
library(readxl) # for reading excel files
library(reshape2) # for melting dataframe (in long format)

#setwd("C:\\GlobalNitrogen_app1_git\\")
#getwd()

ISO_codes <- read.csv('ISO.csv') # https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv
my_files <- 'Zhang_et_al_2021.xlsx'
sheets_lst <- excel_sheets(path = my_files)
FSU <- c("Estonia", "Georgia", "Kazakhstan", "Kyrgyzstan", "Latvia", 
         "Lithuania","Moldova, Republic of", "Russian Federation", "Tajikistan", 
         "Turkmenistan", "Ukraine","Uzbekistan")
dfs <- data.frame(matrix(ncol = 58, nrow = 0))
for (i in 1:length(sheets_lst)){ # create a matrix for each excel sheet with renamed ISOs(e.g., benchmark fertilizer min)
  df = read_excel(path = my_files, sheet = i)
  df$data_type <- sheets_lst[i]
  df['ISO3'] <- ISO_codes$alpha.3[match(df$...1, ISO_codes$name)]
  names(df) <- c("Country", as.character(c(1961:2015)), 'data_type', 'ISO3')
  
  old_names <- unique(df[is.na(df$ISO3), ]$'Country')
  new_names <- c("Côte d'Ivoire", 'Congo, Democratic Republic of the', 
                 "Lao People's Democratic Republic", "Korea, Republic of", 
                 "Sudan", "Eswatini", 
                 "United Kingdom of Great Britain and Northern Ireland", 
                 "Tanzania, United Republic of", "FSU") 
  for (i in 1:length(old_names)){
    df$'Country'[df$'Country' == old_names[i]] <- new_names[i]}
  for (i in 1:length(FSU)){
    tst <- df[rep(df$'Country' == "FSU",), ]
    tst$'Country' <- FSU[i]
    df <- rbind(df, tst)} # add FSU countries
  df['ISO3'] <- ISO_codes$alpha.3[match(df$'Country', ISO_codes$name)]
  df = filter(df, 'Country' != "FSU") #remove FSU from country list
  dfs <- rbind(dfs, df)
}

iso_lst <- unique(dfs$ISO3)
iso_lst <- iso_lst[!is.na(iso_lst)]

# Make a clean dataframe for input values divided by min_Area
dfs2 <- data.frame(matrix(ncol = 58, nrow = 0))
for (iso in iso_lst){
  dfs_Amin <- dfs[which(dfs$data_type=="Benchmark_min_Area_km2" & dfs$ISO3 == iso),]
  dfs_tst <- dfs[which(dfs$ISO3==iso),]
  dfs_tst<-dfs_tst[!(dfs_tst$data_type=="Benchmark_min_Area_km2" | dfs_tst$data_type=="Benchmark_median_Area_km2" | dfs_tst$data_type=="Benchmark_max_Area_km2"),]
  for (i in 1:nrow(dfs_tst)){
    for (ii in 2:56){
      dfs_tst[i,ii] <- dfs_tst[i,ii]/dfs_Amin[1,ii]
    }
  }
  dfs2 <- rbind(dfs2, dfs_tst)
  }
melt_df <- melt(dfs2, id = c('Country', 'ISO3', 'data_type'), variable.name = 'Year')
write.csv(melt_df,'GlobalNStudyFinal_Amin.csv')

# Make a clean dataframe for input values divided by min_Area
dfs2 <- data.frame(matrix(ncol = 58, nrow = 0))
for (iso in iso_lst){
  dfs_Amed <- dfs[which(dfs$data_type=="Benchmark_median_Area_km2" & dfs$ISO3 == iso),]
  dfs_tst <- dfs[which(dfs$ISO3==iso),]
  dfs_tst<-dfs_tst[!(dfs_tst$data_type=="Benchmark_min_Area_km2" | dfs_tst$data_type=="Benchmark_median_Area_km2" | dfs_tst$data_type=="Benchmark_max_Area_km2"),]
  for (i in 1:nrow(dfs_tst)){
    for (ii in 2:56){
      dfs_tst[i,ii] <- dfs_tst[i,ii]/dfs_Amed[1,ii]
    }
  }
  dfs2 <- rbind(dfs2, dfs_tst)
}
melt_df <- melt(dfs2, id = c('Country', 'ISO3', 'data_type'), variable.name = 'Year')
write.csv(melt_df,'GlobalNStudyFinal_Amed.csv')

# Make a clean dataframe for input values divided by max_Area
dfs2 <- data.frame(matrix(ncol = 58, nrow = 0))
for (iso in iso_lst){
  dfs_Amax <- dfs[which(dfs$data_type=="Benchmark_max_Area_km2" & dfs$ISO3 == iso),]
  dfs_tst <- dfs[which(dfs$ISO3==iso),]
  dfs_tst<-dfs_tst[!(dfs_tst$data_type=="Benchmark_min_Area_km2" | dfs_tst$data_type=="Benchmark_median_Area_km2" | dfs_tst$data_type=="Benchmark_max_Area_km2"),]
  for (i in 1:nrow(dfs_tst)){
    for (ii in 2:56){
      dfs_tst[i,ii] <- dfs_tst[i,ii]/dfs_Amax[1,ii]
    }
  }
  dfs2 <- rbind(dfs2, dfs_tst)
}
melt_df <- melt(dfs2, id = c('Country', 'ISO3', 'data_type'), variable.name = 'Year')
#write.csv(melt_df,'GlobalNStudyFinal_Amax.csv')
