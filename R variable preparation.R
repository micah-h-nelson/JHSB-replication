library(tidyverse)
library(MplusAutomation)

#Read in data
data <- read.csv([insert file path])

#Clean/recode variables
data <- data |> 
  mutate(
    #Self-rated health
    srh = case_match(HLTHRATE_W16, 
                     5 ~ 1,
                     4 ~ 2,
                     3 ~ 3,
                     2 ~ 4,
                     1 ~ 5),
    #Gender
    male = if_else(F_SEX_FINAL == 1, 1, 0),
    #Education
    edu = case_match(F_EDUCCAT2_FINAL,
                     1 ~ 1,
                     2 ~ 2,
                     3 ~ 3,
                     4 ~ 3,
                     5 ~ 4,
                     6 ~ 4),
    #Income
    income = if_else(F_INCOME_FINAL == 10, NA, F_INCOME_FINAL),
    #Party identity
    party = case_when(PARTY_W16 == 1 ~ 1,
                      PARTY_W16 == 2 ~ 2,
                      PARTYLN_W16 == 1 & between(PARTY_W16,3,5) ~ 1,
                      PARTYLN_W16 == 2 & between(PARTY_W16,3,5) ~ 2),
    #Age
    age = F_AGECAT_FINAL,
    #Race
    race = if_else(F_RACETHN_RECRUITMENT == 5, NA, F_RACETHN_RECRUITMENT),
    #Marital status
    married = case_when(F_MARITAL_FINAL %in% c(3,4,5,6) ~ 0,
                        F_MARITAL_FINAL %in% c(1,2) ~ 1),
    #Health insurance status
    insured = case_when(F_INSURANCE_FINAL == 1 ~ 1,
                        F_INSURANCE_FINAL == 2 ~ 0),
    #Affective polarization/partisan emotive response variables
    polar_frustrated = case_when(EMTREP_A_W16 == 2 & party == 2 ~ 1,
                                 EMTDEM_A_W16 == 2 & party == 1 ~ 1),
    polar_frustrated = if_else(is.na(polar_frustrated), 0, polar_frustrated),
    polar_frustrated = if_else(is.na(party), NA, polar_frustrated),
    polar_angry = case_when(EMTREP_B_W16 == 2 & party == 2 ~ 1,
                            EMTDEM_B_W16 == 2 & party == 1 ~ 1),
    polar_angry = if_else(is.na(polar_angry), 0, polar_angry),
    polar_angry = if_else(is.na(party), NA, polar_angry),
    polar_afraid = case_when(EMTREP_C_W16 == 2 & party == 2 ~ 1,
                             EMTDEM_C_W16 == 2 & party == 1 ~ 1),
    polar_afraid = if_else(is.na(polar_afraid), 0, polar_afraid),
    polar_afraid = if_else(is.na(party), NA, polar_afraid),
    #For people who fail to check all boxes (including "none of these"), code as missing
    polar_frust_miss = if_else(party == 2 & EMTREP_A_W16 == 1 & EMTREP_B_W16 == 1 & 
                                 EMTREP_C_W16 == 1 & EMTREP_D_W16 == 1 & EMTREP_E_W16 == 1 &
                                 EMTREP_F_W16 == 1 & EMTREP_G_W16 == 1, NA, polar_frustrated),
    polar_frust_miss = if_else(party == 1 & EMTDEM_A_W16 == 1 & EMTDEM_B_W16 == 1 & 
                                 EMTDEM_C_W16 == 1 & EMTDEM_D_W16 == 1 & EMTDEM_E_W16 == 1 &
                                 EMTDEM_F_W16 == 1 & EMTDEM_G_W16 == 1, NA, polar_frust_miss),
    polar_ang_miss = if_else(party == 2 & EMTREP_A_W16 == 1 & EMTREP_B_W16 == 1 & 
                                 EMTREP_C_W16 == 1 & EMTREP_D_W16 == 1 & EMTREP_E_W16 == 1 &
                                 EMTREP_F_W16 == 1 & EMTREP_G_W16 == 1, NA, polar_angry),
    polar_ang_miss = if_else(party == 1 & EMTDEM_A_W16 == 1 & EMTDEM_B_W16 == 1 & 
                                 EMTDEM_C_W16 == 1 & EMTDEM_D_W16 == 1 & EMTDEM_E_W16 == 1 &
                                 EMTDEM_F_W16 == 1 & EMTDEM_G_W16 == 1, NA, polar_ang_miss),
    polar_afr_miss = if_else(party == 2 & EMTREP_A_W16 == 1 & EMTREP_B_W16 == 1 & 
                               EMTREP_C_W16 == 1 & EMTREP_D_W16 == 1 & EMTREP_E_W16 == 1 &
                               EMTREP_F_W16 == 1 & EMTREP_G_W16 == 1, NA, polar_afraid),
    polar_afr_miss = if_else(party == 1 & EMTDEM_A_W16 == 1 & EMTDEM_B_W16 == 1 & 
                               EMTDEM_C_W16 == 1 & EMTDEM_D_W16 == 1 & EMTDEM_E_W16 == 1 &
                               EMTDEM_F_W16 == 1 & EMTDEM_G_W16 == 1, NA, polar_afr_miss),
    #Political participation variables
    rally = if_else(CIVIC_ENG_ACTMOD_A_W16 == 2, 1, 0),
    campaign = if_else(CIVIC_ENG_ACTMOD_C_W16 == 2, 1, 0),
    member = if_else(CIVIC_ENG_ACTMOD_D_W16 == 2, 1, 0),
    contact = if_else(CIVIC_ENG_ACTMOD_G_W16 == 2, 1, 0),
    donate = if_else(CIVIC_ENG_ACTMOD_H_W16 == 2, 1, 0),
    display = if_else(CIVIC_ENG_ACTMOD_I_W16 == 2, 1, 0),
    online = if_else(CIVIC_ENG_ACTMOD_J_W16 == 2, 1, 0),
    #For people who did not check any boxes (including "none of these"), code as missing
    rally_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                            CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                            CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                            CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, rally),
    campaign_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                              CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                              CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                              CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, campaign),
    member_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                              CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                              CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                              CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, member),
    contact_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                              CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                              CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                              CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, contact),
    donate_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                                CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                                CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                                CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, donate),
    display_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                                CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                                CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                                CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, display),
    online_missing = if_else(CIVIC_ENG_ACTMOD_A_W16 == 1 & CIVIC_ENG_ACTMOD_C_W16 == 1 &
                                CIVIC_ENG_ACTMOD_D_W16 == 1 & CIVIC_ENG_ACTMOD_G_W16 == 1 &
                                CIVIC_ENG_ACTMOD_H_W16 == 1 & CIVIC_ENG_ACTMOD_I_W16 == 1 &
                                CIVIC_ENG_ACTMOD_J_W16 == 1 & CIVIC_ENG_ACTMOD_K_W16 == 1, NA, online),
    #Create dichotomoush variables for use in Mplus
    highschool = if_else(edu == 2, 1, 0),
    some_college = if_else(edu == 3, 1, 0),
    college = if_else(edu == 4, 1, 0),
    age1 = if_else(age == 2, 1, 0),
    age2 = if_else(age == 3, 1, 0),
    age3 = if_else(age == 4, 1, 0),
    black = if_else(race == 2, 1, 0),
    hispanic = if_else(race == 3, 1, 0),
    other_race = if_else(race == 4, 1, 0)
    )

#Export data to mplus
prepareMplusData(
  data[,c(184:222)],
  filename = "mplus_data_R.dat")

#Data file definition and variable names for Mplus .inp file:
TITLE: Your title goes here
DATA: FILE = "mplus_data_R.dat";
VARIABLE: 
  NAMES = WEIGHT_FORM_W16 srh male edu income party age race married insured
polar_frustrated polar_angry polar_afraid polar_frust_miss polar_ang_miss
polar_afr_miss rally campaign member contact donate display online
rally_missing campaign_missing member_missing contact_missing donate_missing
display_missing online_missing highschool some_college college age1 age2 age3
black hispanic other_race; 
MISSING=.;

