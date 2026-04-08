*** BEGIN ***

* Project: DFSS analysis cleaning 
* Created on: apr 2026
* Created by: lky
* Edited on: 7 apr 2026
* Edited by: lky
* Stata v.19

* does
	* cleaning and relabeling of DFSS survey data to use in analysis

* assumes
	* access to all data and code
	* ... 

* TO DO:
	* ALL OF IT ...
	* ask anna questions and finish any cleaning 
	
* NOTES:
	
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

	use 			"$data/dfss_both_final 2", clear

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
	rename 			q161_12 dworry12_1
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
	rename 			q211_8 dplaces_rest_1
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
	rename 			q212_8 dplaces_rest_2
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
	rename 			q213_8 dplaces_rest_3
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
	*rename 			q161 region
	rename 			q155 additional_info
	
* describe disaster variables 

	describe disasterfs_*
	tab1 disasterfs_*, m 
	mdesc disasterfs_*
	
* current variables are 1 = never true 2 = sometimes true 3 = often true 4 = don't know / not applicable  
	
* recode all the disasterfs_* variables to be 0=never true, 1=, 2, ...
	lab def fsl 0 "Never true" 1 "Sometimes true" 2 "Often true" 3 ""
	recode disasterfs_* (1=0) (2=1) (3=2) (4 5 6 = .)
	lab val disasterfs_* fsl
	
* confirming that variables have been recoded 

	tab1 disasterfs_*, m /* looked at data editor and think i did this correctly */
	
******************************************************************
**# 4 - preparing independent variables for analysis 
******************************************************************	

**# recoding
	recode 			child (1=0) (2=1)
	recode 			dependents (1=0) (2=1) (3=2) (4=3) (5=4) (6=5)
	
**# cleaning
	replace 		hh_children = "0" if inlist(hh_children, "O", "none", "p0")
	destring 		hh_children, replace /* converting the text variable into a numeric variable */
    gen 			hh_children_clean = hh_children

* verify the result
	tabulate 		hh_children_clean
	rename 			hh_children_clean hh_children
	
	replace 		hh_sac = "0" if inlist(hh_sac, "O", "P", "none") 
	replace 		hh_sac = "1" if inlist(hh_sac, "13", "14", "16") /* changing the ages to count of "1" */
	*** ASK ANNA - is this appropriate ***
	destring 		hh_sac, replace
	tabulate 		hh_sac
	
	replace 		hh_young = "0" if inlist(hh_young, "0", "P", "none", "None", "o")
	*** ASK ANNA - how do i account for the 2 response ***
	destring 		hh_young, replace /* can't destring yet */
	tabulate 		hh_young
	
	replace 		hh_adult = "0" if inlist(hh_adult, "O")
	*** ASK ANNA - how do i account for the other silly responses? ***
	destring 		hh_adult, replace /* can't destring yet */
	
	replace 		hh_elderly = "0" if inlist(hh_elderly, "N/A", "None", "none", ///
					"o", "O")
	*** ASK ANNA - how do i account for the other silly responses? ***
	destring 		hh_elderly, replace /* can't destring yet */
	
******************************************************************
**# 5 - preparing controls for analysis 
******************************************************************
	
**# wealth proxies
	lab def 		income_lbl 1 "< $25,000" 2 "$25,000 - $49,999" 3 "$50,000 - $74,999" ///
					4 "$75,000 - $100,000" 5 "> $100,000"	
	lab val 		income24 income_lbl
	lab var 		income24 "Annual Household Income (Binned)"
	
	gen 			nutrition_snap = strpos(nutrition, "1") > 0 
	gen 			nutrition_wic = strpos(nutrition, "2") > 0
	*** ASK ANNA - how to account for snap in different periods? ***
	*** ASK ANNA - using the housing variable rent, mortgage, utility bills ***
	
**# demographics 
	recode 			disability (2=0) (1=1)
	recode 			hispanic (2=0) (1=1) /* what else goes into race */
	*** ASK ANNA - use ethnicity variable instead and gen as minority ***
	recode 			us_born (2=0) (1=1)
	
	destring 		employment, replace force
	lab def 		employment_lbl 1 "Full time" 2 "Part time" 3 "Unemployed" ///
					4 "Retired" 5 "Student" 6 "Homemaker" 7 "Disabled, not able to work" ///
					8 "other"
	lab val			employment employment_lbl
	lab var 		employment "Employment Status"

**# fixed effects 
	
	lab def 		disaster_lbl 1 "Avalanche" 2 "Coastal flooding" 3 "Cold wave" ///
					4 "Drought" 5 "Earthquake" 6 "Hail" 7 "Heat wave" ///
					8 "Hurricane" 9 "Ice storm" 10 "Landslide" 11 "Lightening" ///
					12 "Riverine flooding" 13 "Strong wind" 14 "Tornado" ///
					15 "Tsunami" 16 "Volcanic activity" 17 "Wildfire" ///
					18 "Winter weather"
	lab val 		disaster_type disaster_lbl
	lab var 		disaster_type "Type of Disaster Experienced"
	
	*** ASK ANNA - what variable should I be using for location? ***

	
**# saving 

	save 			"$data/dfss_both_analysis_ready", replace
	
*** END *** 
	
