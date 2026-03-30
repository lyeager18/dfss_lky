*** BEGIN ***

* Project: DFSS validation 
* Created on: march 2026
* Created by: lky
* Edited on: 25 march 2026
* Edited by: lky
* Stata v.19

* does
	* analysis of DFSS survey data 

* assumes
	* access to all data and code
	* ... 

* TO DO:
	* ALL OF IT ...
	
******************************************************************
**# 0 - setup
******************************************************************

	clear 			all
	
* set $pack to 0 to skip package installation
	global 			pack 	0

* Specify Stata version in use
    global          stataVersion 19.5
    version         $stataVersion

******************************************************************
**# 1 - loading cleaned survey data 
******************************************************************

* importing the cleaned dataset

	use 			"$data/dfss_both_final", clear
	
******************************************************************	
**# 2 - identifying and naming core variables 
******************************************************************

* destringing and handling missing data 

******************************************************************
**# 2 - renaming (survey q# to variable) by section 
******************************************************************

**# consent 

	rename 			q2 eligibility 
	rename 			q3 consent 
	
**# screening 

	rename 			v14 rememberdis
	
**# quota questions 

	rename 			q4 income
	rename 			q5 child 
	rename 			q6 origin
	rename 			q7 race_ethn
	rename 			q7_6_text race_ethnt /* is t the correct naming? */
	
**# county

	rename 			q95 state 
	rename 			q96 al_county
	rename 			q97 ak_county 
	rename 			q98 az_county 
	rename 			q99 ar_county
	rename 			q100 ca_county
	rename 			q101 co_county
	rename 			q102 ct_county
	rename 			q103 de_county
	rename 			q104 fl_county
	rename 			q105 ga_county 
	rename 			q106 hi_county
	rename 			q107 id_county
	rename 			q108 il_county
	rename 			q109 in_county
	rename 			q110 ia_county
	rename 			q111 ks_county
	rename 			q112 ky_county 
	rename 			q113 la_county 
	rename 			q114 me_county 
	rename 			q115 md_county 
	rename 			q116 ma_county 
	rename 			q117 mi_county
	rename 			q118 mn_county 
	rename 			q119 ms_county
	rename 			q120 mo_county
	rename 			q121 mt_county
	rename 			q122 ne_county
	rename 			q123 nv_county
	rename 			q124 nh_county 
	rename 			q125 nj_county
	rename 			q126 nm_county
	rename 			q127 ny_county
	rename 			q128 nc_county
	rename 			q129 nd_county
	rename 			q130 oh_county 
	rename 			q131 ok_county
	rename 			q132 or_county
	rename 			q133 pa_county 
	rename 			q134 ri_county 
	rename 			q135 sc_county
	rename 			q136 sd_county
	rename 			q137 tn_county 
	rename 			q138 tx_county
	rename 			q139 ut_county
	rename 			q140 vt_county
	rename 			q141 va_county
	rename 			q142 wa_county
	rename 			q143 wv_county 
	rename 			q144 wi_county 
	rename 			q145 wy_county
	
**# disaster experience 

	rename 			q8 disaster_type 
	rename 			q9 disaster_name 
	rename 			q10 disaster_year 
	
	rename 			q11 effect_community 
	rename 			q11_11_text effect_communityt
	rename 			q12 effect_hh 
	rename 			q12_11_text effect_hht
	rename 			q13 evac
	rename 			q14 repair 
	*** not sure how to rename q17_18_1, q17_18_2, q17_18_3 ***
	rename 			q161 dworry 
	rename 			q161_1 dworry1_1 /* using _1 to capture time period 1 */
	rename 			q161_2 dworry2_1
	rename 			q161_3 dworry3_1
	rename 			q161_4 dworry4_1
	rename 			q161_5 dworry5_1
	rename 			q161_6 dworry6_1
	rename 			q161_7 dworry7_1
	rename 			q161_8 dworry8_1
	rename 			q161_9 dworry9_1
	rename 			q161_10 dworry10_1
	rename 			q161_11 dworry11_1
	rename 			q161_12 dowrry12_1
	rename 			q161_13 dworry13_1
	rename 			q161_14 dworry_other_1
	rename 			q161_14_text dworry_othert_1 
	*** no obs for dworry* ***
	
	rename 			q162_1 dworry1_2 /* using _2 to capture time period 2 */
	rename 			q162_2 dworry2_2
	rename 			q162_3 dworry3_2
	rename 			q162_4 dworry4_2
	rename 			q162_5 dworry5_2
	rename 			q162_6 dworry6_2 
	rename 			q162_7 dworry7_2
	rename 			q162_8 dworry8_2
	rename 			q162_9 dworry9_2
	rename 			q162_10 dworry10_2
	rename 			q162_11 dworry11_2
	rename 			q162_12 dworry12_2
	rename 			q162_13 dworry13_2 
	rename 			q162_14 dworry_other_2
	rename 			q162_14_text dworry_othert_2
	
**# disaster 6-item food security survey module 
	
	rename 			q171_1 disaster_hfssm1_1 
	rename 			q171_2 disaster_hfssm2_1
	rename 			q171_3 disaster_hfssm3_1
	rename 			q171_4 disaster_hfssm6_1 /* old variable included a 6, maybe referencing the survey # from the hfssm? */
	
	rename 			q172_1 disaster_hfssm1_2
	rename 			q172_2 disaster_hfssm2_2
	rename 			q172_3 disaster_hfssm3_2
	rename 			q172_4 disaster_hfssm6_2
	
	rename 			q173_1 disaster_hfssm1_3
	rename 			q173_2 disaster_hfssm2_3
	rename 			q173_3 disaster_hfssm3_3
	rename 			q173_4 disaster_hfssm6_3
	
	rename 			q181_1 disaster_hfssm9_1 
	rename 			q182_1 disaster_hfssm9_2
	rename 			q183_1 disaster_hfssm9_3
	
	rename 			q191_1 disaster_hfssm_1 /* what number should follow hfssm? */
	rename 			q192_1 disaster_hfssm_2
	rename 			q193_1 disaster_hfssm_3
	
**## disaster coping strategies 

	rename			q201_1 dpractice_stock_1
	rename 			q201_2 dpractice_substitute_1
	rename 			q201_3 dpractice_budget_1
	rename 			q201_4 dpractice_price_1
	rename			q201_5 dpractice_places_1
	rename 			q201_6 dpractice_delivery_1
	rename 			q201_7 dpractice_family_1
	rename 			q201_8 dpractice_programs_1
	rename 			q201_9 dpractice_other_1
	rename 			q201_9_text dpractice_othert_1
	
	rename 			q202_1 dpractice_stock_2
	rename 			q202_2 dpractice_substitute_2
	rename 			q202_3 dpractice_budget_2
	rename 			q202_4 dpractice_price_2
	rename 			q202_5 dpractice_places_2
	rename 			q202_6 dpractice_delivery_2
	rename 			q202_7 dpractice_family_2
	rename 			q202_8 dpractice_programs_2
	rename 			q202_9 dpractice_other_2
	rename 			q202_9_text dpractice_othert_2
	
	rename 			q203_1 dpractice_stock_3
	rename 			q203_2 dpractice_substitute_3
	rename 			q203_3 dpractice_budget_3
	rename 			q203_4 dpractice_price_3
	rename 			q203_5 dpractice_places_3
	rename 			q203_6 dpractice_delivery_3
	rename 			q203_7 dpractice_family_3
	rename 			q203_8 dpractice_programs_3
	rename 			q203_9 dpractice_other_3
	rename 			q203_9_text dpractice_othert_3
	
	rename 			q211_1 dplaces_grocery_1
	rename 			q211_2 dplaces_convenience_1
	rename 			q211_3 dplaces_general_1
	rename 			q211_4 dplaces_specialty_1
	rename 			q211_5 dplaces_grocerydel_1
	rename 			q211_6 dplaces_mealkit_1
	rename 			q211_7 dplaces_mealdel_1
	rename 			q211_8 dpalces_rest_1
	rename 			q211_9 dplaces_group_1
	rename 			q211_10 dplaces_dine_1
	rename 			q211_11 dplaces_snap_1
	rename 			q211_12 dplaces_wic_1
	rename 			q211_13 dplaces_pantry_1
	rename 			q211_14 dplaces_school_1
	rename 			q211_15 dplaces_farm_1
	rename 			q211_16 dplaces_grow_1
	rename 			q211_17 dplaces_other_1
	rename			q211_17_text dplaces_othert_1
	
	rename 			q212_1 dplaces_grocery_2
	rename 			q212_2 dplaces_convenience_2
	rename 			q212_3 dplaces_general_2
	rename 			q212_4 dplaces_specialty_2
	rename 			q212_5 dplaces_grocerydel_2
	rename 			q212_6 dplaces_mealkit_2
	rename 			q212_7 dplaces_mealdel_2
	rename 			q212_8 dpalces_rest_2
	rename 			q212_9 dplaces_group_2
	rename 			q212_10 dplaces_dine_2
	rename 			q212_11 dplaces_snap_2
	rename 			q212_12 dplaces_wic_2
	rename 			q212_13 dplaces_pantry_2
	rename 			q212_14 dplaces_school_2
	rename 			q212_15 dplaces_farm_2
	rename 			q212_16 dplaces_grow_2
	rename 			q212_17 dplaces_other_2
	rename			q212_17_text dplaces_othert_2
	
	rename 			q213_1 dplaces_grocery_3
	rename 			q213_2 dplaces_convenience_3
	rename 			q213_3 dplaces_general_3
	rename 			q213_4 dplaces_specialty_3
	rename 			q213_5 dplaces_grocerydel_3
	rename 			q213_6 dplaces_mealkit_3
	rename 			q213_7 dplaces_mealdel_3
	rename 			q213_8 dpalces_rest_3
	rename 			q213_9 dplaces_group_3
	rename 			q213_10 dplaces_dine_3
	rename 			q213_11 dplaces_snap_3
	rename 			q213_12 dplaces_wic_3
	rename 			q213_13 dplaces_pantry_3
	rename 			q213_14 dplaces_school_3
	rename 			q213_15 dplaces_farm_3
	rename 			q213_16 dplaces_grow_3
	rename 			q213_17 dplaces_other_3
	rename			q213_17_text dplaces_othert_3
	
**## disaster water security 

	rename 			q22 water_source
	rename 			q22_5_text water_source_other
	
	rename 			q231_1 dwater_hh_1 
	rename 			q231_2 dwater_personal_1
	rename 			q231_3 dwater_problems_1 
	rename 			q231_4 dwater_bad_1
	
	rename 			q232_1 dwater_hh_2
	rename 			q232_2 dwater_personal_2
	rename 			q232_3 dwater_problems_2
	rename 			q232_4 dwater_bad_2
	
	rename 			q233_1 dwater_hh_3
	rename 			q233_2 dwater_personal_3
	rename 			q233_3 dwater_problems_3
	rename 			q233_4 dwater_bad_3 
	
**## mental health 
	
	*** already renamed ***	
	
**## housing stability 

	rename 			q25 housing
	
**## health status 

	rename 			q26 health
	rename 			q27 health_issues
	rename 			q27_10_text health_issues_othert
	
**## demographics 

	rename 			q70 age 
	rename 			q71 gender 
	rename 			q72 hispanic 
	rename 			q73 ethnicity 
	rename 			q74 education
	rename 			q74_2_text school_yearst
	rename 			q75 disaster_count
	rename 			q76 dependents 
	rename 			q77_1 hh_children
	rename 			q77_2 hh_sac
	rename 			q77_3 hh_young
	rename 			q77_4 hh_adults
	rename 			q77_5 hh_elderly
	rename 			q78 employment 
	rename 			q78_8_text employment_othert
	rename 			q79 income24
	rename 			q81 partner
	rename 			q82 nutrition
	rename 			q82_6_text nutrition_othert
	rename 			q83 diet
	rename 			q83_7_text diet_othert
	rename 			q84 disability 
	rename 			q153 us_born 
	rename 			q154 us_citizen
	rename 			q161 region
	rename 			q155 additional_info

	
* generating new variables that are needed 





	* Step 1: Create binary "affirmative" variables for Wave 1
* This logic matches your professor's requirement that a score of 1 or 2 counts as 'stressed'
foreach var in supply selection kinds quality safe transport barriers health worry ///
               enjoy cook equipment services budget {
    gen dfss_`var'_affirm = inlist(disasterfs_`var'_1, 1, 2)
}

* Step 2: Sum the score (Scale of 0-15)
egen dfss_missing = rowmiss(disasterfs_supply_1 disasterfs_selection_1 ///
    disasterfs_kinds_1 disasterfs_quality_1 disasterfs_safe_1 disasterfs_transport_1 ///
    disasterfs_barriers_1 disasterfs_health_1 disasterfs_worry_1 disasterfs_enjoy_1 ///
    disasterfs_cook_1 disasterfs_equipment_1 disasterfs_services_1 disasterfs_budget_1)

gen dfss_score = .
replace dfss_score = ///
    dfss_supply_affirm + dfss_selection_affirm + dfss_kinds_affirm + ///
    dfss_quality_affirm + dfss_safe_affirm + dfss_transport_affirm + dfss_barriers_affirm + ///
    dfss_health_affirm + dfss_worry_affirm + dfss_enjoy_affirm + dfss_cook_affirm + ///
    dfss_equipment_affirm + dfss_services_affirm + dfss_budget_affirm ///
    if dfss_missing == 0

* Step 3: Log transformation for OLS (as recommended by professor)
gen dfss_score_log10 = log10(dfss_score + 1)

************************************************************************
** ANALYSIS FOR TERM PAPER
************************************************************************

* A. Summary Statistics for the Model
summarize dfss_score num_children num_elderly income22

* B. Primary OLS Model (with Robust Standard Errors for Heteroskedasticity)
reg dfss_score_log10 num_children num_elderly i.income22 i.ethnicity_new, vce(robust)

* C. Diagnostic: Multicollinearity (VIF)
* Run this after the regression to ensure your variables aren't too correlated
vif

* D. Ordered Probit Model (Advanced)
* Use the raw score (0-15) as the dependent variable
oprobit dfss_score num_children num_elderly i.income22 i.ethnicity_new, vce(robust)

* E. Marginal Effects
* This is essential for interpreting the Probit model results for your paper
margins, dyex(*) atmeans

******************************************************************
**# 2 - renaming and generating variables (mapping to survey q# and variable list) by section *** NOT ALL NEED TO BE RENAMED ***
******************************************************************

* consent & screening section

	* all variables in this section are appropriately named

* quota section
	
	capture rename q7_6_text race_ethn_other

* states and counties section

	* all variables in this section are appropriately named

* disaster experience section

	rename 			q11 effect_community 
	
	* ------------------------------------------------------------------------------
* STEP: Break out comma-separated "Check All That Apply" (Question 11)
* ------------------------------------------------------------------------------

* 1. Create a temporary helper variable wrapped in commas
* (This safely turns a response like "1,4" into ",1,4,")
gen temp_comm = "," + effect_community + ","

* 2. Generate new 0/1 dummy variables for each of the 11 checkboxes
* (It searches for the number inside the commas. If found=1, if not=0)
gen effect_community1 = (strpos(temp_comm, ",1,") > 0) if effect_community != ""
gen effect_community2 = (strpos(temp_comm, ",2,") > 0) if effect_community != ""
gen effect_community3 = (strpos(temp_comm, ",3,") > 0) if effect_community != ""
gen effect_community4 = (strpos(temp_comm, ",4,") > 0) if effect_community != ""
gen effect_community5 = (strpos(temp_comm, ",5,") > 0) if effect_community != ""
gen effect_community6 = (strpos(temp_comm, ",6,") > 0) if effect_community != ""
gen effect_community7 = (strpos(temp_comm, ",7,") > 0) if effect_community != ""
gen effect_community8 = (strpos(temp_comm, ",8,") > 0) if effect_community != ""
gen effect_community9 = (strpos(temp_comm, ",9,") > 0) if effect_community != ""
gen effect_community10 = (strpos(temp_comm, ",10,") > 0) if effect_community != ""
gen effect_community11 = (strpos(temp_comm, ",11,") > 0) if effect_community != ""

* 3. Drop the temporary helper variable so your dataset stays clean
drop temp_comm

* 4. Apply your Yes/No value labels to these new variables
capture label values effect_community1-effect_community11 yesno_lbl

	capture rename q11_1 effect_community1
	capture rename Q11_2 effect_community2
	capture rename Q11_3 effect_community3
	capture rename Q11_4 effect_community4
	capture rename Q11_5 effect_community5
	capture rename Q11_6 effect_community6
	capture rename Q11_7 effect_community7
	capture rename Q11_8 effect_community8
	capture rename Q11_9 effect_community9
	capture rename Q11_10 effect_community10
	capture rename Q11_11 effect_community11
	capture rename Q11_11_TEXT effect_communityt

capture rename Q12_1 effect_hh1
capture rename Q12_2 effect_hh2
capture rename Q12_3 effect_hh3
capture rename Q12_4 effect_hh4
capture rename Q12_5 effect_hh5
capture rename Q12_6 effect_hh6
capture rename Q12_7 effect_hh7
capture rename Q12_8 effect_hh8
capture rename Q12_9 effect_hh9
capture rename Q12_10 effect_hh10
capture rename Q12_11 effect_hh11
capture rename Q12_11_TEXT effect_hht

capture rename Q13  evac
capture rename Q14  repair

* Cause of worry/anxiety
capture rename Q16#1_1  dworry1
capture rename Q16#1_2  dworry2
capture rename Q16#1_3  dworry3
capture rename Q16#1_4  dworry4
capture rename Q16#1_5  dworry5
capture rename Q16#1_6  dworry6
capture rename Q16#1_7  dworry7
capture rename Q16#1_8  dworry8
capture rename Q16#1_9  dworry9
capture rename Q16#1_10 dworry10
capture rename Q16#1_11 dworry11
capture rename Q16#1_12 dworry12
capture rename Q16#1_13 dworry13
capture rename Q16#1_14 dworry_other
capture rename Q16#1_14_TEXT dworry_othert

* Food Security scale questions 
capture rename Q17#1_1  disaster_hfssm1
capture rename Q17#1_2  disaster_hfssm2
capture rename Q17#1_3  disaster_hfssm3
capture rename Q17#1_4  disaster_hfssm6
capture rename Q18#1_1  disaster_hfssm9

* Disaster Coping Strategies
capture rename Q20#1_1  dpractice_stock
capture rename Q20#1_2  dpractice_substitute
capture rename Q20#1_3  dpractice_budget
capture rename Q20#1_4  dpractice_price
capture rename Q20#1_5  dpractice_places
capture rename Q20#1_6  dpractice_delivery
capture rename Q20#1_7  dpractice_family
capture rename Q20#1_8  practice_programs
capture rename Q20#1_9  dpractice_other
capture rename Q20#1_10 dpractice_othert

* Demographics & Health
capture rename Q26   health
capture rename Q70   age
capture rename Q71   gender
capture rename Q72   hispanic
capture rename Q73   ethnicity
capture rename Q74   education
capture rename Q75   disaster_count
capture rename Q76   dependents

capture rename Q77_1 hh_children
capture rename Q77_2 hh_sac
capture rename Q77_3 hh_young
capture rename Q77_4 hh_adults
capture rename Q77_5 hh_elderly

capture rename Q78   employment
capture rename Q153  us_born
capture rename Q154  us_citizen
capture rename Q161  us_region

capture rename Q79   income22
capture rename Q81   partner

capture rename Q82_1 nutrition_snap
capture rename Q82_2 nutrition_wic
capture rename Q82_3 nutrition_school
capture rename Q82_4 nutrition_pantry
capture rename Q82_5 nutrition_community
capture rename Q82_6 nutrition_other
capture rename Q82_6_TEXT nutrition_othert
capture rename Q82_7 nutrition_none

capture rename Q83_1 diet_allergy
capture rename Q83_2 diet_sensitivity
capture rename Q83_3 diet_weight
capture rename Q83_4 diet_health
capture rename Q83_5 diet_religious
capture rename Q83_6 diet_ethical
capture rename Q83_7 diet_other
capture rename Q83_7_TEXT diet_othert
capture rename Q83_8 diet_none

capture rename Q84   disability
capture rename Q155  experience_share


* ------------------------------------------------------------------------------
* STEP 3: DESTRING AND APPLY VALUE LABELS
* ------------------------------------------------------------------------------

* Eligibility, Consent, and Demographics
label define ynl 1 "Yes" 2 "No"
label define ynl_0 1 "Yes" 0 "No"

capture destring eligibility consent remeberdis income child hispanic_origin, replace force
capture label values eligibility ynl
capture label values consent ynl
capture label values remeberdis ynl
capture label values child ynl
capture label values hispanic_origin ynl

label define incomel 1 ">$50K" 2 "$50K<"
capture label values income incomel

* Geography (States)
capture destring state, replace force
label define statel 5 "Alabama" 54 "Rhode Island" 
capture label values state statel

* Disaster Experience
capture destring disaster_type disaster_year evac repair, replace force

label define dis_typel 1 "Avalanche" 2 "Coastal flooding" 3 "Cold wave" 4 "Drought" ///
    5 "Earthquake" 6 "Hail" 7 "Heat wave" 8 "Hurricane" 9 "Ice storm" ///
    10 "Landslide" 11 "Lightning" 12 "Riverine flooding" 13 "Strong wind" ///
    14 "Tornado" 15 "Tsunami" 16 "Volcanic activity" 17 "Wildfire" 18 "Winter weather"
capture label values disaster_type dis_typel

label define dis_yearl 1 "2017" 2 "2018" 3 "2019" 4 "2020" 5 "2021" 6 "2022" 7 "Other year"
capture label values disaster_year dis_yearl

label define evacl 1 "Yes, we all did" 2 "Yes, some HH members did" 3 "No"
capture label values evac evacl

label define repairl 1 "Affected: cosmetic damage" 2 "Minor: non-structural and repairable" ///
    3 "Major: structural damage" 4 "Destroyed: total loss" 5 "Not damaged"
capture label values repair repairl

* Disaster Food Security Module (DFSS)
* Replaces 4 and 5 (NA/Don't know) with missing (.) and maps frequencies
local dfss_vars disasterfs_supply_1 disasterfs_selection_1 disasterfs_kinds_1 ///
    disasterfs_quality_1 disasterfs_safe_1 disasterfs_transport_1 disasterfs_barriers_1 ///
    disasterfs_health_1 disasterfs_worry_1 disasterfs_enjoy_1 disasterfs_cook_1 ///
    disasterfs_equipment_1 disasterfs_services_1 disasterfs_budget_1 disasterfs_foodaid_1 ///
    disaster_hfssm1 disaster_hfssm2 disaster_hfssm3

foreach var of local dfss_vars {
    capture destring `var', replace force
    capture replace `var' = . if `var' == 4 | `var' == 5
}

label define freq_label 0 "Never True" 1 "Sometimes True" 2 "Often True"
foreach var of local dfss_vars {
    capture label values `var' freq_label
}

capture destring disaster_hfssm6 disaster_hfssm9, replace force
capture label values disaster_hfssm6 ynl
capture label values disaster_hfssm9 ynl

* Coping Strategies
local coping dpractice_stock dpractice_substitute dpractice_budget dpractice_price ///
    dpractice_places dpractice_delivery dpractice_family practice_programs dpractice_other

foreach var of local coping {
    capture destring `var', replace force
    capture label values `var' ynl_0
}

* Demographics & Health continued
capture destring gender ethnicity education dependents employment income22 partner health, replace force

label define genderl 1 "Male" 2 "Female" 3 "Non-binary, third gender" 4 "Prefer not to say"
capture label values gender genderl

label define ethnl 1 "American Indian/ Alaska Native" 2 "Asian" 3 "Black or African American" ///
    4 "Native Hawaiian/ Pacific Islander" 5 "White"
capture label values ethnicity ethnl

label define edul 1 "No schooling" 2 "Grades 1-12" 3 "High school graduate or GED" ///
    4 "Some college" 5 "Associates degree" 6 "Bachelor's degree" 7 "Master's degree" ///
    8 "Professional or doctorate degree"
capture label values education edul

label define depl 1 "None" 2 "1" 3 "2" 4 "3" 5 "4" 6 "5 or more"
capture label values dependents depl

label define empl 1 "Full time" 2 "Part time" 3 "Unemployed" 4 "Retired" ///
    5 "Student" 6 "Homemaker" 7 "Disabled, not able to work" 8 "Other"
capture label values employment empl

label define inc22l 1 "< $25,000" 2 "$25,000 - $49,999" 3 "$50,000 - $74,999" ///
    4 "$75,000 - $100,000" 5 ">$100,000"
capture label values income22 inc22l

label define partnerl 1 "Single" 2 "Married" 3 "Living with a partner" 4 "Divorced" 5 "Widowed"
capture label values partner partnerl

label define healthl 1 "Excellent" 2 "Very good" 3 "Good" 4 "Fair" 5 "Poor"
capture label values health healthl


* ------------------------------------------------------------------------------
* STEP 4: SAVE THE CLEANED DATA
* ------------------------------------------------------------------------------
*save "DFSS_Cleaned_Labeled_Data.dta", replace
