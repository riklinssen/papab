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

purpose
m_pur_con_plans					(1-4)  
m_pur_conactionstaken			(1-4) 

attitude 
m_att_eag_askothers				(1-4) 			
m_att_drive_newpractices 		(0-9)

household support
m_hhsup_coll_whoplan  			(1-3)

village support
m_vilsup_coll_samevision  		(1-7)                    
*/
recode m_hhsup_coll_whoplan (2=1) (3=2) (4=3)	//about collaboration: husband/wife separate=1; jointly=2; whole hh=3

rename m_pur_con_plans m_pur_con_plans_old
rename m_pur_con_actionstaken m_pur_con_actionstaken_old
rename m_att_eag_askothers m_att_eag_askothers_old
rename m_att_drive_newpractices m_att_drive_newpractices_old
rename m_hhsup_coll_whoplan m_hhsup_coll_whoplan_old
rename m_vilsup_coll_samevision m_vilsup_coll_samevision_old

gen	m_pur_con_plans				=	((5-1)/(4-1))	*	(	m_pur_con_plans_old				-	4)		+	5
gen	m_pur_con_actionstaken		=	((5-1)/(4-1))	*	(	m_pur_con_actionstaken_old		-	4)		+	5
gen	m_att_eag_askothers			=	((5-1)/(4-1))	*	(	m_att_eag_askothers_old			-	4)		+	5
gen	m_att_drive_newpractices 	=	((5-1)/(9-0))	*	(	m_att_drive_newpractices_old	-	9)		+	5
gen	m_hhsup_coll_whoplan		=	((5-1)/(3-1))	*	(	m_hhsup_coll_whoplan_old		-	3)		+	5
gen	m_vilsup_coll_samevision	=	((5-1)/(7-1))	*	(	m_vilsup_coll_samevision_old	-	7)		+	5

lab var	m_pur_con_plans				"rescaled 1-5:	Can you please describe the plans or aspirations your household has for the near "
lab var	m_pur_con_actionstaken		"rescaled 1-5: 	Can you please describe concrete actions our household has taken in the recent"
lab var	m_att_eag_askothers			"rescaled 1-5:	When you see changes on other farms, how often would you then ask the owner wh"	 
lab var m_att_drive_newpractices 	"rescaled 1-5:  Please describe which new practices/tools you have tested"
lab var	m_hhsup_coll_whoplan		"rescaled 1-5:	Who is usually doing the planning of agricultural activities within the househo" 
lab var	m_vilsup_coll_samevision	"rescaled 1-5:	People generally have the same vision, in this village?" 

order	m_pur_con_plans	, 			before(	m_pur_con_plans_old				)
order	m_pur_con_actionstaken, 	before(	m_pur_con_actionstaken_old		)
order	m_att_eag_askothers	, 		before(	m_att_eag_askothers_old			)
order 	m_att_drive_newpractices, 	before( m_att_drive_newpractices_old	)
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
			//scale reliability: 0.8027
predict		m_att_pr

*household support
tab1		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney
pwcorr		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, st(0.5)
			//most of them are >0.1 and significant; not all (m_hhsup_mut_confl_hh)
factor		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, pf mine(1)
			//again, 1x eigenvalue >1
rotate,		promax blanks(0.3)
			//all above >0.3, apart from m_hhsup_mut_confl_hh --> drop
factor		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, pf mine(1)
rotate,		promax blanks(0.3)
alpha		m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney, gen(m_hhsup_mean)
			//sclae reliablity: 0.6564
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
			//scale reliability: 0.5855
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

/*
//excl m_att_drive_newpractices
alpha 		m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers  m_att_drive_improveproud, gen(m_att_mean2)
alpha 		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean m_att_drive_newpractices, gen (motivation_mean2)
pwcorr 		motivation_mean motivation_mean2, st(0.5) //0.9748*, high enough to conclude it can stay in
drop 		m_att_mean2 motivation_mean2*/

*motivation pr scaled between 0-100.
sum 		motivation_pr
gen 		motivation_score= (100-0) / (1.876993 - -3.078107) * (motivation_pr - 1.876993) + 100
lab var 	motivation_score "Motivation score rescaled(0-100)"

*Label recoded outcome variables (1-5)
lab def purpose 			1 "Low purpose" 5 "High purpose"
lab def autonomy 			1 "Low autonomy" 5 "High autonomy"
lab def attitude 			1 "Low attitudes" 5 "High attitudes"
lab def hhsup 				1 "Low household support" 5 "High household support"
lab def vilsup 				1 "Low village support" 5 "High village support"
lab def motivation 			1 "Low motivation" 5 "High motivation"
lab def motivation_sc		0 "Low motivation" 100 "High motivation"
lab val m_pur_mean 			purpose
lab val m_aut_mean 			autonomy
lab val m_att_mean 			attitude
lab val m_hhsup_mean 		hhsup
lab val m_vilsup_mean 		vilsup
lab val motivation_mean		motivation
lab val motivation_score	motivation_sc

*********************************************************************
*Pillar 2: Resilience
*********************************************************************

/*
Remove items that deal with evaluations of the past or give subjective evaluations of what has happenend (e.g. income compared to x years ago). 

Component analyses 
income diversity 		--> single item: r_inc_farm_sh_farm --> median share of income derived from farming income=100% --> not included does not discriminate
crop diversity 			--> nr of different annual & perrennial crops grown + nr of different crops grown sold on market 
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

*Income sources:
tab1		r_inc_farm_sh_farm
gen 		r_inc_farm_mean=r_inc_farm_sh_farm
			//but don't include, because doesn't discriminate

*Crop diversity new
*number of different annual and perrenial crops cultivated
*--> leave out change in crops in resilience scale
tab1  r_crop_ann_cult_total r_crop_per_cult_total  r_crop_per_sell_total r_crop_ann_sell_total
	
*Livestock situation new
*total number of different types of livestock owned and sold at the market
*r_lvstck_div_total r_lvstck_div_sell_total
*set to 0 if no livestock (also for fodder items 0 if no livestock)
foreach v in r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder{ 
replace `v'=0 if r_lvstck_own==0
} 
*
recode r_lvstck_nutr_producefeed r_lvstck_nutr_fodder (77=0)	//NA to zero

*list of items that need min-max rescaling:
*r_lvstck_nutr_producefeed r_lvstck_nutr_fodder
rename		r_lvstck_nutr_producefeed  r_lvstck_nutr_producefeed_old
rename		r_lvstck_nutr_fodder r_lvstck_nutr_fodder_old

gen			r_lvstck_nutr_producefeed	=	((5-1)/(4-0))	*	(r_lvstck_nutr_producefeed_old	-	4)	+	5
gen			r_lvstck_nutr_fodder		=	((5-1)/(4-0))	*	(r_lvstck_nutr_fodder_old	-	4)	+	5

lab var 	r_lvstck_nutr_producefeed	"rescaled 1-5: Do you produce enough feed for your livestock"
lab var 	r_lvstck_nutr_fodder		"rescaled 1-5: Are fodder resources available"

order		r_lvstck_nutr_producefeed, before(r_lvstck_nutr_producefeed_old)
order		r_lvstck_nutr_fodder, before(r_lvstck_nutr_fodder_old)

*Household resilience:
*list of items that need min-max rescaling: 
*r_res_food_mean					(1-3)
rename 		r_res_food_mean 		r_res_food_mean_old
gen			r_res_food_mean			=	((5-1)/(3-1))	*	(r_res_food_mean_old	-	3)	+	5
lab var		r_res_food_mean			"rescaled 1-5:	 Mean of food situation over past 12 months "
order		r_res_food_mean	, 		before(	r_res_food_mean_old		)

tab1 		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype
pwcorr		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, st(0.5)
			//all high correlation (>0.3), and significant
factor		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, pf mine(1)
			//1x eigenvalue >1
rotate,		promax blanks (0.3)
			//all >0.45, so ok
alpha		r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype, gen(r_res_mean)
			//scale reliability: 0.8554
predict		r_res_pr

*Coping ability
tab1		r_cop_shock_illness r_cop_shock_death r_cop_shock_injury r_cop_shock_jobloss r_cop_shock_wagecut r_cop_shock_cropfailure r_cop_shock_noremitt r_cop_shock_drought r_cop_shock_flood r_cop_shock_naturalhazard r_cop_shock_theft r_cop_shock_suddenexpenses r_cop_shock_total r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh
pwcorr		r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, st(0.5)
			//correlation significant and >0.1
factor		r_cop_shock_cat r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh, components(1) mine(1) blanks(.3)
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
*Sub constructs to pillar COMPONENT ANALYSES
//////////////////////////////////////

/*Items: 
income diversity:
	none
crop diversity:
	r_crop_ann_cult_total r_crop_per_cult_total  r_crop_per_sell_total r_crop_ann_sell_total 
livestock situation:
	r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder
household resilience:
	r_res_mean
coping ability:
	r_cop_mean */

tab1 	r_crop_ann_cult_total r_crop_per_cult_total  r_crop_per_sell_total r_crop_ann_sell_total r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_mean r_cop_mean
pca		r_crop_ann_cult_total r_crop_per_cult_total  r_crop_per_sell_total r_crop_ann_sell_total r_lvstck_div_total r_lvstck_div_sell_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_mean r_cop_mean, blanks(.3)
*meh...
rotate,		promax blanks (0.3)

*try with total number of different crops grown and sold
gen 	r_crop_cult_total	=	r_crop_ann_cult_total + r_crop_per_cult_total
gen 	r_crop_sell_total 	= 	r_crop_ann_sell_total + r_crop_per_sell_total
gen 	r_lvstck_total		=	r_lvstck_div_total + r_lvstck_div_sell_total
pca		r_crop_cult_total r_crop_sell_total r_lvstck_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_mean r_cop_mean, components(3)  blanks(.3)
//loadingplot, comp(3) combined

rotate,		promax blanks (0.3)
//loadingplot, comp(3) combined
predict	resilience_pr1 resilience_pr2 resilience_pr3 

gen resilience_pr=resilience_pr1 + resilience_pr2 + resilience_pr3
alpha resilience_pr1 resilience_pr2 resilience_pr3, gen(resilience_mean)
sum resilience_pr

*rescale to 0-100
//V(new)=	((Max(new)-Min(new))/(Max(old)-Min(old))*(Value(old)-Max(old)) + Max(new)
gen resilience_score=(100-0) / (8.900831 - -7.867002)*(resilience_pr - 8.900831)+100
lab var resilience_pr1 	"pr. Scores for comp1 - crop diversity-"
lab var resilience_pr2 	"pr. Scores for comp2 - hh-resilience & coping ability-"
lab var resilience_pr3 	"pr. Scores for comp3 - livestock situation -"
lab var	resilience_pr 	"pr. Scores for resilience (mean 3 resilience components)"
lab var resilience_score "Resilience score rescaled(0-100)"

*Label recoded outcome variables (1-5)
lab def count27				0 "0" 27 "27"
lab def count16				0 "0" 16 "16"
lab def count12				0 "0" 12 "12"
lab def producefeed			1 "Low production of feed" 5 "High production of feed"
lab def fodder 				1 "Low level of fodder" 5 "High level of fodder"
lab def hhresilience		1 "Low household resilience" 5 "High household resilience"
lab def coping 				1 "Low coping ability" 5 "High coping ability"
lab def resilience			0 "Low resilience" 100 "High resilience"
lab val r_crop_cult_total 			count27
lab val r_crop_sell_total  			count16
lab val r_lvstck_total  			count12
lab val r_lvstck_nutr_producefeed 	producefeed
lab val r_lvstck_nutr_fodder 		fodder
lab val r_res_mean 					hhresilience
lab val r_cop_mean 					coping
lab val resilience_score			resilience


*********************************************************************
*Pillar 3: Stewardship
*********************************************************************

//////////////////////////////////////
*Items to sub construct
//////////////////////////////////////

/*list of items that need rescaling: 
awareness
s_awa_soilqual_changewhy  (1-4)
s_awa_veg_changewhy (1-4)
s_awa_bio_protectimp (1-3)

use of commons
s_comm_trees_howuse (1-4)
s_comm_water_howconserve  (1-4)
s_comm_water_sourceimp (1-4)
s_comm_land_howuse (1-4)
s_comm_land_howconserve (1-4)

land management
s_land_agro_whyhow (1-7)
*/

//IDK to missing
recode s_awa_soilqual_change s_awa_veg_change s_awa_water_change (88=.)
//NA to missing
recode s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve (77=.)

rename 	s_awa_bio_protectimp s_awa_bio_protectimp_old
gen 	s_awa_bio_protectimp = ((5-1)/(3-1))	*	(s_awa_bio_protectimp_old	-	3)	+	5
lab var s_awa_bio_protectimp "rescaled 1-5: Important to protect the environment?"
order 	s_awa_bio_protectimp, before(s_awa_bio_protectimp_old)
*
rename 	s_land_agro_whyhow s_land_agro_whyhow_old
gen 	s_land_agro_whyhow = ((5-1)/(7-1))	*	(s_land_agro_whyhow_old	-	7)	+	5
lab var s_land_agro_whyhow "rescaled 1-5: s_land_agro_whyhow"
order 	s_land_agro_whyhow, before(s_land_agro_whyhow_old)
*
foreach x in s_awa_soilqual_changewhy s_awa_veg_changewhy s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve{
rename 	`x' `x'_old
gen		`x' = ((5-1)/(4-1))	*	(`x'_old	-	4)	+	5
lab var	`x'	"rescaled 1-5: `x'"
order	`x', before(`x'_old)
}
*

*Awareness
tab1		s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex
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
			//scale realiability= 0.8097
predict		s_awa_pr

*Use of the commons
tab1		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve
pwcorr		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, st(0.5)
			//all significant >0.15
factor		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, pf mine(1)
			//1x eigenvalue>1
rotate,		promax blanks (0.3)
			//all above 0.3
alpha		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, gen(s_comm_mean)
			//scale reliability= 0.7760
predict		s_comm_pr

*Farm management
gen 		s_farm_soil_compost=0
replace 	s_farm_soil_compost=1 if s_farm_soil_practcompost==1 | s_farm_soil_practcomp_chem==1
gen 		s_farm_soil_manure=0
replace 	s_farm_soil_manure=1 if s_farm_soil_practmanure==1 | s_farm_soil_practmanure_chem==1
gen 		s_farm_soil_chemical=0
replace 	s_farm_soil_chemical=1 if s_farm_soil_practchemfert==1 | s_farm_soil_practcomp_chem==1 | s_farm_soil_practmanure_chem==1

lab val 	s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical binary
order 		s_farm_soil_compost, before(s_farm_soil_practcompost)
order 		s_farm_soil_manure, after(s_farm_soil_compost)
order 		s_farm_soil_chemical, after(s_farm_soil_manure)

lab var 	s_farm_soil_compost "respondent uses compost"
lab var 	s_farm_soil_manure "respondent uses manure"
lab var 	s_farm_soil_chemical "respondent uses chemical fertilizer"
tab1 		s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical

//awareness: s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practwhyhow
tab1		s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practwhyhow
pwcorr		s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practwhyhow, st(0.5)
factor		s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practwhyhow, pf mine(1)
rotate,		promax blanks(0.3)
alpha		s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practwhyhow, gen(s_farm_why_mean)
predict		s_farm_why_pr

//operational: s_farm_crop_rotation s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical
tab1		s_farm_crop_rotation s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical
pwcorr		s_farm_crop_rotation s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical, st(0.5)
egen 		s_farm_pract_totnr=rowtotal(s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert)
order		s_farm_pract_totnr, before(s_farm_soil_practcompost)

*Land management
//awareness: s_land_physpract_whyhow s_land_agro_whyhow s_land_mngmtpract_whyhow
tab1		s_land_physpract_whyhow s_land_agro_whyhow s_land_mngmtpract_whyhow
pwcorr		s_land_physpract_whyhow s_land_agro_whyhow s_land_mngmtpract_whyhow, st(0.5)
factor		s_land_physpract_whyhow s_land_agro_whyhow s_land_mngmtpract_whyhow, pf mine(1)
rotate,		promax blanks(0.3)
alpha		s_land_physpract_whyhow s_land_agro_whyhow s_land_mngmtpract_whyhow, gen(s_land_why_mean)
predict		s_land_why_pr

//operational: s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops
tab1 		s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops
pwcorr		s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops, st(0.5)
			//s_land_physpract_gullycontrol; only 18 respondents = yes; drop
			//s_land_physpract_stonebunds; only 43 respondents = yes; drop	
			//s_land_mngmtpract_staggering; only 82 respondents = yes; drop
			//also: previous analysis shows that these low freq. practices end up in a separate component. So additional rational for excluding them.
egen 		s_land_pract_total=rowtotal(s_land_physpract_total s_land_mngmtpract_total)

//////////////////////////////////////
*Sub constructs to pillar
//////////////////////////////////////

*practices included as dummies
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/			s_farm_crop_rotation s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical /*
*/			s_land_physpract_contourlines s_land_physpract_conttrack /*
*/			s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops /*
*/			, blanks(.3) mine(1)
rotate		,promax blanks(0.3)
			//s_farm_crop_rotation and s_farm_soil_chemical below 0.3, drop
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/			s_farm_soil_compost s_farm_soil_manure /*
*/			s_land_physpract_contourlines s_land_physpract_conttrack /*
*/			s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops /*
*/			, blanks(.3) mine(1) 
rotate		,promax  blanks(0.3)
			//all above 0.3, ok. 4 components in total
predict		stewardship_pr1	stewardship_pr2 stewardship_pr3 stewardship_pr4 
gen			stewardship_pr= stewardship_pr1 + stewardship_pr2 + stewardship_pr3 + stewardship_pr4
alpha		stewardship_pr1	stewardship_pr2 stewardship_pr3 stewardship_pr4, gen(stewardship_mean)
			//alpha= 0.1719
			
*rescale to 0-100
//V(new)=	((Max(new)-Min(new))/(Max(old)-Min(old))*(Value(old)-Max(old)) + Max(new)
sum 		stewardship_pr
gen stewardship_score=(100-0) / (8.480449 - -7.866103)*(stewardship_pr - 8.480449)+100
lab var stewardship_pr1 	"pr. Scores for comp1 - s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean"
lab var stewardship_pr2 	"pr. Scores for comp2 - s_land_physpract_contourlines s_land_physpract_conttrack"
lab var stewardship_pr3 	"pr. Scores for comp3 - s_farm_soil_compost s_farm_soil_manure"
lab var stewardship_pr4 	"pr. Scores for comp4 - s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops"
lab var	stewardship_pr 	"pr. Scores for stewardship (mean 4 stewardship components)"
lab var stewardship_score "Stewardship score rescaled(0-100)"
			
/*total nr of practices (1)
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/ s_farm_crop_rotation s_farm_pract_totnr s_land_physpract_total s_land_mngmtpract_total , blanks(.3) mine(1)
rotate		,promax blanks(0.3)
			//s_land_physpract_total s_farm_pract_totnr below 0.3
*total nr of practices (2)
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/ s_farm_crop_rotation s_farm_pract_totnr s_land_pract_total , blanks(.3) mine(1)
rotate		,promax blanks(0.3)			
			//s_farm_pract_totnr below 0.3
*total nr of practices (3)
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/ s_farm_crop_rotation s_land_pract_total , blanks(.3) mine(1)
rotate		,promax blanks(0.3)		
			//all above 0.3, ok.
			
*total dummies farm mngmt + total nr of practices
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/			s_farm_crop_rotation s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical /*
*/			s_land_physpract_total s_land_mngmtpract_total, blanks(.3) mine(1)
rotate		,promax blanks(0.3)
			//s_farm_crop_rotation below 0.3
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/			s_farm_soil_compost s_farm_soil_manure s_farm_soil_chemical /*
*/			s_land_physpract_total s_land_mngmtpract_total, blanks(.3) mine(1)
rotate		,promax blanks(0.3)
			//s_land_physpract_total s_farm_soil_chemical below 0.3
pca			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/			s_farm_soil_compost s_farm_soil_manure /*
*/			s_land_mngmtpract_total, blanks(.3) mine(1)
rotate		,promax blanks(0.3)	
			//ok now, but probably better to work with only dummies, or only totals.
			//also a lot of variables dropped in this case.*/

*new pillar (components *-1)
gen	stewardship_pr2_reversed= stewardship_pr2*-1
gen stewardship_pr3_reversed= stewardship_pr3*-1
gen stewardship_pr4_reversed= stewardship_pr4*-1

gen			stewardship_pr_v2=stewardship_pr1 + stewardship_pr2_reversed + stewardship_pr3_reversed + stewardship_pr4_reversed
alpha		stewardship_pr1 stewardship_pr2_reversed stewardship_pr3_reversed stewardship_pr4_reversed, gen(stewardship_mean_v2)

sum			stewardship_pr_v2
gen stewardship_score_v2=(100-0) / (5.693706 - -11.60987)*(stewardship_pr_v2 - 5.693706)+100

mean stewardship_score, over(educ_cat)
mean stewardship_score_v2, over(educ_cat)

pwcorr stewardship_pr3 educ_cat, st(0.5)
pwcorr stewardship_pr3_reversed educ_cat, st(0.5)

pwcorr stewardship_pr1 stewardship_pr3, st(0.5)
pwcorr stewardship_pr1 stewardship_pr3_reversed, st(0.5)

lab var stewardship_pr2_reversed 	"pr. Scores for comp2; reversed - s_land_physpract_contourlines s_land_physpract_conttrack"
lab var stewardship_pr3_reversed 	"pr. Scores for comp3; reversed - s_farm_soil_compost s_farm_soil_manure"
lab var stewardship_pr4_reversed 	"pr. Scores for comp4; reversed - s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops"
lab var	stewardship_pr_v2 	"pr. Scores for stewardship; reversed (mean 4 stewardship components)"
lab var stewardship_score_v2 "Stewardship score rescaled(0-100)"

/*We decided to continue with stewardship_score_v2 as the correlations with attitudes on stewardship,
and the correlations with education make more sense (positive instead of negative).*/

lab def awareness			1 "Low awareness" 5 "High awareness"
lab def commons 			1 "Low level of conserving" 5 "High level of conserving"
lab def stewardship			1 "Low stewardship" 5 "High stewardship"
lab def st_score			0 "Low stewardship" 100 "High stewardship"
lab val s_awa_mean 					awareness
lab val s_comm_mean 				commons
lab val s_farm_why_mean 			awareness
lab val s_land_why_mean 			awareness
lab val s_farm_soil_compost s_farm_soil_manure s_land_physpract_contourlines s_land_physpract_conttrack s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops binary
lab val stewardship_score_v2		st_score



****reviewed stewardship pillar (vs3)
****3rd stewardship revision after review
* structure: 
* 1 knowledge & awareness (Why and how)
* 2 practices

* 1. a) Awareness of changes & sense of stewardship 					--> s_awa_mean
/*
Why do you think that the soil quality might change, what are possible reasons? 									-s_awa_soilqual_changewhy
Why do you think that the vegetation might change, what are possible reasons?										- s_awa_veg_changewhy
Why do you think that the water quality and quantity might change, what are possible reasons? 						- s_awa_water_changewhy
Please mention three concrete actions that you undertake to conserve protect natural resources outside your own farm. - s_awa_coll_action
Please give ONE example that describes the importance of nature for yourself.										- s_awa_bio_natureimp_ex

*/
	


* 1. b) use & knowledge of commons --> 									--> s_comm_mean
/*
Please explain about the importance of trees and bushes on the land outside your own farm. 						- s_comm_trees_howuse
Please explain how you use trees and bushes on the land outside your own farm. 									- s_comm_trees_importance
Please explain the importance of water sources in this village and how you use them.							- s_comm_water_sourceimp 
Please describe – with examples – how you try to conserve water yourself?										- s_comm_water_howconserve
Please explain the importance of the common lands in this village and how you use them. 						- s_comm_land_howuse
Please describe – with examples – how you try to conserve the common lands yourself?							- s_comm_land_howconserve

    

* 1. c) knowledge+ awareness on how to apply physical, land, crop, soil  management practices	--> 
Physical practices (knowledge)
- If you have such practices [ physical practices, Contourlines/trenches etc.]], please explain why and how you apply these practices.		- s_land_physpract_whyhow
Land management practices incl trees (knowledge) 
- If you have such practices [ land management practices, ploughing on countourline ], please explain why and how you apply these practices.	- s_land_mngmtpract_whyhow
- Please describe if you have trees on your farm, how you use them, why you have them and if you are satisfied? 								- s_comm_trees_howuse								-

Crop management (knowledge)
- Why do you use crop rotations on your fields?																									- s_farm_crop_rotationwhy 
Soil management (knowledge/how & why)
- If you have these practices, please explain why and how you apply these practices [fertilizer/soil].											- s_farm_soil_practwhyhow



2. 
Practices (actual implememention)
Physical
*/
tab1 s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_total 

*Land management
tab1 s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_total

*Crop (rotation)
gen s_farm_crop_rotation_most=.
replace s_farm_crop_rotation_most=0 if s_farm_crop_rotation <4
replace s_farm_crop_rotation_most=1 if s_farm_crop_rotation >3


*soil (fertilizer)
tab1 s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practtotal


 



**factor analyses
* 1. c) how why practices*/ -->s_howwhy_mean

factor		s_land_physpract_whyhow s_land_mngmtpract_whyhow s_comm_trees_howuse s_farm_crop_rotationwhy s_farm_soil_practwhyhow, pf mine(1)

alpha 		s_land_physpract_whyhow s_land_mngmtpract_whyhow s_comm_trees_howuse s_farm_crop_rotationwhy s_farm_soil_practwhyhow, gen(s_howwhy_mean)


* 1 b) use & knowledge of commons --> 	s_comm_mean

factor		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve, pf mine(1)
			//1x eigenvalue>1
alpha		s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve
			//scale reliability= 0.7760

* 1 a) Awareness of changes & sense of stewardship--> s_awa_mean
factor		s_awa_soilqual_changewhy s_awa_veg_changewhy s_awa_water_changewhy s_awa_coll_action s_awa_bio_natureimp_ex, pf mine(1)

alpha 		s_awa_soilqual_changewhy s_awa_veg_changewhy s_awa_water_changewhy s_awa_coll_action s_awa_bio_natureimp_ex

*2 practices
*Physical
tab1 s_land_physpract_total
*Land management
tab1 s_land_mngmtpract_total	
*Crop
tab1 s_farm_crop_rotation_most
*Soil/fertilizer
tab1 s_farm_soil_practtotal



***sub-constructs to pillar
pca s_howwhy_mean s_comm_mean s_awa_mean s_land_physpract_total s_land_mngmtpract_total s_farm_crop_rotation_most s_farm_soil_practtotal,  components(1)

*pillar score
predict stewardship_pr_v3
lab var stewardship_pr_v3 "predicted values stewardshipv3 howwhy-commons-stewardship-practice(final)"
*rescale to 0-100
//V(new)=	((Max(new)-Min(new))/(Max(old)-Min(old))*(Value(old)-Max(old)) + Max(new)
summ stewardship_pr_v3
egen stewardship_pr_v3_max=max(stewardship_pr_v3)
egen stewardship_pr_v3_min=min(stewardship_pr_v3)
foreach j in stewardship_pr_v3_max stewardship_pr_v3_min{ 
replace `j'=. if stewardship_pr_v3==.
}


gen stewardship_score_v3 = (100-0)/(stewardship_pr_v3_max-stewardship_pr_v3_min)* (stewardship_pr_v3-stewardship_pr_v3_max)+100
lab var stewardship_score_v3 "stewardship score v3 rescaled 0-100"



********************************************************************
*SAVE
*********************************************************************

cd "C:\Users\RikL\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean"
save "PAPAB Impact study - Analysis2 Incl Factors.dta", replace
export delimited using "PAPAB Impact study - Analysis2 Incl Factors.csv", replace

/*********************************************************************
*Export label overview
*********************************************************************

cd ""C:\Users\RikL\Projects\papab\notebooks\data\interim\ValueLabels_PAPAB.xls""
numlabel, add force

*Export variable name + variable label
preserve
    describe *, replace clear
    list
    export excel using VariableLabels_PAPAB.xlsx, replace first(var)
restore

*Export value labels
uselabel, clear
export excel lname value label using "ValueLabels_PAPAB", sheetreplace
