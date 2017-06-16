### Internal phosphorus loading in Canadian freshwaters: A critical review and data analysis
### Orihel et al.
### https://github.com/jjvenky/Internal_P_loading


### 03 Figures


#####################################
## Load Libraries
#####################################

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

levels(pflux$O2.CAT)[match("INSITU(ANOXIC)", levels(pflux$O2.CAT))] <- "Anoxic"
levels(pflux$O2.CAT)[match("INSITU(HYPOXIC)", levels(pflux$O2.CAT))] <- "Hypoxic"
levels(pflux$O2.CAT)[match("INSITU(OXIC)", levels(pflux$O2.CAT))] <- "Oxic"
levels(pflux$O2.CAT)[match("ANOXIC", levels(pflux$O2.CAT))] <- "Anoxic"
levels(pflux$O2.CAT)[match("HYPOXIC", levels(pflux$O2.CAT))] <- "Hypoxic"
levels(pflux$O2.CAT)[match("OXIC", levels(pflux$O2.CAT))] <- "Oxic"

CORE <- subset(pflux, METHOD == "CORE INCUBATION")
OTHER <- subset(pflux, METHOD != "CORE INCUBATION")


####################################################################
## Figure 4 - Histograms
####################################################################

Lgross <- subset(pflux, FCLASS == "Lgross")
Lnet <- subset(pflux, FCLASS == "Lnet")
min(na.omit(Lgross$TP.FLUX.mg_m2_d.value))
max(na.omit(Lgross$TP.FLUX.mg_m2_d.value))

min(na.omit(Lnet$TP.FLUX.mg_m2_d.value))*365
max(na.omit(Lnet$TP.FLUX.mg_m2_d.value))*365

Lnet$TP.FLUX.mg_m2_y.value <- Lnet$TP.FLUX.mg_m2_d.value*365

Lgrosshist <- ggplot(Lgross, aes(TP.FLUX.mg_m2_d.value)) +
  geom_histogram(binwidth = 1, fill = "white", colour = "black") +
  theme_bw() +
  labs(x = expression("L"[gross]*" (mg TP m"^-2*"d"^-1*")"), y = "") +
  scale_x_continuous(limits = c(-25, 55))

Lnethist <- ggplot(Lnet, aes(TP.FLUX.mg_m2_y.value)) +
  geom_histogram(binwidth = 365, fill = "white", colour = "black") +
  theme_bw()+labs(x = expression("L"[net]*" (mg TP m"^-2*"y"^-1*")"), y= "") +
  scale_x_continuous(limits = c(-9125,20075))

gA <- ggplotGrob(Lgrosshist)
gB <- ggplotGrob(Lnethist)
grid.newpage()
grid.draw(rbind(gA, gB))


####################################################################
## Figures for Section 6 (A, B & C)
####################################################################

# Figure 6A
# Figure for core incubations by oxic state
oxy <- ggplot(data = CORE, aes(x = O2.CAT, y = TP.FLUX.mg_m2_d.value)) +
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
  annotate("text", x = 1:3, y = 35, label = c("a", "a", "b"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "A", size = 8)
oxy

# Medians for core incubations by oxic state
summarise(group_by(CORE, O2.CAT),
      median = median(TP.FLUX.mg_m2_d.value, na.rm = TRUE),
      sd = sd(TP.FLUX.mg_m2_d.value, na.rm = TRUE))

# statistics for core incubations by oxic state
oxy_aov <- kruskal.test(CORE$TP.FLUX.mg_m2_d.value, CORE$O2.CAT)
pairwise.wilcox.test(CORE$TP.FLUX.mg_m2_d.value, CORE$O2.CAT, paired = FALSE)

# Figure 6B
# Figure for core incubations by pH category
ph.flux <- ggplot(data = CORE, aes(x = LAKEPH.CAT, TP.FLUX.mg_m2_d.value)) +
  geom_boxplot() +
  scale_x_discrete(limits = c("Moderately Acidic", "Neutral", "Moderately Alkaline")) +
  scale_y_continuous(limits = c(-0.5, 50)) +
  labs(x = "Lake pH category", y = expression("L"[gross]*" (mg TP m"^-2*"d"^-1*")")) +
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(), 
                     text = element_text(size= 8 ),
                     axis.title.x = element_text(vjust= -1 ), 
                     axis.title.y = element_text(vjust = 1),
                     plot.margin = (unit(c(.5, .5, .5, .25), "cm"))) +
  annotate("text", x = 1:3, y = 35, label = c("b", "b", "a"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "B", size = 8)
ph.flux

# Medians for core incubations by pH category and geology
summarise(group_by(CORE, LAKEPH.CAT),
      median = median(TP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(TP.FLUX.mg_m2_d.value, na.rm = TRUE))
summarise(group_by(CORE, ROCK),
      median = median(TP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(TP.FLUX.mg_m2_d.value, na.rm = TRUE))



# Statistics for core incubations by pH category and geology
pH_flux_aov <- kruskal.test(CORE$TP.FLUX.mg_m2_d.value, CORE$LAKEPH.CAT)
pairwise.wilcox.test(CORE$TP.FLUX.mg_m2_d.value, CORE$LAKEPH.CAT, paired = FALSE)
rock_aov <- kruskal.test(CORE$TP.FLUX.mg_m2_d.value, CORE$ROCK)
pairwise.wilcox.test(CORE$TP.FLUX.mg_m2_d.value, CORE$ROCK, paired = FALSE)

# Figure 6C
# Figure for core incubations by trophic state
trophic.flux <- ggplot(data = CORE, aes(x = TROPHIC.STATE, y = TP.FLUX.mg_m2_d.value)) + 
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
  annotate("text", x = 1:4, y = 35, label = c("c", "b", "a", "a"), size = 4) +
  annotate("text", x = 0.75, y = 45, label = "C", size = 8)
trophic.flux

# Medians for core incubations by trophic state
summarise(group_by(CORE, TROPHIC.STATE),
      median = median(TP.FLUX.mg_m2_d.value, na.rm = TRUE), 
      sd = sd(TP.FLUX.mg_m2_d.value, na.rm = TRUE))

# Statistics for core incubations by trophic state
trophic_flux_aov <- kruskal.test(CORE$TP.FLUX.mg_m2_d.value, CORE$TROPHIC.STATE)
pairwise.wilcox.test(CORE$TP.FLUX.mg_m2_d.value, CORE$TROPHIC.STATE, paired = FALSE)

# Figures 6A, 6B, 6C
grid.arrange(oxy, ph.flux, trophic.flux, ncol = 1)


####################################################################
## Figure 7
####################################################################


# remove volcanic rocks since there are no points to plot
figure7 <- ggplot(data =  subset(pflux, METHOD == "CORE INCUBATION" & ROCK != "volcanic rocks"), 
                  aes(x = pH, y = TP.FLUX.mg_m2_d.value, colour = ROCK, shape = TROPHIC.STATE)) + 
  geom_point(size = 2) +
  theme_bw() + 
  labs(x = "Sediment porewater pH", 
       y = expression("L"[gross]*" (mg TP m"^-2*"d"^-1*")"), 
       shape = "Trophic state", colour="Surficial geology") +
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
