use [insert data file name]

*Clean/prepare variables
*Self-rated health
gen srh = .
replace srh = 1 if hlthrate_w16 == 5
replace srh = 2 if hlthrate_w16 == 4
replace srh = 3 if hlthrate_w16 == 3
replace srh = 4 if hlthrate_w16 == 2
replace srh = 5 if hlthrate_w16 == 1

label define srh 1 "Poor" 2 "Fair" 3 "Good" 4 "Very Good" 5 "Excellent"
label value srh srh

*Gender
gen male = 1 if f_sex_final == 1
replace male = 0 if f_sex_final == 2

*Education
gen edu = 1 if f_educcat2_final == 1
replace edu = 2 if f_educcat2_final == 2
replace edu = 3 if f_educcat2_final == 3
replace edu = 3 if f_educcat2_final == 4
replace edu = 4 if f_educcat2_final == 5
replace edu = 4 if f_educcat2_final == 6

label define edu 1 "less than HS" 2 "HS" 3 "some college/2 yr college" 4 "college +"
label value edu edu

*Income
gen income = f_income_final
recode income (10=.)
label define income 1 "< 10,000" 2 "10,000 - 20,000" 3 "20,000 - 30,000" 4 "30,000 - 40,000" ///
5 "40,000 - 50,000" 6 "50,000 - 75,000" 7 "75,000 - 100,000" 8 "100,000 - 150,000" 9 "150,000 +"

label value income income

*Party identity
*1 = republican/lean republican
*2 = dem/lean dem
gen party = .
replace party = 1 if party_w16 == 1
replace party = 2 if party_w16 == 2
replace party = 1 if partyln_w16 == "1" & party == .
replace party = 2 if partyln_w16 == "2" & party == .

label define party 1 "R/lean R" 2 "D/Lean D"
label value party party

*Age
gen age = .
replace age = 1 if f_agecat_final == "1"
replace age = 2 if f_agecat_final == "2"
replace age = 3 if f_agecat_final == "3"
replace age = 4 if f_agecat_final == "4"

label define age 1 "18-29" 2 "30-49" 3 "50-64" 4 "65+"
label value age age

*Race
gen race = f_racethn_recruitment
recode race (5=.)

label define race 1 "White non hispanic" 2 "Black non hispanic" 3 "Hispanic" 4 "Other"
label value race race

*Marital status
gen married = .
replace married = 0 if f_marital_final == "3"
replace married = 0 if f_marital_final == "4"
replace married = 0 if f_marital_final == "5"
replace married = 0 if f_marital_final == "6"
replace married = 1 if f_marital_final == "1"
replace married = 1 if f_marital_final == "2"

label define married 0 "not married/partnered" 1 "married/partnered"
label value married married

*Health insurance status
gen insured = .
replace insured = 1 if f_insurance_final == "1"
replace insured = 0 if f_insurance_final == "2"


*Affective polarization/partisan emotive response variables
*Frustrated
gen polar_frustrated = 1 if emtrep_a_w16 == 2 & party == 2
replace polar_frustrated = 1 if emtdem_a_w16 == 2 & party == 1
recode polar_frustrated (.=0)

*Angry
gen polar_angry = 1 if emtrep_b_w16 == 2 & party == 2
replace polar_angry = 1 if emtdem_b_w16 == 2 & party == 1
recode polar_angry (.=0)

*Afraid
gen polar_afraid = 1 if emtrep_c_w16 == 2 & party == 2
replace polar_afraid = 1 if emtdem_c_w16 == 2 & party == 1
recode polar_afraid (.=0)

*Recode independents no lean as missing
replace polar_frustrated = . if party == .
replace polar_angry = . if party == .
replace polar_afraid = . if party == .

*Assume that everyone who checked no boxes for this question, including "none of the above"
*did not provide valid response. Code these as missing.
gen polar_frust_miss = polar_frustrated
replace polar_frust_miss = . if party == 2 & emtrep_a_w16 == 1 & emtrep_b_w16 == 1 & emtrep_c_w16 == 1 & emtrep_d_w16 == 1 & emtrep_e_w16 == 1 & emtrep_f_w16 == 1 & emtrep_g_w16 == 1
replace polar_frust_miss = . if party == 1 & emtdem_a_w16 == 1 & emtdem_b_w16 == 1 & emtdem_c_w16 == 1 & emtdem_d_w16 == 1 & emtdem_e_w16 == 1 & emtdem_f_w16 == 1 & emtdem_g_w16 == 1

gen polar_ang_miss = polar_angry
replace polar_ang_miss = . if party == 2 & emtrep_a_w16 == 1 & emtrep_b_w16 == 1 & emtrep_c_w16 == 1 & emtrep_d_w16 == 1 & emtrep_e_w16 == 1 & emtrep_f_w16 == 1 & emtrep_g_w16 == 1
replace polar_ang_miss = . if party == 1 & emtdem_a_w16 == 1 & emtdem_b_w16 == 1 & emtdem_c_w16 == 1 & emtdem_d_w16 == 1 & emtdem_e_w16 == 1 & emtdem_f_w16 == 1 & emtdem_g_w16 == 1

gen polar_afr_miss = polar_afraid
replace polar_afr_miss = . if party == 2 & emtrep_a_w16 == 1 & emtrep_b_w16 == 1 & emtrep_c_w16 == 1 & emtrep_d_w16 == 1 & emtrep_e_w16 == 1 & emtrep_f_w16 == 1 & emtrep_g_w16 == 1
replace polar_afr_miss = . if party == 1 & emtdem_a_w16 == 1 & emtdem_b_w16 == 1 & emtdem_c_w16 == 1 & emtdem_d_w16 == 1 & emtdem_e_w16 == 1 & emtdem_f_w16 == 1 & emtdem_g_w16 == 1

*Political engagement variables
gen rally = 1 if civic_eng_actmod_a_w16 == 2
recode rally (.=0)

gen campaign = 1 if civic_eng_actmod_c_w16 == 2
recode campaign (.=0)

gen member = 1 if civic_eng_actmod_d_w16 == 2
recode member (.=0)

gen contact = 1 if civic_eng_actmod_g_w16 == 2
recode contact (.=0)

gen donate = 1 if civic_eng_actmod_h_w16 == 2
recode donate (.=0)

gen display = 1 if civic_eng_actmod_i_w16 == 2
recode display (.=0)

gen online = 1 if civic_eng_actmod_j_w16 == 2
recode online (.=0)

*Recode as missing cases in which participants selected no boxes, including the one with "none of the above"
gen rally_missing = rally
replace rally_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen campaign_missing = campaign
replace campaign_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen member_missing = member
replace member_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen contact_missing = contact
replace contact_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen donate_missing = donate
replace donate_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen display_missing = display
replace display_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

gen online_missing = online
replace online_missing = . if civic_eng_actmod_a_w16 == 1 & civic_eng_actmod_c_w16 == 1 & civic_eng_actmod_d_w16 == 1 & civic_eng_actmod_g_w16 == 1 & civic_eng_actmod_h_w16 == 1 & civic_eng_actmod_i_w16 == 1 & civic_eng_actmod_j_w16 == 1 & civic_eng_actmod_k_w16 == 1

*Create dichotomous variables for analysis
gen highschool = 1 if edu == 2
replace highschool = 0 if edu == 1
replace highschool = 0 if edu == 3
replace highschool = 0 if edu == 4

gen some_college = 1 if edu == 3
replace some_college = 0 if edu == 1
replace some_college = 0 if edu == 2
replace some_college = 0 if edu == 4

gen college = 1 if edu == 4
replace college = 0 if inrange(edu,1,3)

gen age1 = .
replace age1 = 1 if age == 2
replace age1 = 0 if age == 1
replace age1 = 0 if age == 3
replace age1 = 0 if age == 4

gen age2 = .
replace age2 = 1 if age == 3
replace age2 = 0 if age == 1
replace age2 = 0 if age == 2
replace age2 = 0 if age == 4

gen age3 = .
replace age3 = 1 if age == 4
replace age3 = 0 if inrange(age,1,3)

gen black = 1 if race == 2
replace black = 0 if race == 1
replace black = 0 if race == 3
replace black = 0 if race == 4

gen hispanic = 1 if race == 3
replace hispanic = 0 if race == 1
replace hispanic = 0 if race == 2
replace hispanic = 0 if race == 4

gen other_race = 1 if race == 4
replace other_race = 0 if inrange(race,1,3)

*convert to mplus for analysis
stata2mplus weight_form_w16 srh male edu income party  ///
age race married polar_frust_miss polar_ang_miss polar_afr_miss rally_missing ///
campaign_missing member_missing contact_missing donate_missing display_missing ///
online_missing highschool some_college college ///
age1 age2 age3 black hispanic other_race insured using mplus_data



