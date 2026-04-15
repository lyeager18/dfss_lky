*** BEGIN ***

* Project: 549 analysis
* Created on: march 2026
* Created by: lky
* Edited on: 14 apr 2026
* Edited by: lky
* Stata v.19

* does
	* analysis of DFSS survey data 

* assumes
	* access to all data and code
	* ... 

* TO DO:
	* make histogram prettier
	
* NOTES:
	* heteroskedasticity test (, vce(cluster ___))
	* first difference model (score_before, score_during)
	* how to implement these for probit model?
	* predict the change in food stress (delta method?)
	* omitted variable bias
	
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

	*use 			"$data/dfss_both_final 2", clear
	use 			"$data/dfss_both_analysis_ready", clear
	
******************************************************************	
**# 2 - creating dependent variable (dfs_shock) 
******************************************************************

* 15 variables going into the dfs score 
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
					dfss_cook_1 dfss_equipment_1 dfss_services_1 dfss_budget_1), missing

*** during ***
	foreach var in 	supply selection kinds quality safe transport barriers ///
					health worry enjoy cook equipment services budget foodaid {
		gen 		dfss_`var'_2 = inlist(disasterfs_`var'_2, 1, 2)
					}
					
	egen 			score_during = rowtotal(dfss_supply_2 dfss_selection_2 ///
					dfss_kinds_2 dfss_quality_2 dfss_safe_2 dfss_transport_2 ///
					dfss_barriers_2 dfss_health_2 dfss_worry_2 dfss_enjoy_2 ///
					dfss_cook_2 dfss_equipment_2 dfss_services_2 dfss_budget_2), missing
	
	gen 			dfs_shock = score_during - score_before 
	
	tab 			dfs_shock /* 622 hhs experienced an increase in food stress, 266 reported lower food stress, 386 hh no change */
	*** make this histogram better ***
	histogram 		dfs_shock 
	
******************************************************************
**# 3 - creating dependent variables 
******************************************************************

* converting to numeric 

	foreach v in 	hh_children hh_sac hh_young hh_adults hh_elderly {
		destring 	`v', replace 
		replace 	`v' = 0 if missing(`v')
	}
	
* creating count variables of children, elderly and accounting for "ghost households"

	gen 			num_children = hh_children + hh_sac 	
	gen 			num_elderly = hh_elderly
	gen 			num_adults = hh_adults
	
	drop if 		num_children == 0 & num_elderly == 0 & num_adults == 0
	drop if 		num_elderly == 9 /* dropping outlier */
	
* creating dependency ratio
	
	gen 			dep_ratio = (num_children + num_elderly) / num_adults if num_adults > 0
	
* attempting with just hh size 

	gen 			hh_size = num_adults + num_elderly + num_children
	
* creating binary so i can try probit later

	gen 			shock_binary = .
	replace 		shock_binary = 1 if dfs_shock > 0 & !missing(dfs_shock)
	replace 		shock_binary = 0 if dfs_shock <= 0 & !missing(dfs_shock)
	
******************************************************************
**# 4 - defining control groups 
******************************************************************

	global wealth_controls i.income24 i.nutrition_snap i.nutrition_wic
	global demo_controls i.employment i.us_born i.non_white
	global fe_controls i.disaster_cat i.region
	
************************************************************************
**# 5 - models 
************************************************************************

**# model 1 - vulnerability severity (OLS)

**## first attempt using dep_ratio: 

	reg dfs_shock dep_ratio $wealth_controls $demo_controls $fe_controls, vce(cluster state)
	
	
/*           |               Robust
   dfs_shock | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
   dep_ratio |   .3058142   .2266781     1.35   0.184    -.1504652    
*/

**## next attempt, not using the ratio since it's not stat sig:

	reg dfs_shock hh_size $wealth_controls $demo_controls $fe_controls, vce(cluster state)
	
/*           |               Robust
   dfs_shock | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
     hh_size |   .1551735   .1212618     1.28   0.207    -.0886397    
*/

**## next attempt, since hh_size was still not stat sig:

	reg dfs_shock num_children num_adults num_elderly $wealth_controls $demo_controls $fe_controls, vce(cluster state)
	
/*	         |               Robust
   dfs_shock | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
num_children |   .1193747   .1737404     0.69   0.495    -.2299537    
  num_adults |   .1009501   .1161096     0.87   0.389    -.1325039    
 num_elderly |   .8531805   .3078069     2.77   0.008     .2342932    
*/

**## further attempt to see if i can tease out the effect of children :

	reg dfs_shock hh_children hh_sac num_adults num_elderly $wealth_controls $demo_controls $fe_controls, vce(cluster state)

/*           |               Robust
   dfs_shock | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
 hh_children |   .3018269   .3048372     0.99   0.327    -.3110893    
      hh_sac |   .0455687   .1588494     0.29   0.775    -.2738195    
  num_adults |   .1090732   .1164966     0.94   0.354    -.1251589    
 num_elderly |   .8642997    .308655     2.80   0.007     .2437073    
*/

**## last attempt with an interaction term:

	reg dfs_shock c.num_children##i.nutrition_wic num_adults num_elderly $wealth_controls $demo_controls $fe_controls, vce(cluster state)

/*           |               Robust
   dfs_shock | Coefficient  std. err.      t    P>|t|     [95% conf. interval]
-------------+----------------------------------------------------------------
num_children |   .1524811   .2063904     0.74   0.464    -.2624946    
> .5674567
1.nutritio~c |   -.728176   .6503963    -1.12   0.268    -2.035885    
> .5795334
             |
nutrition_~c#|
          c. |
num_children |
          1  |  -.1691846   .2687121    -0.63   0.532    -.7094665    
> .3710973
             |
  num_adults |   .1026975   .1160536     0.88   0.381     -.130644    
>  .336039
 num_elderly |   .8631158   .3092027     2.79   0.008      .241422    
>  1.48481
*/
	
**# model 2 - vulnerability (probit) 

* running the probit model
	probit shock_binary num_children num_adults num_elderly $wealth_controls $demo_controls $fe_controls, vce(cluster state)

* looking at the marginal effects 
	margins, dydx(num_children num_adults num_elderly)
	
/*           |            Delta-method
             |      dy/dx   std. err.      z    P>|z|     [95% conf. interval]
-------------+----------------------------------------------------------------
num_children |    .018477   .0181183     1.02   0.308    -.0170343    
> .0539883
  num_adults |   .0263647    .014212     1.86   0.064    -.0014904    
> .0542197
 num_elderly |   .0917501    .019272     4.76   0.000     .0539777    
> .1295225
------------------------------------------------------------------------------
*/

*** this is telling me that having an elderly household member increases the probability of experiencing a food shock in the first place ***

*** END *** 

	

