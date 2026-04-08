*** BEGIN ***

* Project: DFSS validation 
* Created on: march 2026
* Created by: lky
* Edited on: 6 apr 2026
* Edited by: lky
* Stata v.19

* does
	* analysis of DFSS survey data 

* assumes
	* access to all data and code
	* ... 

* TO DO:
	* ALL OF IT ...
	
* NOTES:
	* heteroskedasticity test 
	* use clustered standard errors 
	* how to implement these for probit model?
	* predict the change in food stress (delta method?)
	* omitted variable bias
	* autocorrelation using newey-west 
	
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
**# 1 - loading analysis ready data
******************************************************************

* importing the cleaned, named, and labeled dataset

	use 			"$data/dfss_both_final 2", clear
	*use 			"$data/dfss_both_analysis_ready", clear
	
******************************************************************	
**# 2 - creating dependent variable (dfss_score) 
******************************************************************

* 15 variables going into the dfss score 
* only want the significant answers of sometimes true and often true 
* accounting for before and during the disaster (to identify initial food insecurity)

*** before ***
	foreach var in 	supply selection kinds quality safe transport barriers ///
					health worry enjoy cook equipment services budget foodaid {
		gen 			dfss_`var'_1 = inlist(disasterfs_`var'_1, 1, 2)
					}
					
	egen 			score_before = rowtotal(dfss_supply_1 dfss_selection_1 ///
					dfss_kinds_1 dfss_quality_1 dfss_safe_1 dfss_transport_1 ///
					dfss_barriers_1 dfss_health_1 dfss_worry_1 dfss_enjoy_1 ///
					dfss_cook_1 dfss_equipment_1 dfss_services_1 dfss_budget_1)

*** during ***
	foreach var in 	supply selection kinds quality safe transport barriers ///
					health worry enjoy cook equipment services budget foodaid {
		gen 		dfss_`var'_2 = inlist(disasterfs_`var'_2, 1, 2)
					}
					
	egen 			score_during = rowtotal(dfss_supply_2 dfss_selection_2 ///
					dfss_kinds_2 dfss_quality_2 dfss_safe_2 dfss_transport_2 ///
					dfss_barriers_2 dfss_health_2 dfss_worry_2 dfss_enjoy_2 ///
					dfss_cook_2 dfss_equipment_2 dfss_services_2 dfss_budget_2)
	
	gen 			dfss_shock = score_during - score_before 
	
	tab 			dfss_shock /* 591 hhs experienced an increase in food stress, 205 reported lower food stress */
	histogram 		dfss_shock
	
	
******************************************************************
**# 3 - creating dependent variables ()
******************************************************************

* converting to numeric (*** need to clean before this will run ***)

	foreach v in 	hh_children hh_sac hh_young hh_adults hh_elderly {
		destring 	`v', replace 
		replace 	`v' = 0 if missing(`v')
	}
	
* creating count variables of children, elderly, or dependents?

	gen 			num_children = hh_children + hh_sac 
	gen 			num_elderly = hh_elderly
	gen 			num_adults = hh_adults
	
* creating dependency ratio
	
	gen 			dep_ratio = (num_children + num_elderly) / num_adults if num_adults > 0

************************************************************************
** 4 - models 
************************************************************************


