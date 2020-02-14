* Project: PAPAB (Impact Study)
* Country: Burundi
* Survey: 2019
* Objective: Prepare for Analysis
* Author: Marieke Meeske
* Date: 22-01-2020

*********************************************************************
*IMPORT+CD
*********************************************************************

cd "C:/Users/`c(username)'/Box\ONL-IMK/2.0 Projects/Current/2018-05 PAPAB Burundi/07. Analysis & reflection/Data & Analysis"
use "2. Clean\PAPAB Impact study - Cleaning1.dta", clear
set more off, perm
estimates clear

*********************************************************************
*KEEP CONSENT
*********************************************************************

keep if consent==1

*********************************************************************
*RECODE SKIP-LOGIC TO MISSING (IPV 111)
*********************************************************************

foreach x in Status Progress Finished code_enumerator province commune colline pip_generation gender consent StartDate EndDate RecordedDate land_hectares land_plots id duration_m below10 pip_generation_clean weight_generation female land_own land_rent land_communal land_total hhsize_total r_inc_farm_commerce r_inc_farm_farm r_inc_farm_stable r_inc_farm_sme r_inc_farm_other1 r_inc_farm_sh_subscrop r_inc_farm_sh_subslivestock r_inc_farm_sh_salefieldcrop r_inc_farm_sh_salecashcrop r_inc_farm_sh_saleorchard r_inc_farm_sh_salelivestock r_inc_farm_sh_saleprepfood r_inc_farm_sh_agrwage r_inc_farm_sh_shepherd r_inc_farm_sh_miller r_inc_farm_sh_unskilledday r_inc_farm_sh_skilled r_inc_farm_sh_employee r_inc_farm_sh_trade r_inc_farm_sh_firewood r_inc_farm_sh_handicrafts r_inc_farm_sh_carpet r_inc_farm_sh_mining r_inc_farm_sh_military r_inc_farm_sh_taxi r_inc_farm_sh_remitt_out r_inc_farm_sh_remitt_in r_inc_farm_sh_pension r_inc_farm_sh_govbenefit r_inc_farm_sh_rental r_inc_farm_sh_foodaid r_inc_farm_sh_begging r_inc_farm_sh_commerce r_inc_farm_sh_other r_inc_farm_sh_total r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1 r_inc_farm_sh_total1 r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_actsh_total r_crop_ann_cult_total r_crop_ann_sell_total r_crop_per_cult_total r_crop_per_sell_total r_lvstck_div_total r_lvstck_div_sell_total r_res_food_mean r_cop_shock_total s_land_physpract_total s_land_mngmtpract_total age educ farmtype hhsize_men18 hhsize_women18 hhsize_children head_type educ_head pip_approach pip_training pip_training_year pip_have pip_implemented pip_improvedecon m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_stay m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_villvill m_vilsup_coll_confl_solved m_vilsup_coll_samevision r_inc_farm_subscrop r_inc_farm_subslivestock r_inc_farm_salefieldcrop r_inc_farm_salecashcrop r_inc_farm_saleorchard r_inc_farm_salelivestock r_inc_farm_saleprepfood r_inc_farm_agrwage r_inc_farm_shepherd r_inc_farm_miller r_inc_farm_unskilledday r_inc_farm_skilled r_inc_farm_employee r_inc_farm_trade r_inc_farm_firewood r_inc_farm_handicrafts r_inc_farm_carpet r_inc_farm_mining r_inc_farm_military r_inc_farm_taxi r_inc_farm_remitt_out r_inc_farm_remitt_in r_inc_farm_pension r_inc_farm_govbenefit r_inc_farm_rental r_inc_farm_foodaid r_inc_farm_begging r_inc_farm_other r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough r_crop_ann_cult_maize r_crop_ann_cult_sorghum r_crop_ann_cult_cassava r_crop_ann_cult_rice r_crop_ann_cult_irishpotato r_crop_ann_cult_sweetpotato r_crop_ann_cult_colocase r_crop_ann_cult_eleusine r_crop_ann_cult_beans r_crop_ann_cult_greenpeas r_crop_ann_cult_cajapeas r_crop_ann_cult_cabbage r_crop_ann_cult_amaranth r_crop_ann_cult_carrot r_crop_ann_cult_tomato r_crop_ann_cult_beet r_crop_ann_cult_eggplant r_crop_ann_cult_pepper r_crop_ann_cult_spinach r_crop_ann_cult_cucumber r_crop_ann_cult_yams r_crop_ann_cult_onions r_crop_ann_cult_watermelon r_crop_ann_cult_squash r_crop_ann_cult_other1 r_crop_ann_cult_other2 r_crop_ann_sell_maize r_crop_ann_sell_sorghum r_crop_ann_sell_cassava r_crop_ann_sell_rice r_crop_ann_sell_irishpotato r_crop_ann_sell_sweetpotato r_crop_ann_sell_colocase r_crop_ann_sell_eleusine r_crop_ann_sell_beans r_crop_ann_sell_greenpeas r_crop_ann_sell_cajapeas r_crop_ann_sell_cabbage r_crop_ann_sell_amaranth r_crop_ann_sell_carrot r_crop_ann_sell_tomato r_crop_ann_sell_beet r_crop_ann_sell_eggplant r_crop_ann_sell_pepper r_crop_ann_sell_spinach r_crop_ann_sell_cucumber r_crop_ann_sell_yams r_crop_ann_sell_onions r_crop_ann_sell_watermelon r_crop_ann_sell_squash r_crop_ann_sell_other1 r_crop_ann_sell_other2 r_crop_ann_change r_crop_per_cult_palmoil r_crop_per_cult_bananas r_crop_per_cult_mango r_crop_per_cult_avocado r_crop_per_cult_papaya r_crop_per_cult_guava r_crop_per_cult_lemon r_crop_per_cult_orange r_crop_per_cult_coffee r_crop_per_cult_other1 r_crop_per_cult_other2 r_crop_per_sell_palmoil r_crop_per_sell_bananas r_crop_per_sell_mango r_crop_per_sell_avocado r_crop_per_sell_papaya r_crop_per_sell_guava r_crop_per_sell_lemon r_crop_per_sell_orange r_crop_per_sell_coffee r_crop_per_sell_other1 r_crop_per_sell_other2 r_crop_per_cult_change r_crop_inc_change r_lvstck_own r_lvstck_div_cattle r_lvstck_div_goats r_lvstck_div_sheep r_lvstck_div_pigs r_lvstck_div_chicken r_lvstck_div_guineapigs r_lvstck_div_rabbits r_lvstck_div_ducks r_lvstck_div_poultry r_lvstck_div_other r_lvstck_div_sell_cattle r_lvstck_div_sell_goats r_lvstck_div_sell_sheep r_lvstck_div_sell_pigs r_lvstck_div_sell_chicken r_lvstck_div_sell_guineapigs r_lvstck_div_sell_rabbits r_lvstck_div_sell_ducks r_lvstck_div_sell_poultry r_lvstck_div_sell_other r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_food_1 r_res_food_2 r_res_food_3 r_res_food_4 r_res_food_5 r_res_food_6 r_res_food_7 r_res_food_8 r_res_food_9 r_res_food_10 r_res_food_11 r_res_food_12 r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype r_cop_shock_illness r_cop_shock_death r_cop_shock_injury r_cop_shock_jobloss r_cop_shock_wagecut r_cop_shock_cropfailure r_cop_shock_noremitt r_cop_shock_drought r_cop_shock_flood r_cop_shock_naturalhazard r_cop_shock_theft r_cop_shock_suddenexpenses r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_whyhow s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practwhyhow s_farm_soil_nofert_expensive s_farm_soil_nofert_notavail s_farm_soil_nofert_dontneed s_farm_soil_nofert_other s_farm_soil_chemfert_buygroup s_farm_soil_chemfert_buygroup_nr s_farm_lvstck_intgr s_farm_lvstck_plans s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve group nogroup_interest fertknow accessfert_pnseb fertwhy_notavailable fertwhy_nointerest fertwhy_hatefert fertwhy_expensive fertwhy_howtojoin fertwhy_joincomplicated fertwhy_noinfo fertwhy_other fertwhy_rta fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes radio_mboniyongana {
replace `x'=. if `x'==111
}

tab pip_generation_clean,mi
drop if pip_generation_clean==.		//1 obs dropped

*********************************************************************
*ADDITIONAL DATA CHANGES
*********************************************************************

*First: create dummies for categorical variables
tab educ, 			gen(educ)
tab educ_cat,		gen(educ_cat)
tab farmtype, 		gen(farmtype)
tab head_type, 		gen(headtype)
tab educ_head, 		gen(educhead)
tab educ_head_cat,	gen(educhead_cat)

save "2. Clean\PAPAB Impact study - Ready for analysis.dta", replace
//export delimited using "2. Clean\PAPAB Impact study - Ready for analysis.csv", replace

*********************************************************************
*EXPORT MEAN VALUES SOCIO-DEMOGRAPHICS
*********************************************************************

use "2. Clean\PAPAB Impact study - Ready for analysis.dta", clear
cd "4. Output"

/*Export socio-demographic info
local	socioecon	female age /*
*/					educ1 educ2 educ3 educ4 educ5 educ6 educ7 educ8 /*
*/					educ_cat1 educ_cat2 educ_cat3 educ_cat4/*
*/					educhead1 educhead2 educhead3 educhead4 educhead5 educhead6 educhead7 educhead8 /*
*/					educhead_cat1 educhead_cat2 educhead_cat3 educhead_cat4 /*
*/					r_inc_farm_farm r_inc_farm_stable r_inc_farm_sme r_inc_farm_other1 /*
*/					hhsize_total dependency /*
*/					land_hectares land_plots land_own land_rent land_communal /*
*/					farmtype1 farmtype2 farmtype3 headtype1 headtype2 headtype3  /*
*/					pip_approach pip_training pip_have pip_implemented

local 	cols		Group Mean SE CI_lowerbound CI_upperbound N
local	ncols:		word count `cols'
local	nrows:		word count `socioecon' `socioecon' `socioecon' `socioecon' `socioecon' `socioecon' 

matrix 				v=J(`nrows',`ncols',.)
mat 				colnames v=`cols'

svyset				colline [pw=weight_generation_inv], str(pip_generation_clean)

local				irow=0
foreach x in		`socioecon'{

replace pip_approach=99999 		if pip_generation_clean!=5	//change to 99999 to make mat run (otherwise no observations)
					local	++irow
					qui mean `x' if pip_generation_clean==1
					matrix g1 = r(table)
					mat 	v[`irow',1]= 1	
					mat 	v[`irow',2]= g1[1,1]
					mat 	v[`irow',3]= g1[2,1]
					mat 	v[`irow',4]= g1[5,1]
					mat 	v[`irow',5]= g1[6,1]
					mat		v[`irow',6]= e(N)

					local	++irow
					qui mean `x' if pip_generation_clean==2
					matrix g2 = r(table)
					mat 	v[`irow',1]= 2
					mat 	v[`irow',2]= g2[1,1]
					mat 	v[`irow',3]= g2[2,1]
					mat 	v[`irow',4]= g2[5,1]
					mat 	v[`irow',5]= g2[6,1]
					mat		v[`irow',6]= e(N)
					
					local	++irow
					qui mean `x' if pip_generation_clean==3
					matrix g3 = r(table)
					mat 	v[`irow',1]= 3	
					mat 	v[`irow',2]= g3[1,1]
					mat 	v[`irow',3]= g3[2,1]
					mat 	v[`irow',4]= g3[5,1]
					mat 	v[`irow',5]= g3[6,1]
					mat		v[`irow',6]= e(N)
					
					local	++irow
					qui mean `x' if pip_generation_clean==4
					matrix g4 = r(table)
					mat 	v[`irow',1]= 4	
					mat 	v[`irow',2]= g4[1,1]
					mat 	v[`irow',3]= g4[2,1]
					mat 	v[`irow',4]= g4[5,1]
					mat 	v[`irow',5]= g4[6,1]
					mat		v[`irow',6]= e(N)

replace pip_have=99999 			if pip_generation_clean==5	//change to 99999 to make mat run (otherwise no observations)
replace pip_implemented=99999 	if pip_generation_clean==5	//change to 99999 to make mat run (otherwise no observations)
					local	++irow
					qui mean `x' if pip_generation_clean==5
					matrix g5 = r(table)
					mat 	v[`irow',1]= 5	
					mat 	v[`irow',2]= g5[1,1]
					mat 	v[`irow',3]= g5[2,1]
					mat 	v[`irow',4]= g5[5,1]
					mat 	v[`irow',5]= g5[6,1]
					mat		v[`irow',6]= e(N)
					
replace pip_have=. 				if pip_generation_clean==5	//change back
replace pip_implemented=. 		if pip_generation_clean==5	//change back
					local	++irow
					qui svy: mean `x' if pip==1
					matrix g6 = r(table)
					mat 	v[`irow',1]= 6	
					mat 	v[`irow',2]= g6[1,1]
					mat 	v[`irow',3]= g6[2,1]
					mat 	v[`irow',4]= g6[5,1]
					mat 	v[`irow',5]= g6[6,1]
					mat		v[`irow',6]= e(N)	
replace pip_approach=.			if pip_generation_clean!=5	//change back	
}
*
mat 		list v, f(%10.3f)

putexcel 	set "4. Output\PAPAB Impact study - SocioDemographics.xlsx",  modify 	
putexcel	A1 = matrix(v, names) 

*Add name of variable and label
local 		irow=1
foreach 	x in `socioecon'  {
			local 		++irow
			sleep 3000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP - G1")
			
			local 		++irow 
			sleep 3000
			putexcel A`irow' = ("`x'") 	B`irow' = ("PIP - G2")
					
			local 		++irow 
			sleep 3000
			putexcel A`irow' = ("`x'")	B`irow' = ("PIP - G3")	 
			
			local 		++irow
			sleep 3000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP - G4")
			
			local 		++irow
			sleep 3000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP - Comparison")
			
			local 		++irow
			sleep 3000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP - All generations (weighted)")
}
*Make sure to empty rows for PIP variables that were adjusted (see above!)
svyset, clear*/

*********************************************************************
*MATCHING
*********************************************************************

/*We need to do 5 matches:
1. PIP G1 vs Comparison
2. PIP G2 vs Comparison
3. PIP G3 vs Comparison
4. PIP G4 vs Comparison
5. PIP ALL vs Comparison

We will set the comparison as reference group (comparison= 1; PIP= 0), 
in order for the comparison group to receive weight= 1. 
This is due to the fact that respondents in the comparison group can be matched more than once, 
given that they’re part of four different matching models. 
We will thus estimate the propensity of being in the comparison group relative to being a PIP-farmer. 
By setting the comparison as reference group they will, in each matching model, always receive weight= 1.
We will combine the weights of the four matching models to construct one weight indicator.*/

*0: Construct matching sub samples with comparison==1
gen comparison=0
replace comparison=1 if pip==0
lab def comp 1 "Comparison" 0 "PIP Generation X"
lab val comparison comp
lab var comparison "1= Comparison; 0= PIP"
order comparison, after(pip)
tab pip comparison,mi

gen comp_g1=comparison
replace comp_g1=. if pip_generation_clean!=1 & pip_generation_clean!=5
gen comp_g2=comparison
replace comp_g2=. if pip_generation_clean!=2 & pip_generation_clean!=5
gen comp_g3=comparison
replace comp_g3=. if pip_generation_clean!=3 & pip_generation_clean!=5
gen comp_g4=comparison
replace comp_g4=. if pip_generation_clean!=4 & pip_generation_clean!=5
tab1 comp_g1 comp_g2 comp_g3 comp_g4
lab val comp_g1 comp_g2 comp_g3 comp_g4 comp
foreach x in comp_g4 comp_g3 comp_g2 comp_g1{
order `x', after(comparison)
lab var `x' "Subsample comparison + separate generation"
}

tab pip_generation_clean commune	
		//commune perfectly predicts comparison
		//so matching on commune not possible; go with higher level (province)

*1: Covariates list
		//excl. income from matching? because correlated with outcomes!!
tab1	province gender age educ_cat educ_head_cat head_type dependency /*
		*/	mixedfarm land_hectares land_plots land_own land_rent land_communal
		//not enough variation in land_communal, remove
sum 	land_own land_rent land_communal
corr  	land_rent land_own
		//corr= -0.9998 (= makes sense)
		//land_own: 85% on average; land_rent: 15% on average -> include land_own
sum 	land_hectares land_plots
corr 	land_hectares land_plots
		//corr= 0.5359 (= quite high). Also land_plots doesn't necessarily say much about scale of farmer.
		//continue with land_hectares only in covariate list
egen 	miss_cov=rowmiss(province gender age educ_cat educ_head_cat head_type dependency /*
		*/	mixedfarm land_hectares land_own)
tab 	pip_generation_clean miss_cov		
		//in total 6 obs missing, so ok

reg 	comparison 	i.province i.gender age i.educ_cat i.educ_head_cat i.head_type dependency /*
		*/ 	i.mixedfarm land_hectares land_own
vif		//vif= ok; all below 10 (largest value = 4.8), apart from age_sqrd (which is logical)

/*2: Check general goodness of fit
logit 	comparison i.province i.gender age i.educ_cat i.educ_head_cat i.head_type dependency i.mixedfarm land_hectares land_own
											//Pseudo R2= 0.1088
estat	class								//Correctly specified = 67.15%
lroc										//area under ROC curve; c-statistic= 0.7165 (>0.5 --> so ok)
estat 	gof, group(10) table				//Chi2 not significant --> ok
//https://www.statalist.org/forums/forum/general-stata-discussion/general/1322159-interpretation-of-classification-table-in-stata-for-a-logistic-regression
		//educ_cat and educ_head_cat both not signficiant, as well as dependency
		//let's additionally test with chi2+ttest
ttest	educ_head_cat, by(comparison)		//not significant
tab		educ_head_cat comparison, col chi2	//not significant
		//let's see what happens when removing i.educ_head_cat
logit 	comparison i.province i.gender age i.educ_cat i.head_type dependency i.mixedfarm land_hectares land_own
											//Pseudo R2= 0.1087
estat	class								//Correctly specified = 66.74%
lroc										//area under ROC curve; c-statistic= 0.7164 (>0.5 --> so ok)
estat 	gof, group(10) table				//Chi2 not significant --> ok
		//let's see what happens when removing dependency as well
ttest 	dependency, by(comparison)			//not significant
logit 	comparison i.province i.gender age i.educ_cat i.head_type i.mixedfarm land_hectares land_own
											//Pseudo R2= 0.1084
estat	class								//Correctly specified = 67.08%
lroc										//area under ROC curve; c-statistic= 0.7162 (>0.5 --> so ok)
estat 	gof, group(10) table				//Chi2 not significant --> ok
		//let's see what happens if we add age_sqrd
logit 	comparison i.province i.gender age age_sqrd i.educ_cat i.head_type i.mixedfarm land_hectares land_own
											//Pseudo R2= 0.1091; age_sqrd not significant
estat	class								//Correctly specified = 66.56%
lroc										//area under ROC curve; c-statistic= 0.7160 (>0.5 --> so ok)
estat 	gof, group(10) table				//Chi2 not significant --> ok
		//conclusion: not necessary to add it in
		
*3: Defining matching model
local 	covariates	i.province i.gender age age_sqrd i.educ_cat i.head_type i.mixedfarm land_hectares land_own

//kernel
psmatch2 comparison `covariates',  kernel logit caliper(0.001) comm
pstest `covariates', both
ren 	(_pscore _treated _support _weight) (k_pscore k_treated k_support k_weight)
tab 	k_support comparison
		//N= 956, ttest ok, %bias ok, B&R ok, 956 on support

//radius
psmatch2 comparison `covariates',  radius logit caliper(0.001) comm
pstest `covariates', both
ren 	(_pscore _treated _support _weight) (r_pscore r_treated r_support r_weight)
tab 	r_support comparison			
		//N= 956, ttest ok, %bias mostly ok, R and B ok, 804 on support
		
/*Conclusion: kernel matching gives better balancing results than radius matching,
and also leaves us with more observations. Therefore go with kernel matching.*/
*/

*Although analysis above on comparison (so everyone vs comparison) suggest to not include educ_head_cat and dependency,
*check what it does when running the matching on separate PIP generations.
*Also include age_sqrd to see if it contributes.
*Turns out we can go forward with original model (without dependency and educ_head_cat,
*as only minor increases in Pseudo R2; and both variables are not significant.
*However, age_sqrd significant when looking at generation 3+4.

/*
//TEST MATCHING
local 	covariates2	i.province i.female age age_sqrd i.educ_cat i.head_type i.mixedfarm land_hectares land_own i.educ_head_cat dependency

//PIP G1 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g1 `covariates2'
predict			p_g1b
outreg2			using Output_Logit_Extended_PAPAB, excel replace label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g1, p(p_g1b) kernel logit caliper(0.001)  comm 
ren 			_weight w_g1b
ren 			_support support_g1b
drop 			r _pscore _treated
tab				support_g1b comp_g1	

//PIP G2 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g2 `covariates2'
predict			p_g2b
outreg2			using Output_Logit_Extended_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1)
psmatch2		comp_g2, p(p_g2b) kernel logit caliper(0.001)  comm 
ren 			_weight w_g2b
ren 			_support support_g2b
drop 			r _pscore _treated
tab				support_g2b comp_g2	

//PIP G3 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g3 `covariates2'
predict			p_g3b
outreg2			using Output_Logit_Extended_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g3, p(p_g3b) kernel logit caliper(0.001)  comm 
ren 			_weight w_g3b
ren 			_support support_g3b
drop 			r _pscore _treated
tab				support_g3b comp_g3	

//PIP G4 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g4 `covariates2'
predict			p_g4b
outreg2			using Output_Logit_Extended_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g4, p(p_g4b) kernel logit caliper(0.001)  comm 
ren 			_weight w_g4b
ren 			_support support_g4b
drop 			r _pscore _treated
tab				support_g4b comp_g4

//PIP ALL vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comparison `covariates2' [pw=weight_generation_inv]
predict			p_allpip2
outreg2			using Output_Logit_Extended_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comparison, p(p_allpip2) kernel logit caliper(0.001)  comm 
ren 			_weight w_allpip2
ren 			_support support_allpip2
drop 			r _pscore _treated
tab				support_allpip2 comparison
*/

//REAL MATCHING
mean land_hectares
gen bigfarm=.
replace bigfarm=1 if land_hectares>1.780469
replace bigfarm=0 if land_hectares<=1.780469
lab val bigfarm binary
lab var bigfarm "1= farm size is above average hectares"
gen mixedfarm_bigfarm=mixedfarm*bigfarm

tab province, g(d_province)
tab educ_cat, g(d_educ_cat)
tab head_type, g(d_head_type)

local 	covariates			i.province i.female age i.educ_cat i.head_type i.mixedfarm land_hectares land_own
local 	covariates_test 	d_province1 d_province2 d_province3 d_province4 d_province5 female age d_educ_cat1 d_educ_cat2 d_educ_cat3 d_educ_cat4 d_head_type1 d_head_type2 d_head_type3 mixedfarm land_hectares land_own

//PIP G1 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g1 `covariates'
				//Pseudo R2= 0.2491
predict			p_g1
outreg2			using Output_Logit_PAPAB, excel replace label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g1, p(p_g1) kernel logit caliper(0.001)  comm 
pstest 			`covariates', both
				//t-test ok, B&R ok, %bias mostly ok
ren 			_weight w_g1
ren 			_support support_g1
drop 			r _pscore _treated
tab				support_g1 comp_g1	//On Support: 107 G1; 333 C
//iebaltab 		`covariates_test' if miss_cov == 0 , grpvar(comp_g1) save(prebalance_g1.xlsx) replace
//iebaltab 		`covariates_test' if miss_cov == 0 & support_g1==1 [pw=w_g1] , grpvar(comp_g1) save(postbalance_g1.xlsx) replace
//balance results ok (both pstest+iebaltab)

//PIP G2 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g2 `covariates'
				//Pseudo R2= 0.1440 
predict			p_g2
outreg2			using Output_Logit_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1)
psmatch2		comp_g2, p(p_g2) kernel logit caliper(0.001)  comm 
pstest 			`covariates', both
				//t-test ok apart from 1, R ok (B not), %bias mostly ok
ren 			_weight w_g2
ren 			_support support_g2
drop 			r _pscore _treated
tab				support_g2 comp_g2	//On Support: 119 G2; 341 C
//iebaltab 		`covariates_test' if miss_cov == 0 , grpvar(comp_g2) save(prebalance_g2.xlsx) replace
//iebaltab 		`covariates_test' if miss_cov == 0 & support_g2==1 [pw=w_g2] , grpvar(comp_g2) save(postbalance_g2.xlsx) replace
//problems with 3.head_type; no problems in iebaltab

//PIP G3 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g3 `covariates'
				//Pseudo R2= 0.1045
predict			p_g3
outreg2			using Output_Logit_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g3, p(p_g3) kernel logit caliper(0.001)  comm 
pstest 			`covariates', both
				//t-test ok apart from 2, R ok (B not), %bias mostly ok
ren 			_weight w_g3
ren 			_support support_g3
drop 			r _pscore _treated
tab				support_g3 comp_g3	//On Support: 120 G3; 419 C
//iebaltab 		`covariates_test' if miss_cov == 0 , grpvar(comp_g3) save(prebalance_g3.xlsx) replace
//iebaltab 		`covariates_test' if miss_cov == 0 & support_g3==1 [pw=w_g3] , grpvar(comp_g3) save(postbalance_g3.xlsx) replace
//pstest: problems with educ_cat; not reduced when adding educ_head_cat; no problems in iebaltab

//PIP G4 vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comp_g4 `covariates'
				//Pseudo R2= 0.0939
predict			p_g4
outreg2			using Output_Logit_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
psmatch2		comp_g4, p(p_g4) kernel logit caliper(0.001)  comm 
pstest 			`covariates', both
				//t-test ok apart from 1, R ok (B not), %bias mostly ok
ren 			_weight w_g4
ren 			_support support_g4
drop 			r _pscore _treated
tab				support_g4 comp_g4	//On Support: 140 G4; 449 C
//iebaltab 		`covariates_test' if miss_cov == 0 , grpvar(comp_g4) save(prebalance_g4.xlsx) replace
//iebaltab 		`covariates_test' if miss_cov == 0 & support_g4==1 [pw=w_g4] , grpvar(comp_g4) save(postbalance_g4.xlsx) replace
//problems with 3.head_type; when changing to headtype_dum land_own becomes unbalanced; no problems in iebaltab

//PIP ALL vs Comparison
set 			seed 123456
generate 		r=uniform()
sort 			r
logit			comparison `covariates' [pw=weight_generation_inv]
				//Pseudo R2= 0.0540
predict			p_allpip
outreg2			using Output_Logit_PAPAB, excel append label(insert) addstat(Pseudo R2, e(r2_p)) bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) 
//psmatch2		comparison, p(p_allpip) kernel logit caliper(0.001)  comm
//pstest 		`covariates', both
				//t-test ok apart from 4 (2 of which are province), R ok (B not), %bias mostly ok
psmatch2		comparison, p(p_allpip) radius logit caliper(0.001)  comm 
pstest 			`covariates', both
				//t-test ok, % mostly ok, B&R ok -> radius matching = better balancing results than kernel
ren 			_weight w_allpip
ren 			_support support_allpip
drop 			r _pscore _treated
tab				support_allpip comparison	//On Support: 140 G4; 449 C
//iebaltab 		`covariates_test' if miss_cov == 0 , grpvar(comparison) save(prebalance_allpip.xlsx) replace
//iebaltab 		`covariates_test' if miss_cov == 0 & support_allpip==1 [pw=w_allpip] , grpvar(comparison) save(postbalance_allpip.xlsx) replace
//moving from kernel to radius matching gives better balancing results

drop 			d_province1 d_province2 d_province3 d_province4 d_province5 d_educ_cat1 d_educ_cat2 d_educ_cat3 d_educ_cat4 d_head_type1 d_head_type2 d_head_type3

*Interesting: the younger the generation, the more comparison respondents on support.
*Interesting: the younger the generation, the lower the goodness of fit of your model (which also makes sense I'd assume)

//Change of R2 between models significant?
//Export -2loglikelihood?













*********************************************************************
*SAVE
*********************************************************************

cd "C:\Users\mariekeme\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean"
save "PAPAB Impact study - Analysis1.dta", replace
export delimited using "PAPAB Impact study - Analysis1.csv", replace
