country_code <- "EGY"
start_year <- 1990
end_year <- 2024
# Create folders
dir.create("data", showWarnings = FALSE)
dir.create("figures", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)

# Download CO2 dataset
url <- "https://owid-public.owid.io/data/co2/owid-co2-data.csv"

download.file(url, "data/owid-co2-data.csv", mode = "wb")

# Read dataset
co2_data <- read.csv("data/owid-co2-data.csv")

# Filter Egypt
egypt_data <- subset(
  co2_data,
  iso_code == country_code &
    year >= start_year &
    year <= end_year
)

# Save Egypt data
write.csv(egypt_data, "data/EGY_co2.csv", row.names = FALSE)

# Annual CO2 emissions graph
png("figures/EGY_annual_co2.png")
plot(egypt_data$year, egypt_data$co2,
     type = "l", xlab = "Year",
     ylab = "CO2 emissions",
     main = "Annual CO2 Emissions in Egypt")
dev.off()

# CO2 per capita graph
png("figures/EGY_per_capita.png")
plot(egypt_data$year, egypt_data$co2_per_capita,
     type = "l", xlab = "Year",
     ylab = "CO2 per capita",
     main = "CO2 Emissions per Capita in Egypt")
dev.off()

# Annual percentage change
egypt_data$annual_change <- c(
  NA,
  diff(egypt_data$co2) / head(egypt_data$co2, -1) * 100
)

png("figures/EGY_annual_change.png")
plot(egypt_data$year, egypt_data$annual_change,
     type = "l", xlab = "Year",
     ylab = "Annual change (%)",
     main = "Annual CO2 Change in Egypt")
dev.off()

# Summary results
summary_data <- data.frame(
  Country = "Egypt",
  First_Year = min(egypt_data$year),
  Last_Year = max(egypt_data$year),
  Mean_CO2 = mean(egypt_data$co2, na.rm = TRUE),
  Total_CO2 = sum(egypt_data$co2, na.rm = TRUE)
)

write.csv(summary_data, "results/EGY_summary.csv", row.names = FALSE)

# Save yearly changes
write.csv(egypt_data, "results/EGY_yearly_changes.csv", row.names = FALSE)

# Save R session information
writeLines(capture.output(sessionInfo()), "results/session_info.txt")

# Display summary
print(summary_data)