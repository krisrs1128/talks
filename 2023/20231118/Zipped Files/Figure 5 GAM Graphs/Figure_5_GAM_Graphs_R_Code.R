# ================================================================
# Folder name: Word done on 05242020
# R File name: ISLR books gam package final soln R code 05242020.R
# ================================================================

library(gam)
R_Survey_Data <- read.csv("SurveyData_120_Rows_05252020.csv")


# 1: Run ISLR'S gam() with orginal data with log(SRC) transform
# =============================================================
#   ======= THIS IS THE BEST MODEL ======
# =====================================================

gam_model_log <- gam(log(SRC) ~ s(JP) + s(IDMBA) + s(EiLR) + s(RvsXL) + s(XL_Exp) + s(VBA_Exp), data = R_Survey_Data)
summary(gam_model_log)
par(mfrow=c(1,1))
plot(gam_model_log, se=TRUE)

p <- plot(gam_model_log)

d <- map_dfr(
  p$preplot,
  ~ tibble(x = .$x, y = .$y, y_se = .$se.y, xlab = .$xlab, ylab = .$ylab) %>%
    mutate(y_lower = y - y_se, y_upper = y + y_se),
  .id = "variable"
)

library(glue)
rug_data <- R_Survey_Data |>
  select(any_of(c("JP", "IDMBA", "RvsXL"))) |>
  pivot_longer(everything()) |>
  mutate(variable = glue("s({name})")) |>
  mutate(
    variable = factor(variable, levels = c("s(JP)", "s(IDMBA)", "s(RvsXL)")),
    variable = str_remove(variable, "s\\("),
    variable = str_remove(variable, "\\)")
  )

theme_set(theme_classic())
d |>
  filter(variable %in% c("s(JP)", "s(IDMBA)", "s(RvsXL)")) |>
  mutate(
    variable = factor(variable, levels = c("s(JP)", "s(IDMBA)", "s(RvsXL)")),
    variable = str_remove(variable, "s\\("),
    variable = str_remove(variable, "\\)")
  ) |>
  ggplot() +
  geom_ribbon(aes(x, ymin = y_lower, ymax = y_upper), alpha = 0.2) +
  geom_line(aes(x, y_upper), linewidth = 0.2) +
  geom_line(aes(x, y_lower), linewidth = 0.2) +
  geom_rug(data = rug_data, aes(value)) +
  geom_line(aes(x, y), linewidth = 1) +
  facet_wrap(~ variable, scales = "free") +
  theme(strip.text = element_text(size = 14)) +
  labs(
    x = "Independent variables",
    y = expression(log(`Student Satisfaction with R`))
  )
ggsave("gam_marginals.png", width = 8, height = 3.5)
