# plot_saving_script.R
# ======================
# This script saves all final plots used in the analysis to the "Plots" folder.
# Make sure this script is run after generating all relevant plot objects.

# Set the correct working directory to save plots
setwd("~/Desktop/Saimun_REDO")

# Load necessary packages
library(ggplot2)
library(ggrepel)
library(viridis)


# Plot: Monthly Rice Price Seasonality
monthly_seasonal_plot <- ggplot(monthly_seasonal, aes(x = month, y = avg_price)) +
  geom_line(group = 1, color = "darkred", size = 1.2) +
  geom_point(color = "black", size = 2) +
  labs(
    title = "Average Monthly Rice Price Seasonality",
    subtitle = "Across All Years",
    x = "Month",
    y = "Avg Price (BDT)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.x = element_text(angle = 0, vjust = 0.5)
  )
ggsave("Plots/monthly_seasonal_plot.png", plot = monthly_seasonal_plot, width = 8, height = 5, dpi = 300)



# Plot: Rice Contribution by Division
rice_contribution_plot <- ggplot(rice_contribution, aes(x = reorder(LOCATION, percent_contribution), y = percent_contribution, fill = LOCATION == "Dhaka")) +
  geom_col(width = 0.7) +
  scale_fill_manual(values = c("TRUE" = "steelblue", "FALSE" = "lightblue")) +
  geom_text(aes(label = sprintf("%.1f%%", percent_contribution)), hjust = -0.1, size = 3.5, color = "black") +
  labs(
    title = "Division-Wise Contribution to Total Rice Market",
    subtitle = "Based on Sum of Price Observations (BDT per KG)",
    x = NULL,
    y = "Contribution (%)",
    fill = NULL
  ) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  theme(
    legend.position = "none",
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11),
    axis.text.x = element_text(size = 10),
    axis.text.y = element_text(size = 11)
  ) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1)))
ggsave("Plots/rice_contribution_plot.png", plot = rice_contribution_plot, width = 8, height = 5, dpi = 300)



# Plot: Child Dependency Trend
child_dependency_trend_plot <- ggplot(rajshahi_summary, aes(x = YEAR, color = urban_rural)) +
  geom_line(aes(y = avg_child_dependency), size = 1.2) +
  geom_point(aes(y = avg_child_dependency), size = 2.5) +
  labs(
    title = "Child Dependency Over Time in Rajshahi",
    subtitle = "Urban vs Rural Trends (1991–2011)",
    x = "Year", y = "Avg Child Dependency",
    color = "Area Type"
  ) +
  theme_minimal()
ggsave("Plots/child_dependency_trend.png", plot = child_dependency_trend_plot, width = 8, height = 5, dpi = 300)



# Plot: Top/Bottom 5 Upazilas
rajshahi_poverty_map <- ggplot(rajshahi_map) +
  geom_sf(aes(fill = poverty), color = "white", size = 0.15) +
  geom_text_repel(
    data = top_bottom_labels,
    aes(geometry = geometry, label = ADM3_EN, color = group),
    stat = "sf_coordinates",
    size = 4,
    fontface = "bold",
    max.overlaps = Inf,
    box.padding = 0.3,
    segment.size = 0.25
  ) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  scale_color_manual(values = c("Top 5" = "yellow", "Bottom 5" = "black")) +
  guides(color = "none") +
  labs(
    title = "Top & Bottom 5 Upazilas by Poverty Rate (Rajshahi Division)",
    fill = "Poverty Rate (%)"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    panel.grid = element_blank(),
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    legend.title = element_text(size = 10),
    legend.text = element_text(size = 9)
  )
ggsave("Plots/rajshahi_poverty_map.png", plot = rajshahi_poverty_map, width = 8, height = 6, dpi = 300)



# Plot: Full Bangladesh Poverty Map with Highlights
p <- ggplot(bgd_upazila_joined) +
  geom_sf(aes(fill = poverty), color = "white", size = 0.1) +
  geom_sf(data = dhaka_division, fill = NA, color = "black", size = 1.2) +
  geom_sf(data = rajshahi_division, fill = NA, color = "cyan", size = 1.2) +
  scale_fill_viridis_c(option = "plasma", direction = -1, name = "Poverty Rate (%)") +
  labs(
    title = "Upazila-Level Poverty in Bangladesh",
    subtitle = "Bold Black Border: Dhaka | Bold Cyan Border: Rajshahi"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(size = 16, face = "bold"),
    plot.subtitle = element_text(size = 11),
    legend.position = "right"
  )
ggsave("Plots/poverty_map_dhaka_rajshahi_highlighted.png", plot = p, width = 8, height = 5, dpi = 300)



# Plot: Upazila-Level Poverty (Rajshahi Focus)
upazila_poverty_rajshahi <- ggplot(rajshahi_map) +
  geom_sf(aes(fill = poverty), color = "white", size = 0.1) +
  scale_fill_viridis_c(option = "plasma", direction = -1) +
  labs(
    title = "Upazila-Level Poverty in Rajshahi Division",
    fill = "Poverty Rate (%)"
  ) +
  theme_minimal()
ggsave("Plots/upazila_poverty_rajshahi.png", plot = upazila_poverty_rajshahi, width = 8, height = 5, dpi = 300)


