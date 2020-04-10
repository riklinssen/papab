* Project: PAPAB (Impact Study)
* Country: Burundi
* Survey: 2019
* Objective: Effect Anaylsis
* Author: Marieke Meeske
* Date: 04-02-2020

*********************************************************************
*IMPORT+CD
*********************************************************************

cd "C:/Users/`c(username)'/Box\ONL-IMK/2.0 Projects/Current/2018-05 PAPAB Burundi/07. Analysis & reflection/Data & Analysis"
use "2. Clean\PAPAB Impact study - Analysis2 Incl Factors.dta", clear
set more off, perm
estimates clear

cd "4. Output"

//farmer groups
foreach x in 1 2 3 4 {
gen pip`x'=.
replace pip`x'=1 if comp_g`x'==0
replace pip`x'=0 if comp_g`x'==1
lab val pip`x' binary
}
rename pip 		pip_allpip
rename w_allpip	w_g_allpip

gen pip_no=.
replace pip_no=1 if pip_allpip==0
replace pip_no=0 if pip_allpip==1
lab val pip_no binary
lab var pip_no "comparison ==1"

/*********************************************************************
*Pillar 1: Motivation
*********************************************************************

//setting the locals
local	 outcomes_m		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean motivation_score
						//all outcome variables are categorical/continous -> regression analysis

//exporting the estimates
foreach 	i in 1 2 3 4 _allpip {
erase 		"pip`i'_motivation_Regression.xml"
erase 		"pip`i'_motivation_Regression.txt"
			
foreach 	var in `outcomes_m'{
			qui reg `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_motivation_Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
}
*

//exporting the mean values
foreach		i in 1 2 3 4 _allpip {
svyset		colline [pw=w_g`i']

local		cols group mean se lb ub pvalue sample
local 		ncols: word count `cols'
local 		nrows: word count `outcomes_m' `outcomes_m' `outcomes_m'
matrix 		v`i'=J(`nrows',`ncols',.)
mat 		colnames v`i'=`cols'

local 		irow=0
foreach 	var in `outcomes_m' {
			local 		++irow
			qui svy: mean `var' if pip`i'==1		//pip generation
			matrix pip = r(table)
			mat 	v`i'[`irow',1]= 1
			mat 	v`i'[`irow',2]= pip[1,1]
			mat 	v`i'[`irow',3]= pip[2,1]
			mat 	v`i'[`irow',4]= pip[5,1]
			mat 	v`i'[`irow',5]= pip[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
						
			local 		++irow
			qui svy: mean `var' if pip`i'==0		//comparison
			matrix comparison = r(table)	
			mat 	v`i'[`irow',1]= 0
			mat 	v`i'[`irow',2]= comparison[1,1]
			mat 	v`i'[`irow',3]= comparison[2,1]
			mat 	v`i'[`irow',4]= comparison[5,1]
			mat 	v`i'[`irow',5]= comparison[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
			
			local 		++irow 
			qui	svy: reg `var' pip`i'				//difference
			matrix diff = r(table)
			mat 	v`i'[`irow',1]= 2
			mat 	v`i'[`irow',2]= diff[1,1]
			mat 	v`i'[`irow',3]= diff[2,1]
			mat 	v`i'[`irow',4]= diff[5,1]
			mat 	v`i'[`irow',5]= diff[6,1]
			mat 	v`i'[`irow',6]= diff[4,1]			
			mat 	v`i'[`irow',7]= e(N) 
}
*
mat 		list v`i', f(%10.3f)

erase 		"pip`i'_motivation_MeanValue.xlsx"
putexcel 	set "pip`i'_motivation_MeanValue.xlsx",  modify 	
putexcel	A1 = matrix(v`i', names) 
putexcel	A1 = ("name")

*Add name of variable and label
local 		irow=1
foreach 	x in `outcomes_m'  {
			local 		++irow
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP`i'")
			
			local 		++irow 
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("Comparison PIP`i'")
			
			local 		++irow 
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("Difference")  
}
}
*/

/*********************************************************************
*Pillar 2: Resilience
*********************************************************************

//setting the locals
local	 outcomes_r		r_crop_cult_total r_crop_sell_total r_lvstck_total r_lvstck_nutr_producefeed r_lvstck_nutr_fodder r_res_mean r_cop_mean resilience_score
						//all outcome variables are categorical/continous -> regression analysis

//exporting the estimates
foreach 	i in 1 2 3 4 _allpip {
erase 		"pip`i'_resilience_Regression.xml"
erase 		"pip`i'_resilience_Regression.txt"
			
foreach 	var in `outcomes_r'{
			qui reg `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_resilience_Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
}
*

//exporting the mean values
foreach		i in 1 2 3 4 _allpip {
svyset		colline [pw=w_g`i']

local		cols group mean se lb ub pvalue sample
local 		ncols: word count `cols'
local 		nrows: word count `outcomes_r' `outcomes_r' `outcomes_r'
matrix 		v`i'=J(`nrows',`ncols',.)
mat 		colnames v`i'=`cols'

local 		irow=0
foreach 	var in `outcomes_r' {
			local 		++irow
			qui svy: mean `var' if pip`i'==1		//pip generation
			matrix pip = r(table)
			mat 	v`i'[`irow',1]= 1
			mat 	v`i'[`irow',2]= pip[1,1]
			mat 	v`i'[`irow',3]= pip[2,1]
			mat 	v`i'[`irow',4]= pip[5,1]
			mat 	v`i'[`irow',5]= pip[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
						
			local 		++irow
			qui svy: mean `var' if pip`i'==0		//comparison
			matrix comparison = r(table)	
			mat 	v`i'[`irow',1]= 0
			mat 	v`i'[`irow',2]= comparison[1,1]
			mat 	v`i'[`irow',3]= comparison[2,1]
			mat 	v`i'[`irow',4]= comparison[5,1]
			mat 	v`i'[`irow',5]= comparison[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
			
			local 		++irow 
			qui	svy: reg `var' pip`i'				//difference
			matrix diff = r(table)
			mat 	v`i'[`irow',1]= 2
			mat 	v`i'[`irow',2]= diff[1,1]
			mat 	v`i'[`irow',3]= diff[2,1]
			mat 	v`i'[`irow',4]= diff[5,1]
			mat 	v`i'[`irow',5]= diff[6,1]
			mat 	v`i'[`irow',6]= diff[4,1]			
			mat 	v`i'[`irow',7]= e(N) 
}
*
mat 		list v`i', f(%10.3f)

erase 		"pip`i'_resilience_MeanValue.xlsx"
putexcel 	set "pip`i'_resilience_MeanValue.xlsx",  modify 	
putexcel	A1 = matrix(v`i', names) 
putexcel	A1 = ("name")

*Add name of variable and label
local 		irow=1
foreach 	x in `outcomes_r'  {
			local 		++irow
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP`i'")
			
			local 		++irow 
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("Comparison PIP`i'")
			
			local 		++irow 
			sleep 2000
			putexcel A`irow' = ("`x'")  B`irow' = ("Difference")  
}
}
*/

*********************************************************************
*Pillar 3: Stewardship
*********************************************************************

//setting the locals
local	 outcomes_s		s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean /*
*/						s_farm_soil_compost s_farm_soil_manure /*
*/						s_land_physpract_contourlines s_land_physpract_conttrack /*
*/						s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops stewardship_score_v2
local	 reg_s			s_awa_mean s_comm_mean s_farm_why_mean s_land_why_mean stewardship_score_v2
local	 probit_s		s_farm_soil_compost s_farm_soil_manure /*
*/						s_land_physpract_contourlines s_land_physpract_conttrack /*
*/						s_land_mngmtpract_ploughing s_land_mngmtpract_mulching s_land_mngmtpract_covercrops

//exporting the estimates
foreach 	i in 1 2 3 4 _allpip {
erase 		"pip`i'_stewardship_Regression.xml"
erase 		"pip`i'_stewardship_Regression.txt"
			
foreach 	var in `reg_s'{
			qui reg `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_stewardship_Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
foreach 	var in `probit_s'{
			qui probit `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_stewardship_Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
}
*

//exporting the mean values
foreach		i in 1 2 3 4 _allpip {
svyset		colline [pw=w_g`i']

local		cols group mean se lb ub pvalue sample
local 		ncols: word count `cols'
local 		nrows: word count `outcomes_s' `outcomes_s' `outcomes_s'
matrix 		v`i'=J(`nrows',`ncols',.)
mat 		colnames v`i'=`cols'

local 		irow=0
foreach 	var in `outcomes_s' {
			local 		++irow
			qui svy: mean `var' if pip`i'==1		//pip generation
			matrix pip = r(table)
			mat 	v`i'[`irow',1]= 1
			mat 	v`i'[`irow',2]= pip[1,1]
			mat 	v`i'[`irow',3]= pip[2,1]
			mat 	v`i'[`irow',4]= pip[5,1]
			mat 	v`i'[`irow',5]= pip[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
						
			local 		++irow
			qui svy: mean `var' if pip`i'==0		//comparison
			matrix comparison = r(table)	
			mat 	v`i'[`irow',1]= 0
			mat 	v`i'[`irow',2]= comparison[1,1]
			mat 	v`i'[`irow',3]= comparison[2,1]
			mat 	v`i'[`irow',4]= comparison[5,1]
			mat 	v`i'[`irow',5]= comparison[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
			
			local 		++irow 
			qui	svy: reg `var' pip`i'				//difference
			matrix diff = r(table)
			mat 	v`i'[`irow',1]= 2
			mat 	v`i'[`irow',2]= diff[1,1]
			mat 	v`i'[`irow',3]= diff[2,1]
			mat 	v`i'[`irow',4]= diff[5,1]
			mat 	v`i'[`irow',5]= diff[6,1]
			mat 	v`i'[`irow',6]= diff[4,1]			
			mat 	v`i'[`irow',7]= e(N) 
}
*
mat 		list v`i', f(%10.3f)

erase 		"pip`i'_stewardship_MeanValue.xlsx"
putexcel 	set "pip`i'_stewardship_MeanValue.xlsx",  modify 	
putexcel	A1 = matrix(v`i', names) 
putexcel	A1 = ("name")

*Add name of variable and label
local 		irow=1
foreach 	x in `outcomes_s'  {
			local 		++irow
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP`i'")
			
			local 		++irow 
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("Comparison PIP`i'")
			
			local 		++irow 
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("Difference")  
}
}

*************other outcomes****

**income changes
*6.5 How   is your income from  agriculture and livestock now compared to three years ago?-->r_inc_farm_change_agrlivestock
*Q6.6 How   is your income from  other sources  now compared to three years ago?--> r_inc_nonfarm_change_other

*Q6.11 Compared   to 3-4 years ago, do you cultivate more, less or the same number of annual crops? r_crop_ann_change
*Q6.14 Compared to 3-4 years ago, do you cultivate more, less or the same number of perrenial crops? r_crop_per_cult_change 
*Q6.15 Compared   to 3-4 years ago, do you sell more, less or the same number crops on the market? r_crop_inc_change

*new var for cultivation
egen r_inc_crop_change=rowmean(r_crop_ann_change r_crop_per_cult_change)

tab1 r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_crop_change r_crop_inc_change

*How   is your income from  other sources  now compared to three years ago?

//setting the locals
local	 outcomes_s		r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_crop_change r_crop_inc_change
local	 reg_s			r_inc_farm_change_agrlivestock r_inc_nonfarm_change_other r_inc_crop_change r_crop_inc_change

//exporting the estimates
foreach 	i in 1 2 3 4 _allpip {
*erase 		"pip`i'_otheroutcomes_Regression.xml"
*erase 		"pip`i'_otheroutcomes_Regression.txt"
			
foreach 	var in `reg_s'{
			qui reg `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_otheroutcomes__Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
foreach 	var in `probit_s'{
			qui probit `var' pip`i' [pw=w_g`i'], vce(cluster colline)
			outreg2 using pip`i'_otheroutcomes__Regression, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
}
*

//exporting the mean values
foreach		i in 1 2 3 4 _allpip {
svyset		colline [pw=w_g`i']

local		cols group mean se lb ub pvalue sample
local 		ncols: word count `cols'
local 		nrows: word count `outcomes_s' `outcomes_s' `outcomes_s'
matrix 		v`i'=J(`nrows',`ncols',.)
mat 		colnames v`i'=`cols'

local 		irow=0
foreach 	var in `outcomes_s' {
			local 		++irow
			qui svy: mean `var' if pip`i'==1		//pip generation
			matrix pip = r(table)
			mat 	v`i'[`irow',1]= 1
			mat 	v`i'[`irow',2]= pip[1,1]
			mat 	v`i'[`irow',3]= pip[2,1]
			mat 	v`i'[`irow',4]= pip[5,1]
			mat 	v`i'[`irow',5]= pip[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
						
			local 		++irow
			qui svy: mean `var' if pip`i'==0		//comparison
			matrix comparison = r(table)	
			mat 	v`i'[`irow',1]= 0
			mat 	v`i'[`irow',2]= comparison[1,1]
			mat 	v`i'[`irow',3]= comparison[2,1]
			mat 	v`i'[`irow',4]= comparison[5,1]
			mat 	v`i'[`irow',5]= comparison[6,1]
			qui	svy: reg `var' pip`i'
			matrix reg = r(table)
			mat 	v`i'[`irow',6]= reg[4,1]
			mat		v`i'[`irow',7]= e(N)
			
			local 		++irow 
			qui	svy: reg `var' pip`i'				//difference
			matrix diff = r(table)
			mat 	v`i'[`irow',1]= 2
			mat 	v`i'[`irow',2]= diff[1,1]
			mat 	v`i'[`irow',3]= diff[2,1]
			mat 	v`i'[`irow',4]= diff[5,1]
			mat 	v`i'[`irow',5]= diff[6,1]
			mat 	v`i'[`irow',6]= diff[4,1]			
			mat 	v`i'[`irow',7]= e(N) 
}
*
mat 		list v`i', f(%10.3f)

*erase 		"pip`i'_otheroutcomes_MeanValue.xlsx"
putexcel 	set "pip`i'_otheroutcomes_MeanValue.xlsx",  modify 	
putexcel	A1 = matrix(v`i', names) 
putexcel	A1 = ("name")

*Add name of variable and label
local 		irow=1
foreach 	x in `outcomes_s'  {
			local 		++irow
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP`i'")
			
			local 		++irow 
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("Comparison PIP`i'")
			
			local 		++irow 
			sleep 2500
			putexcel A`irow' = ("`x'")  B`irow' = ("Difference")  
}
}


*********************************************************************
*Correlation pillar 1&2&3
*********************************************************************

*Simple correlation testing across all pillars
pwcorr motivation_score resilience_score stewardship_score_v2, st(0.5)
	//motivation&resilience: 	0.7134*
	//motivation&stewardship: 	0.5758*
	//resilience&stewardship: 	0.5430*

*Regression analysis
local 	covariates			i.province i.female age i.educ_cat i.head_type i.mixedfarm land_hectares land_own
egen 	miss=				rowmiss(province female age educ_cat head_type mixedfarm land_hectares land_own)
reg		resilience_score 		`covariates' 	motivation_score		, vce(cluster colline)	//.5394495***
reg		resilience_score 		`covariates' 	stewardship_score_v2	, vce(cluster colline)	//.3295767***
reg		stewardship_score_v2 	`covariates' 	motivation_score 		, vce(cluster colline)	//.4308688***
reg 	stewardship_score_v2 	`covariates'	resilience_score 		, vce(cluster colline)	//.3637481***

//full sample
erase		"fullsample_RegressionPillars.xml"
erase		"fullsample_RegressionPillars.txt"
			qui reg resilience_score 		`covariates' 	motivation_score 		, vce(cluster colline)
			outreg2 using fullsample_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg resilience_score 		`covariates' 	stewardship_score_v2	, vce(cluster colline)
			outreg2 using fullsample_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	motivation_score 		, vce(cluster colline)
			outreg2 using fullsample_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	resilience_score 		, vce(cluster colline)
			outreg2 using fullsample_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue

//pip generation 1-4 and comparison
foreach 	i in 1 2 3 4 _no {
erase		"pip`i'_RegressionPillars.xml"
erase		"pip`i'_RegressionPillars.txt"

			qui reg resilience_score 		`covariates' 	motivation_score 		if pip`i'==1, vce(cluster colline)
			outreg2 using pip`i'_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg resilience_score 		`covariates' 	stewardship_score_v2	if pip`i'==1, vce(cluster colline)
			outreg2 using pip`i'_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	motivation_score 		if pip`i'==1, vce(cluster colline)
			outreg2 using pip`i'_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	resilience_score 		if pip`i'==1, vce(cluster colline)
			outreg2 using pip`i'_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
}
*

//all pip, incl sampling weights
erase 		"pip_allpip_RegressionPillars.xml"
erase		"pip_allpip_RegressionPillars.txt"
			qui reg resilience_score 		`covariates' 	motivation_score 		[pw=weight_generation_inv] if pip_allpip==1, vce(cluster colline)
			outreg2 using pip_allpip_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg resilience_score 		`covariates' 	stewardship_score_v2	[pw=weight_generation_inv] if pip_allpip==1, vce(cluster colline)
			outreg2 using pip_allpip_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	motivation_score 		[pw=weight_generation_inv] if pip_allpip==1, vce(cluster colline)
			outreg2 using pip_allpip_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue
			
			qui reg stewardship_score_v2 	`covariates' 	resilience_score 		[pw=weight_generation_inv] if pip_allpip==1, vce(cluster colline)
			outreg2 using pip_allpip_RegressionPillars, excel append bdec(5) symbol(***,**,*) alpha(0.01, 0.05, 0.1) pvalue

/*I’d say  1st run at full sample (inc. comparison) to asses whether there is any relationship between these at all. 
(we can introduce some controls there based on a discussion with Aad). Then add interaction effect of motivation * generation, 
or slice date into 5 generations  (incl control), so we can plot a scatterplot with the regression line for each generation. 
Slope of that regression line hopefully steeper for G1 compared to G3. shows (or all generations PIP)*/

//gen			motivation_pip`i'= motivation_score*pip`i'
//gen			resilience_pip`i'= resilience_score*pip`i'
//gen			stewardship_pip`i'= stewardship_score_v2*pip`i'



