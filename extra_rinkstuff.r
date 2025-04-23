# download moneypuck season data csv
download.file(
  "https://raw.githubusercontent.com/moneyPuckData/shots/master/2024.csv",
  destfile = "shots_2024.csv"
)

# load required libraries
library(readr)
library(dplyr)
library(ggplot2)
library(viridis)
library(sportyR)

# read moneypuck csv into dataframe
shots <- read_csv("shots_2024.csv", show_col_types = FALSE)

# detect best goal probability column
grep_cols <- grep("(xg|goal.*prob|prob.*goal)", names(shots),
                  ignore.case = TRUE, value = TRUE)
xg_col    <- grep_cols[which.max(colSums(!is.na(shots[grep_cols])))]
cat("using probability column:", xg_col, "\n")

# filter all leafs 5x5 shot attempts
leaf_5v5 <- shots %>%
  filter(
    teamCode         == "TOR",
    homeSkatersOnIce == 5,
    awaySkatersOnIce == 5,
    shotOnEmptyNet   == FALSE
  ) %>%
  mutate(
    # true if leafs were home
    is_home   = isHomeTeam == 1,
    # x coordinate with orientation
    x_plot    = if_else(
                   is_home,
                   arenaAdjustedXCordABS,
                   -arenaAdjustedXCordABS
                ),
    # y coordinate on rink
    y_plot    = arenaAdjustedYCord,
    # assign goal probability values
    goal_prob = .data[[xg_col]]
  )

# filter only actual goals
leaf_goals <- leaf_5v5 %>% filter(goal == 1)

# define selected forward shooters
forwards_list <- c(
  "Matthew Knies","Auston Matthews","Mitch Marner",
  "Max Domi","John Tavares","William Nylander",
  "Bobby McMann","Pontus Holmberg","Nicholas Robertson",
  "Steven Lorentz","Scott Laughton","Calle Jarnkrok"
)

# keep only selected forward goals
leaf_forwards <- leaf_goals %>%
  filter(shooterName %in% forwards_list)

# build goal probability map for forwards
leaf_plot <-
  geom_hockey(league = "NHL", display_range = "full") +

  # summary heatmap of goal probability
  stat_summary_2d(
    data  = leaf_forwards,
    aes(x = x_plot, y = y_plot, z = goal_prob),
    bins  = 50,
    fun   = mean,
    na.rm = TRUE,
    alpha = 0.9
  ) +
  scale_fill_viridis_c(
    name      = "Goal Probability",
    option    = "D",
    direction = -1,
    limits    = c(0, 1),
    trans     = "sqrt",
    na.value  = "transparent"
  ) +

  # overlay goal markers for forwards
  geom_point(
    data   = leaf_forwards,
    aes(x = x_plot, y = y_plot, shape = is_home),
    colour = "darkgreen",
    size   = 2,
    alpha  = 0.9
  ) +
  scale_shape_manual(
    name   = "Venue",
    values = c(`FALSE` = 1, `TRUE` = 16),
    labels = c("Away Goal", "Home Goal")
  ) +

  # set x and y axis labels
  scale_x_continuous(
    name   = "Feet from Centre Line",
    breaks = seq(-100, 100, 50),
    labels = c("100","50","0","50","100")
  ) +
  scale_y_continuous(
    name   = "Feet from Rink Center",
    breaks = seq(-42.5, 42.5, 21)
  ) +
  coord_fixed(xlim = c(-100,100), ylim = c(-42.5,42.5)) +

  # add plot titles and caption
  labs(
    title    = "Leafs 5×5 – goal probability map",
    subtitle = "toronto leafs 2024/2025 season",
    caption  = "data: moneypuck.com"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    panel.background = element_rect(fill = "white"),
    panel.grid.major = element_line(colour = "grey90"),
    panel.grid.minor = element_blank(),
    plot.title       = element_text(hjust = 0.5, face = "bold", size = 18),
    plot.subtitle    = element_text(hjust = 0.5, size = 14),
    axis.title       = element_text(face = "italic", size = 12),
    legend.position  = "right"
  )

# draw the plot and summary output
print(leaf_plot)
cat("total goals by selected forwards:", nrow(leaf_forwards), "\n")