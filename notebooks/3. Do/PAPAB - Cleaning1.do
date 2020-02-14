* Project: PAPAB (Impact Study)
* Country: Burundi
* Survey: 2019
* Objective: Cleaning1 - Renaming + Labeling
* Author: Marieke Meeske
* Date: 12-12-2019

/////////////////////////////////////////
*This do-file consists of three parts:
*1: Renaming of variables
*2: Labeling of variables
*3: Recoding of text variables
*4: Labeling of values
*5: Renaming to updated names
*6: Other cleaning
*7: Add sampling weights
*8: Add long+lat info per colline
*9: Save and export (incl. variable/value labels, codebook)
/////////////////////////////////////////

*********************************************************************
*IMPORT+CD
*********************************************************************

*Import cleaned+merged data
cd "C:/Users/`c(username)'/Box\ONL-IMK/2.0 Projects/Current/2018-05 PAPAB Burundi/07. Analysis & reflection/Data & Analysis"
usespss "1. Raw/PAPAB Impact study.sav", clear
numlabel, add
set more off

*Drop empty variables
foreach var of varlist _all {
     capture assert mi(`var')
     if !_rc {
        drop `var'
     }
}
*

*Survey time
mata 	usespss_dates()
rename 	Duration__in_seconds_ duration_s
gen		duration_m = duration_s/60
order 	duration_m, after(duration_s)
lab var duration_m "duration in minutes"
lab var duration_s "duration in seconds"
gen below10=0
replace below10=1 if duration_m<10
order below10, after(duration_m)
lab var below10 "Survey is below 10 minutes"

*Keep only real
keep if Finished==1
sort StartDate
gen id=_n
order id, first
keep if id>=18
drop id

*Gen id
gen id=_n
order id, first
lab var id "ID based on row number"

*********************************************************************
*1: RENAME VARIABLES
*********************************************************************

rename Q2_2 	code_enumerator
rename Q2_3_1 	province
rename Q2_3_2 	commune
rename Q2_3_3 	colline
rename Q2_4 	pip_generation
rename Q2_5 	gender
rename Q2_6 	code_respondent	
rename Q3_2 	consent
rename Q4_2 	age
rename Q4_3 	educ
rename Q4_4 	farmtype
rename Q4_5 	land_hectares
rename Q4_6 	land_plots
rename Q4_7_1 	land_own
rename Q4_7_2 	land_rent
rename Q4_7_3 	land_communal
egen land_total=rowtotal (land_own land_rent land_communal)
order land_total, after(land_communal)
rename Q4_9_1 	hhsize_men18
rename Q4_9_2 	hhsize_women18
rename Q4_9_3 	hhsize_children
egen hhsize_total=rowtotal (hhsize_men18 hhsize_women18 hhsize_children)
order hhsize_total, after(hhsize_children)
rename Q4_10 	head_type
rename Q4_11 	educ_head
rename Q4_12 	pip_approach
rename Q4_13 	pip_training
rename Q4_14 	pip_training_year
rename Q4_15 	pip_training_trainer
rename Q4_16 	pip_have
rename Q4_17_19 pip_implemented
rename Q4_18 	pip_improvedecon

//Motivation
rename Q5_2 	m_valuelife
rename Q5_3 	m_proudlife
rename Q5_4 	m_stay
rename Q5_5 	m_condition
rename Q5_6 	m_plans
rename Q5_7 	m_actionstaken
rename Q5_8 	m_choice
rename Q5_9 	m_desires
rename Q5_10 	m_improve
rename Q5_11 	m_easy
rename Q5_12 	m_incharge
rename Q5_13 	m_manageresp
rename Q5_14 	m_learnimprove
rename Q5_15 	m_changes_askothers
rename Q5_16 	m_shareknowledge
rename Q5_17 	m_problems_askothers
rename Q5_18 	m_newpractices
rename Q5_19 	m_improveproud
rename Q5_20 	m_collaborate
rename Q5_21 	m_whoplanning
rename Q5_22 	m_understandplanning
rename Q5_23 	m_understandplanning2
rename Q5_24 	m_conflicts_hh
rename Q5_25 	m_accesslabour
rename Q5_26 	m_enoughmoney
rename Q5_27 	m_feelvalued
rename Q5_28 	m_conflicts_hhvillage
rename Q5_29 	m_trust
rename Q5_30 	m_lendmoney
rename Q5_31 	m_conflicts_villvill
rename Q5_32 	m_conflicts_solved
rename Q5_33 	m_samevision

//Resilience
rename Q6_2_1_1 	r_inc_subs_crop
rename Q6_2_2_1 	r_inc_subs_livestock
rename Q6_2_3_1 	r_inc_sale_fieldcrop
rename Q6_2_4_1 	r_inc_sale_cashcrop
rename Q6_2_5_1 	r_inc_sale_orchard
rename Q6_2_6_1 	r_inc_sale_livestock
rename Q6_2_7_1 	r_inc_sale_prepfood
rename Q6_2_8_1 	r_inc_agrwage
rename Q6_2_9_1 	r_inc_shepherd
rename Q6_2_10_1 	r_inc_miller
rename Q6_2_11_1 	r_inc_unskilledday
rename Q6_2_12_1 	r_inc_skilled
rename Q6_2_13_1 	r_inc_employee
rename Q6_2_14_1 	r_inc_trade
rename Q6_2_15_1 	r_inc_firewood
rename Q6_2_16_1 	r_inc_handicrafts
rename Q6_2_17_1 	r_inc_carpet
rename Q6_2_18_1 	r_inc_mining
rename Q6_2_19_1 	r_inc_military
rename Q6_2_20_1 	r_inc_taxi
rename Q6_2_21_1 	r_inc_remitt_out
rename Q6_2_22_1 	r_inc_remitt_in
rename Q6_2_23_1 	r_inc_pension
rename Q6_2_24_1 	r_inc_govbenefit
rename Q6_2_25_1 	r_inc_rental
rename Q6_2_26_1 	r_inc_sale_foodaid
rename Q6_2_27_1 	r_inc_begging
rename Q6_2_28_1 	r_inc_other
rename Q6_2_28_TEXT r_inc_other_text
rename Q6_3_1878 	r_incshare_subs_crop
rename Q6_3_1879 	r_incshare_subs_livestock
rename Q6_3_1880 	r_incshare_sale_fieldcrop
rename Q6_3_1881 	r_incshare_sale_cashcrop
rename Q6_3_1882 	r_incshare_sale_orchard
rename Q6_3_1883 	r_incshare_sale_livestock
rename Q6_3_1884 	r_incshare_sale_prepfood
rename Q6_3_1885 	r_incshare_agrwage
rename Q6_3_1886 	r_incshare_shepherd
rename Q6_3_1887 	r_incshare_miller
rename Q6_3_1888 	r_incshare_unskilledday
rename Q6_3_1889 	r_incshare_skilled
rename Q6_3_1890 	r_incshare_employee
rename Q6_3_1891 	r_incshare_trade
rename Q6_3_1892 	r_incshare_firewood
rename Q6_3_1893 	r_incshare_handicrafts
rename Q6_3_1894 	r_incshare_carpet
rename Q6_3_1895 	r_incshare_mining
rename Q6_3_1896 	r_incshare_military
rename Q6_3_1897 	r_incshare_taxi
rename Q6_3_1898 	r_incshare_remitt_out
rename Q6_3_1899 	r_incshare_remitt_in
rename Q6_3_1900 	r_incshare_pension
rename Q6_3_1901 	r_incshare_govbenefit
rename Q6_3_1902 	r_incshare_rental
rename Q6_3_1903 	r_incshare_sale_foodaid
rename Q6_3_1904 	r_incshare_begging
rename Q6_3_1905 	r_incshare_other
rename Q6_3_1905_TEXT r_incshare_other_text
rename Q6_4_4 		r_actshare_labor
rename Q6_4_5 		r_actshare_sowing
rename Q6_4_6 		r_actshare_weeding
rename Q6_4_7 		r_actshare_harvesting
rename Q6_4_8 		r_actshare_sorting
rename Q6_4_9 		r_actshare_drying
rename Q6_4_10 		r_actshare_tightening
rename Q6_4_11 		r_actshare_transport
egen r_actshare_total=rowtotal(r_actshare_labor r_actshare_sowing r_actshare_weeding r_actshare_harvesting r_actshare_sorting r_actshare_drying r_actshare_tightening r_actshare_transport),mi
order r_actshare_total, after(r_actshare_transport)
rename Q6_5 		r_inc_change_agrlivestock
rename Q6_6 		r_inc_change_other
rename Q6_7 		r_finance_vsla
rename Q6_8 		r_finance_enough
rename Q6_9_93 		r_anncropcult_maize
rename Q6_9_94 		r_anncropcult_sorghum
rename Q6_9_95 		r_anncropcult_cassava
rename Q6_9_96 		r_anncropcult_rice
rename Q6_9_97 		r_anncropcult_irishpotato
rename Q6_9_99 		r_anncropcult_sweetpotato
rename Q6_9_100 	r_anncropcult_colocase
rename Q6_9_101 	r_anncropcult_eleusine
rename Q6_9_102 	r_anncropcult_beans
rename Q6_9_103 	r_anncropcult_greenpeas
rename Q6_9_104 	r_anncropcult_cajapeas
rename Q6_9_105 	r_anncropcult_cabbage
rename Q6_9_106 	r_anncropcult_amaranth
rename Q6_9_107 	r_anncropcult_carrot
rename Q6_9_108 	r_anncropcult_tomato
rename Q6_9_109 	r_anncropcult_beet
rename Q6_9_110 	r_anncropcult_eggplant
rename Q6_9_111 	r_anncropcult_pepper
rename Q6_9_112 	r_anncropcult_spinach
rename Q6_9_113		r_anncropcult_cucumber
rename Q6_9_114 	r_anncropcult_yams
rename Q6_9_115		r_anncropcult_onions
rename Q6_9_116 	r_anncropcult_watermelon
rename Q6_9_117 	r_anncropcult_squash
rename Q6_9_118		r_anncropcult_other1
rename Q6_9_118_TEXT r_anncropcult_other1_text
rename Q6_9_119		r_anncropcult_other2
rename Q6_9_119_TEXT r_anncropcult_other2_text
egen r_anncropcult_total=rowtotal(r_anncropcult_maize r_anncropcult_sorghum r_anncropcult_cassava r_anncropcult_rice r_anncropcult_irishpotato r_anncropcult_sweetpotato r_anncropcult_colocase r_anncropcult_eleusine r_anncropcult_beans r_anncropcult_greenpeas r_anncropcult_cajapeas r_anncropcult_cabbage r_anncropcult_amaranth r_anncropcult_carrot r_anncropcult_tomato r_anncropcult_beet r_anncropcult_eggplant r_anncropcult_pepper r_anncropcult_spinach r_anncropcult_cucumber r_anncropcult_yams r_anncropcult_onions r_anncropcult_watermelon r_anncropcult_squash r_anncropcult_other1 r_anncropcult_other2)
order r_anncropcult_total, after(r_anncropcult_other2_text)
rename Q6_10_93 	r_anncropsell_maize
rename Q6_10_94 	r_anncropsell_sorghum
rename Q6_10_95 	r_anncropsell_cassava
rename Q6_10_96 	r_anncropsell_rice
rename Q6_10_97 	r_anncropsell_irishpotato
rename Q6_10_99 	r_anncropsell_sweetpotato
rename Q6_10_100 	r_anncropsell_colocase
rename Q6_10_101 	r_anncropsell_eleusine
rename Q6_10_102 	r_anncropsell_beans
rename Q6_10_103 	r_anncropsell_greenpeas
rename Q6_10_104 	r_anncropsell_cajapeas
rename Q6_10_105 	r_anncropsell_cabbage
rename Q6_10_106 	r_anncropsell_amaranth
rename Q6_10_107 	r_anncropsell_carrot
rename Q6_10_108 	r_anncropsell_tomato
rename Q6_10_109 	r_anncropsell_beet
rename Q6_10_110 	r_anncropsell_eggplant
rename Q6_10_111 	r_anncropsell_pepper
rename Q6_10_112 	r_anncropsell_spinach
rename Q6_10_113	r_anncropsell_cucumber
rename Q6_10_114 	r_anncropsell_yams
rename Q6_10_115 	r_anncropsell_onions
rename Q6_10_116 	r_anncropsell_watermelon
rename Q6_10_117 	r_anncropsell_squash
rename Q6_10_118	r_anncropsell_other1
rename Q6_10_119	r_anncropsell_other2
egen r_anncropsell_total=rowtotal(r_anncropsell_maize r_anncropsell_sorghum r_anncropsell_cassava r_anncropsell_rice r_anncropsell_irishpotato r_anncropsell_sweetpotato r_anncropsell_colocase r_anncropsell_eleusine r_anncropsell_beans r_anncropsell_greenpeas r_anncropsell_cajapeas r_anncropsell_cabbage r_anncropsell_amaranth r_anncropsell_carrot r_anncropsell_tomato r_anncropsell_beet r_anncropsell_eggplant r_anncropsell_pepper r_anncropsell_spinach r_anncropsell_cucumber r_anncropsell_yams r_anncropsell_onions r_anncropsell_watermelon r_anncropsell_squash r_anncropsell_other1)
order r_anncropsell_total, after(r_anncropsell_other2)
rename Q6_11 		r_anncrop_change
rename Q6_12_83 	r_percropcult_palmoil
rename Q6_12_84 	r_percropcult_bananas
rename Q6_12_85 	r_percropcult_mango
rename Q6_12_86 	r_percropcult_avocado
rename Q6_12_87 	r_percropcult_papaya
rename Q6_12_88 	r_percropcult_guava
rename Q6_12_89 	r_percropcult_lemon
rename Q6_12_90 	r_percropcult_orange
rename Q6_12_91 	r_percropcult_coffee
rename Q6_12_92		r_percropcult_other1
rename Q6_12_93		r_percropcult_other2
rename Q6_12_92_TEXT r_percropcult_other1_text
rename Q6_12_93_TEXT r_percropcult_other2_text
egen r_percropcult_total=rowtotal(r_percropcult_palmoil r_percropcult_bananas r_percropcult_mango r_percropcult_avocado r_percropcult_papaya r_percropcult_guava r_percropcult_lemon r_percropcult_orange r_percropcult_coffee r_percropcult_other1 r_percropcult_other2)
order r_percropcult_total, after(r_percropcult_other2)
rename Q6_13_83 	r_percropsell_palmoil
rename Q6_13_84 	r_percropsell_bananas
rename Q6_13_85 	r_percropsell_mango
rename Q6_13_86 	r_percropsell_avocado
rename Q6_13_87 	r_percropsell_papaya
rename Q6_13_88		r_percropsell_guava 
rename Q6_13_89 	r_percropsell_lemon
rename Q6_13_90 	r_percropsell_orange
rename Q6_13_91 	r_percropsell_coffee
rename Q6_13_92 	r_percropsell_other1
rename Q6_13_93		r_percropsell_other2
egen r_percropsell_total=rowtotal(r_percropsell_palmoil r_percropsell_bananas r_percropsell_mango r_percropsell_avocado r_percropsell_papaya r_percropsell_guava r_percropsell_lemon r_percropsell_orange r_percropsell_coffee r_percropsell_other1  r_percropsell_other2)
order r_percropsell_total, after(r_percropsell_other2)
rename Q6_14 		r_percropcult_change
rename Q6_15 		r_cropsell_change
rename Q6_16 		r_own_livestock
rename Q6_17_13 	r_livestock_cattle
rename Q6_17_14 	r_livestock_goats
rename Q6_17_15 	r_livestock_sheep
rename Q6_17_16 	r_livestock_pigs
rename Q6_17_17 	r_livestock_chicken
rename Q6_17_18 	r_livestock_guineapigs
rename Q6_17_19 	r_livestock_rabbits
rename Q6_17_20 	r_livestock_ducks
rename Q6_17_21 	r_livestock_poultry
rename Q6_17_22		r_livestock_other
rename Q6_17_22_TEXT	r_livestock_other_text
egen r_livestock_total=rowtotal(r_livestock_cattle r_livestock_goats r_livestock_sheep r_livestock_pigs r_livestock_chicken r_livestock_guineapigs r_livestock_rabbits r_livestock_ducks r_livestock_poultry)
order r_livestock_total, after(r_livestock_other)
rename Q6_18_13 	r_livestocksell_cattle
rename Q6_18_14 	r_livestocksell_goats
rename Q6_18_15 	r_livestocksell_sheep
rename Q6_18_16 	r_livestocksell_pigs
rename Q6_18_17 	r_livestocksell_chicken
rename Q6_18_18		r_livestocksell_guineapigs
rename Q6_18_19 	r_livestocksell_rabbits
rename Q6_18_20		r_livestocksell_ducks
rename Q6_18_21 	r_livestocksell_poultry
rename Q6_18_22 	r_livestocksell_other
egen r_livestocksell_total=rowtotal(r_livestocksell_cattle r_livestocksell_goats r_livestocksell_sheep r_livestocksell_pigs r_livestocksell_chicken r_livestocksell_guineapigs r_livestocksell_rabbits r_livestocksell_ducks r_livestocksell_poultry)
order r_livestocksell_total, after(r_livestocksell_other)
rename Q6_19 		r_livestock_health
rename Q6_20 		r_livestock_health_medical
rename Q6_21 		r_livestock_producefeed
rename Q6_22 		r_livestock_fodder
rename Q6_23_1 		r_food1
rename Q6_23_2  	r_food2
rename Q6_23_3 		r_food3
rename Q6_23_4 		r_food4
rename Q6_23_5 		r_food5
rename Q6_23_6 		r_food6
rename Q6_23_7 		r_food7
rename Q6_23_8 		r_food8
rename Q6_23_9 		r_food9
rename Q6_23_10 	r_food10
rename Q6_23_11 	r_food11
rename Q6_23_12 	r_food12
rename Q6_24 		r_hh_health
rename Q6_25 		r_intgr_farm_mngmt
rename Q6_26 		r_skills_access
rename Q6_27 		r_skills_problem
rename Q6_28 		r_planningtasks
rename Q6_29 		r_decic_farminput
rename Q6_30 		r_decic_croptype
rename Q6_31_4 		r_shock_illness
rename Q6_31_5 		r_shock_death
rename Q6_31_6 		r_shock_injury
rename Q6_31_7 		r_shock_jobloss
rename Q6_31_8 		r_shock_wagecut
rename Q6_31_9 		r_shock_cropfailure
rename Q6_31_10 	r_shock_noremitt
rename Q6_31_11 	r_shock_drought
rename Q6_31_12 	r_shock_flood
rename Q6_31_13 	r_shock_naturalhazard
rename Q6_31_14 	r_shock_theft
rename Q6_31_15 	r_shock_suddenexpenses
egen r_shock_total=rowtotal(r_shock_illness r_shock_death r_shock_injury r_shock_jobloss r_shock_wagecut r_shock_cropfailure r_shock_noremitt r_shock_drought r_shock_flood r_shock_naturalhazard r_shock_theft r_shock_suddenexpenses), mi
order r_shock_total, after(r_shock_suddenexpenses)
rename Q6_32 		r_shock_severity
rename Q6_33 		r_shock_changecope
rename Q6_34 		r_shock_abilitycope
rename Q6_35 		r_assets_managefarm
rename Q6_36 		r_assets_managehh

//Stewardship
rename Q7_1 		s_landquality_change
rename Q7_2 		s_landquality_changewhy
rename Q7_3 		s_veg_change
rename Q7_4 		s_veg_changewhy
rename Q7_5 		s_water_change
rename Q7_6 		s_water_changewhy
rename Q7_7 		s_natresc_protect
rename Q7_8 		s_natresc_protectimp
rename Q7_9 		s_nature_importance
rename Q7_13_20 	s_physpract_contourlines
rename Q7_13_21 	s_physpract_conttrack
rename Q7_13_22 	s_physpract_stonebunds
rename Q7_13_23 	s_physpract_gullycontrol
egen s_physpract_total=rowtotal(s_physpract_contourlines s_physpract_conttrack s_physpract_stonebunds s_physpract_gullycontrol)
order s_physpract_total, after(s_physpract_gullycontrol)
rename Q7_14 		s_physpract_whyhow
rename Q7_15 		s_trees_change
rename Q7_16 		s_trees_whyhow
rename Q7_20_47 	s_mngmtpract_ploughing
rename Q7_20_48 	s_mngmtpract_staggering
rename Q7_20_49 	s_mngmtpract_mulching
rename Q7_20_50 	s_mngmtpract_covercrops
egen s_mngmtpract_total=rowtotal(s_mngmtpract_ploughing s_mngmtpract_staggering s_mngmtpract_mulching s_mngmtpract_covercrops)
order s_mngmtpract_total, after(s_mngmtpract_covercrops)
rename Q7_21 		s_mngmtpract_whyhow
rename Q7_22 		s_croprotation
rename Q7_23 		s_croprotation_why
rename Q7_24 		s_mixintercrop_why
rename Q7_25_1 		s_soilpract_compost
rename Q7_25_2 		s_soilpract_manure
rename Q7_25_4 		s_soilpract_chemfert
rename Q7_25_5 		s_soilpract_compost_chemfert
rename Q7_25_6 		s_soilpract_manure_chemfert
rename Q7_26 		s_soilpract_whyhow
rename Q7_27_1 		s_nofert_expensive
rename Q7_27_2 		s_nofert_notavail
rename Q7_27_3 		s_nofert_dontneed
rename Q7_27_4 		s_nofert_other
rename Q7_27_4_TEXT s_nofert_other_text
rename Q7_28 		s_chemfert_buygroup
rename Q7_29 		s_chemfert_buygroup_nr
rename Q7_30 		s_croplivestock_intgr
rename Q7_31 		s_treesbush_importance
rename Q7_32 		s_livestock_plans
rename Q7_33 		s_treesbush_howuse
rename Q7_34 		s_water_howconserve
rename Q7_35 		s_water_sourceimp
rename Q7_36 		s_commonlands_howuse
rename Q7_37 		s_commonlands_howconserve

//Final evaluation
rename Q8_1 		group
rename Q8_2 		nogroup_interest
rename Q9_1 		fertknow
rename Q9_2 		accessfert_pnseb
rename Q9_3_1		fertwhy_notavailable 
rename Q9_3_2		fertwhy_nointerest 
rename Q9_3_3		fertwhy_hatefert 
rename Q9_3_4		fertwhy_expensive 
rename Q9_3_5		fertwhy_howtojoin 
rename Q9_3_6		fertwhy_joincomplicated 
rename Q9_3_7		fertwhy_noinfo 
rename Q9_3_8		fertwhy_other
rename Q9_3_9		fertwhy_rta
rename Q9_4_1		fertlike_distribution 
rename Q9_4_2		fertlike_registration 
rename Q9_4_3		fertlike_advancepay 
rename Q9_4_4		fertlike_availability 
rename Q9_4_5		fertlike_quality 
rename Q9_4_6		fertlike_price 
rename Q9_4_7		fertlike_ferttypes
rename Q9_5			radio_mboniyongana

*********************************************************************
*2: LABELING 1 (VARIABLE LABELS)
*********************************************************************

//NB: Some variables don't need updated label, as the one already there is ok enough.

lab var code_enumerator "code enumerator"
lab var province"Province"
lab var commune "Commune"
lab var colline "Colline"
lab var pip_generation "PIP farmer generation: BEFORE cleaning"
lab var gender "gender respondent"
lab var code_respondent "code respondent"
lab var consent "consent"
lab var age "age"
lab var educ "highest achieved level of education"
lab var farmtype "type of farm (crop vs animal vs crop & animal"
lab var land_own "% of land owned"
lab var land_rent "% of land rented"
lab var land_communal "% of land communal"
lab var land_total "total % (= should be 100%)"
lab var hhsize_men18 "total nr of men in hh >=18 yrs"
lab var hhsize_women18 "total nr of women in hh >=18 yrs"
lab var hhsize_children "total nr of children in hh <18 yrs"
lab var hhsize_total "total nr of hh members"
lab var pip_approach "Did you ever hear about the PIP approach?"
lab var pip_improvedecon "The PIP plan has improved the economic situation of my household"
lab var m_valuelife "Do you and your household generally value your life and the things that you do?"
lab var m_stay "Are you (and your household) willing to stay and live here over the coming 10 years?"
lab var m_choice "Do you and your household feel free to make your own choices about the households future (without pressure or force from others)?"
lab var m_samevision "People generally have the same vision, in this village?"
lab var r_inc_subs_crop "Income: crop production for home consumption"
lab var r_inc_subs_livestock "Income: livestock production for home consumption"
lab var r_inc_sale_fieldcrop "Income: production and sales of field crops"
lab var r_inc_sale_cashcrop "Income: prodcution and sales of cash crops"
lab var r_inc_sale_orchard "Income: production and sales of orchard products"
lab var r_inc_sale_livestock "Income: production and sales of livestock and products"
lab var r_inc_sale_prepfood "Income: sales of prepared foods"
lab var r_inc_agrwage "Income: agricultural wage labour"
lab var r_inc_shepherd "Income: shepherding"
lab var r_inc_miller "Income: miller"
lab var r_inc_unskilledday "Income: unskilled day labour"
lab var r_inc_skilled "Income: skilled labour"
lab var r_inc_employee "Income: salary as employee"
lab var r_inc_trade "Income: cross border trade"
lab var r_inc_firewood "Income: firewood"
lab var r_inc_handicrafts "Income: handicrafts (sewing, embroidery, etc)"
lab var r_inc_carpet "Income: carpet weaving"
lab var r_inc_mining "Income: mining"
lab var r_inc_military "Income: military service"
lab var r_inc_taxi "Income: taxi"
lab var r_inc_remitt_out "Income: remittances from outside country"
lab var r_inc_remitt_in "Income: remittances from inside country"
lab var r_inc_pension "Income: pension"
lab var r_inc_govbenefit "Income: other government benefits"
lab var r_inc_rental "Income: rental income"
lab var r_inc_sale_foodaid "Income: sale of food aid"
lab var r_inc_begging "Income: begging"
lab var r_inc_other "Income: other"
lab var r_inc_other_text "Income: other, specify"
foreach x in r_incshare_subs_crop r_incshare_subs_livestock r_incshare_sale_fieldcrop r_incshare_sale_cashcrop r_incshare_sale_orchard r_incshare_sale_livestock r_incshare_sale_prepfood r_incshare_agrwage r_incshare_shepherd r_incshare_miller r_incshare_unskilledday r_incshare_skilled r_incshare_employee r_incshare_trade r_incshare_firewood r_incshare_handicrafts r_incshare_carpet r_incshare_mining r_incshare_military r_incshare_taxi r_incshare_remitt_out r_incshare_remitt_in r_incshare_pension r_incshare_govbenefit r_incshare_rental r_incshare_sale_foodaid r_incshare_begging r_incshare_other r_incshare_other_text{
lab var `x' "Income share % (1= 10%)"
}
foreach x in r_actshare_labor r_actshare_sowing r_actshare_weeding r_actshare_harvesting r_actshare_sorting r_actshare_drying r_actshare_tightening r_actshare_transport{
lab var `x' "Women: % in agricultural activities (1= 10%)"
}
lab var r_actshare_total "Women: total % in agricultural activities (= should be 10)"
lab var r_anncropcult_maize "Annual crops cultivated over last 12 months: Maize/grain"
lab var r_anncropcult_sorghum "Annual crops cultivated over last 12 months: Sorghum"
lab var r_anncropcult_cassava "Annual crops cultivated over last 12 months: Cassava"
lab var r_anncropcult_rice "Annual crops cultivated over last 12 months: Rice"
lab var r_anncropcult_irishpotato "Annual crops cultivated over last 12 months: Irish potato"
lab var r_anncropcult_sweetpotato "Annual crops cultivated over last 12 months: Sweet potato"
lab var r_anncropcult_colocase "Annual crops cultivated over last 12 months: Colocase"
lab var r_anncropcult_eleusine "Annual crops cultivated over last 12 months: Eleusine"
lab var r_anncropcult_beans "Annual crops cultivated over last 12 months: Beans"
lab var r_anncropcult_greenpeas "Annual crops cultivated over last 12 months: Green peas"
lab var r_anncropcult_cajapeas "Annual crops cultivated over last 12 months: Caja peas"
lab var r_anncropcult_cabbage "Annual crops cultivated over last 12 months: Cabbage"
lab var r_anncropcult_amaranth "Annual crops cultivated over last 12 months: Amaranth"
lab var r_anncropcult_carrot "Annual crops cultivated over last 12 months: Carrot"
lab var r_anncropcult_tomato "Annual crops cultivated over last 12 months: Tomato"
lab var r_anncropcult_beet "Annual crops cultivated over last 12 months: Beet"
lab var r_anncropcult_eggplant "Annual crops cultivated over last 12 months: Eggplant"
lab var r_anncropcult_pepper "Annual crops cultivated over last 12 months: Pepper"
lab var r_anncropcult_spinach "Annual crops cultivated over last 12 months: Spinach"
lab var r_anncropcult_cucumber "Annual crops cultivated over last 12 months: Cucumber"
lab var r_anncropcult_yams "Annual crops cultivated over last 12 months: Yams"
lab var r_anncropcult_onions "Annual crops cultivated over last 12 months: Onions"
lab var r_anncropcult_watermelon "Annual crops cultivated over last 12 months: Watermelon"
lab var r_anncropcult_squash "Annual crops cultivated over last 12 months: Squash"
lab var r_anncropcult_other1 "Annual crops cultivated over last 12 months: Other"
lab var r_anncropcult_other1_text "Annual crops cultivated over last 12 months: Other, text"
lab var r_anncropcult_other2 "Annual crops cultivated over last 12 months: Other"
lab var r_anncropcult_other2_text "Annual crops cultivated over last 12 months: Other, text"
lab var r_anncropcult_total "Total nr of annual crops cultivated"
lab var r_anncropsell_maize "Annual crops cultivated to sell: Maize"
lab var r_anncropsell_sorghum "Annual crops cultivated to sell: Sorghum"
lab var r_anncropsell_cassava "Annual crops cultivated to sell: Cassava"
lab var r_anncropsell_rice "Annual crops cultivated to sell: Rice"
lab var r_anncropsell_irishpotato "Annual crops cultivated to sell: Irish potato"
lab var r_anncropsell_sweetpotato "Annual crops cultivated to sell: Sweet potato"
lab var r_anncropsell_colocase "Annual crops cultivated to sell: Colocase"
lab var r_anncropsell_eleusine "Annual crops cultivated to sell: Eleusine"
lab var r_anncropsell_beans "Annual crops cultivated to sell: Beans"
lab var r_anncropsell_greenpeas "Annual crops cultivated to sell: Green peas"
lab var r_anncropsell_cajapeas "Annual crops cultivated to sell: Caja peas"
lab var r_anncropsell_cabbage "Annual crops cultivated to sell: Cabbage"
lab var r_anncropsell_amaranth "Annual crops cultivated to sell: Amaranth"
lab var r_anncropsell_carrot "Annual crops cultivated to sell: Carrot"
lab var r_anncropsell_tomato "Annual crops cultivated to sell: Tomato"
lab var r_anncropsell_beet "Annual crops cultivated to sell: Beet"
lab var r_anncropsell_eggplant "Annual crops cultivated to sell: Eggplant"
lab var r_anncropsell_pepper "Annual crops cultivated to sell: Pepper"
lab var r_anncropsell_spinach "Annual crops cultivated to sell: Spinach"
lab var r_anncropsell_yams "Annual crops cultivated to sell: Yams"
lab var r_anncropsell_onions "Annual crops cultivated to sell: Onions"
lab var r_anncropsell_watermelon "Annual crops cultivated to sell: Watermelon"
lab var r_anncropsell_squash"Annual crops cultivated to sell: Squash"
lab var r_anncropsell_cucumber "Annual crops cultivated to sell: Cucumber"
lab var r_anncropsell_other1 "Annual crops cultivated to sell: Other"
lab var r_anncropsell_other2 "Annual crops cultivated to sell: Other"
lab var r_anncropsell_total "Total nr of annual crops cultivated to sell"
lab var r_percropcult_total "Total nr of perrenial crops cultivated"
lab var r_percropsell_total "Total nr of perrenial crops cultivated to sell"
lab var r_livestock_total "Total nr of livestock (diversity)"
lab var r_livestocksell_total "Total nr of livestock sold"
lab var r_shock_total "Total nr of shocks (= should be 6)"
lab var s_physpract_total "Total nr of applied physical practices" 
lab var s_mngmtpract_total "Total nr of applied management practices"
lab var group "Are you member of a group/association"
lab var nogroup_interest "If not, are you interested in becoming a member of a group/association?"
lab var	fertknow	"To your knowledge, is there any government program or programs that provide access to fertilizer?"
lab var	accessfert	"Do you have access to the PNSEB program?"
lab var	fertwhy_notavailable "Why no access to fertilizer: It is not available in my hill"
lab var	fertwhy_nointerest "Why no access to fertilizer: It does not interest me"
lab var	fertwhy_hatefert "Why no access to fertilizer: I do not like using fertilizer"
lab var	fertwhy_expensive "Why no access to fertilizer: It's too expensive"
lab var	fertwhy_howtojoin "Why no access to fertilizer: I do not know how to access it"
lab var	fertwhy_joincomplicated "Why no access to fertilizer: It's too complicated to access"
lab var	fertwhy_noinfo "Why no access to fertilizer: I did not have enough information"
lab var	fertwhy_other	"Why no access to fertilizer: Other"
lab var	fertwhy_rta "Why no access to fertilizer: Refuse to answer"
lab var	fertlike_distribution "Satisfied with PNSEB: The quality of the distribution (distance, cheating)"
lab var	fertlike_registration  "Satisfied with PNSEB: The record"
lab var	fertlike_advancepay  "Satisfied with PNSEB: Payment of advances and balances"
lab var	fertlike_availability  "Satisfied with PNSEB: The availability of fertilizer on time"
lab var	fertlike_quality  "Satisfied with PNSEB: The quality of the fertilizer provided"
lab var	fertlike_price  "Satisfied with PNSEB: The cost of the fertilizer provided"
lab var	fertlike_ferttypes	 "Satisfied with PNSEB: The type (kind) of fertilizer available"
lab var radio_mboniyongana "Has your household ever listened to the program MBONIYONGANA?"

*********************************************************************
*3: TEXT RESPONSES
*********************************************************************

//r_inc_other_text r_incshare_other_text 
replace r_inc_other_text="Commerce" if strpos(r_inc_other_text, "Commerce") | strpos(r_inc_other_text, "C0mmerce") /*
*/ | strpos(r_inc_other_text, "commerce") | strpos(r_inc_other_text, "commer6") | strpos(r_inc_other_text, "Boutique") /*
*/ | strpos(r_inc_other_text, "Boutiquier") | strpos(r_inc_other_text, "Vente")
replace r_inc_other_text="Pêcheur" if strpos(r_inc_other_text, "Peche") | strpos(r_inc_other_text, "PÃªcheur") /*
*/ | strpos(r_inc_other_text, "PÃªche") | strpos(r_inc_other_text, "peche") | strpos(r_inc_other_text, "pÃªche")

replace r_incshare_other_text="Commerce" if strpos(r_incshare_other_text, "Commerce") | strpos(r_incshare_other_text, "C0mmerce") /*
*/ | strpos(r_incshare_other_text, "commerce") | strpos(r_incshare_other_text, "commer6") | strpos(r_incshare_other_text, "Boutique") /*
*/ | strpos(r_incshare_other_text, "Boutiquier") | strpos(r_incshare_other_text, "Vente") | strpos(r_incshare_other_text, "Commrce") 
replace r_incshare_other_text="Pêcheur" if strpos(r_incshare_other_text, "Peche") | strpos(r_incshare_other_text, "PÃªcheur") /*
*/ | strpos(r_incshare_other_text, "PÃªche") | strpos(r_incshare_other_text, "peche") | strpos(r_incshare_other_text, "pÃªche")

gen r_inc_commerce=0 	//largest 'other' category and cannot be recoded in existing categories
order r_inc_commerce, after(r_inc_begging)
lab var r_inc_commerce "Income: commerce"
lab val r_inc_commerce binary

replace r_inc_employee=1 if strpos(r_inc_other_text, "Salaire non agricole")
replace r_inc_agrwage=1 if strpos(r_inc_other_text, "Agronome communal")
replace r_inc_handicrafts=1 if strpos(r_inc_other_text, "Couture")
replace r_inc_commerce=1 if strpos(r_inc_other_text, "Commerce") | strpos(r_incshare_other_text, "Commerce")

replace r_inc_other=0	if strpos(r_inc_other_text, "Salaire non agricole") | strpos(r_inc_other_text, "Agronome communal") |  strpos(r_inc_other_text, "Couture") | strpos(r_inc_other_text, "Commerce")  | strpos(r_incshare_other_text, "Commerce")

gen r_incshare_commerce=.	//largest 'other' category and cannot be recoded in existing categories
order r_incshare_commerce, after(r_incshare_begging)
lab var r_incshare_commerce "Income share % (1= 10%)"
	
replace r_incshare_agrwage=		r_incshare_other if r_inc_agrwage==1		& strpos(r_inc_other_text, "Agronome communal")
replace r_incshare_employee=	r_incshare_other if r_inc_employee==1 		& strpos(r_inc_other_text, "Salaire non agricole")
replace r_incshare_handicrafts=	r_incshare_other if r_inc_handicrafts==1	& strpos(r_inc_other_text, "Couture")
replace r_incshare_commerce=	r_incshare_other if r_inc_commerce==1 		& strpos(r_inc_other_text, "Commerce") | strpos(r_incshare_other_text, "Commerce")

replace r_incshare_other=0			if strpos(r_inc_other_text, "Salaire non agricole") | strpos(r_inc_other_text, "Agronome communal") |  strpos(r_inc_other_text, "Couture") | strpos(r_inc_other_text, "Commerce")  | strpos(r_incshare_other_text, "Commerce")

replace r_incshare_other_text=""	if strpos(r_inc_other_text, "Salaire non agricole") | strpos(r_inc_other_text, "Agronome communal") |  strpos(r_inc_other_text, "Couture") | strpos(r_inc_other_text, "Commerce")  | strpos(r_incshare_other_text, "Commerce")
replace r_inc_other_text=""			if strpos(r_inc_other_text, "Salaire non agricole") | strpos(r_inc_other_text, "Agronome communal") |  strpos(r_inc_other_text, "Couture") | strpos(r_inc_other_text, "Commerce")  | strpos(r_incshare_other_text, "Commerce")

egen r_incshare_total=rowtotal(r_incshare_subs_crop r_incshare_subs_livestock r_incshare_sale_fieldcrop r_incshare_sale_cashcrop r_incshare_sale_orchard r_incshare_sale_livestock r_incshare_sale_prepfood r_incshare_agrwage r_incshare_shepherd r_incshare_miller r_incshare_unskilledday r_incshare_skilled r_incshare_employee r_incshare_trade r_incshare_firewood r_incshare_handicrafts r_incshare_carpet r_incshare_mining r_incshare_military r_incshare_taxi r_incshare_remitt_out r_incshare_remitt_in r_incshare_pension r_incshare_govbenefit r_incshare_rental r_incshare_sale_foodaid r_incshare_begging r_incshare_commerce r_incshare_other),mi
order r_incshare_total, after(r_incshare_other_text)
lab var r_incshare_total "Total % of income (= should be 10)"

//r_anncropcult_other1_text	r_anncropcult_other2_text 	//peanuts, soja
replace r_anncropcult_maize=1 if strpos(r_anncropcult_other1_text, "Ble") | strpos(r_anncropcult_other1_text, "BlÃ©") | strpos(r_anncropcult_other1_text, "blÃ©")
replace r_anncropcult_other1=0 if strpos(r_anncropcult_other1_text, "Ble") | strpos(r_anncropcult_other1_text, "BlÃ©") | strpos(r_anncropcult_other1_text, "blÃ©")
replace r_anncropcult_other1_text="" if strpos(r_anncropcult_other1_text, "Ble") | strpos(r_anncropcult_other1_text, "BlÃ©") | strpos(r_anncropcult_other1_text, "blÃ©")
replace r_anncropcult_maize=1 if strpos(r_anncropcult_other2_text, "Ble") | strpos(r_anncropcult_other2_text, "BlÃ©") | strpos(r_anncropcult_other2_text, "blÃ©")
replace r_anncropcult_other2=0 if strpos(r_anncropcult_other2_text, "Ble") | strpos(r_anncropcult_other2_text, "BlÃ©") | strpos(r_anncropcult_other2_text, "blÃ©")
replace r_anncropcult_other2_text="" if strpos(r_anncropcult_other2_text, "Ble") | strpos(r_anncropcult_other2_text, "BlÃ©") | strpos(r_anncropcult_other2_text, "blÃ©")
replace r_anncropcult_other1_text="Peanut" if strpos(r_anncropcult_other1_text, "Arachide") | strpos(r_anncropcult_other1_text, "Arachides") | strpos(r_anncropcult_other1_text, "Archides") | strpos(r_anncropcult_other1_text, "arachide")  
replace r_anncropcult_other2_text="Peanut" if strpos(r_anncropcult_other2_text, "Archide")
replace r_anncropcult_other1_text="Soja" if strpos(r_anncropcult_other1_text, "soja")
replace r_anncropcult_other1_text="Sunflower" if strpos(r_anncropcult_other1_text, "Tourne sol") | strpos(r_anncropcult_other1_text, "Tournesol")
replace r_anncropcult_other2_text="Sunflower" if strpos(r_anncropcult_other2_text, "Tourne sol") | strpos(r_anncropcult_other2_text, "Tournesol")

replace r_anncropcult_other1_text="" if strpos(r_anncropcult_other1_text, "Aucun")
replace r_anncropcult_other1=0 if strpos(r_anncropcult_other1_text, "Aucun")

replace r_anncropsell_maize=r_anncropsell_other1 if r_anncropcult_maize==1 & r_anncropsell_other1!=.
replace r_anncropsell_maize=r_anncropsell_other2 if r_anncropsell_maize==. & r_anncropcult_maize==1 & r_anncropsell_other2!=.

//r_percropcult_other1_text r_percropcult_other2_text
replace r_percropcult_other1=0 if strpos(r_percropcult_other1_text, "Rien") | strpos(r_percropcult_other1_text, "Aucun") | strpos(r_percropcult_other1_text, "aucun")
replace r_percropcult_other1_text="" if strpos(r_percropcult_other1_text, "Rien") | strpos(r_percropcult_other1_text, "Aucun") | strpos(r_percropcult_other1_text, "aucun")

replace r_percropcult_other1_text="Tea" if strpos(r_percropcult_other1_text, "The") | strpos(r_percropcult_other1_text, "Le thÃ©") /*
*/ | strpos(r_percropcult_other1_text, "ThÃ©") | strpos(r_percropcult_other1_text, "thÃ©") | strpos(r_percropcult_other1_text, "Threier") /*
*/ | strpos(r_percropcult_other1_text, "theirs")
replace r_percropcult_other1_text="Prune" if strpos(r_percropcult_other1_text, "Prune du japon") | strpos(r_percropcult_other1_text, "Prunier du japon") | strpos(r_percropcult_other1_text, "Prinier") /*
*/ | strpos(r_percropcult_other1_text, "Prunier")
replace r_percropcult_other1_text="Jackfruit" if strpos(r_percropcult_other1_text, "Jacquier") | strpos(r_percropcult_other1_text, "Jakier") | strpos(r_percropcult_other1_text, "jacquier") /*
*/ | strpos(r_percropcult_other1_text, "Jackier") | strpos(r_percropcult_other1_text, "jackier")

replace r_percropcult_other2_text="Tea" if strpos(r_percropcult_other2_text, "Le thÃ©") | strpos(r_percropcult_other2_text, "ThÃ©") | strpos(r_percropcult_other2_text, "Theier")
replace r_percropcult_other2_text="Prune" if strpos(r_percropcult_other2_text, "Prune du japon") | strpos(r_percropcult_other2_text, "Prunier du japon") | strpos(r_percropcult_other2_text, "Prinier")
replace r_percropcult_other2_text="Jackfruit" if strpos(r_percropcult_other2_text, "Jacquier") | strpos(r_percropcult_other2_text, "Jakier") | strpos(r_percropcult_other2_text, "jacquier")

replace r_percropcult_avocado=1 if strpos(r_percropcult_other1_text, "Avocatier") | strpos(r_percropcult_other1_text, "Avocatier") | strpos(r_percropcult_other1_text, "Avacatiers") /*
*/ | strpos(r_percropcult_other2_text, "Avacatiers") | strpos(r_percropcult_other2_text, "Avocagiers")
replace r_percropcult_mango=1 if strpos(r_percropcult_other1_text, "Manguier") | strpos(r_percropcult_other1_text, "Mangier") | strpos(r_percropcult_other1_text, "manguier") | strpos(r_percropcult_other2_text, "Manguier") /*
*/ | strpos(r_percropcult_other1_text, "Mangue") | strpos(r_percropcult_other1_text, "Maguier") | strpos(r_percropcult_other1_text, "Mnguier")
replace r_percropcult_orange=1 if strpos(r_percropcult_other1_text, "Oranger")

replace r_percropcult_other1=0 if strpos(r_percropcult_other1_text, "Avocatier") | strpos(r_percropcult_other1_text, "Avacatiers") | strpos(r_percropcult_other1_text, "Avocagiers")/*
*/ | strpos(r_percropcult_other1_text, "Manguier") | strpos(r_percropcult_other1_text, "Mangier") | strpos(r_percropcult_other1_text, "manguier") | strpos(r_percropcult_other1_text, "Manguier") /*
*/ | strpos(r_percropcult_other1_text, "Maguier") | strpos(r_percropcult_other1_text, "Oranger") | strpos(r_percropcult_other1_text, "Mnguier")
replace r_percropcult_other1_text="" if strpos(r_percropcult_other1_text, "Avocatier") | strpos(r_percropcult_other1_text, "Avacatiers") | strpos(r_percropcult_other1_text, "Avocagiers")/*
*/ | strpos(r_percropcult_other1_text, "Manguier") | strpos(r_percropcult_other1_text, "Mangier") | strpos(r_percropcult_other1_text, "manguier") | strpos(r_percropcult_other1_text, "Manguier") /*
*/ | strpos(r_percropcult_other1_text, "Maguier") | strpos(r_percropcult_other1_text, "Oranger") | strpos(r_percropcult_other1_text, "Mnguier")

replace r_percropcult_other2=0 if strpos(r_percropcult_other2_text, "Avocatier") | strpos(r_percropcult_other2_text, "Manguier") | strpos(r_percropcult_other2_text, "Avacatiers") /*
*/ | strpos(r_percropcult_other2_text, "Mangue")
replace r_percropcult_other2_text="" if strpos(r_percropcult_other2_text, "Avocatier") | strpos(r_percropcult_other2_text, "Manguier") | strpos(r_percropcult_other2_text, "Avacatiers") /*
*/ | strpos(r_percropcult_other2_text, "Mangue")

replace r_percropsell_mango=r_percropsell_other1 if r_percropcult_mango==1 & r_percropsell_other1!=.
replace r_percropsell_avocado=r_percropsell_other1 if r_percropcult_avocado==1 & r_percropsell_other1!=. 
replace r_percropsell_orange=r_percropsell_other1 if r_percropcult_orange==1 & r_percropsell_other1!=.
replace r_percropsell_mango=r_percropsell_other2 if r_percropsell_mango==. & r_percropcult_mango==1 & r_percropsell_other2!=.
replace r_percropsell_avocado=r_percropsell_other2 if r_percropsell_avocado==. & r_percropcult_avocado==1 & r_percropsell_other2!=. 
replace r_percropsell_orange=r_percropsell_other2 if r_percropsell_orange==. & r_percropcult_orange==1 & r_percropsell_other2!=.

//r_livestock_other_text
replace r_livestock_other=0 if strpos(r_livestock_other_text, "Aucun")
replace r_livestock_guineapigs=1 if strpos(r_livestock_other_text, "Cabaye") | strpos(r_livestock_other_text, "Cobail") /*
*/ | strpos(r_livestock_other_text, "Cobaille") | strpos(r_livestock_other_text, "Cobailles") | strpos(r_livestock_other_text, "Cobaye") /*
*/ | strpos(r_livestock_other_text, "Cobayes") | strpos(r_livestock_other_text, "Pigeau")
replace r_livestock_poultry=1 if strpos(r_livestock_other_text, "Poules")
replace r_livestock_other=0 if strpos(r_livestock_other_text, "Cabaye") | strpos(r_livestock_other_text, "Cobail") /*
*/ | strpos(r_livestock_other_text, "Cobaille") | strpos(r_livestock_other_text, "Cobailles") | strpos(r_livestock_other_text, "Cobaye") /*
*/ | strpos(r_livestock_other_text, "Cobayes") | strpos(r_livestock_other_text, "Pigeau") | strpos(r_livestock_other_text, "Poules")
replace r_livestock_other_text="" if strpos(r_livestock_other_text, "Cabaye") | strpos(r_livestock_other_text, "Cobail") /*
*/ | strpos(r_livestock_other_text, "Cobaille") | strpos(r_livestock_other_text, "Cobailles") | strpos(r_livestock_other_text, "Cobaye") /*
*/ | strpos(r_livestock_other_text, "Cobayes") | strpos(r_livestock_other_text, "Pigeau") | strpos(r_livestock_other_text, "Poules")

replace r_livestocksell_guineapigs=r_livestocksell_other if r_livestock_guineapigs==1
replace r_livestocksell_poultry=r_livestocksell_other if r_livestock_poultry==1

//s_nofert_other_text
replace s_nofert_other_text="Soil degradation" if strpos(s_nofert_other_text, "Degrade") | strpos(s_nofert_other_text, "DÃ©gradation") /*
*/ | strpos(s_nofert_other_text, "dÃ©tÃ©riore") | strpos(s_nofert_other_text, "dÃ©grade") | strpos(s_nofert_other_text, "dÃ©truit") /*
*/ | strpos(s_nofert_other_text, "denature")
replace s_nofert_expensive=1 if strpos(s_nofert_other_text, "d'argent") | strpos(s_nofert_other_text, "Manque de moyen") /*
*/ | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "argent")
replace s_nofert_other=0 if strpos(s_nofert_other_text, "d'argent") | strpos(s_nofert_other_text, "Manque de moyen") /*
*/ | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "argent")
replace s_nofert_other_text="" if strpos(s_nofert_other_text, "d'argent") | strpos(s_nofert_other_text, "Manque de moyen") /*
*/ | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "Manque de moyens") | strpos(s_nofert_other_text, "argent")
replace s_nofert_dontneed=1 if strpos(s_nofert_other_text, "Fumure organique suffit") | strpos(s_nofert_other_text, "Le sol est fertile") 
replace s_nofert_other=0 if strpos(s_nofert_other_text, "Fumure organique suffit") | strpos(s_nofert_other_text, "Le sol est fertile") 
replace s_nofert_other_text="" if strpos(s_nofert_other_text, "Fumure organique suffit") | strpos(s_nofert_other_text, "Le sol est fertile") 

*********************************************************************
*3: LABELING 2 (VALUE LABELS)
*********************************************************************	

//77= Not applicable
//88= Don't know
//99= Refuse to answer
//111= Skip-logic, so question was not presented to respondent

//province commune colline
label list Q2_3_1
label list Q2_3_2
label list Q2_3_3
replace commune=19 if colline==22
replace province=1 if colline==22

//pip generation
gen pip_generation_clean=pip_generation
lab var pip_generation_clean "PIP farmer generation: clean"
lab val pip_generation_clean Q2_4
order pip_generation_clean, after(pip_generation)

tab pip_generation colline, mi
replace pip_generation_clean=4 if pip_generation==5 & colline==3		//only generation 4 in #3
replace pip_approach=. if pip_approach==1 & pip_generation_clean==4		//skip-logic
replace pip_generation_clean=4 if pip_generation==. & colline==13		//only generation 4 in #13
replace pip_generation_clean=2 if pip_generation==4 & colline==17		//only generation 2 in #17
replace pip_generation_clean=5 if pip_generation==. & colline==22		//only comparison in #22
replace pip_generation_clean=3 if pip_generation==4 & colline==31		//both generation 1 and 3 in #31, but recode based on training year
replace pip_generation_clean=5 if pip_generation==. & colline==36		//only comparison in #36
replace pip_generation_clean=5 if pip_generation==. & colline==39		//only comparison in #39
replace pip_generation_clean=. if pip_generation==5 & colline==43		//only geneartion 2 and 3 in #43, but respondents says have never heard of PIP
replace pip_generation_clean=. if pip_generation==1 & colline==43		//only geneartion 2 and 3 in #43, but respondents doesn't give consent
replace pip_generation_clean=2 if pip_generation==4 & colline==50		//only comparison in #50
replace pip_generation_clean=5 if pip_generation==. & colline==55		//only comparison in #55
replace pip_generation_clean=5 if pip_generation==. & colline==89		//only comparison in #89
replace pip_generation_clean=5 if pip_generation==. & colline==92		//only comparison in #92
replace pip_generation_clean=5 if pip_generation==4 & colline==92		//only comparison in #92
tab pip_generation_clean colline, mi

//administrative
lab def province 1 "Bujumbura" 2 "Cibitoke" 3 "Makamba" 4 "Muyinga" 5 "Rumonge"
	recode province (1=1) (24=2) (41=3)  (57=4) (73=5)
	lab val province province
lab def commune 1 "Kanyosha" 2 "Mubimbi" 3 "Nyabiraba" 4 "Mugongomanga" 5 "Mabayi" 6 "Rugombo" 7 "Bukinanyana" 8 "Buganda" /*
	*/ 9 "Makamba" 10 "Nyanza-Lac" 11 "Mabanda" 12 "Muyinga" 13 "Mwakiro" 14 "Buhinyuza" 15 "Burambi" 16 "Rumonge" /*
	*/ 17 "Buyengero" 18 "Muhuta"
	recode commune (2=1) (7=2) (12=3) (19=4) (25=5) (30=6) (35=7) (38=8) (42=9) (47=10) (54=11) /*
	*/ (58=12) (63=13) (70=14) (74=15) (81=16) (88=17) (91=18)
	lab val commune commune
lab def colline 1 "MUSUGI" 2 "RUVUMU" 3 "GISAGARA" 4 "KIZIBA" 5 "BUBAJI" 6 "KIZUNGA" 7 "NYABIRABA" 8 "Gisarwe" /*
	*/ 9 "Mwura" 10 "BUHORO" 11 "GITUKURA" 12 "KAGAZI" 13 "Rugeregere" 14 "Kibaya" 15 "Kansega" 16 "CANDA" /*
	*/ 17 "Nyankara" 18 "BINIGANYI" 19 "MUGUMURE" 20 "Mukubano" 21 "Kibago" 22 "Gatongati 1" 23 "Murama" /*
	*/ 24 "Gahekenya" 25 "Gahemba" 26 "RUKANYA" 27 "Butihinda" 28 "Buhinyuza" 29 "GATOBO" 30 "RWANIRO" /*
	*/ 31 "GATETE" 32 "Muhanda" 33 "MURAMBI" 34 "Karambi" 35 "Gitaza"
	recode colline (3=1) (5=2) (8=3) (10=4) (13=5) (15=6) (17=7) (20=8) (22=9) (26=10) (28=11)
	recode colline (31=12) (33=13) (36=14) (39=15) (43=16) (45=17) (48=18) (50=19) (52=20) (55=21) (59=22) (61=23)
	recode colline (64=24) (66=25) (68=26) (71=27) (75=28) (77=29) (79=30) (82=31) (84=32) (86=33) (89=34) (92=35)
	lab val colline colline
	
//all other labels
lab def binary_idk 0 "No" 1 "Yes" 88 "Not sure/doesn't know"
	recode s_water_change s_veg_change (6=0) (4=1) (5=88)
	recode s_landquality_change (18=0) (16=1) (17=88)
	lab val s_water_change s_veg_change s_landquality_change binary_idk
lab def binary_rta 0 "No" 1 "Yes" 99 "Refuse to answer"
	recode accessfert_pnseb (2=0) (3=99)
	lab val accessfert_pnseb binary_rta
lab def binary 0 "No" 1 "Yes"
	foreach x in r_inc_subs_crop r_inc_subs_livestock r_inc_sale_fieldcrop r_inc_sale_cashcrop r_inc_sale_orchard r_inc_sale_livestock r_inc_sale_prepfood r_inc_agrwage r_inc_shepherd r_inc_miller r_inc_unskilledday r_inc_skilled r_inc_employee r_inc_trade r_inc_firewood r_inc_handicrafts r_inc_carpet r_inc_mining r_inc_military r_inc_taxi r_inc_remitt_out r_inc_remitt_in r_inc_pension r_inc_govbenefit r_inc_rental r_inc_sale_foodaid r_inc_begging r_inc_other /*
	*/ r_anncropcult_maize r_anncropcult_sorghum r_anncropcult_cassava r_anncropcult_rice r_anncropcult_irishpotato r_anncropcult_sweetpotato r_anncropcult_colocase r_anncropcult_eleusine r_anncropcult_beans r_anncropcult_greenpeas r_anncropcult_cajapeas r_anncropcult_cabbage r_anncropcult_amaranth r_anncropcult_carrot r_anncropcult_tomato r_anncropcult_beet r_anncropcult_eggplant r_anncropcult_pepper r_anncropcult_spinach r_anncropcult_cucumber r_anncropcult_yams r_anncropcult_onions r_anncropcult_watermelon r_anncropcult_squash r_anncropcult_other1 r_anncropcult_other2 /*
	*/ r_percropcult_palmoil r_percropcult_bananas r_percropcult_mango r_percropcult_avocado r_percropcult_papaya r_percropcult_guava r_percropcult_lemon r_percropcult_orange r_percropcult_coffee r_percropcult_other1 r_percropcult_other2 /*
	*/ s_physpract_contourlines s_physpract_conttrack s_physpract_stonebunds s_physpract_gullycontrol /*
	*/ s_mngmtpract_ploughing s_mngmtpract_staggering s_mngmtpract_mulching s_mngmtpract_covercrops /*
	*/ s_soilpract_compost s_soilpract_manure s_soilpract_chemfert s_soilpract_compost_chemfert s_soilpract_manure_chemfert {
	replace `x'=0 if `x'!=1
	lab val `x' binary
	}
	foreach x in maize sorghum cassava rice irishpotato sweetpotato colocase eleusine beans greenpeas cajapeas cabbage amaranth carrot tomato beet eggplant pepper spinach cucumber yams onions watermelon squash other1 {
	replace r_anncropsell_`x'=0 if r_anncropsell_`x'==. & r_anncropcult_`x'==1
	lab val r_anncropsell_`x' binary
	replace r_anncropsell_`x'=111 if r_anncropsell_`x'==. & r_anncropcult_`x'==0
	}
	foreach x in palmoil bananas mango avocado papaya guava lemon orange coffee other1 other2 {
	replace r_percropsell_`x'=0 if r_percropsell_`x'==. & r_percropcult_`x'==1
	lab val r_percropsell_`x' binary
	replace r_percropsell_`x'=111 if r_percropsell_`x'==. & r_percropcult_`x'==0
	}
	recode r_own_livestock (43=0) (42=1)
	foreach x in cattle goats sheep pigs chicken guineapigs rabbits ducks poultry other {
	replace r_livestock_`x'=0 if r_livestock_`x'!=1 & r_own_livestock==1
	replace r_livestocksell_`x'=0 if r_livestocksell_`x'==. & r_livestock_`x'==1
	lab val r_livestock_`x' r_livestocksell_`x' binary
	replace r_livestocksell_`x'=111 if r_livestocksell_`x'==. & r_livestock_`x'==0
	}
	foreach x in fertwhy_notavailable fertwhy_nointerest fertwhy_hatefert fertwhy_expensive fertwhy_howtojoin fertwhy_joincomplicated fertwhy_noinfo fertwhy_other fertwhy_rta{
	replace `x'=0 if `x'!=1 & accessfert_pnseb==0
	lab val `x' binary
	}
	foreach x in subs_crop subs_livestock sale_fieldcrop sale_cashcrop sale_orchard sale_livestock sale_prepfood agrwage shepherd miller unskilledday skilled employee trade firewood handicrafts carpet mining military taxi remitt_out remitt_in pension govbenefit rental sale_foodaid begging other {
	replace r_incshare_`x'=0 if r_incshare_`x'==. & r_inc_`x'==1
	//share so no binary
	}
	foreach x in r_actshare_labor r_actshare_sowing r_actshare_weeding r_actshare_harvesting r_actshare_sorting r_actshare_drying r_actshare_tightening r_actshare_transport r_actshare_total {
	replace `x'=0 if `x'==. & gender==2
	//share so no binary
	}
	foreach x in s_nofert_expensive s_nofert_notavail s_nofert_dontneed s_nofert_other {
	replace `x'=0 if `x'==. & s_soilpract_compost==1 | `x'==. & s_soilpract_manure==1
	lab val `x' binary
	}
	recode consent (2=0)
	recode pip_have (53=0) (52=1)
	recode group (35=1) (36=0)
	recode nogroup_interest (17=0) (68=1)
	recode s_chemfert_buygroup (27=0) (26=1)
	recode pip_training (2=0)
	recode pip_approach (2=0)
	lab val consent pip_have pip_training pip_approach group nogroup_interest s_chemfert_buygroup r_own_livestock binary
lab def head_type 1 "Dual headed" 2 "Female headed" 3 "Male headed"
	recode head_type (52=1) (53=2) (54=3)
	lab val head_type head_type
lab def educ 1 "None" 2 "Ecolde d'alphabetisation" 3 "Ecole primaire" 4 "College Lycee general" 5 "College Lycee technique" /*
	*/ 6 "Enseignants du primaire" 7 "Premier cycle universitaire" 8 "Enseignantsecondaire" 9 "Deuxieme cycle universitaire" 10 "Troiseme cycle universitaire"
	recode educ educ_head (10=2) (2=3) (3=4) (4=5) (5=6) (6=7) (7=8) (8=9) (9=10)
	lab val educ educ_head educ
lab def agree 1 "Strongly disagree" 2 "Disagree" 3 "Somewhat disagree" 4 "Neither agree/disagree" 5 "Somewhat agree" 6 "Agree" 7 "Strongly agree"
	recode m_samevision (10=1) (9=2) (8=3) (7=4) (6=5) (5=6) (4=7)
	recode s_trees_whyhow (194=1) (193=2) (192=3) (191=4) (190=5) (189=6) (188=7)
	recode pip_improvedecon (15=1) (14=3) (13=4) (12=5) (11=7)
	lab val m_samevision s_trees_whyhow pip_improvedecon agree	
lab def aware 1 "Not aware" 2 "More or less aware" 3 "Aware" 4 "Very well aware"
	recode s_landquality_changewhy (78=1) (77=2) (76=3) (75=4)
	recode s_veg_changewhy (7=1) (6=2) (5=3) (4=4)
	lab val s_landquality_changewhy s_veg_changewhy aware
lab def aware2 1 "Not at all aware" 2 "Not aware" 3 "More or less aware" 4 "Aware" 5 "Very well aware"
	recode s_water_changewhy s_mngmtpract_whyhow s_soilpract_whyhow s_croprotation_why /*
	*/ s_mixintercrop_why s_croplivestock_intgr s_livestock_plans (8=1) (7=2) (6=3) (5=4) (4=5)
	recode s_physpract_whyhow (136=1) (135=2) (134=3) (133=4) (132=5)
	recode s_treesbush_importance (48=1) (47=2) (46=3) (45=4) (44=5)
	lab val s_water_changewhy s_physpract_whyhow s_mngmtpract_whyhow s_soilpract_whyhow /*
	*/ s_croprotation_why s_mixintercrop_why s_croplivestock_intgr s_livestock_plans s_treesbush_importance aware2	
lab def ofcourse 1 "Not at all, never" 2 "Not really, a lot of doubts" 3 "Neutral, sometimes" 4 "Yes, mostly" 5 "Of course, no doubts"
	//no recoding needed
	lab val m_valuelife m_proudlife m_stay m_choice m_desires m_improve m_easy m_incharge m_manageresp m_learnimprove /*
	*/ m_improveproud m_understandplanning m_understandplanning2 m_accesslabour m_enoughmoney m_feelvalued m_trust /*
	*/ m_lendmoney ofcourse
	lab def worsebetter 1 "Much worse" 2 "Worse" 3 "Same" 4 "Better" 5 "Much better"
	recode m_condition (5=1) (1=5) (2=4) (4=2)
	lab val m_condition worsebetter
lab def concrete 1 "Not concrete" 2 "Hardly concrete" 3 "Somewhat concrete" 4 "Very concrete"
	recode m_plans m_actionstaken (1=4) (4=1) (2=3) (3=2)
	lab val m_plans m_actionstaken concrete
lab def always 1 "Never" 2 "Sometimes" 3 "Most of the time" 4 "Always"
	recode m_changes_askothers (19=4) (20=3) (22=2) (23=1)
	recode m_shareknowledge m_problems_askothers (16=1) (14=2) (13=3) (12=4)
	lab val m_changes_askothers m_shareknowledge m_problems_askothers always
lab def conflict 1 "Often" 2 "Quite a lot, most of the time" 3 "Neutral, sometimes" 4 "Rarely, very small" 5 "Not at all, never"
	recode m_conflicts_hh (35=5) (34=3) (32=2) (31=1)
	recode m_conflicts_hhvillage (27=1) (28=2) (29=3) (30=4) (31=5)
	recode m_conflicts_villvill (1=5) (5=2) (6=1) 
	lab val m_conflicts_hh m_conflicts_hhvillage m_conflicts_villvill conflict
lab def conflict_inv 5 "Often" 4 "Quite a lot, most of the time" 3 "Neutral, sometimes" 2 "Rarely, very small" 1 "Not at all, never"
	recode m_conflicts_solved (4=5) (5=4) (6=3) (7=2) (8=1)
	lab val m_conflicts_solved conflict_inv
lab def good 1 "Very bad" 2 "Bad" 3 "Neutral" 4 "Good" 5 "Very good"
	recode m_collaborate (32=5) (33=4) (34=3) (35=2) (36=1)
	lab val m_collaborate good
lab def m_whoplanning 4 "Whole household" 3 "Husband and wife jointly" 2 "Husband only" 1 "Wife only"
	recode m_whoplanning (51=4) (52=3) (53=2) (54=1)
	lab val m_whoplanning m_whoplanning
lab def higher 1 "Much lower" 2 "Lower" 3 "The same" 4 "Higher" 5 "Much higher"
	recode r_inc_change_agrlivestock r_inc_change_other (28=1) (27=2) (26=3) (25=4) (24=5)
	lab val r_inc_change_agrlivestock r_inc_change_other higher
lab def r_finance_vsla 1 "I don't know these services" 2 "I do know these services but I don't use them" 3 "Less than every 3 months" /*
	*/ 4 "Every 3 months" 5 "Every 2 months" 6 "Once a month or more"
	recode r_finance_vsla (557=1) (556=2) (555=3) (554=4) (553=5) (552=6)
	lab val r_finance_vsla r_finance_vsla
lab def r_finance_enough 1 "No, not enough" 2 "Yes, but very little" 3 "Yes, partly enough" 4 "Yes, support was enough"
	recode r_finance_enough (14=1) (13=2) (12=3) (11=4)
	lab val r_finance_enough r_finance_enough
lab def change 1 "Much less" 2 "Slighly less" 3 "About the same" 4 "Slighly more" 5 "Much more"
	recode r_anncrop_change (90=1) (89=2) (88=3) (87=4) (86=5)
	recode r_percropcult_change (43=1) (42=2) (41=3) (40=4) (39=5)
	recode r_cropsell_change (203=1) (202=2) (201=3) (200=4) (199=5)
	lab val r_anncrop_change r_percropcult_change r_cropsell_change change
lab def r_livestock_health 5 "Not at all" 4 "Hardly" 3 "Not so serious" 2 "Some of them" 1 "Yes, a lot"
	recode r_livestock_health (43=5) (42=4) (41=3) (40=2) (39=1)
	lab val r_livestock_health r_livestock_health
lab def yesalways 1 "Not at all" 2 "Not really" 3 "More or less" 4 "Mostly yes" 5 "Yes, always"
	recode r_skills_access (53=1) (52=2) (51=3) (50=4) (49=5)
	recode r_skills_problem (8=1) (7=2) (6=3) (5=4) (4=5)
	lab val r_skills_access r_skills_problem yesalways
lab def yesalways2 1 "No" 2 "Hardly" 3 "Mostly" 4 "Yes, always" 77 "Not applicable"
	recode r_livestock_health_medical (29=77) (28=1) (27=2) (26=3) (25=4)
	recode r_livestock_producefeed (7=1) (6=2) (5=3) (4=4) (8=77)
	lab val r_livestock_health_medical r_livestock_producefeed yesalways2
lab def yes2 1 "Barely, not" 2 "More or less" 3 "Yes, mostly" 4 "Yes" 77 "Not applicable"
	recode r_livestock_fodder (78=77) (77=1) (76=2) (75=3) (74=4)
	lab val r_livestock_fodder yes2 
lab def food 1 "Not enough" 2 "Just manage" 3 "Enough"
	recode r_food1 r_food2 r_food3 r_food4 r_food5 r_food6 r_food7 r_food8 r_food9 r_food10 r_food11 r_food12 (45=1) (46=2) (47=3) (56=.) (55=.) (54=.)
	lab val r_food1 r_food2 r_food3 r_food4 r_food5 r_food6 r_food7 r_food8 r_food9 r_food10 r_food11 r_food12 food
	egen r_food_mean=rowmean(r_food1 r_food2 r_food3 r_food4 r_food5 r_food6 r_food7 r_food8 r_food9 r_food10 r_food11 r_food12)
	lab val r_food_mean food
	order r_food_mean, after(r_food12)
	lab var r_food_mean "Mean of food situation over past 12 months"	
lab def goodbad 1 "Very bad" 2 "Rather bad" 3 "More or less" 4 "Good" 5 "Very good"
	recode r_hh_health (16=1) (15=2) (14=3) (12=4) (11=5)
	lab val r_hh_health goodbad
lab def understanding 1 "No understanding" 2 "Hardly any understanding" 3 "Moderate understanding" 4 "Good understanding" 5 "Very good understanding"
	recode r_intgr_farm_mngmt (44=1) (43=2) (42=3) (41=4) (40=5)
	lab val r_intgr_farm_mngmt understanding
lab def organised 1 "Not at all organised" 2 "Not good organised" 3 "Rather well organised" 4 "Good organised" 5 "Very good organised"
	recode r_planningtasks (46=1) (45=2) (44=3) (43=4) (42=5)
	recode r_decic_farminput r_decic_croptype (8=1) (7=2) (6=3) (5=4) (4=5)
	lab val r_planningtasks r_decic_farminput r_decic_croptype organised
lab def impact 1 "Very severe impact" 2 "Quite severe impact" 3 "Moderate impact" 4 "Barely any impact" 5 "No impact" 
	recode r_shock_severity (58=5) (57=4) (56=3) (55=2) (54=1)
	lab val r_shock_severity impact
lab def prepared 1 "Unprepared" 2 "Barely prepared" 3 "Neutral" 4 "Just about prepared" 5 "Better prepared"
	recode r_shock_changecope (63=1) (62=2) (61=3) (60=4) (59=5)
	lab val r_shock_changecope prepared
lab def able 1 "Not at all able" 2 "Not well able" 3 "More or less" 4 "Able" 5 "Very well able"
	recode r_shock_abilitycope (47=1) (46=2) (45=4) (44=4) (43=5)
	lab val r_shock_abilitycope able
lab def absolutely 1 "Not at all" 2 "Barely" 3 "More or less" 4 "Yes, mostly" 5 "Yes, absolutely"
	recode r_assets_managehh (8=1) (7=2) (6=3) (5=4) (4=5)
	recode r_assets_managefarm (35=1) (34=2) (33=3) (32=4) (31=5)
	lab val r_assets_managehh r_assets_managefarm absolutely
lab def shock 0 "Shock not mentioned" 1 "Main shock" 2 "2nd shock" 3 "3rd shock"
	lab val r_shock_illness r_shock_death r_shock_injury r_shock_jobloss r_shock_wagecut r_shock_cropfailure r_shock_noremitt r_shock_drought r_shock_flood r_shock_naturalhazard r_shock_theft r_shock_suddenexpenses shock
lab def clear 1 "Not at all clear" 2 "Not so clear" 3 "More or less clear" 4 "Clear" 5 "Very clear"
	recode s_nature_importance (8=1) (7=2) (6=3) (5=4) (4=5)
	recode s_natresc_protect (108=1) (107=2) (106=3) (105=4) (104=5)
	lab val s_nature_importance s_natresc_protect clear
lab def important 1 "Not at all important" 2 "Moderately important" 3 "Very important"
	recode s_natresc_protectimp (12=3) (13=2) (15=1)
	lab val s_natresc_protectimp important
lab def increase 1 "Decreased a lot" 2 "Decreased a bit" 3 "Remained the same" 4 "Increased a bit" 5 "Increased a lot"
	recode s_trees_change (98=1) (97=2) (96=3) (95=4) (94=5)
	lab val s_trees_change increase
lab def conserve 1 "Not good, exploiting" 2 "Not so well" 3 "Quite well" 4 "Very well, conserving" 77 "Not applicable / doesn't use" 
	recode s_water_howconserve s_commonlands_howconserve (9=77) (8=1) (7=2) (5=3) (4=4)
	recode s_treesbush_howuse s_water_sourceimp s_commonlands_howuse (6=77) (5=1) (4=2) (3=3) (1=4)
	lab val s_treesbush_howuse s_water_howconserve s_water_sourceimp s_commonlands_howuse s_commonlands_howconserve conserve
lab def satisfied 1 "Not at all satisfied" 2 "Not satisfied" 3 "Satisfied" 4 "Very satisfied" 99 "Refuse to answer"
	recode fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes (5=99) (4=1) (3=2) (2=3) (1=4)
	lab val fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes satisfied
lab def radio 1 "Yes I know this radio show and have listened" 2 "I know this radio show but never listened" 3 "I don't know this radio show"
	recode radio_mboniyongana (1=1) (9=2) (8=3)
	lab val radio_mboniyongana radio
lab def pnseb 1 "No" 2 "Yes, other" 3 "Yes, but don't know name" 4 "Yes, PNSEB" 88 "Don't know" 99 "Refuse to answer"
	recode fertknow (6=99) (5=88) (4=1) (3=2) (2=3) (1=4)
	lab val fertknow pnseb
lab def s_croprotation 1 "Not at all" 2 "For a single plot only" 3 "Yes for some plots" 4 "Yes for most plots" 5 "Yes for all plots"
	recode s_croprotation (5=1) (4=2) (3=3) (2=4) (1=5)
	lab val s_croprotation s_croprotation
gen female=gender
	order female, after(gender)
	recode female (1=0) (2=1)
	lab val female binary
	lab var female "Respondent is female"

*********************************************************************
*5: RENAMING TO ADD SUBCONSTRUCTS+INDICATORS
*********************************************************************

rename	m_valuelife				m_pur_cur_valuelife
rename	m_proudlife				m_pur_cur_proudlife
rename	m_stay					m_pur_fut_stay
rename	m_condition				m_pur_fut_condition
rename	m_plans					m_pur_con_plans
rename	m_actionstaken			m_pur_con_actionstaken
rename	m_choice				m_aut_free_choice
rename	m_desires				m_aut_free_desires
rename	m_improve				m_aut_self_improve
rename	m_easy					m_aut_self_easy
rename	m_incharge				m_aut_mas_incharge
rename	m_manageresp			m_aut_mas_manageresp
rename	m_learnimprove			m_att_eag_learnimprove
rename	m_changes_askothers		m_att_eag_askothers
rename	m_shareknowledge		m_att_open_shareknow
rename	m_problems_askothers	m_att_open_askothers
rename	m_newpractices			m_att_drive_newpractices
rename	m_improveproud			m_att_drive_improveproud
rename	m_collaborate			m_hhsup_coll_collaborate
rename	m_whoplanning			m_hhsup_coll_whoplan
rename	m_understandplanning	m_hhsup_mut_undplan
rename	m_conflicts_hh			m_hhsup_mut_confl_hh
rename	m_accesslabour			m_hhsup_avail_accesslabour
rename	m_enoughmoney			m_hhsup_avail_enoughmoney
rename	m_feelvalued			m_vilsup_soc_feelvalued
rename	m_conflicts_hhvillage	m_vilsup_soc_confl_hhvill
rename	m_trust					m_vilsup_trust_trust
rename	m_lendmoney				m_vilsup_trust_lendmoney
rename	m_conflicts_villvill	m_vilsup_coll_confl_villvill
rename	m_conflicts_solved		m_vilsup_coll_confl_solved
rename	m_samevision			m_vilsup_coll_samevision

rename	r_inc_subs_crop			r_inc_farm_subscrop
rename	r_inc_subs_livestock	r_inc_farm_subslivestock
rename	r_inc_sale_fieldcrop	r_inc_farm_salefieldcrop
rename	r_inc_sale_cashcrop		r_inc_farm_salecashcrop
rename	r_inc_sale_orchard		r_inc_farm_saleorchard
rename	r_inc_sale_livestock	r_inc_farm_salelivestock
rename	r_inc_sale_prepfood		r_inc_farm_saleprepfood
rename	r_inc_agrwage			r_inc_farm_agrwage
rename	r_inc_shepherd			r_inc_farm_shepherd
rename	r_inc_miller			r_inc_farm_miller
rename	r_inc_unskilledday		r_inc_farm_unskilledday
rename	r_inc_skilled			r_inc_farm_skilled
rename	r_inc_employee			r_inc_farm_employee
rename	r_inc_trade				r_inc_farm_trade
rename	r_inc_firewood			r_inc_farm_firewood
rename	r_inc_handicrafts		r_inc_farm_handicrafts
rename	r_inc_carpet			r_inc_farm_carpet
rename	r_inc_mining			r_inc_farm_mining
rename	r_inc_military			r_inc_farm_military
rename	r_inc_taxi				r_inc_farm_taxi
rename	r_inc_remitt_out		r_inc_farm_remitt_out
rename	r_inc_remitt_in			r_inc_farm_remitt_in
rename	r_inc_pension			r_inc_farm_pension
rename	r_inc_govbenefit		r_inc_farm_govbenefit
rename	r_inc_rental			r_inc_farm_rental
rename	r_inc_sale_foodaid		r_inc_farm_foodaid
rename	r_inc_begging			r_inc_farm_begging
rename	r_inc_commerce			r_inc_farm_commerce
rename	r_inc_other				r_inc_farm_other
rename	r_inc_other_text		r_inc_farm_other_text
rename	r_incshare_subs_crop		r_inc_farm_sh_subscrop
rename	r_incshare_subs_livestock	r_inc_farm_sh_subslivestock
rename	r_incshare_sale_fieldcrop	r_inc_farm_sh_salefieldcrop
rename	r_incshare_sale_cashcrop	r_inc_farm_sh_salecashcrop
rename	r_incshare_sale_orchard		r_inc_farm_sh_saleorchard
rename	r_incshare_sale_livestock	r_inc_farm_sh_salelivestock
rename	r_incshare_sale_prepfood	r_inc_farm_sh_saleprepfood
rename	r_incshare_agrwage		r_inc_farm_sh_agrwage
rename	r_incshare_shepherd		r_inc_farm_sh_shepherd
rename	r_incshare_miller		r_inc_farm_sh_miller
rename	r_incshare_unskilledday	r_inc_farm_sh_unskilledday
rename	r_incshare_skilled		r_inc_farm_sh_skilled
rename	r_incshare_employee		r_inc_farm_sh_employee
rename	r_incshare_trade		r_inc_farm_sh_trade
rename	r_incshare_firewood		r_inc_farm_sh_firewood
rename	r_incshare_handicrafts	r_inc_farm_sh_handicrafts
rename	r_incshare_carpet		r_inc_farm_sh_carpet
rename	r_incshare_mining		r_inc_farm_sh_mining
rename	r_incshare_military		r_inc_farm_sh_military
rename	r_incshare_taxi			r_inc_farm_sh_taxi
rename	r_incshare_remitt_out	r_inc_farm_sh_remitt_out
rename	r_incshare_remitt_in	r_inc_farm_sh_remitt_in
rename	r_incshare_pension		r_inc_farm_sh_pension
rename	r_incshare_govbenefit	r_inc_farm_sh_govbenefit
rename	r_incshare_rental		r_inc_farm_sh_rental
rename	r_incshare_sale_foodaid	r_inc_farm_sh_foodaid
rename	r_incshare_begging		r_inc_farm_sh_begging
rename	r_incshare_commerce		r_inc_farm_sh_commerce
rename	r_incshare_other		r_inc_farm_sh_other
rename	r_incshare_other_text	r_inc_farm_sh_other_text
rename	r_incshare_total		r_inc_farm_sh_total
rename	r_actshare_labor		r_inc_farm_actsh_labor
rename	r_actshare_sowing		r_inc_farm_actsh_sowing
rename	r_actshare_weeding		r_inc_farm_actsh_weeding
rename	r_actshare_harvesting	r_inc_farm_actsh_harvesting
rename	r_actshare_sorting		r_inc_farm_actsh_sorting
rename	r_actshare_drying		r_inc_farm_actsh_drying
rename	r_actshare_tightening	r_inc_farm_actsh_tightening
rename	r_actshare_transport	r_inc_farm_actsh_transport
rename	r_actshare_total		r_inc_farm_actsh_total
rename	r_inc_change_agrlivestock	r_inc_farm_change_agrlivestock
rename	r_inc_change_other		r_inc_nonfarm_change_other
rename	r_finance_vsla			r_inc_finance_vsla
rename	r_finance_enough		r_inc_finance_enough
rename	r_anncropcult_maize		r_crop_ann_cult_maize
rename	r_anncropcult_sorghum	r_crop_ann_cult_sorghum
rename	r_anncropcult_cassava	r_crop_ann_cult_cassava
rename	r_anncropcult_rice		r_crop_ann_cult_rice
rename	r_anncropcult_irishpotato	r_crop_ann_cult_irishpotato
rename	r_anncropcult_sweetpotato	r_crop_ann_cult_sweetpotato
rename	r_anncropcult_colocase	r_crop_ann_cult_colocase
rename	r_anncropcult_eleusine	r_crop_ann_cult_eleusine
rename	r_anncropcult_beans		r_crop_ann_cult_beans
rename	r_anncropcult_greenpeas	r_crop_ann_cult_greenpeas
rename	r_anncropcult_cajapeas	r_crop_ann_cult_cajapeas
rename	r_anncropcult_cabbage	r_crop_ann_cult_cabbage
rename	r_anncropcult_amaranth	r_crop_ann_cult_amaranth
rename	r_anncropcult_carrot	r_crop_ann_cult_carrot
rename	r_anncropcult_tomato	r_crop_ann_cult_tomato
rename	r_anncropcult_beet		r_crop_ann_cult_beet
rename	r_anncropcult_eggplant	r_crop_ann_cult_eggplant
rename	r_anncropcult_pepper	r_crop_ann_cult_pepper
rename	r_anncropcult_spinach	r_crop_ann_cult_spinach
rename	r_anncropcult_cucumber	r_crop_ann_cult_cucumber
rename	r_anncropcult_yams		r_crop_ann_cult_yams
rename	r_anncropcult_onions	r_crop_ann_cult_onions
rename	r_anncropcult_watermelon	r_crop_ann_cult_watermelon
rename	r_anncropcult_squash	r_crop_ann_cult_squash
rename	r_anncropcult_other1	r_crop_ann_cult_other1
rename	r_anncropcult_other2	r_crop_ann_cult_other2
rename	r_anncropcult_other1_text	r_crop_ann_cult_other1_text
rename	r_anncropcult_total		r_crop_ann_cult_total
rename	r_anncropcult_other2_text	r_crop_ann_cult_other2_text
rename	r_anncropsell_maize		r_crop_ann_sell_maize
rename	r_anncropsell_sorghum	r_crop_ann_sell_sorghum
rename	r_anncropsell_cassava	r_crop_ann_sell_cassava
rename	r_anncropsell_rice		r_crop_ann_sell_rice
rename	r_anncropsell_irishpotato	r_crop_ann_sell_irishpotato
rename	r_anncropsell_sweetpotato	r_crop_ann_sell_sweetpotato
rename	r_anncropsell_colocase	r_crop_ann_sell_colocase
rename	r_anncropsell_eleusine	r_crop_ann_sell_eleusine
rename	r_anncropsell_beans		r_crop_ann_sell_beans
rename	r_anncropsell_greenpeas	r_crop_ann_sell_greenpeas
rename	r_anncropsell_cajapeas	r_crop_ann_sell_cajapeas
rename	r_anncropsell_cabbage	r_crop_ann_sell_cabbage
rename	r_anncropsell_amaranth	r_crop_ann_sell_amaranth
rename	r_anncropsell_carrot	r_crop_ann_sell_carrot
rename	r_anncropsell_tomato	r_crop_ann_sell_tomato
rename	r_anncropsell_beet		r_crop_ann_sell_beet
rename	r_anncropsell_eggplant	r_crop_ann_sell_eggplant
rename	r_anncropsell_pepper	r_crop_ann_sell_pepper
rename	r_anncropsell_spinach	r_crop_ann_sell_spinach
rename	r_anncropsell_cucumber	r_crop_ann_sell_cucumber
rename	r_anncropsell_yams		r_crop_ann_sell_yams
rename	r_anncropsell_onions	r_crop_ann_sell_onions
rename	r_anncropsell_watermelon	r_crop_ann_sell_watermelon
rename	r_anncropsell_squash	r_crop_ann_sell_squash
rename	r_anncropsell_other1	r_crop_ann_sell_other1
rename	r_anncropsell_other2	r_crop_ann_sell_other2
rename	r_anncropsell_total		r_crop_ann_sell_total
rename	r_anncrop_change		r_crop_ann_change
rename	r_percropcult_palmoil	r_crop_per_cult_palmoil
rename	r_percropcult_bananas	r_crop_per_cult_bananas
rename	r_percropcult_mango		r_crop_per_cult_mango
rename	r_percropcult_avocado	r_crop_per_cult_avocado
rename	r_percropcult_papaya	r_crop_per_cult_papaya
rename	r_percropcult_guava		r_crop_per_cult_guava
rename	r_percropcult_lemon		r_crop_per_cult_lemon
rename	r_percropcult_orange	r_crop_per_cult_orange
rename	r_percropcult_coffee	r_crop_per_cult_coffee
rename	r_percropcult_other1	r_crop_per_cult_other1
rename	r_percropcult_other2	r_crop_per_cult_other2
rename	r_percropcult_total		r_crop_per_cult_total
rename	r_percropcult_other1_text	r_crop_per_cult_other1_text
rename	r_percropcult_other2_text	r_crop_per_cult_other2_text
rename	r_percropsell_palmoil	r_crop_per_sell_palmoil
rename	r_percropsell_bananas	r_crop_per_sell_bananas
rename	r_percropsell_mango		r_crop_per_sell_mango
rename	r_percropsell_avocado	r_crop_per_sell_avocado
rename	r_percropsell_papaya	r_crop_per_sell_papaya
rename	r_percropsell_guava		r_crop_per_sell_guava
rename	r_percropsell_lemon		r_crop_per_sell_lemon
rename	r_percropsell_orange	r_crop_per_sell_orange
rename	r_percropsell_coffee	r_crop_per_sell_coffee
rename	r_percropsell_other1	r_crop_per_sell_other1
rename	r_percropsell_other2	r_crop_per_sell_other2
rename	r_percropsell_total		r_crop_per_sell_total
rename	r_percropcult_change	r_crop_per_cult_change
rename	r_cropsell_change		r_crop_inc_change
rename	r_own_livestock			r_lvstck_own
rename	r_livestock_cattle		r_lvstck_div_cattle
rename	r_livestock_goats		r_lvstck_div_goats
rename	r_livestock_sheep		r_lvstck_div_sheep
rename	r_livestock_pigs		r_lvstck_div_pigs
rename	r_livestock_chicken		r_lvstck_div_chicken
rename	r_livestock_guineapigs	r_lvstck_div_guineapigs
rename	r_livestock_rabbits		r_lvstck_div_rabbits
rename	r_livestock_ducks		r_lvstck_div_ducks
rename	r_livestock_poultry		r_lvstck_div_poultry
rename	r_livestock_total		r_lvstck_div_total
rename	r_livestock_other		r_lvstck_div_other
rename	r_livestock_other_text	r_lvstck_div_other_text
rename	r_livestocksell_cattle	r_lvstck_div_sell_cattle
rename	r_livestocksell_goats	r_lvstck_div_sell_goats
rename	r_livestocksell_sheep	r_lvstck_div_sell_sheep
rename	r_livestocksell_pigs	r_lvstck_div_sell_pigs
rename	r_livestocksell_chicken	r_lvstck_div_sell_chicken
rename	r_livestocksell_guineapigs	r_lvstck_div_sell_guineapigs
rename	r_livestocksell_rabbits	r_lvstck_div_sell_rabbits
rename	r_livestocksell_ducks	r_lvstck_div_sell_ducks
rename	r_livestocksell_poultry	r_lvstck_div_sell_poultry
rename	r_livestocksell_total	r_lvstck_div_sell_total
rename	r_livestocksell_other	r_lvstck_div_sell_other
rename	r_livestock_health		r_lvstck_health
rename	r_livestock_health_medical	r_lvstck_health_medical
rename	r_livestock_producefeed		r_lvstck_nutr_producefeed
rename	r_livestock_fodder		r_lvstck_nutr_fodder
rename	r_food1					r_res_food_1
rename	r_food2					r_res_food_2
rename	r_food3					r_res_food_3
rename	r_food4					r_res_food_4
rename	r_food5					r_res_food_5
rename	r_food6					r_res_food_6
rename	r_food7					r_res_food_7
rename	r_food8					r_res_food_8
rename	r_food9					r_res_food_9
rename	r_food10				r_res_food_10
rename	r_food11				r_res_food_11
rename	r_food12				r_res_food_12
rename	r_food_mean				r_res_food_mean
rename	r_hh_health				r_res_food_health_hh
rename	r_intgr_farm_mngmt		r_res_skills_farm_mngmt
rename	r_skills_access			r_res_skills_access
rename	r_skills_problem		r_res_skills_problem
rename	r_planningtasks			r_res_org_planningtasks
rename	r_decic_farminput		r_res_org_decic_farminput
rename	r_decic_croptype		r_res_org_decic_croptype
rename	r_shock_illness			r_cop_shock_illness
rename	r_shock_death			r_cop_shock_death
rename	r_shock_injury			r_cop_shock_injury
rename	r_shock_jobloss			r_cop_shock_jobloss
rename	r_shock_wagecut			r_cop_shock_wagecut
rename	r_shock_cropfailure		r_cop_shock_cropfailure
rename	r_shock_noremitt		r_cop_shock_noremitt
rename	r_shock_drought			r_cop_shock_drought
rename	r_shock_flood			r_cop_shock_flood
rename	r_shock_naturalhazard	r_cop_shock_naturalhazard
rename	r_shock_theft			r_cop_shock_theft
rename	r_shock_suddenexpenses	r_cop_shock_suddenexpenses
rename	r_shock_total			r_cop_shock_total
rename	r_shock_severity		r_cop_shock_severity
rename	r_shock_changecope		r_cop_strategy_changecope
rename	r_shock_abilitycope		r_cop_strategy_abilitycope
rename	r_assets_managefarm		r_cop_assets_managefarm
rename	r_assets_managehh		r_cop_assets_managehh

rename	s_landquality_change	s_awa_soilqual_change
rename	s_landquality_changewhy	s_awa_soilqual_changewhy
rename	s_veg_change			s_awa_veg_change
rename	s_veg_changewhy			s_awa_veg_changewhy
rename	s_water_change			s_awa_water_change
rename	s_water_changewhy		s_awa_water_changewhy
rename	s_natresc_protect		s_awa_coll_action
rename	s_natresc_protectimp	s_awa_bio_protectimp
rename	s_nature_importance		s_awa_bio_natureimp_ex
rename	s_physpract_contourlines	s_land_physpract_contourlines
rename	s_physpract_conttrack	s_land_physpract_conttrack
rename	s_physpract_stonebunds	s_land_physpract_stonebunds
rename	s_physpract_gullycontrol	s_land_physpract_gullycontrol
rename	s_physpract_total		s_land_physpract_total
rename	s_physpract_whyhow		s_land_physpract_whyhow
rename	s_trees_change			s_land_agro_change
rename	s_trees_whyhow			s_land_agro_whyhow
rename	s_mngmtpract_ploughing	s_land_mngmtpract_ploughing
rename	s_mngmtpract_staggering	s_land_mngmtpract_staggering
rename	s_mngmtpract_mulching	s_land_mngmtpract_mulching
rename	s_mngmtpract_covercrops	s_land_mngmtpract_covercrops
rename	s_mngmtpract_total		s_land_mngmtpract_total
rename	s_mngmtpract_whyhow		s_land_mngmtpract_whyhow
rename	s_croprotation			s_farm_crop_rotation
rename	s_croprotation_why		s_farm_crop_rotationwhy
rename	s_mixintercrop_why		s_farm_crop_mixwhy
rename	s_soilpract_compost		s_farm_soil_practcompost
rename	s_soilpract_manure		s_farm_soil_practmanure
rename	s_soilpract_chemfert	s_farm_soil_practchemfert
rename	s_soilpract_compost_chemfert	s_farm_soil_practcomp_chem
rename	s_soilpract_manure_chemfert		s_farm_soil_practmanure_chem
rename	s_soilpract_whyhow		s_farm_soil_practwhyhow
rename	s_nofert_expensive		s_farm_soil_nofert_expensive
rename	s_nofert_notavail		s_farm_soil_nofert_notavail
rename	s_nofert_dontneed		s_farm_soil_nofert_dontneed
rename	s_nofert_other			s_farm_soil_nofert_other
rename	s_nofert_other_text		s_farm_soil_nofert_other_text
rename	s_chemfert_buygroup		s_farm_soil_chemfert_buygroup
rename	s_chemfert_buygroup_nr	s_farm_soil_chemfert_buygroup_nr
rename	s_croplivestock_intgr	s_farm_lvstck_intgr
rename	s_treesbush_importance	s_comm_trees_importance
rename	s_livestock_plans		s_farm_lvstck_plans
rename	s_treesbush_howuse		s_comm_trees_howuse
rename	s_water_howconserve		s_comm_water_howconserve
rename	s_water_sourceimp		s_comm_water_sourceimp
rename	s_commonlands_howuse	s_comm_land_howuse
rename	s_commonlands_howconserve	s_comm_land_howconserve

order s_farm_lvstck_plans, after(s_farm_lvstck_intgr)

*********************************************************************
*6: OTHER CLEANING
*********************************************************************

*Drop irrelevant variables
drop m_understandplanning2 //duplicate

*Check some variables
tab gender,mi
replace gender=1 if r_inc_farm_actsh_total==.					//Q only asked to women if income from agriculture (which is the case)
replace female=0 if r_inc_farm_actsh_total==.					//Idem
tab consent,mi
replace consent=1 if consent==. & age!=. & educ!=.				//consent=1 if no missings in rest of variables (because otherwise survey would have been directed to the end)
tab age 														//range 18-89, so seems ok
tab1 hhsize_men18 hhsize_women18 hhsize_children hhsize_total	//range seems ok
tab1 land_hectares land_plots									//range hectares 0-13, range plots 0-32
replace land_plots="" if land_plots=="U"
replace land_plots="0.5" if land_plots=="0,5"
replace land_plots="1.4" if land_plots=="1,4"
replace land_plots="1.5" if land_plots=="1,5"
replace land_plots="2.5" if land_plots=="2,5"
destring land_plots, replace									//Cleaning hectares+plots? What is reliable?
tab s_farm_soil_chemfert_buygroup_nr
recode s_farm_soil_chemfert_buygroup_nr (80=.) 					//outlier

gen dependency=hhsize_children/hhsize_total
lab var dependency "hhsize_children/hhsize_total"
order dependency, after(hhsize_total)

gen pip=.
replace pip=0 if pip_generation_clean==5
replace pip=1 if pip_generation_clean==1 | pip_generation_clean==2 | pip_generation_clean==3 | pip_generation_clean==4
lab var pip "Dummy: PIP or not"
lab val pip binary
order pip, after(pip_generation_clean)

*Shares
foreach x in land_own land_rent land_communal land_total pip_implemented {
gen `x'_pc=`x'/100 if `x'!=111
replace `x'_pc=`x' if `x'==111
order `x'_pc, after(`x')
lab var `x'_pc "`x'/100"
drop `x'
rename `x'_pc `x'
}
lab var land_own "% of land that is owned"
lab var land_rent "% of land that is rented"
lab var land_communal "% of land that is communal"
foreach x in r_inc_farm_sh_subscrop r_inc_farm_sh_subslivestock r_inc_farm_sh_salefieldcrop r_inc_farm_sh_salecashcrop r_inc_farm_sh_saleorchard r_inc_farm_sh_salelivestock r_inc_farm_sh_saleprepfood r_inc_farm_sh_agrwage r_inc_farm_sh_shepherd r_inc_farm_sh_miller r_inc_farm_sh_unskilledday r_inc_farm_sh_skilled r_inc_farm_sh_employee r_inc_farm_sh_trade r_inc_farm_sh_firewood r_inc_farm_sh_handicrafts r_inc_farm_sh_carpet r_inc_farm_sh_mining r_inc_farm_sh_military r_inc_farm_sh_taxi r_inc_farm_sh_remitt_out r_inc_farm_sh_remitt_in r_inc_farm_sh_pension r_inc_farm_sh_govbenefit r_inc_farm_sh_rental r_inc_farm_sh_foodaid r_inc_farm_sh_begging r_inc_farm_sh_commerce r_inc_farm_sh_other r_inc_farm_sh_total {
gen `x'_pc=`x'/10 if `x'!=111
replace `x'_pc=`x' if `x'==111
order `x'_pc, after(`x')
lab var `x'_pc "Income share (/10)"
drop `x'
rename `x'_pc `x'
}
lab var r_inc_farm_sh_other_text "Income share (/10)"
foreach x in r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_actsh_total {
gen `x'_pc=`x'/10 if `x'!=111
replace `x'_pc=`x' if `x'==111
order `x'_pc, after(`x')
lab var `x'_pc "Women: % in agricultural activities (/10)"
drop `x'
rename `x'_pc `x'
}
*

*Create income groups
egen r_inc_farm_totalnr=rowtotal(r_inc_farm_subscrop r_inc_farm_subslivestock r_inc_farm_salefieldcrop r_inc_farm_salecashcrop r_inc_farm_saleorchard r_inc_farm_salelivestock r_inc_farm_saleprepfood r_inc_farm_agrwage r_inc_farm_shepherd r_inc_farm_miller r_inc_farm_unskilledday r_inc_farm_skilled r_inc_farm_employee r_inc_farm_trade r_inc_farm_firewood r_inc_farm_handicrafts r_inc_farm_carpet r_inc_farm_mining r_inc_farm_military r_inc_farm_taxi r_inc_farm_remitt_out r_inc_farm_remitt_in r_inc_farm_pension r_inc_farm_govbenefit r_inc_farm_rental r_inc_farm_foodaid r_inc_farm_begging r_inc_farm_commerce r_inc_farm_other)
lab var r_inc_farm_totalnr "Total nr of income sources"
order r_inc_farm_totalnr, after(r_inc_farm_other_text)

gen r_inc_farm_farm=0
	replace r_inc_farm_farm=1 if r_inc_farm_subscrop==1 | r_inc_farm_subslivestock==1 | /*							//farmer
	*/ r_inc_farm_salefieldcrop==1 | r_inc_farm_salecashcrop==1 | r_inc_farm_saleorchard==1 | /*
	*/ r_inc_farm_salelivestock==1 | r_inc_farm_saleprepfood==1 | r_inc_farm_agrwage==1 | /*
	*/ r_inc_farm_shepherd==1
gen r_inc_farm_stable=0																							//stable income
	replace r_inc_farm_stable=1 if r_inc_farm_skilled==1 | r_inc_farm_employee==1 | r_inc_farm_military==1 | /*
	*/ r_inc_farm_pension==1 | r_inc_farm_rental==1	| r_inc_farm_miller==1 |  r_inc_farm_mining==1
gen r_inc_farm_sme=0																							//sme, commerce
	replace r_inc_farm_sme=1 if r_inc_farm_trade==1 | r_inc_farm_firewood==1 | r_inc_farm_handicrafts==1 | /*
	*/ r_inc_farm_carpet==1 | r_inc_farm_foodaid==1 | r_inc_farm_commerce==1	
gen r_inc_farm_other1=0
	replace r_inc_farm_other1=1 if r_inc_farm_unskilledday==1 | r_inc_farm_taxi==1 | r_inc_farm_remitt_out==1 | /*
	*/ r_inc_farm_remitt_in==1 | r_inc_farm_govbenefit==1 | r_inc_farm_begging==1 | r_inc_farm_other==1
lab val r_inc_farm_farm r_inc_farm_stable r_inc_farm_sme r_inc_farm_other1 binary
lab var r_inc_farm_farm 	"Dummy: income from agriculture"
lab var r_inc_farm_stable 	"Dummy: stable source of income"
lab var r_inc_farm_sme 		"Dummy: income from sme, commerce, trade"
lab var r_inc_farm_other1	"Dummy: income from 'other'"
foreach x in r_inc_farm_other1 r_inc_farm_sme r_inc_farm_stable r_inc_farm_farm  {
order `x', after(r_inc_farm_other_text)
}
* 																					
egen r_inc_farm_sh_farm=rowtotal(r_inc_farm_sh_subscrop r_inc_farm_sh_subslivestock r_inc_farm_sh_salefieldcrop r_inc_farm_sh_salecashcrop r_inc_farm_sh_saleorchard r_inc_farm_sh_salelivestock r_inc_farm_sh_saleprepfood r_inc_farm_sh_agrwage r_inc_farm_sh_shepherd)
egen r_inc_farm_sh_stable=rowtotal(r_inc_farm_sh_miller r_inc_farm_sh_skilled r_inc_farm_sh_employee r_inc_farm_sh_mining r_inc_farm_sh_military r_inc_farm_sh_pension r_inc_farm_sh_rental)
egen r_inc_farm_sh_sme=rowtotal(r_inc_farm_sh_trade r_inc_farm_sh_firewood r_inc_farm_sh_handicrafts r_inc_farm_sh_carpet r_inc_farm_sh_foodaid r_inc_farm_sh_commerce) 
egen r_inc_farm_sh_other1=rowtotal(r_inc_farm_sh_unskilledday r_inc_farm_sh_taxi r_inc_farm_sh_remitt_out r_inc_farm_sh_remitt_in r_inc_farm_sh_govbenefit r_inc_farm_sh_begging r_inc_farm_sh_other)
lab var r_inc_farm_sh_farm 		"Share: income from agriculture"
lab var r_inc_farm_sh_stable 	"Share: stable source of income"
lab var r_inc_farm_sh_sme 		"Share: income from sme, commerce, trade"
lab var r_inc_farm_sh_other1 	"Share: income from 'other'"
replace r_inc_farm_sh_farm=1 if r_inc_farm_sh_farm>=1 & r_inc_farm_sh_farm!=. & r_inc_farm_sh_farm!=111
foreach x in r_inc_farm_sh_other1 r_inc_farm_sh_sme r_inc_farm_sh_stable r_inc_farm_sh_farm  {
order `x', after(r_inc_farm_sh_total)
}
egen r_inc_farm_sh_total1=rowtotal(r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1)
order r_inc_farm_sh_total1, after(r_inc_farm_sh_other1)
replace r_inc_farm_sh_total1=1 if r_inc_farm_sh_total== 1
lab var r_inc_farm_sh_total1	"Share: total"

*Create education groups
gen educ_cat=.
replace educ_cat=1 if educ==1
replace educ_cat=2 if educ==2
replace educ_cat=3 if educ==3
replace educ_cat=4 if educ>= 4 & educ<=8
lab def educ_cat 1 "Education: none" 2 "Education: ecole d'alphabetisation" 3	"Education: ecole primaire" 4 "Education: college lycee general, or higher"
lab val educ_cat educ_cat 
order educ_cat, after(educ)
lab var educ_cat "Education, recategorized"

gen educ_head_cat=.
replace educ_head_cat=1 if educ_head==1
replace educ_head_cat=2 if educ_head==2
replace educ_head_cat=3 if educ_head==3
replace educ_head_cat=4 if educ_head>= 4 & educ_head<=8
lab val educ_head_cat educ_cat 
order educ_head_cat, after(educ_head)
lab var educ_head_cat "Education head, recategorized"

*Aggregate farmtype
tab farmtype	//only animal= only 8
gen mixedfarm=farmtype
recode mixedfarm (1=0) (2=0) (3=1)
lab def mixedfarm 0 "Only crop/animal production" 1 "Crop production + animal keeping"
lab val mixedfarm mixedfarm
order mixedfarm, after(farmtype)
lab var mixedfarm "What is your farm type: 1= Both crop+animal?"

*Aggregate headtype
tab head_type
gen headtype_dum=.
replace headtype_dum=1 if head_type==1
replace headtype_dum=0 if head_type==2 | head_type==3
lab val headtype_dum binary
lab var headtype_dum "1= Dual headed; 0= Female OR Male headed"
order headtype_dum, after(head_type)

*Age squared
gen age_sqrd=age*age
order age_sqrd, after(age)
lab var age_sqrd "Age Squared"

*Fertilizer usage
//compost only, manure only, chemical only, compost&chemical, manure&chemical
tab s_farm_soil_practcompost if s_farm_soil_practcomp_chem==1
replace s_farm_soil_practcompost=0 if s_farm_soil_practcomp_chem==1	
tab s_farm_soil_practmanure if s_farm_soil_practmanure_chem==1
replace s_farm_soil_practmanure=0 if s_farm_soil_practmanure_chem==1
replace s_farm_soil_practchemfert=0 if s_farm_soil_practcomp_chem==1 | s_farm_soil_practmanure_chem==1
tab1 s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem

*Shock type
gen r_cop_shock_cat=.
replace r_cop_shock_cat=1 if r_cop_shock_illness==1 | r_cop_shock_death==1 | r_cop_shock_injury==1
replace r_cop_shock_cat=2 if r_cop_shock_jobloss==1 | r_cop_shock_wagecut==1 | r_cop_shock_noremitt==1 | r_cop_shock_theft==1 | r_cop_shock_suddenexpenses==1
replace r_cop_shock_cat=3 if r_cop_shock_cropfailure==1 | r_cop_shock_drought==1 | r_cop_shock_flood==1 | r_cop_shock_naturalhazard==1
lab def shockcat 1 "Household" 2 "Economic" 3 "Climate"
lab val r_cop_shock_cat shockcat
order r_cop_shock_cat, after(r_cop_shock_total)
lab var r_cop_shock_cat "Main shocks categorized"

*Add routing skip-logic to missings (= 111, see above)
foreach x in r_inc_farm_sh_farm r_inc_farm_sh_stable r_inc_farm_sh_sme r_inc_farm_sh_other1 r_inc_farm_sh_total1 age educ farmtype land_hectares land_plots land_own land_rent land_communal land_total hhsize_men18 hhsize_women18 hhsize_children hhsize_total head_type educ_head pip_approach pip_training pip_training_year pip_have pip_implemented pip_improvedecon m_pur_cur_valuelife m_pur_cur_proudlife m_pur_fut_stay m_pur_fut_condition m_pur_con_plans m_pur_con_actionstaken m_aut_free_choice m_aut_free_desires m_aut_self_improve m_aut_self_easy m_aut_mas_incharge m_aut_mas_manageresp m_att_eag_learnimprove m_att_eag_askothers m_att_open_shareknow m_att_open_askothers m_att_drive_newpractices m_att_drive_improveproud m_hhsup_coll_collaborate m_hhsup_coll_whoplan m_hhsup_mut_undplan m_hhsup_mut_confl_hh m_hhsup_avail_accesslabour m_hhsup_avail_enoughmoney m_vilsup_soc_feelvalued m_vilsup_soc_confl_hhvill m_vilsup_trust_trust m_vilsup_trust_lendmoney m_vilsup_coll_confl_villvill m_vilsup_coll_confl_solved m_vilsup_coll_samevision r_inc_farm_subscrop r_inc_farm_subslivestock r_inc_farm_salefieldcrop r_inc_farm_salecashcrop r_inc_farm_saleorchard r_inc_farm_salelivestock r_inc_farm_saleprepfood r_inc_farm_agrwage r_inc_farm_shepherd r_inc_farm_miller r_inc_farm_unskilledday r_inc_farm_skilled r_inc_farm_employee r_inc_farm_trade r_inc_farm_firewood r_inc_farm_handicrafts r_inc_farm_carpet r_inc_farm_mining r_inc_farm_military r_inc_farm_taxi r_inc_farm_remitt_out r_inc_farm_remitt_in r_inc_farm_pension r_inc_farm_govbenefit r_inc_farm_rental r_inc_farm_foodaid r_inc_farm_begging r_inc_farm_commerce r_inc_farm_other r_inc_farm_sh_subscrop r_inc_farm_sh_subslivestock r_inc_farm_sh_salefieldcrop r_inc_farm_sh_salecashcrop r_inc_farm_sh_saleorchard r_inc_farm_sh_salelivestock r_inc_farm_sh_saleprepfood r_inc_farm_sh_agrwage r_inc_farm_sh_shepherd r_inc_farm_sh_miller r_inc_farm_sh_unskilledday r_inc_farm_sh_skilled r_inc_farm_sh_employee r_inc_farm_sh_trade r_inc_farm_sh_firewood r_inc_farm_sh_handicrafts r_inc_farm_sh_carpet r_inc_farm_sh_mining r_inc_farm_sh_military r_inc_farm_sh_taxi r_inc_farm_sh_remitt_out r_inc_farm_sh_remitt_in r_inc_farm_sh_pension r_inc_farm_sh_govbenefit r_inc_farm_sh_rental r_inc_farm_sh_foodaid r_inc_farm_sh_begging r_inc_farm_sh_commerce r_inc_farm_sh_other r_inc_farm_sh_total r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_actsh_total r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_finance_vsla r_inc_finance_enough r_crop_ann_cult_maize r_crop_ann_cult_sorghum r_crop_ann_cult_cassava r_crop_ann_cult_rice r_crop_ann_cult_irishpotato r_crop_ann_cult_sweetpotato r_crop_ann_cult_colocase r_crop_ann_cult_eleusine r_crop_ann_cult_beans r_crop_ann_cult_greenpeas r_crop_ann_cult_cajapeas r_crop_ann_cult_cabbage r_crop_ann_cult_amaranth r_crop_ann_cult_carrot r_crop_ann_cult_tomato r_crop_ann_cult_beet r_crop_ann_cult_eggplant r_crop_ann_cult_pepper r_crop_ann_cult_spinach r_crop_ann_cult_cucumber r_crop_ann_cult_yams r_crop_ann_cult_onions r_crop_ann_cult_watermelon r_crop_ann_cult_squash r_crop_ann_cult_other1 r_crop_ann_cult_other2 r_crop_ann_cult_total r_crop_ann_sell_maize r_crop_ann_sell_sorghum r_crop_ann_sell_cassava r_crop_ann_sell_rice r_crop_ann_sell_irishpotato r_crop_ann_sell_sweetpotato r_crop_ann_sell_colocase r_crop_ann_sell_eleusine r_crop_ann_sell_beans r_crop_ann_sell_greenpeas r_crop_ann_sell_cajapeas r_crop_ann_sell_cabbage r_crop_ann_sell_amaranth r_crop_ann_sell_carrot r_crop_ann_sell_tomato r_crop_ann_sell_beet r_crop_ann_sell_eggplant r_crop_ann_sell_pepper r_crop_ann_sell_spinach r_crop_ann_sell_cucumber r_crop_ann_sell_yams r_crop_ann_sell_onions r_crop_ann_sell_watermelon r_crop_ann_sell_squash r_crop_ann_sell_other1 r_crop_ann_sell_other2 r_crop_ann_sell_total r_crop_ann_change r_crop_per_cult_palmoil r_crop_per_cult_bananas r_crop_per_cult_mango r_crop_per_cult_avocado r_crop_per_cult_papaya r_crop_per_cult_guava r_crop_per_cult_lemon r_crop_per_cult_orange r_crop_per_cult_coffee r_crop_per_cult_other1 r_crop_per_cult_other2 r_crop_per_cult_total r_crop_per_sell_palmoil r_crop_per_sell_bananas r_crop_per_sell_mango r_crop_per_sell_avocado r_crop_per_sell_papaya r_crop_per_sell_guava r_crop_per_sell_lemon r_crop_per_sell_orange r_crop_per_sell_coffee r_crop_per_sell_other1 r_crop_per_sell_other2 r_crop_per_sell_total r_crop_per_cult_change r_crop_inc_change r_lvstck_own r_lvstck_div_cattle r_lvstck_div_goats r_lvstck_div_sheep r_lvstck_div_pigs r_lvstck_div_chicken r_lvstck_div_guineapigs r_lvstck_div_rabbits r_lvstck_div_ducks r_lvstck_div_poultry r_lvstck_div_total r_lvstck_div_other r_lvstck_div_sell_cattle r_lvstck_div_sell_goats r_lvstck_div_sell_sheep r_lvstck_div_sell_pigs r_lvstck_div_sell_chicken r_lvstck_div_sell_guineapigs r_lvstck_div_sell_rabbits r_lvstck_div_sell_ducks r_lvstck_div_sell_poultry r_lvstck_div_sell_total r_lvstck_div_sell_other r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_food_1 r_res_food_2 r_res_food_3 r_res_food_4 r_res_food_5 r_res_food_6 r_res_food_7 r_res_food_8 r_res_food_9 r_res_food_10 r_res_food_11 r_res_food_12 r_res_food_mean r_res_food_health_hh r_res_skills_farm_mngmt r_res_skills_access r_res_skills_problem r_res_org_planningtasks r_res_org_decic_farminput r_res_org_decic_croptype r_cop_shock_illness r_cop_shock_death r_cop_shock_injury r_cop_shock_jobloss r_cop_shock_wagecut r_cop_shock_cropfailure r_cop_shock_noremitt r_cop_shock_drought r_cop_shock_flood r_cop_shock_naturalhazard r_cop_shock_theft r_cop_shock_suddenexpenses r_cop_shock_total r_cop_shock_severity r_cop_strategy_changecope r_cop_strategy_abilitycope r_cop_assets_managefarm r_cop_assets_managehh s_awa_soilqual_change s_awa_soilqual_changewhy s_awa_veg_change s_awa_veg_changewhy s_awa_water_change s_awa_water_changewhy s_awa_coll_action s_awa_bio_protectimp s_awa_bio_natureimp_ex s_land_physpract_contourlines s_land_physpract_conttrack s_land_physpract_stonebunds s_land_physpract_gullycontrol s_land_physpract_total s_land_physpract_whyhow s_land_agro_change s_land_agro_whyhow s_land_mngmtpract_ploughing s_land_mngmtpract_staggering s_land_mngmtpract_mulching s_land_mngmtpract_covercrops s_land_mngmtpract_total s_land_mngmtpract_whyhow s_farm_crop_rotation s_farm_crop_rotationwhy s_farm_crop_mixwhy s_farm_soil_practcompost s_farm_soil_practmanure s_farm_soil_practchemfert s_farm_soil_practcomp_chem s_farm_soil_practmanure_chem s_farm_soil_practtotal s_farm_soil_practwhyhow s_farm_soil_nofert_expensive s_farm_soil_nofert_notavail s_farm_soil_nofert_dontneed s_farm_soil_nofert_other s_farm_soil_chemfert_buygroup s_farm_soil_chemfert_buygroup_nr s_farm_lvstck_intgr s_farm_lvstck_plans s_comm_trees_importance s_comm_trees_howuse s_comm_water_howconserve s_comm_water_sourceimp s_comm_land_howuse s_comm_land_howconserve group nogroup_interest fertknow accessfert_pnseb fertwhy_notavailable fertwhy_nointerest fertwhy_hatefert fertwhy_expensive fertwhy_howtojoin fertwhy_joincomplicated fertwhy_noinfo fertwhy_other fertwhy_rta fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes radio_mboniyongana{
replace `x'						=111 if consent==0
}
replace pip_training_trainer 	="111" if consent==0
replace pip_approach			=111 if pip_generation_clean!=5
replace pip_approach=1 if pip_training==0 & pip_generation_clean==5		//reversed recoding based on skip-logic
foreach x in pip_training pip_training_year pip_have pip_implemented pip_improvedecon {
replace `x'						=111 if pip_approach==0
}
replace pip_training_trainer 	="111" if pip_training_trainer=="" & pip_approach==0
replace pip_training_year		=111 if pip_training==0
replace pip_training_trainer	="111" if pip_training==0
replace pip_have				=111 if pip_training==0
replace pip_implemented			=111 if pip_have==0 
replace pip_improvedecon		=111 if pip_have==0
replace pip_implemented			=111 if pip_training==0 				//NB: this skip-logic wasn't in the survey, but I think it should have been
replace pip_improvedecon		=111 if pip_training==0					//NB: this skip-logic wasn't in the survey, but I think it should have been
replace m_hhsup_coll_whoplan	=111 if head_type!=1			
foreach x in subscrop subslivestock salefieldcrop salecashcrop saleorchard salelivestock saleprepfood agrwage shepherd miller unskilledday skilled employee trade firewood handicrafts carpet mining military taxi remitt_out remitt_in pension govbenefit rental foodaid begging other {
	replace r_inc_farm_sh_`x'=111 if r_inc_farm_sh_`x'==. & r_inc_farm_`x'==0
}
foreach x in r_inc_farm_actsh_labor r_inc_farm_actsh_sowing r_inc_farm_actsh_weeding r_inc_farm_actsh_harvesting r_inc_farm_actsh_sorting r_inc_farm_actsh_drying r_inc_farm_actsh_tightening r_inc_farm_actsh_transport r_inc_farm_actsh_total{
replace `x'						=111 if female==0 | (r_inc_farm_sh_subscrop==0 & r_inc_farm_sh_subslivestock==0 & /*
*/	 r_inc_farm_sh_salefieldcrop==0 & r_inc_farm_sh_salecashcrop==0 & r_inc_farm_sh_saleorchard==0 & /*
*/ 	 r_inc_farm_sh_salelivestock==0 & r_inc_farm_sh_agrwage==0)
replace `x'						=111 if female==0 | (r_inc_farm_sh_subscrop==. & r_inc_farm_sh_subslivestock==. & /*
*/	 r_inc_farm_sh_salefieldcrop==. & r_inc_farm_sh_salecashcrop==. & r_inc_farm_sh_saleorchard==. & /*
*/ 	 r_inc_farm_sh_salelivestock==. & r_inc_farm_sh_agrwage==.)
}
replace r_inc_farm_change_agrlivestock	=111 if r_inc_farm_sh_subscrop==0 & r_inc_farm_sh_subslivestock==0 & /*
*/	 r_inc_farm_sh_salefieldcrop==0 & r_inc_farm_sh_salecashcrop==0 & r_inc_farm_sh_saleorchard==0 & /*
*/ 	 r_inc_farm_sh_salelivestock==0 & r_inc_farm_sh_agrwage==0 & r_inc_farm_sh_saleprepfood==0 & r_inc_farm_sh_shepherd==0
replace r_inc_farm_change_agrlivestock	=111 if r_inc_farm_sh_subscrop==. & r_inc_farm_sh_subslivestock==. & /*
*/	 r_inc_farm_sh_salefieldcrop==. & r_inc_farm_sh_salecashcrop==. & r_inc_farm_sh_saleorchard==. & /*
*/ 	 r_inc_farm_sh_salelivestock==. & r_inc_farm_sh_agrwage==. & r_inc_farm_sh_saleprepfood==. & r_inc_farm_sh_shepherd==.
replace r_inc_nonfarm_change_other		=111 if r_inc_farm_sh_miller==. & r_inc_farm_sh_unskilledday==. & /*
*/	 r_inc_farm_sh_skilled==. & r_inc_farm_sh_employee==. & r_inc_farm_sh_trade==. & r_inc_farm_sh_firewood==. & /*
*/	 r_inc_farm_sh_handicrafts==. & r_inc_farm_sh_carpet==. & r_inc_farm_sh_mining==. & r_inc_farm_sh_military==. & /*
*/ 	 r_inc_farm_sh_taxi==. & r_inc_farm_sh_remitt_out==. & r_inc_farm_sh_remitt_in==. & r_inc_farm_sh_pension==. & /*
*/	 r_inc_farm_sh_govbenefit==. & r_inc_farm_sh_rental==. & r_inc_farm_sh_foodaid==. & r_inc_farm_sh_begging==. & /*
*/	 r_inc_farm_sh_commerce==. & r_inc_farm_sh_other==.
replace r_inc_nonfarm_change_other		=111 if r_inc_farm_sh_miller==0 & r_inc_farm_sh_unskilledday==0 & /*
*/	 r_inc_farm_sh_skilled==0 & r_inc_farm_sh_employee==0 & r_inc_farm_sh_trade==0 & r_inc_farm_sh_firewood==0 & /*
*/	 r_inc_farm_sh_handicrafts==0 & r_inc_farm_sh_carpet==0 & r_inc_farm_sh_mining==0 & r_inc_farm_sh_military==0 & /*
*/ 	 r_inc_farm_sh_taxi==0 & r_inc_farm_sh_remitt_out==0 & r_inc_farm_sh_remitt_in==0 & r_inc_farm_sh_pension==0 & /*
*/	 r_inc_farm_sh_govbenefit==0 & r_inc_farm_sh_rental==0 & r_inc_farm_sh_foodaid==0 & r_inc_farm_sh_begging==0 & /*
*/	 r_inc_farm_sh_commerce==0 & r_inc_farm_sh_other==0
replace r_inc_finance_enough			=111 if r_inc_finance_vsla==1 | r_inc_finance_vsla==2 | r_inc_finance_vsla==111
foreach x in r_lvstck_div_cattle r_lvstck_div_goats r_lvstck_div_sheep r_lvstck_div_pigs r_lvstck_div_chicken r_lvstck_div_guineapigs r_lvstck_div_rabbits r_lvstck_div_ducks r_lvstck_div_poultry r_lvstck_div_total r_lvstck_div_other r_lvstck_div_sell_cattle r_lvstck_div_sell_goats r_lvstck_div_sell_sheep r_lvstck_div_sell_pigs r_lvstck_div_sell_chicken r_lvstck_div_sell_guineapigs r_lvstck_div_sell_rabbits r_lvstck_div_sell_ducks r_lvstck_div_sell_poultry r_lvstck_div_sell_total r_lvstck_div_sell_other r_lvstck_health r_lvstck_health_medical r_lvstck_nutr_producefeed r_lvstck_nutr_fodder {
replace `x'								=111 if r_lvstck_own!=1
}
replace r_lvstck_health_medical			=111 if r_lvstck_health==1 | r_lvstck_health==111
foreach x in s_land_physpract_whyhow s_land_agro_change{
replace `x'								=111 if s_land_physpract_total==0
}
replace s_land_mngmtpract_whyhow		=111 if s_land_mngmtpract_total==0
foreach x in s_farm_crop_rotationwhy s_farm_crop_mixwhy	{
replace `x'								=111 if s_farm_crop_rotation==1
}
foreach x in s_farm_soil_nofert_expensive s_farm_soil_nofert_notavail s_farm_soil_nofert_dontneed s_farm_soil_nofert_other{
replace `x'								=111 if s_farm_soil_practcompost==0 & s_farm_soil_practmanure==0
}
replace s_farm_soil_chemfert_buygroup_nr=111 if s_farm_soil_chemfert_buygroup==0
replace s_farm_lvstck_intgr				=111 if r_lvstck_own==0
replace s_farm_lvstck_plans				=111 if r_lvstck_own==0
replace nogroup_interest				=111 if group==1
foreach x in accessfert_pnseb fertwhy_notavailable fertwhy_nointerest fertwhy_hatefert fertwhy_expensive fertwhy_howtojoin fertwhy_joincomplicated fertwhy_noinfo fertwhy_other fertwhy_rta fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes radio_mboniyongana{
replace `x'								=111 if fertknow==1 | fertknow==88 | fertknow==99
}
foreach x in fertwhy_notavailable fertwhy_nointerest fertwhy_hatefert fertwhy_expensive fertwhy_howtojoin fertwhy_joincomplicated fertwhy_noinfo fertwhy_other fertwhy_rta{
replace `x'								=111 if accessfert_pnseb!=0
}
foreach x in fertlike_distribution fertlike_registration fertlike_advancepay fertlike_availability fertlike_quality fertlike_price fertlike_ferttypes{
replace `x'								=111 if accessfert_pnseb!=1
}
*

*********************************************************************
*7: ADD SAMPLING WEIGHTS
*********************************************************************

gen weight_generation=.
replace	weight_generation=		0.169278996865204	if	pip_generation_clean==	1
replace	weight_generation=		0.0304336116347967	if	pip_generation_clean==	2
replace	weight_generation=		0.022893230708506	if	pip_generation_clean==	3
replace	weight_generation=		0.0100596392900769	if	pip_generation_clean==	4
replace	weight_generation=		1					if	pip_generation_clean==	5
lab var weight_generation "Sampling weight by generation"

gen weight_generation_inv=1/weight_generation
lab var weight_generation_inv "INVERSE Sampling weight by generation"

order weight_generation, after(pip)
order weight_generation_inv, after(weight_generation)

*********************************************************************
*8: ADD GEO INFO PER COLLINE
*********************************************************************

gen latitude=.
tostring latitude, replace
replace latitude=	"S 4° 16' 22''"	if colline==	18
replace latitude=	"S 3° 27' 22''"	if colline==	5
replace latitude=	"S 3° 45' 38''"	if colline==	28
replace latitude=	"S 2°42'51.4''"	if colline==	10
replace latitude=	"S 2° 56' 41''"	if colline==	27
replace latitude=	"S 4° 12' 17''"	if colline==	16
replace latitude=	"S 3° 6' 36''"	if colline==	24
replace latitude=	"S 3° 6' 14''"	if colline==	25
replace latitude=	"S 4° 2' 36''"	if colline==	31
replace latitude=	"S 3° 53' 41''"	if colline==	29
replace latitude=	"S 2° 45' 45''"	if colline==	22
replace latitude=	"S 3° 17' 23''"	if colline==	3
replace latitude=	"S 3° 25' 25''"	if colline==	8
replace latitude=	"S 3° 36' 27''"	if colline==	35
replace latitude=	"S 2° 41' 29''"	if colline==	11
replace latitude=	"S 2° 51' 11''"	if colline==	12
replace latitude=	"S 2° 59' 45''"	if colline==	15
replace latitude=	"S 3° 50' 13''"	if colline==	34
replace latitude=	"S 4° 18' 27''"	if colline==	21
replace latitude=	"S 2° 54' 5''"	if colline==	14
replace latitude=	"S 3° 16' 0''"	if colline==	4
replace latitude=	"S 3° 30' 21''"	if colline==	6
replace latitude=	"S 4° 16' 39''"	if colline==	19
replace latitude=	"S 3° 59' 7''"	if colline==	32
replace latitude=	"S 4° 17' 17''"	if colline==	20
replace latitude=	"S 2° 42' 5''"	if colline==	23
replace latitude=	"S 3° 58' 26''"	if colline==	33
replace latitude=	"S 3° 27' 41''"	if colline==	1
replace latitude=	"S 3° 22' 44''"	if colline==	9
replace latitude=	"S 3° 28' 7''"	if colline==	7
replace latitude=	"S 4° 10' 50''"	if colline==	17
replace latitude=	"S 2° 48' 54''"	if colline==	13
replace latitude=	"S 3° 7' 42''"	if colline==	26
replace latitude=	"S 3° 26' 36''"	if colline==	2
replace latitude=	"S 3° 47' 53''"	if colline==	30
lab var latitude "latitude, per colline"
order latitude, after(LocationLongitude)

gen longitude=.
tostring longitude, replace
replace longitude=	"E 29° 35' 42''"	if colline==	18
replace longitude=	"E 29° 29' 32''"	if colline==	5
replace longitude=	"E 29° 25' 30''"	if colline==	28
replace longitude=	"E 29°10'00.7''"	if colline==	10
replace longitude=	"E 30° 20' 0''"		if colline==	27
replace longitude=	"E 29° 51' 9''"		if colline==	16
replace longitude=	"E 30° 20' 22''"	if colline==	24
replace longitude=	"E 30° 15' 59''"	if colline==	25
replace longitude=	"E 29° 28' 48''"	if colline==	31
replace longitude=	"E 29° 27' 35''"	if colline==	29
replace longitude=	"E 30° 21' 51''"	if colline==	22
replace longitude=	"E 29° 29' 0''"		if colline==	3
replace longitude=	"E 29° 32' 52''"	if colline==	8
replace longitude=	"E 29° 21' 25''"	if colline==	35
replace longitude=	"E 29° 15' 30''"	if colline==	11
replace longitude=	"E 29° 6' 39''"		if colline==	12
replace longitude=	"E 29° 14' 47''"	if colline==	15
replace longitude=	"E 29° 34' 22''"	if colline==	34
replace longitude=	"E 29° 51' 30''"	if colline==	21
replace longitude=	"E 29° 22' 23''"	if colline==	14
replace longitude=	"E 29° 29' 46''"	if colline==	4
replace longitude=	"E 29° 30' 0''"		if colline==	6
replace longitude=	"E 29° 41' 43''"	if colline==	19
replace longitude=	"E 29° 29' 55''"	if colline==	32
replace longitude=	"E 29° 40' 30''"	if colline==	20
replace longitude=	"E 30° 28' 46''"	if colline==	23
replace longitude=	"E 29° 32' 7''"		if colline==	33
replace longitude=	"E 29° 24' 47''"	if colline==	1
replace longitude=	"E 29° 32' 51''"	if colline==	9
replace longitude=	"E 29° 28' 56''"	if colline==	7
replace longitude=	"E 29° 49' 49''"	if colline==	17
replace longitude=	"E 29° 7' 21''"		if colline==	13
replace longitude=	"E 30° 15' 7''"		if colline==	26
replace longitude=	"E 29° 26' 23''"	if colline==	2
replace longitude=	"E 29° 25' 8''"		if colline==	30
lab var longitude "longitude, per colling"
order longitude, after(latitude)

/*NB: Data from geonames.org.
Format is DSM. QGIS doesn't have a problem with reading this format; PowerBI does.
Later converted to degrees.*/

*********************************************************************
*9: SAVE DATA
*********************************************************************

*Dataset
cd "2. Clean"
save "PAPAB Impact study - Cleaning1.dta", replace
export delimited using "C:\Users\mariekeme\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean\PAPAB Impact study - Cleaning1.csv", replace

/*
quietly {
    log using PAPAB_Codebook.txt, text replace
    noisily codebook
    log close
}

*Export variable name + variable label
numlabel, add force
preserve
    describe *, replace clear
    list
    export excel using VariableLabels_PAPAB.xlsx, replace first(var)
restore

*Export value labels
uselabel, clear
export excel lname value label using "ValueLabels_PAPAB", sheetreplace
