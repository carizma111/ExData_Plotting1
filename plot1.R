# Read the file in R

# Loading libraries

library(dplyr)

library(lubridate)

# Read text file in R

hpc <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")

hpc$Date <- as.character(hpc$Date)

hpc$Time <- as.character(hpc$Time)

hpc_con <- mutate(hpc, datetime = paste(Date, Time, sep = ' '))

hpc_con$datetime  <- dmy_hms(hpc_con$datetime, tz=Sys.timezone())

hpc_con$Date <-as.Date(hpc_con$Date , format = '%d/%m/%Y')

# Create a subset only for dates between "2007-02-01" and "2007-02-02"

hpc_subset <- filter(hpc_con, Date>="2007-02-01" & Date<="2007-02-02")

hpc_subset_1 <- hpc_subset

# remove the initial data imported from the workspace

rm(hpc)

# Preparation of datasets for plotting plot1 and plot2

hpc_subset_2 <- select(hpc_subset_1, Global_active_power, datetime)

hpc_subset_2$Global_active_power <- as.character(hpc_subset_2$Global_active_power)

hpc_subset_2$Global_active_power <- as.numeric(hpc_subset_2$Global_active_power)

# Plot1

png("plot1.png", width = 480 , height = 480 , units = "px")

hist(hpc_subset_2$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

dev.off()
