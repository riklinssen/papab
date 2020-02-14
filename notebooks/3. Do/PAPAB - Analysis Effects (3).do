* Project: PAPAB (Impact Study)
* Country: Burundi
* Survey: 2019
* Objective: Effect Anaylsis
* Author: Marieke Meeske
* Date: 04-02-2020

*********************************************************************
*IMPORT+CD
*********************************************************************
*TEST git


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

*********************************************************************
*Pillar 1: Motivation
*********************************************************************

//setting the locals
local	 outcomes_m		m_pur_mean m_aut_mean m_att_mean m_hhsup_mean m_vilsup_mean motivation_mean
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

local		cols Group Mean SE CI_lowerbound CI_upperbound N
local 		ncols: word count `cols'
local 		nrows: word count `outcomes_m' `outcomes_m'
matrix 		v`i'=J(`nrows',`ncols',.)
mat 		colnames v`i'=`cols'

local 		irow=0
foreach 	var in `outcomes_m' {
			local 		++irow
			qui svy: mean `var' if pip`i'==1
			matrix pip = r(table)
			mat 	v`i'[`irow',1]= 1
			mat 	v`i'[`irow',2]= pip[1,1]
			mat 	v`i'[`irow',3]= pip[2,1]
			mat 	v`i'[`irow',4]= pip[5,1]
			mat 	v`i'[`irow',5]= pip[6,1]
			mat		v`i'[`irow',6]= e(N)
						
			local 		++irow
			qui svy: mean `var' if pip`i'==0
			matrix comparison = r(table)
			mat 	v`i'[`irow',1]= 0
			mat 	v`i'[`irow',2]= comparison[1,1]
			mat 	v`i'[`irow',3]= comparison[2,1]
			mat 	v`i'[`irow',4]= comparison[5,1]
			mat 	v`i'[`irow',5]= comparison[6,1]
			mat		v`i'[`irow',6]= e(N)
}
*
mat 		list v`i', f(%10.3f)

erase 		"pip`i'_motivation_MeanValue.xlsx"
putexcel 	set "pip`i'_motivation_MeanValue.xlsx",  modify 	
putexcel	A1 = matrix(v`i', names) 

*Add name of variable and label
local 		irow=1
foreach 	x in `outcomes_m'  {
			local 		++irow
			sleep 1500
			putexcel A`irow' = ("`x'")  B`irow' = ("PIP`i'")
			
			local 		++irow 
			sleep 1500
			putexcel A`irow' = ("`x'")  B`irow' = ("Comparison")
}
}
*

