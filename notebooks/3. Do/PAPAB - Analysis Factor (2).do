* Project: PAPAB (Impact Study)
* Country: Burundi
* Survey: 2019
* Objective: Factor Analysis
* Author: Marieke Meeske
* Date: 29-01-2020

*********************************************************************
*IMPORT+CD
*********************************************************************

cd "C:/Users/`c(username)'/Box\ONL-IMK/2.0 Projects/Current/2018-05 PAPAB Burundi/07. Analysis & reflection/Data & Analysis"
use "2. Clean\PAPAB Impact study - Analysis1.dta", clear
set more off, perm
estimates clear

//for all:
//check predict values, because they seem strange




*********************************************************************
*Pillar 1: Motivation
*********************************************************************

//////////////////////////////////////
*Items to sub construct
//////////////////////////////////////


/*
*min-max rescaling for items not ranging from 1-5.

*rescaling to min-max (1-5) according
formula: 
V(new)=	((Max(new)-Min(new))/(Max(old)-Min(old))*(Value(old)-Max(old)) + Max(new)


list of items that need rescaling: 

///////////motivation///////////
m_pur_con_plans					(1-4)  
m_pur_conactionstaken			(1-4) 

attitude 
m_att_eag_askothers				(1-4) 			
m_att_drive_newpractices 		(1-9)

household support
m_hhsup_coll_whoplan  			(1-3)

village support
m_vilsup_coll_samevision  		(1-7)                    

*/




rename m_pur_con_plans m_pur_con_plans_old
rename m_pur_con_actionstaken m_pur_con_actionstaken_old
rename m_att_eag_askothers m_att_eag_askothers_old
rename m_hhsup_coll_whoplan m_hhsup_coll_whoplan_old
rename m_vilsup_coll_samevision m_vilsup_coll_samevision_old

gen	m_pur_con_plans				=	((5-1)/(4-1))	*	(	m_pur_con_plans_old				-	4)		+	5
gen	m_pur_con_actionstaken		=	((5-1)/(4-1))	*	(	m_pur_con_actionstaken_old		-	4)		+	5
gen	m_att_eag_askothers			=	((5-1)/(4-1))	*	(	m_att_eag_askothers_old			-	4)		+	5
gen	m_hhsup_coll_whoplan		=	((5-1)/(3-1))	*	(	m_hhsup_coll_whoplan_old		-	3)		+	5
gen	m_vilsup_coll_samevision	=	((5-1)/(7-1))	*	(	m_vilsup_coll_samevision_old	-	7)		+	5

lab var	m_pur_con_plans				"rescaled 1-5:	Can you please describe the plans or aspirations your household has for the near "
lab var	m_pur_con_actionstaken		"rescaled 1-5: 	Can you please describe concrete actions our household has taken in the recent"
lab var	m_att_eag_askothers			"rescaled 1-5:	When you see changes on other farms, how often would you then ask the owner wh"	 
lab var	m_hhsup_coll_whoplan		"rescaled 1-5:	Who is usually doing the planning of agricultural activities within the househo" 
lab var	m_vilsup_coll_samevision	"rescaled 1-5:	People generally have the same vision, in this village?" 

order	m_pur_con_plans	, 			before(	m_pur_con_plans_old				)
order	m_pur_con_actionstaken, 		before(	m_pur_con_actionstaken_old	)
order	m_att_eag_askothers	, 		before(	m_att_eag_askothers_old			)
order	m_hhsup_coll_whoplan, 		before(	m_hhsup_coll_whoplan_old		)
order	m_vilsup_coll_samevision, 	before(	m_vilsup_coll_samevision_old	)



///////////motivation///////////


*purpose
tab1	 	m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_stay m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken
pwcorr 		m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_stay m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken, st(0.5)
			//corr ok, apart from m_pur_fut_stay (= very low)
factor 		m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_stay m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken, pf mine(1)
rotate, 	promax blanks(0.3)
			//only 1 factor with eigenvalue>1; m_pur_fut_stay has little contribution (and high uniqueness) --> drop
//scree		//indeed: knik between 1 and 2
factor 		m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken, pf mine(1)
rotate, 	promax blanks(0.3)			
			//all items have factor loadings >0.6 --> good
alpha		m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken, gen(m_pur_mean)
			//scale reliability: 0.8127
predict		m_pur_pr	
		
*autonomy
tab1		m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp
pwcorr		m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp, st(0.5)
			//all seem ok (at least >0.25)
factor		m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp, pf mine(1)
			//again only 1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all items >0.5 factor loading
alpha		m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp, gen(m_aut_mean)
			//scale reliability: 0.8106
predict		m_aut_pr

*attitude
tab1		m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud
pwcorr		m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud, st(0.5)
			//seems ok; at least 0.15 and significant	
factor		m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud, pf mine(1)
			//again, 1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all items >0.3 factor loading, but most of them have even higher values
alpha		m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud, gen(m_att_mean)
			//scale reliability: 0.8026
predict		m_att_pr

*household support
tab1		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney
recode		m_hhsup_coll_whoplan (2=1) (3=2) (4=3)	//about collaboration: husband/wife separate=1; jointly=2; whole hh=3
pwcorr		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, st(0.5)
			//most of them are >0.1 and significant; not all (m_hhsup_mut_confl_hh)
factor		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, pf mine(1)
			//again, 1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all above >0.3, apart from m_hhsup_mut_confl_hh --> drop
factor		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, pf mine(1)
rotate,		promax blanks(0.3)
alpha		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, gen(m_hhsup_mean)
			//sclae reliablity: 0.6911
predict		m_hhsup_pr

*village support
tab1		m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_villvill m_vilsup_coll_confl_solved m_vilsup_coll_samevision
pwcorr		m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_villvill m_vilsup_coll_confl_solved m_vilsup_coll_samevision, st(0.5)
			//some have negative correlation, but not significant or very small. Seems strange. Problems with m_vilsup_coll_confl_villvill
factor		m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_villvill m_vilsup_coll_confl_solved m_vilsup_coll_samevision, pf mine(1)
			//again, 1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all above >0.3, apart from m_vilsup_coll_confl_villvill --> drop
factor		m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_solved m_vilsup_coll_samevision, pf mine(1)
rotate,		promax blanks(0.3)
			//all above >0.3, apart from m_vilsup_soc_confl_hhvill --> drop
factor		m_vilsup_soc_feelvalued m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_solved m_vilsup_coll_samevision, pf mine(1)
rotate,		promax blanks(0.3)		
			//all above >0.3, ok
alpha		m_vilsup_soc_feelvalued m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_solved m_vilsup_coll_samevision, gen(m_vilsup_mean)
			//scale reliability: 0.5514
predict		m_vilsup_pr

//////////////////////////////////////
*Sub constructs to pillar
//////////////////////////////////////

tab1		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean
pwcorr		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean, st(0.5)
			//all high correlation (>=0.43), and significant
factor		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all >=0.57, so ok
alpha		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean, gen (motivation_mean)
predict		motivation_pr

*motivation pr scaled between 0-100.


*********************************************************************
*Pillar 2: Resilience
*********************************************************************


/*

Remove items that deal with evaluations of the past or give subjective evaluations of what has happenend (e.g. income compared to x years ago). 

Component analyses 
income diversity 		--> single item: r_inc_farm_sh_farm
crop diversity 			--> nr of different annual & perrennial crops grown + nr of different crops grown on market 
livestock situation 	--> nr of different livestock own + nr of livestock products sold on market + production of fodder + production fodder in dry season.
household resilience	--> attitudinal indicator/latent measurement use as average on these items is in component analyses, keep factor analyses results in report (sub-construct scales well). 
coping ability			--> attitudinal indicator/latent measurement use as average on these items is in component analyses, keep factor analyses results in report (sub-construct scales well). 

*/

//////////////////////////////////////
*Items to sub construct
//////////////////////////////////////

*Income diversity
egen r_inc_farm_sh_nonfarm=rowtotal(r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1)
order r_inc_farm_sh_nonfarm, after(r_inc_farm_sh_other1)
lab var r_inc_farm_sh_nonfarm "Share: income nonfarm (sum stable+sme+other1)"

tab1		r_inc_farm_subscrop r_inc_farm_subslivestock r_inc_farm_salefieldcrop r_inc_farm_salecashcrop r_inc_farm_saleorchard r_inc_farm_salelivestock r_inc_farm_saleprepfood r_inc_farm_agrwage r_inc_farm_shepherd r_inc_farm_miller r_inc_farm_unskilledday r_inc_farm_skilled r_inc_farm_employee r_inc_farm_trade r_inc_farm_firewood r_inc_farm_handicrafts r_inc_farm_carpet r_inc_farm_mining r_inc_farm_military r_inc_farm_taxi r_inc_farm_remitt_out r_inc_farm_remitt_in r_inc_farm_pension r_inc_farm_govbenefit r_inc_farm_rental r_inc_farm_foodaid r_inc_farm_begging r_inc_farm_commerce r_inc_farm_other r_inc_farm_farm r_inc_farm_stable r_inc_farm_sme r_inc_farm_other1 r_inc_farm_sh_subscrop r_inc_farm_sh_subslivestock r_inc_farm_sh_salefieldcrop r_inc_farm_sh_salecashcrop r_inc_farm_sh_saleorchard r_inc_farm_sh_salelivestock r_inc_farm_sh_saleprepfood r_inc_farm_sh_agrwage r_inc_farm_sh_shepherd r_inc_farm_sh_miller r_inc_farm_sh_unskilledday r_inc_farm_sh_skilled r_inc_farm_sh_employee r_inc_farm_sh_trade r_inc_farm_sh_firewood r_inc_farm_sh_handicrafts r_inc_farm_sh_carpet r_inc_farm_sh_mining r_inc_farm_sh_military r_inc_farm_sh_taxi r_inc_farm_sh_remitt_out r_inc_farm_sh_remitt_in r_inc_farm_sh_pension r_inc_farm_sh_govbenefit r_inc_farm_sh_rental r_inc_farm_sh_foodaid r_inc_farm_sh_begging r_inc_farm_sh_commerce r_inc_farm_sh_other r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1 r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough
tab1		r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1 r_inc_farm_totalnr r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough
pwcorr		r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1 r_inc_farm_totalnr r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough, st(0.5)
			//negative correlation between income categories, which makes sense becuase together construct income
			//as farming is biggest income source, and these variables are meant to represent farm income (see conceptual framework), continue with r_inc_farm_sh_farm only

	*Income sources:
tab1		r_inc_farm_sh_farm
gen 		r_inc_farm_mean=r_inc_farm_sh_farm

/*	*Change in income: --> leave out income change measures in resilience scale. 
tab1		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough
pwcorr		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough, st(0.5)
factor		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough, pf mine(1)
			//1x eigen value >1
			//finance variables <0.3
factor		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other, pf mine(1)
rotate,		promax blanks(0.3)
			//ok
alpha		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other, gen(r_inc_change_mean)
predict		r_inc_change_pr
*/ 





*Crop diversity old
/*
tab1 		r_crop_ann_cult_maize r_crop_ann_cult_sorghum r_crop_ann_cult_cassava r_crop_ann_cult_rice r_crop_ann_cult_irishpotato r_crop_ann_cult_sweetpotato r_crop_ann_cult_colocase r_crop_ann_cult_eleusine r_crop_ann_cult_beans r_crop_ann_cult_greenpeas r_crop_ann_cult_cajapeas r_crop_ann_cult_cabbage r_crop_ann_cult_amaranth r_crop_ann_cult_carrot r_crop_ann_cult_tomato r_crop_ann_cult_beet r_crop_ann_cult_eggplant r_crop_ann_cult_pepper r_crop_ann_cult_spinach r_crop_ann_cult_cucumber r_crop_ann_cult_yams r_crop_ann_cult_onions r_crop_ann_cult_watermelon r_crop_ann_cult_squash r_crop_ann_cult_other1 r_crop_ann_cult_other2  r_crop_ann_cult_total r_crop_ann_sell_maize r_crop_ann_sell_sorghum r_crop_ann_sell_cassava r_crop_ann_sell_rice r_crop_ann_sell_irishpotato r_crop_ann_sell_sweetpotato r_crop_ann_sell_colocase r_crop_ann_sell_eleusine r_crop_ann_sell_beans r_crop_ann_sell_greenpeas r_crop_ann_sell_cajapeas r_crop_ann_sell_cabbage r_crop_ann_sell_amaranth r_crop_ann_sell_carrot r_crop_ann_sell_tomato r_crop_ann_sell_beet r_crop_ann_sell_eggplant r_crop_ann_sell_pepper r_crop_ann_sell_spinach r_crop_ann_sell_cucumber r_crop_ann_sell_yams r_crop_ann_sell_onions r_crop_ann_sell_watermelon r_crop_ann_sell_squash r_crop_ann_sell_other1 r_crop_ann_sell_other2 r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_palmoil r_crop_per_cult_bananas r_crop_per_cult_mango r_crop_per_cult_avocado r_crop_per_cult_papaya r_crop_per_cult_guava r_crop_per_cult_lemon r_crop_per_cult_orange r_crop_per_cult_coffee r_crop_per_cult_other1 r_crop_per_cult_other2 r_crop_per_cult_total  r_crop_per_sell_palmoil r_crop_per_sell_bananas r_crop_per_sell_mango r_crop_per_sell_avocado r_crop_per_sell_papaya r_crop_per_sell_guava r_crop_per_sell_lemon r_crop_per_sell_orange r_crop_per_sell_coffee r_crop_per_sell_other1 r_crop_per_sell_other2 r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change
tab1		r_crop_ann_cult_total r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_total r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change
pwcorr		r_crop_ann_cult_total r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_total r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change, st(0.5)
			//all >0.2 and significant
factor		r_crop_ann_cult_total r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_total r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all >=0.53, so ok	
alpha		r_crop_ann_cult_total r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_total r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change, gen(r_crop_mean)
			//scale reliability: 0.7736
predict		r_crop_pr

*Crop diversity new


	*Overview of crops:
//	
	
	
	*Change in crops:
tab1		r_crop_ann_change r_crop_per_cult_change r_crop_inc_change
pwcorr		r_crop_ann_change r_crop_per_cult_change r_crop_inc_change, st(0.5)
factor		r_crop_ann_change r_crop_per_cult_change r_crop_inc_change, pf mine(1)

///or: component analysis instead of factor?? 



	

*Livestock situation
tab1		r_lvstck_own r_lvstck_div_cattle r_lvstck_div_goats r_lvstck_div_sheep r_lvstck_div_pigs r_lvstck_div_chicken r_lvstck_div_guineapigs r_lvstck_div_rabbits r_lvstck_div_ducks r_lvstck_div_poultry r_lvstck_div_other r_lvstck_div_total r_lvstck_div_sell_cattle r_lvstck_div_sell_goats r_lvstck_div_sell_sheep r_lvstck_div_sell_pigs r_lvstck_div_sell_chicken r_lvstck_div_sell_guineapigs r_lvstck_div_sell_rabbits r_lvstck_div_sell_ducks r_lvstck_div_sell_poultry r_lvstck_div_sell_other r_lvstck_div_sell_total r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder
recode 		r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder (77=.) //NA to missing
tab1		r_lvstck_own r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder //total instead of each livestock separately
pwcorr		r_lvstck_own r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder, st(0.5)
			//r_own_livestock zero variance for most of variables (skip-logic), so remove
factor		r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder, pf mine(1)
			//1x eigen value >1
rotate,		promax blanks (0.3)
			//r_lvstck_health below 0.3
factor		r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder, pf mine(1)
rotate,		promax blanks (0.3)			
			//all >=0.4065
alpha		r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder, gen(r_lvstck_mean)
predict		r_lvstck_pr			

*Household resilience
/*
list of items that need min-max rescaling: 

///////////household resilience///////////
r_res_food_mean					(1-3)  

*/
rename r_res_food_mean r_res_food_mean_old

gen	r_res_food_mean				=	((5-1)/(3-1))	*	(	r_res_food_mean_old				-	3)		+	5

lab var	r_res_food_mean				"rescaled 1-5:	 Mean of food situation over past 12 months "

order	r_res_food_mean	, 			before(	r_res_food_mean_old				)





tab1 		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype
pwcorr		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, st(0.5)
			//all high correlation (>0.3), and significant
factor		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks (0.3)
			//all >0.45, so ok
alpha		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, gen(r_res_mean)
			//scale reliability: 0.8522
predict		r_res_pr

*Coping ability
tab1		r_cop_shock_illness r_cop_shock_death r_cop_shock_injury r_cop_shock_jobloss r_cop_shock_wagecut r_cop_shock_cropfailure r_cop_shock_noremitt r_cop_shock_drought r_cop_shock_flood r_cop_shock_naturalhazard r_cop_shock_theft r_cop_shock_suddenexpenses r_cop_shock_total r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh
pwcorr		r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, st(0.5)
			//correlation significant and >0.1
factor		r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, pf mine(1)
			//1x eigen value>1
rotate,		promax blanks (0.3)	
			//variables for shock (r_cop_shock_cat r_cop_shock_severity) factor loading <0.3 so drop
factor		r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, pf mine(1)
			//again, eigenvalue >1 1x
rotate,		promax blanks (0.3)
			//all above >=0.6268, so ok
alpha		r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, gen (r_cop_mean)
			//scale reliability 0.7679
predict		r_cop_pr

//////////////////////////////////////
*Sub constructs to pillar
//////////////////////////////////////

/*tab1 		r_inc_farm_mean r_inc_change_mean r_crop_mean r_lvstck_mean r_res_mean r_cop_mean
pwcorr		r_inc_farm_mean r_inc_change_mean r_crop_mean r_lvstck_mean r_res_mean r_cop_mean, st(0.5)
factor		r_inc_farm_mean r_inc_change_mean r_crop_mean r_lvstck_mean r_res_mean r_cop_mean, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks (0.3)
			//all >0.3
alpha		r_inc_farm_mean r_inc_change_mean r_crop_mean r_lvstck_mean r_res_mean r_cop_mean, gen(resilience_mean)
predict		resilience_pr*/	

//update




*********************************************************************
*Pillar 3: Stewardship
*********************************************************************

//////////////////////////////////////
*Items to sub construct
//////////////////////////////////////

*Awareness
tab1		s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex
recode 		s_awa_soilqual_change s_awa_veg_change s_awa_water_change (88=.)	//IDK to missing
pwcorr		s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex, st(0.5)
			//mostly significant
factor		s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex, pf mine(1)
			//1x eigen value>1
rotate,		promax blanks (0.3)
			//s_awa_soilqual_change s_awa_veg_change s_awa_water_change s_awa_bio_protectimp have factor loading <0.3
			//first drop the ones with *_change
factor		s_awa_soilqual_changewhy s_awa_veg_changewhy s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex, pf mine(1)
rotate,		promax blanks (0.3)
			//still s_awa_bio_protectimp <0.3, drop
factor		s_awa_soilqual_changewhy s_awa_veg_changewhy s_awa_water_changewhy s_awa_coll_action s_awa_bio_natureimp_ex, pf mine(1)
rotate,		promax blanks (0.3)			
			//all >0.3, ok
alpha 		s_awa_soilqual_changewhy s_awa_veg_changewhy s_awa_water_changewhy s_awa_coll_action s_awa_bio_natureimp_ex, gen(s_awa_mean)
			//scale realiability= 0.8028
predict		s_awa_pr

*Land management
tab1		s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_total s_land_mngmtpract_whyhow
pwcorr		s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_whyhow, st(0.5)
factor		s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_whyhow, pf mine(1)
			//1 factor, but s_land_physpract_* all <0.3, and most of s_land_mngmtprac_* as well. Let's try with total nr of practices instead.
tab1		s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_total s_land_mngmtpract_whyhow //total nr of practices instead
pwcorr		s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_total s_land_mngmtpract_whyhow, st(0.5)
			//considerable + significant
factor		s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_total s_land_mngmtpract_whyhow, pf mine(1)
			//1x eigenvalue>1
rotate,		promax blanks (0.3)
			//all above 0.3
alpha		s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_total s_land_mngmtpract_whyhow, gen(s_land_mean)
predict		s_land_pr

//check with Rik





*Farm management
tab1		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practtotal s_farm_soil_practwhyhow s_farm_soil_nofert_expensive s_farm_soil_nofert_notavail s_farm_soil_nofert_dontneed s_farm_soil_nofert_other s_farm_soil_chemfert_buygroup s_farm_soil_chemfert_buygroup_nr s_farm_lvstck_intgr s_farm_lvstck_plans
			//skip-logic for s_farm_soil_nofert*; don't include
			//skip-logic s_farm_soil_chemfert_buygroup_nr; don't include
			//s_farm_soil_chemfert_buygroup also not included (Q not meant to measure farm mangement)
tab1		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow 
pwcorr		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow , st(0.5)
			//mixed; negative corr between some about fertilizer type (which makes sense)
factor		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow , pf mine(1)
			//1x eigen value >1
rotate,		promax blanks(0.3)			
			//s_farm_soil_practchemfert <0.3, drop
factor		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow , pf mine(1)
rotate,		promax blanks(0.3)				
alpha		s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow , gen(s_farm_mean)
			//scale reliability: 0.7284
predict		s_farm_pr

//check with Rik



	
*Use of the commons
tab1		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve
recode		s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve (77=.) //NA to missing
pwcorr		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, st(0.5)
			//all significant >0.15
factor		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, pf mine(1)
			//1x eigenvalue>1
rotate,		promax blanks (0.3)
			//all above 0.3
alpha		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, gen(s_comm_mean)
			//scale reliability= 0.7488
predict		s_comm_pr

//////////////////////////////////////
*Sub constructs to pillar
//////////////////////////////////////

/*tab1 		s_awa_mean s_land_mean s_farm_mean s_comm_mean
pwcorr		s_awa_mean s_land_mean s_farm_mean s_comm_mean, st(0.5)
			//all positive and signifciant, and considerable
factor		s_awa_mean s_land_mean s_farm_mean s_comm_mean, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks (0.3)
			//all above 0.3
alpha		s_awa_mean s_land_mean s_farm_mean s_comm_mean, gen(stewardship_mean)
			//scale reliability: 0.8688
predict		stewardship_pr*/

*********************************************************************
*Other
*********************************************************************

drop *_pr	//becuase not sure yet what to do with it


*********************************************************************
*SAVE
*********************************************************************

cd "C:\Users\mariekeme\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean"
save "PAPAB Impact study - Analysis2 Incl Factors.dta", replace
export delimited using "PAPAB Impact study - Analysis2 Incl Factors.csv", replace

