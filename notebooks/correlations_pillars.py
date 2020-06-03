import datetime
import glob
import os
import re
from pathlib import Path

import matplotlib.cm
import matplotlib.dates as mdates
import matplotlib.gridspec as gridspec
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
import numpy as np
import pandas as pd
import seaborn as sns
from matplotlib.dates import DateFormatter
from statsmodels.stats.weightstats import DescrStatsW




# hex_values = ['#E70052',  # rood
#               '#F16E22',  # oranje
#               '#E43989',  # roze
#               '#630235',  # Bordeax
#               '#61A534',  # oxgroen
#               '#53297D',  # paars
#               '#0B9CDA',  # blauw
#               '#0C884A'  # donkergroen
#               ]
# paths
root = Path.cwd()
interim = root/"data"/"interim"
clean = root/"data"/"clean"
graphs = root/"graphs"

# dataset indiv level
select = ['id, ''resilience_score', 'motivation_score',
    'stewardship_score_v3', 'pip_generation_clean']
cleanf = clean/"PAPAB Impact study - Analysis2 Incl Factors.dta"


clean = pd.read_stata(cleanf, convert_categoricals=False)

# correlations between pillars (raw)
pillars = ['motivation_score', 'resilience_score',
    'stewardship_score_v3', 'pip_generation_clean']
pillarlabels = {'motivation_score': 'Motivation (score 0-100)',
        'resilience_score': 'Resilience (score 0-100)',
        'stewardship_score_v3': 'Stewardship (score 0-100)'}

# colormap for generations
cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22',
            'All PIP* \n (average)': '#61A534'}

###################correlations between subconstruct and pillar
#create correlation matrix
#motivation sub-constructs --> reslience & stewardship

motivsub=['m_pur_pr', 'm_aut_pr', 'm_att_pr', 'm_hhsup_pr',  'm_vilsup_pr']
pils=['resilience_score', 'stewardship_score_v3']
selcols=motivsub + pils
motiv=clean.loc[:,selcols]

motiv_corr=pd.DataFrame(motiv.corr()).loc[motivsub, pils]

#rename with meaningful names
motiv_corr = motiv_corr.rename(index = {'m_pur_pr': 'Purpose',
                                        'm_aut_pr': 'Autonomy',
                                        'm_att_pr': 'Attitude',
                                        'm_hhsup_pr': 'Household support',
                                        'm_vilsup_pr': 'Village support'},
                               columns = {'resilience_score': 'Resilience',
                                          'stewardship_score_v3': 'Stewardship'}).sort_values(by='Resilience', ascending=False)

#same for resilience --> stewardship
res_sub=['resilience_pr1', 'r_res_pr', 
'r_cop_pr',
'resilience_pr3']

# resilience_pr1 	"pr. Scores for comp1 - crop diversity-"
# resilience_pr3    "pr. Scores for comp3 - livestock situation -"
# r_res_pr --> household resilience
# r_cop_pr --> household coping

pils2=['stewardship_score_v3']
rescols=res_sub+pils2

res=clean.loc[:, rescols]
res_corr=pd.DataFrame(res.corr()).loc[res_sub,pils2]
res_corr = res_corr.rename(index={'resilience_pr1': 'Crop diversity',
                                  'r_res_pr': 'HH-resilience',
                                  'r_cop_pr': 'HH-coping ability',
                                  'resilience_pr3': 'Livestock situation'}, 
                                  columns={'stewardship_score_v3': 'Stewardship'}).sort_values(by='Stewardship', ascending=False)
# correlation_plot motivation--> stewardship AND resilience

sns.set_style('ticks')
f, ax1 = plt.subplots(nrows=1, ncols=1, figsize=(3, 3))
sns.heatmap(motiv_corr, annot=True,  linewidths=1, ax=ax1, cmap="PiYG", fmt='.2f', vmin=-1, vmax=1)
ax1.set_ylabel('Motivation (sub-construct)', fontstyle='italic', size='large')
ax1.set_xlabel('Pillar', fontstyle='italic', size='large')
ax1.tick_params(axis='x', bottom=False, top=True, labelbottom=False, labeltop=True, size=2)
ax1.xaxis.set_label_position('top')
f.suptitle('Correlation-coefficients*\nMotivation (sub-constructs)\nand Resilience & Stewardship', x=-0.5, y=1.3, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's r\nranging from -1 perfect negative correlation to 1, perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.show()
#plt.savefig(graphs/'motivation_correlations.svg', bbox_inches='tight')



# correlation_plot resilience--> stewardship
f, ax1 = plt.subplots(nrows=1, ncols=1, figsize=(3, 3))
sns.heatmap(res_corr, annot=True,  linewidths=1, ax=ax1, cmap="PiYG", fmt='.2f', vmin=-1, vmax=1)
ax1.set_ylabel('Resilience (sub-construct)', fontstyle='italic', size='large')
ax1.set_xlabel('Pillar', fontstyle='italic', size='large')
ax1.tick_params(axis='x', bottom=False, top=True, labelbottom=False, labeltop=True, size=2)
ax1.xaxis.set_label_position('top')
f.suptitle('Correlation-coefficients*\nResilience (sub-constructs)\nand Stewardship', x=-0.5, y=1.1, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's r\nranging from -1 perfect negative correlation to 1, perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.savefig(graphs/'resilience_correlations.svg', bbox_inches='tight')


###correlations between pillars

#colors for each gen
# hex_values = ['#E70052',  # rood
#               '#F16E22',  # oranje   comparison
#               '#E43989',  # roze     PIP G4
#               '#630235',  # Bordeax   PIP G3
#               '#53297D',  # paars    PIP G2
#               '#0B9CDA',  # blauw    PIP G1
#               '#61A534',  # oxgroen #all pip
#               '#0C884A'  # donkergroen
#               ]


pillarpalette=['#E70052', '#0C884A', '#FBC43A']

#E70052 -red
#0C884A - dark green
#FBC43A - yellow
#FF1D34-deep red


pillar_df = clean[pillars].drop(columns='pip_generation_clean').rename(columns=pillarlabels)
#caclulate correlation cooefficients
corrs=pillar_df.corr()
f=sns.pairplot(pillar_df, kind='reg', corner=True, diag_kind='hist', plot_kws={'line_kws':{'color':'#E70052'}, 'scatter_kws': {'color':'#FBC43A', 's': 3, 'alpha': 0.5}}, diag_kws={'color': '#0C884A', 'bins':10})
#get the offdiagonals to input correlation coefficients (ids are the same)
axs=f.axes
rw=[1,2,2]
clm=[0,0,1]
for r,c in zip(rw,clm):
    #select ax to plot. 
    ax=axs[r,c]
    #get correlation coefficient (same indexing as plot because symmetry)
    r=corrs.iat[r,c]
    #format
    s= 'r = '+ "{:.2f}".format(r)
    ax.text(x=0.2,y=0.9, s=s , ha='center', va='center', color='#E70052', fontstyle='italic', transform=ax.transAxes )
    #make labels bigger
    ax.xaxis.set_label_text(ax.xaxis.get_label_text(),size='large')
    ax.yaxis.set_label_text(ax.yaxis.get_label_text(),size='large')
axs[2,2].xaxis.set_label_text(axs[2,2].xaxis.get_label_text(),size='large')

#for top left plot
axs[0,0].yaxis.set_visible(True)
axs[0,0].spines['left'].set_visible(True)
axs[0,0].yaxis.set_label_text('Motivation (score 0-100)',size='large')
#figtitle and footnotes
fig=plt.gcf()
fig.suptitle('Correlation between pillars:\nScores for motivation, resilience, and stewardship plotted against eachother\nDistributions of scores on diagonals', x=0, y=1.1, ha='left', size='x-large')
plt.figtext(0,-0.1, "r = Pearson's r ranging from -1 perfect negative correlation to 1, perfect positive correlation\nall correlation coefficients significant at p<0.01\nfull sample, n=962", size='small')
plt.savefig(graphs/'pillar_correlations.svg', bbox_inches='tight')


###motivation stewardship & resilience by pip-plan completion



##check by gender of hh head



pillar_gender = clean.loc[:,['motivation_score',
 'resilience_score',
 'stewardship_score_v3',
  'head_type']]

f1=sns.lmplot(x='motivation_score', y= 'resilience_score',  col='head_type', data=pillar_gender)
f2=sns.lmplot(x='resilience_score', y= 'stewardship_score_v3',  col='head_type', data=pillar_gender)

#caclulate correlation cooefficients
#corrs=pillar_df.corr()
f=sns.pairplot(pillar_gender, kind='reg', hue='head_type', corner=True, diag_kind='hist', plot_kws={'line_kws':{'color':'#E70052'}, 'scatter_kws': {'color':'#FBC43A', 's': 3, 'alpha': 0.5}}, diag_kws={'color': '#0C884A', 'bins':10})
#get the offdiagonals to input correlation coefficients (ids are the same)
axs=f.axes
rw=[1,2,2]
clm=[0,0,1]
for r,c in zip(rw,clm):
    #select ax to plot. 
    ax=axs[r,c]
    #get correlation coefficient (same indexing as plot because symmetry)
    r=corrs.iat[r,c]
    #format
    s= 'r = '+ "{:.2f}".format(r)
    ax.text(x=0.2,y=0.9, s=s , ha='center', va='center', color='#E70052', fontstyle='italic', transform=ax.transAxes )
    #make labels bigger
    ax.xaxis.set_label_text(ax.xaxis.get_label_text(),size='large')
    ax.yaxis.set_label_text(ax.yaxis.get_label_text(),size='large')
axs[2,2].xaxis.set_label_text(axs[2,2].xaxis.get_label_text(),size='large')

#for top left plot
axs[0,0].yaxis.set_visible(True)
axs[0,0].spines['left'].set_visible(True)
axs[0,0].yaxis.set_label_text('Motivation (score 0-100)',size='large')
#figtitle and footnotes
fig=plt.gcf()
fig.suptitle('Correlation between pillars:\nScores for motivation, resilience, and stewardship plotted against eachother\nDistributions of scores on diagonals', x=0, y=1.1, ha='left', size='x-large')
plt.figtext(0,-0.1, "r = Pearson's r ranging from -1 perfect negative correlation to 1, perfect positive correlation\nall correlation coefficients significant at p<0.01\nfull sample, n=962", size='small')
plt.savefig(graphs/'pillar_correlations.svg', bbox_inches='tight')





##################3

#pillars by pip completion
cols=[c for c in pillarlabels.keys()]
cols=cols+ ['pip_implemented', 'pip_generation_clean']


compldata=clean.loc[:, cols].dropna(axis=0, how='any', subset=['pip_implemented'])
#rename columns nice labels
pillarlabels['pip_implemented']="% of pip plan completed"
compldata=compldata.rename(columns=pillarlabels)
compldata.columns=([i.replace(' (','\n(') for i in compldata.columns])

complcorr=list(compldata.corr().loc["% of pip plan completed"].iloc[:-2])
scatkws={'color':'#FBC43A', 's': 3, 'alpha': 0.5}


fig, (ax1, ax2, ax3) =plt.subplots(nrows=3, ncols=1, sharex='row', figsize=(3,3*1.61))
for ax,r in zip(fig.axes, complcorr): 
    ax.set_ylim(0,100)
    ax.set_xlim(0, 1)
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))
    ax.xaxis.set_label("% of pip plan completed")
    s=  'r = '+ "{:.2f}".format(r)
    ax.text(x=0.2,y=0.9, s=s , ha='center', va='center', color='#E70052', fontstyle='italic', transform=ax.transAxes )

plt.subplots_adjust(bottom = 0.2, top =1.3, wspace=0.5, left=0.2)

ax1=sns.regplot(x="% of pip plan completed", y='Motivation\n(score 0-100)', order=2,data=compldata, ax=ax1, scatter_kws=scatkws,  line_kws={'color':'#E70052'})
ax2=sns.regplot(x="% of pip plan completed", y='Resilience\n(score 0-100)', order=2,data=compldata, ax=ax2, scatter_kws=scatkws, line_kws={'color':'#E70052'})
ax3=sns.regplot(x="% of pip plan completed", y='Stewardship\n(score 0-100)', order=2,data=compldata, ax=ax3, scatter_kws=scatkws, line_kws={'color':'#E70052'})
#plot correlation coefficients


#titles
ax1.set_title('Pip completion & Motivation')
ax2.set_title('Pip completion & Resilience')
ax3.set_title('Pip completion & Stewardship')

sns.despine()
for axi in fig.axes[:-1]:
    axi.xaxis.set_visible(False) # Hide only x axis

fig.suptitle('Correlation between pip plan completion\nand scores on pillar\nmotivation, resilience, and stewardship', x=0, y=1.5, ha='left', size='x-large')
plt.figtext(0,0, "r = Pearson's r ranging from:\n-1 perfect negative correlation to 1, perfect positive correlation\nall correlation coefficients significant at p<0.01\npip farmers only, n=488", size='small')
plt.savefig(graphs/'pip_completion_corr.svg', bbox_inches='tight')


plt.show()



