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
f.suptitle('Correlation-coefficients*\nMotivation (sub-constructs)\nand Resilience & Stewardship', x=-0.5, y=1.1, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's $\\rho$\nranging from -1-perfect negative correlation to-1-perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.savefig(graphs/'motivation_correlations')



# correlation_plot resilience--> stewardship
f, ax1 = plt.subplots(nrows=1, ncols=1, figsize=(3, 3))
sns.heatmap(res_corr, annot=True,  linewidths=1, ax=ax1, cmap="PiYG", fmt='.2f', vmin=-1, vmax=1)
ax1.set_ylabel('Resilience (sub-construct)', fontstyle='italic', size='large')
ax1.set_xlabel('Pillar', fontstyle='italic', size='large')
ax1.tick_params(axis='x', bottom=False, top=True, labelbottom=False, labeltop=True, size=2)
ax1.xaxis.set_label_position('top')
f.suptitle('Correlation-coefficients*\nResilience (sub-constructs)\nand Stewardship', x=-0.5, y=1.1, ha='left')
plt.figtext(-0.5,-0.1, "* Pearson's $\\rho$\nranging from -1-perfect negative correlation to-1-perfect positive correlation\nDarker green represents stronger positive correlation\nDarker purple represent stronger negative correlation\nall cofficients significant at p<0.01", size='x-small')
plt.savefig(graphs/'resilience_correlations')


##################3
#see if motivation, resilience stewardship changes with plan implemented


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

