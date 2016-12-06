### Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis
### Orihel et al.
### https://github.com/jjvenky/Internal_P_loading


### 03 Figures


#####################################
## Load Libraries
#####################################

library(rpart)
library(rpart.plot)
library(ggplot2)
library(grid)
library(gridExtra)
library(GGally)
library(Cairo)
library(dplyr)


#####################################
## Load data
#####################################

pflux <- read.csv("PFLUX_assembled.csv")

levels(pflux$O2.CAT)[match("INSITU(ANOXIC)", levels(pflux$O2.CAT))] <- "ANOXIC"
levels(pflux$O2.CAT)[match("INSITU(HYPOXIC)", levels(pflux$O2.CAT))] <- "HYPOXIC"
levels(pflux$O2.CAT)[match("INSITU(OXIC)", levels(pflux$O2.CAT))] <- "OXIC"

CORE <- subset(pflux, METHOD == "CORE INCUBATION")
OTHER <- subset(pflux, METHOD != "CORE INCUBATION")


#####################################
## Cart model for PFLUX
#####################################

# create equation for cart model
equation <- SRP.FLUX.mg_m2_d.value ~ SITE.DEPTH + LOI + SITE.SED.P + SITE.SED.Fe + START.SEASON + TROPHIC.STATE + LAKEPH.CAT + LAKE.AREA + ROCK + pH + O2.CAT + LIGHT.CAT

PFLUX_cart <- rpart(equation, method = "anova", data = pflux, control = rpart.control(cp = 0.0001))

nsplit <- PFLUX_cart$cptable[, 2]
bestcp <- PFLUX_cart$cptable[nsplit == 3, "CP"]
PFLUX_cart.pruned <- prune(PFLUX_cart, cp = bestcp)

prp(PFLUX_cart.pruned, type = 4, faclen = 0, cex = 0.8, extra = 1)
rsq.rpart(PFLUX_cart)


#####################################
## Cart model for PFLUX_CORE 
#####################################

equation <- SRP.FLUX.mg_m2_d.value ~ SITE.DEPTH + LOI + SITE.SED.P + SITE.SED.Fe + START.SEASON + TROPHIC.STATE + LAKEPH.CAT + LAKE.AREA + ROCK.DETAIL + ROCK + pH + O2.CAT + LIGHT.CAT

PFLUX_CORE_cart <- rpart(equation, method = "anova", data = CORE, control = rpart.control(cp = 0.0001))

nsplit <- PFLUX_CORE_cart$cptable[, 2]
bestcp <-  PFLUX_CORE_cart$cptable[nsplit==2, "CP"]
PFLUX_CORE_cart.pruned <- prune(PFLUX_CORE_cart, cp = bestcp)

prp(PFLUX_CORE_cart.pruned,type = 4, faclen = 0, cex = 0.8, extra = 1)
rsq.rpart(PFLUX_CORE_cart)


####################################################################
## Figures for Section 5 (A, B & C)
####################################################################

# Figure 5A
# Figure for core incubations by oxic state
oxy <- ggplot(data = CORE, aes(x = O2.CAT, y = SRP.FLUX.mg_m2_d.value)) +
  geom_boxplot() +
#  scale_x_discrete(limits = c("Anoxic", "Hypoxic", "Oxic")) +
  scale_y_continuous(limits = c(-0.5, 50)) +
  labs(x = "Oxygen treatment", y = "") +
  theme_bw()+ theme(panel.grid.major = element_blank(), 
                    panel.grid.minor = element_blank(), 
                    text = element_text(size = 8 ),
                    axis.title.x = element_text(vjust = -1), 
                    axis.title.y = element_text(vjust = 3),
                    plot.margin = (unit(c(.5, .5, .5, .5), "cm"))) +
  annotate("text", x = 1:3, y = 30, label = c("a", "a", "b"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "A", size = 8)
oxy

# Medians for core incubations by oxic state
summarise(group_by(CORE, O2.CAT),
      median = median(SRP.FLUX.mg_m2_d.value, na.rm = TRUE),
      sd = sd(SRP.FLUX.mg_m2_d.value, na.rm = TRUE))

# statistics for core incubations by oxic state
oxy_aov <- kruskal.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$O2.CAT)
pairwise.wilcox.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$O2.CAT, paired = FALSE)

# Figure 5B
# Figure for core incubations by pH category
ph.flux <- ggplot(data = CORE, aes(x = LAKEPH.CAT, SRP.FLUX.mg_m2_d.value)) +
  geom_boxplot() +
  scale_x_discrete(limits = c("Moderately Acidic", "Neutral", "Moderately Alkaline")) +
  scale_y_continuous(limits = c(-0.5, 50)) +
  labs(x = "Lake pH category", y = expression("Sediment P flux (mg SRP m"^-2*"d"^-1*")")) +
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(), 
                     text = element_text(size= 8 ),
                     axis.title.x = element_text(vjust= -1 ), 
                     axis.title.y = element_text(vjust = 1),
                     plot.margin = (unit(c(.5, .5, .5, .25), "cm"))) +
  annotate("text", x = 1:3, y = 30, label = c("b", "b", "a"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "B", size = 8)
ph.flux

# Medians for core incubations by pH category and geology
summarise(group_by(CORE, LAKEPH.CAT),
      median = median(SRP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(SRP.FLUX.mg_m2_d.value, na.rm = TRUE))
summarise(group_by(CORE, ROCK),
      median = median(SRP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(SRP.FLUX.mg_m2_d.value, na.rm = TRUE))

# Statistics for core incubations by pH category
pH_flux_aov <- kruskal.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$LAKEPH.CAT)
pairwise.wilcox.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$LAKEPH.CAT, paired = FALSE)

# Figure 5C
# Figure for core incubations by trophic state
trophic.flux <- ggplot(data = CORE, aes(x = TROPHIC.STATE, y = SRP.FLUX.mg_m2_d.value)) + 
  geom_boxplot() +
  scale_x_discrete(limits = c("Oligotrophic", "Mesotrophic", "Eutrophic", "Hypereutrophic")) +
  scale_y_continuous(limits = c(-0.5, 50)) +
  labs(x = "Trophic state", y = "") + 
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(), 
                     text = element_text(size = 8),
                     axis.title.x = element_text(vjust = -1), 
                     axis.title.y = element_text(vjust = 3),
                     plot.margin = (unit(c(.5, .5, .5, .5), "cm"))) +
  annotate("text", x = 1:4, y = 30, label = c("c", "b", "a", "a"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "C", size = 8)
trophic.flux

# Medians for core incubations by trophic state
summarise(group_by(CORE, TROPHIC.STATE),
      median = median(SRP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(SRP.FLUX.mg_m2_d.value, na.rm = TRUE))

# Statistics for core incubations by trophic state
trophic_flux_aov <- kruskal.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$TROPHIC.STATE)
pairwise.wilcox.test(CORE$SRP.FLUX.mg_m2_d.value, CORE$TROPHIC.STATE, paired = FALSE)

# Figures 5A, 5B, 5C
grid.arrange(oxy, ph.flux, trophic.flux, ncol = 1)


####################################################################
## Figure 7
####################################################################


# remove volcanic rocks since there are no points to plot
figure7 <- ggplot(data =  subset(pflux, METHOD == "CORE INCUBATION" & ROCK != "volcanic rocks"), 
                  aes(x = pH, y = SRP.FLUX.mg_m2_d.value, colour = ROCK, shape = TROPHIC.STATE)) + 
  geom_point(size = 2) +
  theme_bw() + 
  labs(x = "Sediment porewater pH", 
       y = expression("Sediment P flux (mg SRP m"^-2*"d"^-1*")"), 
       shape = "Trophic state") +
  theme(panel.grid.minor = element_blank(), 
        panel.grid.major=element_blank(), 
        text = element_text(size = 16),
        axis.title.x = element_text(vjust = -0.5), 
        axis.title.y = element_text(vjust = 1)) +
  scale_colour_manual(values = c("grey70", "black", "grey33")) +
  scale_y_continuous(limits  = c(-0.5, 50)) +
  geom_vline(xintercept = 7.21, colour = "grey50", linetype = "longdash") +
  annotate("text", parse = TRUE, label = as.character(expression("H"[2]*"PO"[4]^-{})), x = 6.5, y = 35, size = 7) +
  annotate("text", parse = TRUE, label = as.character(expression("HPO"[4]^2-{})), x = 8, y = 35, size = 7)
figure7


# EOF