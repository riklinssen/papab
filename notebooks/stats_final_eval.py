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
from pandas.api.types import CategoricalDtype


import seaborn as sns
from matplotlib.dates import DateFormatter
from statsmodels.stats.weightstats import DescrStatsW
# calculate and visualise indicators neccesary for the final evaluation of PAPAB
# disaggregation neccesary: The disaggregation required is (1) PIP farmers; (2) farmers who don’t have a PIP; and (3) both of them
# For each group, we will be interested also to have a gender disaggregation

# paths
root = Path.cwd()
interim = root/"data"/"interim"
clean = root/"data"/"clean"
graphs = root/"graphs"

cleaned = pd.read_stata(
    clean/"PAPAB Impact study - Ready for analysis.dta", index_col='id')


# disaggr dummy's
cleaned['total'] = 'total'
# map gender for nice categories
cleaned['gender'] = cleaned['female'].map({'Yes': 'Women', 'No': 'Men'})
cleaned['pip_g'] = cleaned['pip_generation_clean'].map({'1. PIP-Generation 1': 'G 1',
                                                        '2. PIP-Generation 2': 'G 2',
                                                        '3. PIP-Generation 3': 'G 3',
                                                        '4. PIP-Generation 4': 'G 4',
                                                        '5. NON-PIP-COMPARISON GROUP': 'Non-PIP'})

disag = ['pip_g', 'gender', 'total']
data = cleaned.loc[:, disag]

# GL 1.a: The proportion of households that report an improvement in average annual income,
# Q pip_improvedecon   The PIP plan has improved the economic situation of my household
# % agree or strongly agree

remap_cat_agr = {
    'Strongly disagree': 0,
    'Somewhat disagree': 0,
    'Neither agree/disagree': 0,
    'Somewhat agree': 1,
    'Strongly agree': 1,
    np.NaN: np.NaN}

remap_cat_higher = {'Much higher': 1,
                    'Higher': 1,
                    'The same': 0,
                    'Lower': 0,
                    'Much lower': 0,
                    np.NaN: np.NaN}


percent = ['pip_improvedecon', 'r_inc_nonfarm_change_other',
           'r_inc_farm_change_agrlivestock', 'group', 'nogroup_interest']

for c in percent:
    data[c] = cleaned[c]

# remap into proportions agree/disagree
data['pip_improvedecon'] = data['pip_improvedecon'].map(remap_cat_agr)
# lower/higher
for c in ['r_inc_nonfarm_change_other', 'r_inc_farm_change_agrlivestock']:
    data[c] = cleaned[c].map(remap_cat_higher)
# yes/no
for c in ['group']:
    data[c] = cleaned[c].cat.codes

# group interest
for c in ['nogroup_interest']:
    data[c] = cleaned[c].cat.codes.map({0: 1, 1: 0, -1: np.NaN })


#radio show dummy's
dums=pd.get_dummies(cleaned['radio_mboniyongana'], dummy_na=False)
dums.columns=['r_listen', 'r_know', 'r_dontknow']
data=pd.concat([data, dums], axis=1)

percent.append('r_listen')
percent


####################other functionalities colors + labels

titles = ['Total', 'by gender', 'by pip generation',
          'by gender X\npip generation']

cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22'}
gendercolors = ['#61A534', '#FBC43A']  # oxgroen yellow


def labelperc(ax, xpos='center'):
    """
    Attach a text label above each bar in *ax*, displaying its height.

    *xpos* indicates which side to place the text w.r.t. the center of
    the bar. It can be one of the following {'center', 'right', 'left'}.
    """
    xpos = xpos.lower()  # normalize the case of the parameter
    ha = {'center': 'center', 'right': 'left', 'left': 'right'}
    offset = {'center': 0.5, 'right': 0.57, 'left': 0.43}  # x_txt = x + w*off
    bars = ax.patches
    for bar in bars:
        height = bar.get_height()
        heightp = format(bar.get_height(), ".0%")
        if height > 0.5:
            ax.text(bar.get_x() + bar.get_width()*offset[xpos], height*0.5,
                    '{}'.format(heightp), ha=ha[xpos], va='bottom', color='white', alpha=1, size='x-small', rotation=90,)
        if height <= 0.5:
            ax.text(bar.get_x() + bar.get_width()*offset[xpos], height*1.1,
                    '{}'.format(heightp), ha=ha[xpos], va='bottom', color=bar.get_facecolor(), alpha=1, size='x-small', rotation=90)


###suptitles
suptitle_dict={ 'pip_improvedecon': "% of household who improved their living environment\n(pip-only)",
 'r_inc_nonfarm_change_other': "% of households who report non-farm income sources are (much) higher\npast 3 years",
 'r_inc_farm_change_agrlivestock': "% of households who report farm income sources are (much) higher\n past 3 years",
 'group': "% of households who are associated in a group",
 'nogroup_interest': "% of non-associated households who are interested in associating in a group",
 'r_listen': "% of households who have listened to radio mboniyongana"}

####################plot_loop#####################
for ind in percent: 
    # totals
    totals = pd.DataFrame(data.groupby(
        'total')[ind].mean()).reset_index()
    # by gender
    gender = pd.DataFrame(data.groupby('gender')[
                        ind].mean()).reset_index()
    # by generation
    generation = pd.DataFrame(data.groupby(
        'pip_g')[ind].mean()).reset_index()
    # by gender*generation
    generationgender = pd.DataFrame(data.groupby(['pip_g', 'gender'])[
                                    ind].mean()).reset_index()





    fig, (ax1, ax2, ax3, ax4) = plt.subplots(nrows=1, ncols=4,
                                            sharey='row',  gridspec_kw=ratios, figsize=(6, 3.3))
    # plot data
    sns.barplot(x="total", y=ind,
                data=totals, ax=ax1, color='black')
    sns.barplot(x="gender", y=ind,
                data=gender, ax=ax2, palette=gendercolors)
    sns.barplot(x="pip_g", y=ind, data=generation,
                ax=ax3, palette=cmapgens.values())
    sns.barplot(x="pip_g", y=ind, hue='gender',
                data=generationgender, ax=ax4, palette=gendercolors)
    ax4.legend(bbox_to_anchor=(0, -0.4, 0, -0.4), loc='lower left',
            ncol=1, mode="expand", borderaxespad=0.)
    # titles, yaxisformatter, y-x-axis labels
    for (ax, title) in zip(fig.axes, titles):
        ax.set_title(title, fontsize='small', ha='center')
        sns.despine(ax=ax)
        ax.set_ylabel(None)
        ax.set_xlabel(None)
        ax.yaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))

        # add labels.
        labelperc(ax)
        # rotatet ticks
        for tick in ax.get_xticklabels():
            tick.set_rotation(45)

    # suptitle
    fig.suptitle(x=0.5, y=1.10, t=suptitle_dict[ind])
    #footnotes
    if ind != 'r_listen':
        n=len(cleaned[ind].dropna())
    if ind == 'r_listen': 
        n=len(cleaned['radio_mboniyongana'])
    
    plt.figtext(x=0, y=-0.3,s="Source: PIP-impact study, n="+ str(n), fontsize='small', fontstyle='italic', fontweight='light', color='gray')

    #filename
    filename=graphs/"FE_{}.png".format(ind)

    fig.savefig(filename, dpi=300, facecolor='w', bbox_inches='tight')

