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

	foreach v in q77_1 q77_2 q77_3 q77_4 q77_5 {
		destring 	`v', replace force
		replace `v' = 0 if missing(`v')
	}
	
* identifying and renaming independent variables of interest for the paper 

	rename 			q70 age 
	
	rename 			q79 income24 
	lab var 		income24 "2024 Annual Household Income"
	
	rename 			q5 children_present 
	lab def 		children_present 0 "no children" 1 "child"
	recode 			children_present (2=0) (1=1) 
	
	rename 			q77_1 child_count_young /* children under age 5 */
*** NEEDS RECODING AND DROPPING ***
	rename 			q77_2 child_count_sac /* school aged children */
*** NEEDS RECODING AND DROPPING ***

	rename 			q77_5 elderly_count 
*** NEEDS RECODING AND DROPPING ***

	rename 			q77_4 adults_wa /* working aged adults */
*** NEEDS RECODING AND DROPPING ***

* other possible independent variables to use (partner, dependents)

* identifying and renaming control variables 

	rename 			q74 education
	
	rename 			q73 gender

	rename 					

	
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
