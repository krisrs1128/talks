
R_Survey_Data <- read.csv("Cat_variables_Only_SurveyData_120_Rows_05252020.csv")

R_Survey_Data$ESL <- as.factor(R_Survey_Data$ESL)
R_Survey_Data$AgeGp <- as.factor(R_Survey_Data$AgeGp)
R_Survey_Data$Work <- as.factor(R_Survey_Data$Work)
R_Survey_Data$Gender <- as.factor(R_Survey_Data$Gender)
R_Survey_Data$FGC <- as.factor(R_Survey_Data$FGC)
str(R_Survey_Data)


# ggplots: Cat vars vs. SRC
# ==========================
library(plyr)

# SRC by ESL
# ==========
SRC_by_ESL <- ddply(R_Survey_Data, "ESL", summarize,
                    SRC.mean=mean(SRC), SRC.sd=sd(SRC),
                    Length=NROW(SRC),
                    SRC_frac=qt(p=0.95, df=Length-1),
                    Lower=SRC.mean - SRC_frac*SRC.sd/sqrt(Length),
                    Upper=SRC.mean + SRC_frac*SRC.sd/sqrt(Length) 
)
library("ggplot2")

ggplot(SRC_by_ESL, aes(x=SRC.mean, y=ESL))+geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=0.3) +
  theme(text=element_text(size=10, face="bold"))



# SRC by AgeGp
# ============
SRC_by_AgeGp <- ddply(R_Survey_Data, "AgeGp", summarize,
                      SRC.mean=mean(SRC), SRC.sd=sd(SRC),
                      Length=NROW(SRC),
                      SRC_frac=qt(p=0.95, df=Length-1),
                      Lower=SRC.mean - SRC_frac*SRC.sd/sqrt(Length),
                      Upper=SRC.mean + SRC_frac*SRC.sd/sqrt(Length) 
)

#library("ggplot2")

ggplot(SRC_by_AgeGp, aes(x=SRC.mean, y=AgeGp))+geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=0.3) +
  theme(text=element_text(size=10, face="bold"))




# SRC by Work
# ============
SRC_by_Work <- ddply(R_Survey_Data, "Work", summarize,
                     SRC.mean=mean(SRC), SRC.sd=sd(SRC),
                     Length=NROW(SRC),
                     SRC_frac=qt(p=0.95, df=Length-1),
                     Lower=SRC.mean - SRC_frac*SRC.sd/sqrt(Length),
                     Upper=SRC.mean + SRC_frac*SRC.sd/sqrt(Length) 
)

#library("ggplot2")

ggplot(SRC_by_Work, aes(x=SRC.mean, y=Work))+geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=0.3) +
  theme(text=element_text(size=10, face="bold"))



# SRC by Gender
# =============
SRC_by_Gender <- ddply(R_Survey_Data, "Gender", summarize,
                       SRC.mean=mean(SRC), SRC.sd=sd(SRC),
                       Length=NROW(SRC),
                       SRC_frac=qt(p=0.95, df=Length-1),
                       Lower=SRC.mean - SRC_frac*SRC.sd/sqrt(Length),
                       Upper=SRC.mean + SRC_frac*SRC.sd/sqrt(Length) 
)

#library("ggplot2")
ggplot(SRC_by_Gender, aes(x=SRC.mean, y=Gender))+geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=0.3) +
  theme(text=element_text(size=10, face="bold"))




# SRC by FGC 
# ===========
SRC_by_FGC <- ddply(R_Survey_Data, "FGC", summarize,
                    SRC.mean=mean(SRC), SRC.sd=sd(SRC),
                    Length=NROW(SRC),
                    SRC_frac=qt(p=0.95, df=Length-1),
                    Lower=SRC.mean - SRC_frac*SRC.sd/sqrt(Length),
                    Upper=SRC.mean + SRC_frac*SRC.sd/sqrt(Length) 
)

#library("ggplot2")

ggplot(SRC_by_FGC, aes(x=SRC.mean, y=FGC))+geom_point() +
  geom_errorbarh(aes(xmin=Lower, xmax=Upper), height=0.3) +
  theme(text=element_text(size=10, face="bold"))


list(
  `Age Group` = SRC_by_AgeGp |> 
      mutate(variable = case_match(AgeGp, "2" ~ "18-20", "3" ~ "21-23", "4" ~ "24-26", "5" ~ "27-29", "6" ~ ">29")),
  `Gender` = SRC_by_Gender |>
      mutate(variable = case_match(Gender, "0" ~ "Women", "1" ~ "Men")),
  `English Second Language` = SRC_by_ESL |>
      mutate(variable = case_match(ESL, "0" ~ "No", "1" ~ "Yes")),
  `Work` = SRC_by_Work |>
      mutate(variable = case_match(Work, "1" ~ "Full Time", "2" ~ "Part Time", "3" ~ "None")),
  `First Generation` = SRC_by_FGC |>
      mutate(variable = case_match(FGC, "0" ~ "Not First Gen", "1" ~ "First Gen"))
) |>
  bind_rows(.id = "group") |>
  ggplot(aes(SRC.mean, variable)) +
  geom_point(size = 4) +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), linewidth = 1) +
  facet_wrap(~ group, scales = "free_y") +
  labs(x = "Student Satisfaction with R", y = "") +
  theme(
    strip.text = element_text(size = 11),
    axis.text = element_text(size = 10),
    axis.title = element_text(size = 14)
  )
  
ggsave("intervals.png", width = 9, height = 4)
