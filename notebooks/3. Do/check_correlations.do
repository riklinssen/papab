use "C:\Users\RikL\Projects\papab\notebooks\data\clean\PAPAB Impact study - Analysis2 Incl Factors.dta", clear



pwcorr m_pur_pr m_aut_pr m_att_pr m_hhsup_pr  m_vilsup_pr resilience_score stewardship_score_v2, sig bonferroni

pwcorr m_pur_mean m_aut_mean m_att_mean m_hhsup_mean  m_vilsup_mean resilience_score stewardship_score_v2, sig bonferroni

pwcorr resilience_pr1 resilience_pr2 resilience_pr3 stewardship_score_v2, sig bonferroni


pwcorr motivation_score resilience_score stewardship_score_v2 pip_implemented, sig 

pwcorr motivation_score resilience_score stewardship_score_v2 pip_training_year, sig 
 corr pip_training_year pip_generation_clean
