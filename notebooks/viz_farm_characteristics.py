import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import matplotlib.ticker as mtick
import matplotlib.cm
from matplotlib.dates import DateFormatter
import matplotlib.patches as mpatches
import matplotlib.gridspec as gridspec
import matplotlib.dates as mdates
import datetime
from pathlib import Path
import re
from statsmodels.stats.weightstats import DescrStatsW


#utils/funcs

def grouped_weights_statsdf(df, statscols, groupbycol, weightscol):
    """generates df with weighted means and 95% CI by groupbycol for cols in statscols
    

    Parameters
    ----------
    df : df
        df to be weigthed
    statscols : list
        cols/outcomes for weigthed stats
    groupbycol : str
        column name in df that defines groups 
    weightscol : str
        column name in df with weigths 
              
    
    Returns
    -------
    df
        multi-indexed df with outcome and groups as index
        stats generated: weighted mean, upper bound (95 CI), lower bound (95% CI), weighted n by group, total n unweighted

    """    
    alldata=pd.DataFrame()
    for c in statscols: 
        cdf=df.dropna(subset=[c])
        nrobs=len(cdf)
        grouped=cdf.groupby(groupbycol)
        stats={}
        means=[]
        lower=[]
        upper=[]
        nrobs_gr=[]
        groups=list(grouped.groups.keys())
        for gr in groups:
            stats=DescrStatsW(grouped.get_group(gr)[c], weights=grouped.get_group(gr)[weightscol], ddof=0)
            means.append(stats.mean)
            lower.append(stats.tconfint_mean()[0])
            upper.append(stats.tconfint_mean()[1])
            nrobs_gr.append(stats.nobs)          
        weightedstats=pd.DataFrame([means, lower, upper, nrobs_gr], columns=groups, index=['weighted mean', 'lower bound', 'upper bound', 'wei_n__group']).T
        weightedstats['tot_n_unweigthed']=nrobs
        weightedstats['outcome']=c
        weightedstats.index.name='groups'
        colstats=weightedstats.reset_index()
        colstats=colstats.set_index(['outcome', 'groups'])
        alldata=pd.concat([alldata, colstats])
               
    return alldata





def remove(list):
    """remove digits and periods in list, strip  & capitalize
    """     
    pattern = '[0-9.]'
    p = [re.sub(pattern, '', i) for i in list]
    l=[i.strip().capitalize() for i in p]
    return l



#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"
graphs=root/"graphs"
descr=pd.read_excel(interim/"PAPAB Impact study - SocioDemographics.xlsx", names=['variable', 'group', 'mean', 'se', 'ci_lowerbound', 'ci_upperbound', 'n'], index_col=0)

descr_labels=pd.read_excel(interim/"PAPAB Impact study - SocioDemographics Labeldict.xlsx", names=['var', 'label'])
#make dict for readable categories
varl=remove(list(descr_labels.label))
descr_d = dict(
    zip(
        list(descr_labels.iloc[:, 0]), varl))
descr_labels['var']=descr_labels['var'].replace(descr_d)






#farm chars
chars=['r_inc_farm_farm', 'land_hectares', 'land_plots', 'farmtype1', 'farmtype2', 'farmtype3', 'land_own','land_rent', 'land_communal', 'pip_implemented']

farmchars=(
    descr.loc[chars, ['group','mean']]
    .rename(columns={'mean': 'prop'})
    .assign(category=lambda x: x.index.map(descr_d)) #add descriptive labels
    ) 


#categories to outcome variables

ovar=[c for c in farmchars['category'].unique()]
nvar=['r_inc_farm_farm',
 'land_hectares',
 'land_plots',
 'farmtype',
 'farmtype',
 'farmtype',
 'land_ownership',
 'land_ownership',
 'land_ownership', 
 'pip_implemented']
farmchars['outcome']=farmchars['category'].map(dict(zip(ovar, nvar)))

#mapping groupnames/generation titles for graphs
# proper labeling
newlabels=['G 1',
            'G 2',
            'G 3',
            'G 4',
            'Comparison \n group',
            'All PIP* \n (average)']
glabeldict = dict(zip([c for c in farmchars['group']], newlabels)) # for group labels from descriptives set
farmchars['group']=farmchars['group'].map(glabeldict)


#remove negligible categories (very small percentages for farmtype2 (animal keeping only) & land_communal	


farmchars=farmchars.loc[~farmchars.index.isin(['land_communal', 'farmtype2'])]



farmchars=pd.pivot_table(farmchars, index=['outcome', 'group', 'category'], values='prop' ).sort_index()


grouplist=newlabels




#colormap for generations
cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22',
            'All PIP* \n (average)': '#61A534'}


##############

fig, ax=plt.subplots(nrows=2, ncols=6, sharex='col', sharey='row', figsize=(6.26,6.26))

topr=fig.axes[:6]
#plot the farmtypes on top row
for ax, gr in zip(topr, grouplist):
    sel=farmchars.loc[('farmtype', gr)]
    ax.barh(y=sel.index, width=sel['prop'], color=cmapgens[gr])
    ax.set_title(gr, color=cmapgens[gr])

#share of land owned/rented
botr=fig.axes[6:]
#plot
for ax, gr in zip(botr, grouplist): 
    sel=farmchars.loc[('land_ownership', gr)]
    ax.barh(y=sel.index, width=sel['prop'], color=cmapgens[gr])

#ticks for upper ax removed
for l in [topr, botr]: 
    for ax in l:
        ax.tick_params(axis='x',which= 'major', length=0, labelsize=0)
        ax.tick_params(axis='y',which= 'major', length=0)

        ax.spines['left'].set_visible(True)
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.spines['bottom'].set_visible(False)

        rects = ax.patches
        # For each bar: Place a label
        for rect in rects:
            # Get X and Y placement of label from rect.
            x_value = rect.get_width()
            x_place= rect.get_width()+0.03
            y_value = rect.get_y() + rect.get_height() / 2
            label = "{:.0%}".format(x_value)
            kleur=rect.get_facecolor()
            ax.text(x_place, y_value, label, verticalalignment='center', size='small', color=kleur)

#bottom axs
for ax in botr:
    ax.set_xlim([0,1])
    ax.xaxis.set_major_locator(plt.MaxNLocator(2))
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))

    ax.tick_params(axis='x',which= 'major', length=2, labelrotation=90, labelsize='medium', pad=0.05)


    ax.spines['left'].set_visible(True)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(True)

    rects = ax.patches
# For each bar: Place a label
    for rect in rects:
        # Get X and Y placement of label from rect.
        x_value = rect.get_width()
        x_place= rect.get_width()+0.03
        y_value = rect.get_y() + rect.get_height() / 2
        label = "{:.0%}".format(x_value)
        kleur=rect.get_facecolor()
        ax.text(x_place, y_value, label, verticalalignment='center', size='small', color=kleur)


##footnotes
plt.figtext(0, 0, "Total n=962 \n*Average of all PIP-farmers is computed using sampling weights", size='small',  ha="left") 
