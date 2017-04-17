# Read the file in R

# Loading libraries

library(dplyr)

library(lubridate)

library(reshape2)

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

# Preparation of datasets for plotting plot 3

hpc_subset_3 <- select(hpc_subset_1, Sub_metering_1, Sub_metering_2, Sub_metering_3, datetime)

hpc_subset_3$Sub_metering_1 <- as.character(hpc_subset_3$Sub_metering_1)

hpc_subset_3$Sub_metering_1 <- as.numeric(hpc_subset_3$Sub_metering_1)

hpc_subset_3$Sub_metering_2 <- as.character(hpc_subset_3$Sub_metering_2)

hpc_subset_3$Sub_metering_2 <- as.numeric(hpc_subset_3$Sub_metering_2)

hpc_subset_4 <- melt(hpc_subset_3, id=c("datetime"), measure.vars = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

head(hpc_subset_4)

# Preparation of datasets for plotting plot 4

hpc_subset_5<- select(hpc_subset_1, Global_reactive_power, Voltage, datetime)

hpc_subset_5$Global_reactive_power <- as.character(hpc_subset_5$Global_reactive_power)

hpc_subset_5$Global_reactive_power <- as.numeric(hpc_subset_5$Global_reactive_power)

hpc_subset_5$Voltage <- as.character(hpc_subset_5$Voltage)

hpc_subset_5$Voltage <- as.numeric(hpc_subset_5$Voltage)


# Plot4

png("plot4.png", width = 480 , height = 480 , units = "px")

# Setting up the plot size

par(mfrow=c(2,2), mar=c(4,4,2,1))

# Global Active Power

plot(hpc_subset_2$datetime, hpc_subset_2$Global_active_power, type = "l", ylab = "Global Active Power", xlab = "Datetime")

# Voltage

plot(hpc_subset_5$datetime, hpc_subset_5$Voltage, type = "l", ylab = "Voltage", xlab = "Datetime")

# Energy Sub meeting

plot(hpc_subset_4$datetime, hpc_subset_4$value, type = "n", ylab = "Energy sub meeting", xlab = "Datetime")

Sub_metering_1 <- subset(hpc_subset_4, variable == "Sub_metering_1")

points(Sub_metering_1$datetime, Sub_metering_1$value, col="black", type = "l")

Sub_metering_2 <- subset(hpc_subset_4, variable == "Sub_metering_2")

points(Sub_metering_2$datetime, Sub_metering_2$value, col="red", type = "l")

Sub_metering_3 <- subset(hpc_subset_4, variable == "Sub_metering_3")

points(Sub_metering_3$datetime, Sub_metering_3$value, col="blue", type = "l")

legend("topright", pch=c(20,20,20), col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))


# Global Reactive Power

plot(hpc_subset_5$datetime, hpc_subset_5$Global_reactive_power, type = "l", ylab = "Global_reactive_power", xlab = "Datetime")

dev.off()



