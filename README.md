These files replicate the main analysis for my article in Journal of Health and Social Behavior:

Nelson, Micah. 2022. "Resentment Is Like Drinking Poison? The Heterogeneous Health Effects of Affective Polarization". Journal of Health and Social Behavior 63(4):508-524.

https://doi.org/10.1177/00221465221075311

The dataset analyzed in this paper can be obtained for free from the Pew Research Center at this link: https://www.pewresearch.org/politics/dataset/american-trends-panel-wave-16/

This repository contains three files:
1. A Stata do-file ("Stata variable preparation.do") for cleaning and preparing variables and exporting the data to Mplus.
2. An R file ("R variable preparation.R") that performs the same tasks in R for those who cannot access Stata.
3. An Mplus input file ("main model replication.inp") that performs the main analysis presented in the paper in Mplus. This analysis uses the dataset exported to Mplus via Stata.