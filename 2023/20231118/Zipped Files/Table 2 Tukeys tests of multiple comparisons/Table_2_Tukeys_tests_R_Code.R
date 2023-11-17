# Table 2 in Paper on Top of Page 7
# =================================
R_Survey_Data <- read.csv("Cat_variables_Only_SurveyData_120_Rows_05252020.csv")

R_Survey_Data$ESL <- as.factor(R_Survey_Data$ESL)
R_Survey_Data$AgeGp <- as.factor(R_Survey_Data$AgeGp)
R_Survey_Data$Work <- as.factor(R_Survey_Data$Work)
R_Survey_Data$Gender <- as.factor(R_Survey_Data$Gender)
R_Survey_Data$FGC <- as.factor(R_Survey_Data$FGC)
str(R_Survey_Data)

# ANOVA for all 5 cat variables vs. SRC
# =====================================
Anova_SRC_ESL <- aov(SRC~ESL, data=R_Survey_Data)
summary(Anova_SRC_ESL)

Anova_SRC_AgeGp <- aov(SRC~AgeGp, data=R_Survey_Data)
summary(Anova_SRC_AgeGp)

Anova_SRC_Work <- aov(SRC~Work, data=R_Survey_Data)
summary(Anova_SRC_Work)

Anova_SRC_Gender <- aov(SRC~Gender, data=R_Survey_Data)
summary(Anova_SRC_Gender)

Anova_SRC_FGC <- aov(SRC~FGC, data=R_Survey_Data)
summary(Anova_SRC_FGC)

# ANOVA for all 5 cat variables vs. JP
# =====================================
Anova_JP_ESL <- aov(JP~ESL, data=R_Survey_Data)
summary(Anova_JP_ESL)

Anova_JP_AgeGp <- aov(JP~AgeGp, data=R_Survey_Data)
summary(Anova_JP_AgeGp)

Anova_JP_Work <- aov(JP~Work, data=R_Survey_Data)
summary(Anova_JP_Work)

Anova_JP_Gender <- aov(JP~Gender, data=R_Survey_Data)
summary(Anova_JP_Gender)

Anova_JP_FGC <- aov(JP~FGC, data=R_Survey_Data)
summary(Anova_JP_FGC)

# ANOVA for all 5 cat variables vs. IDMBA
# =====================================
Anova_IDMBA_ESL <- aov(IDMBA~ESL, data=R_Survey_Data)
summary(Anova_IDMBA_ESL)

Anova_IDMBA_AgeGp <- aov(IDMBA~AgeGp, data=R_Survey_Data)
summary(Anova_IDMBA_AgeGp)

Anova_IDMBA_Work <- aov(IDMBA~Work, data=R_Survey_Data)
summary(Anova_IDMBA_Work)

Anova_IDMBA_Gender <- aov(IDMBA~Gender, data=R_Survey_Data)
summary(Anova_IDMBA_Gender)

Anova_IDMBA_FGC <- aov(IDMBA~FGC, data=R_Survey_Data)
summary(Anova_IDMBA_FGC)


# ANOVA for all 5 cat variables vs. RvsXL
# =======================================
Anova_RvsXL_ESL <- aov(RvsXL~ESL, data=R_Survey_Data)
summary(Anova_RvsXL_ESL)

Anova_RvsXL_AgeGp <- aov(RvsXL~AgeGp, data=R_Survey_Data)
summary(Anova_RvsXL_AgeGp)

Anova_RvsXL_Work <- aov(RvsXL~Work, data=R_Survey_Data)
summary(Anova_RvsXL_Work)

Anova_RvsXL_Gender <- aov(RvsXL~Gender, data=R_Survey_Data)
summary(Anova_RvsXL_Gender)

Anova_RvsXL_FGC <- aov(RvsXL~FGC, data=R_Survey_Data)
summary(Anova_RvsXL_FGC)


# Tukey HSD
# Cat vars vs SRC
TukeyHSD(Anova_SRC_ESL)
TukeyHSD(Anova_SRC_AgeGp)
TukeyHSD(Anova_SRC_Work)
TukeyHSD(Anova_SRC_Gender)
TukeyHSD(Anova_SRC_FGC)


