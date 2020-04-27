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
    'stewardship_score_v2', 'pip_generation_clean']
cleanf = clean/"PAPAB Impact study - Analysis2 Incl Factors.dta"


clean = pd.read_stata(cleanf, convert_categoricals=False)

# correlations between pillars (raw)
pillars = ['motivation_score', 'resilience_score',
    'stewardship_score_v2', 'pip_generation_clean']
pillarlabels = {'motivation_score': 'Motivation (score 0-100)',
        'resilience_score': 'Resilience (score 0-100)',
        'stewardship_score_v2': 'Stewardship (score 0-100)'}

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
pils=['resilience_score', 'stewardship_score_v2']
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
                                          'stewardship_score_v2': 'Stewardship'}).sort_values(by='Resilience', ascending=False)

#same for resilience --> stewardship
res_sub=['resilience_pr1', 
'resilience_pr2',
'resilience_pr3']
pils2=['stewardship_score_v2']
rescols=res_sub+pils2

res=clean.loc[:, rescols]
res_corr=pd.DataFrame(res.corr()).loc[res_sub,pils2]
res_corr = res_corr.rename(index={'resilience_pr1': 'Crop diversity',
                                  'resilience_pr2': 'HH-resilience & coping ability',
                                  'resilience_pr3': 'Livestock situation'}, 
                                  columns={'stewardship_score_v2': 'Stewardship'}).sort_values(by='Stewardship', ascending=False)
# correlation_plot motivation--> stewardship AND resilience

sns.set_style('ticks')
f, ax1 = plt.subplots(nrows=1, ncols=1, figsize=(3, 3))
sns.heatmap(motiv_corr, annot=True,  linewidths=1, ax=ax1, cmap="PiYG", fmt='.2f', vmin=-1, vmax=1)
ax1.set_ylabel('Motivation (sub-construct)', fontstyle='italic', size='large')
ax1.set_xlabel('Pillar', fontstyle='italic', size='large')
ax1.tick_params(axis='x', bottom=False, top=True, labelbottom=False, labeltop=True, size=2)
ax1.xaxis.set_label_position('top')
f.suptitle('Correlation-coefficients*\nMotivation (sub-constructs)\nand Resilience & Stewardship', x=-0.5, y=1.3, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's r\ranging from -1 perfect negative correlation to 1, perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.savefig(graphs/'motivation_correlations.svg')



# correlation_plot resilience--> stewardship
f, ax1 = plt.subplots(nrows=1, ncols=1, figsize=(3, 3))
sns.heatmap(res_corr, annot=True,  linewidths=1, ax=ax1, cmap="PiYG", fmt='.2f', vmin=-1, vmax=1)
ax1.set_ylabel('Resilience (sub-construct)', fontstyle='italic', size='large')
ax1.set_xlabel('Pillar', fontstyle='italic', size='large')
ax1.tick_params(axis='x', bottom=False, top=True, labelbottom=False, labeltop=True, size=2)
ax1.xaxis.set_label_position('top')
f.suptitle('Correlation-coefficients*\nResilience (sub-constructs)\nand Stewardship', x=-0.5, y=1.1, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's r\nranging from -1 perfect negative correlation to 1, perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.savefig(graphs/'resilience_correlations.svg')


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
    s= 'r = '+ '{:.2f}'.format(r)
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
plt.savefig(graphs/'resilience_correlations.svg', bbox_inches='tight')



##check by gender of hh head



pillar_gender = clean.loc[:,['motivation_score',
 'resilience_score',
 'stewardship_score_v2',
  'head_type']]

f1=sns.lmplot(x='motivation_score', y= 'resilience_score',  col='head_type', data=pillar_gender)
f2=sns.lmplot(x='resilience_score', y= 'stewardship_score_v2',  col='head_type', data=pillar_gender)

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
    s= 'r = '+ '{:.2f}'.format(r)
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
plt.savefig(graphs/'resilience_correlations.svg', bbox_inches='tight')





##################3
#see if motivation, resilience stewardship changes with plan implemented

#pillars by pip completion
cols=[c for c in pillarlabels.keys()]
cols=cols+ ['pip_implemented', 'pip_generation_clean']


compldata=clean.loc[:, cols].dropna(axis=0, how='any', subset=['pip_implemented'])

#rename columns nice labels
compldata=compldata.rename(columns=pillarlabels)
fig, ((ax1, ax2), (ax3, ax4), (ax5, ax6))=plt.subplots(nrows=3, ncols=2)
sns.regplot(x='pip_implemented', y='Motivation (score 0-100)', order=1, data=compldata, ax=ax1, scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
sns.regplot(x='pip_implemented', y='Motivation (score 0-100)', order=2,data=compldata, ax=ax2,  scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
sns.regplot(x='pip_implemented', y='Resilience (score 0-100)', order=1,data=compldata, ax=ax3,  scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
sns.regplot(x='pip_implemented', y='Resilience (score 0-100)', order=2,data=compldata, ax=ax4,  scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
sns.regplot(x='pip_implemented', y='Stewardship (score 0-100)', order=1,data=compldata, ax=ax5,  scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
sns.regplot(x='pip_implemented', y='Stewardship (score 0-100)', order=2,data=compldata, ax=ax6,  scatter_kws={'alpha':0.5}, line_kws={'color':'red'})
for ax in fig.axes: 
    ax.set_ylim((0,100))
plt.show()

# pip generation not loaded as category change array to categories
genmap = {k: v for k, v in zip([v for v in range(1, 5)], cmapgens.keys())}
genmap[5] = 'Comparison \n group'
genmap
# stewardship score read in as category
pillar_df = clean[pillars]
#catorder
catorder=pd.CategoricalDtype(categories=list(genmap.values()), ordered=True)
pillar_df['generation'] = pillar_df['pip_generation_clean'].map(genmap).astype(catorder)
pillar_df=pillar_df.drop(columns=['pip_generation_clean'])
# colors for generations.
genplotpalette = [clr for clr in list(cmapgens.values())[:-1]]

sns.set_palette(sns.color_palette(genplotpalette))
fig, axs = plt.subplots(nrows=1, ncols=)

###motivation score--> resilience by generation
mot_reli = sns.lmplot(x="motivation_score", y="resilience_score", col='generation',
               hue='generation', data=pillar_df, scatter_kws={"alpha": 0.2}, height=3.5, aspect=3.5/5).set_axis_labels('Motivation (score 0-100)', 'Resilience (score 0-100)')

fig=plt.gcf()
axs=fig.axes
for ax, title, c in zip(axs,list(genmap.values()),genplotpalette): 
    ax.set_title(title, color=c), 
plt.show(fig)


## motivation score--> stewardship by generation
mot_stew = sns.lmplot(x="motivation_score", y="stewardship_score_v2", col='generation',
               hue='generation', data=pillar_df, scatter_kws={"alpha": 0.2}, height=3.5, aspect=3.5/5).set_axis_labels('Motivation (score 0-100)', 'Stewardship (score 0-100)')

fig=plt.gcf()
axs=fig.axes
for ax, title, c in zip(axs,list(genmap.values()),genplotpalette): 
    ax.set_title(title, color=c), 
plt.show(fig)

fig.suptitle('suptitle')
plt.show()

## stewardship score--> reilience by generation
res_stew = sns.lmplot(x="resilience_score", y="stewardship_score_v2", col='generation',
               hue='generation', data=pillar_df, scatter_kws={"alpha": 0.2}, height=3.5, aspect=3.5/5).set_axis_labels('Resilience (score 0-100)', 'Stewardship (score 0-100)')

fig=plt.gcf()
axs=fig.axes
for ax, title, c in zip(axs,list(genmap.values()),genplotpalette): 
    ax.set_title(title, color=c), 
fig.suptitle('suptitle')
plt.show(fig)

fig.suptitle('suptitle')
plt.show()

test=pillar_df['generation']!='Comparison \n group']
nocomp=pillar_df['generation'!='Comparison \n group']
pillar_gens=pillar_df.loc[
sns.lmplot(x="motivation_score",  y="stewardship_score_v2", data=pillar_df.loc[pillar_df['generation']!='Comparison \n group'], hue='generation' )

sns.lmplot(x="motivation_score",  y="stewardship_score_v2", data=pillar_df)

