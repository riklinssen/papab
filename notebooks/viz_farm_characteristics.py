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
import joypy
from statsmodels.stats.weightstats import DescrStatsW

sns.set_style('white')
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
#graphs=root/"graphs"

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

#switch order of groups (comparison group last)
grouplist[-1], grouplist[-2] = grouplist[-2], grouplist[-1]




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

topleft=fig.axes[0]
topleft.set_ylabel('Farm type', fontstyle='oblique')

botleft=fig.axes[6]
botleft.set_ylabel('% of land owned/rented', fontstyle='oblique')

fig.align_ylabels()

plt.subplots_adjust(hspace=0.2, wspace=0.3)

##footnotes
plt.figtext(0, 0, "Total n=962 \n*Average of all PIP-farmers is computed using sampling weights", size='small',  ha="left") 

plt.savefig(graphs/'descr_farmchars.svg', bbox_inches='tight')



#hectares
sel=farmchars.loc['land_hectares'].reset_index()

#order the same as other plots
sel2=sel.iloc[2:]
sel2=sel2.append(sel.iloc[:2])



fig, ax=plt.subplots(figsize=(3.13,3.13))
sel2['color']=sel2['group'].map(cmapgens)
ax1=ax.bar(height=sel2['prop'], x=sel2['group'], color=sel2['color'])

rects = ax1.patches
# For each bar: Place a label
for rect in rects:
    # Get X and Y placement of label from rect.
    y_value = rect.get_height()
    x_place= rect.get_x()+(rect.get_width()/2)
    y_place = rect.get_height()*1.01
    label = round(y_value,1)
    kleur=rect.get_facecolor()
    ax.text(x_place, y_place, label, horizontalalignment='center', size='small', color=kleur)
for ax in fig.axes: 
    ax.tick_params(axis='x',which= 'major', length=2, labelrotation=90, labelsize='medium', pad=0.05)
    ax.set_ylabel('Average land use (in ha)', fontstyle='oblique')
    ax.set_title('Land use \n(rented + owned), \nby generation')


sns.despine()
plt.figtext(0, -0.1, "Total n=962", size='small',  ha="left") 
plt.savefig(graphs/'descr_farmchars_landuse.svg', bbox_inches='tight')

###pip completion
cleanf=clean/"PAPAB Impact study - Ready for analysis.dta"
clean=pd.read_stata(cleanf)
joyd=clean[['pip_implemented', 'pip_generation_clean']].dropna(how='any')
#n=488

cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22',
            'All PIP* \n (average)': '#61A534'}

# proper labeling
glabeldict_cl={ '5. NON-PIP-COMPARISON GROUP' : 'Comparison \n group',
 '3. PIP-Generation 3': 'G 3',
 '2. PIP-Generation 2' : 'G 2',
 '4. PIP-Generation 4':  'G 4',
 '1. PIP-Generation 1': 'G 1' } 


###cmapgens2={k: v for k in joyd.pip_generation_clean.unique(), v } 
joyd['pip_generation_clean']=joyd['pip_generation_clean'].replace(glabeldict_cl)
joyd['color']=joyd['pip_generation_clean'].map(cmapgens)




fig,axes=joypy.joyplot(joyd, by='pip_generation_clean')#,  color=['#0B9CDA', '#53297D', '#630235','#E43989'])

colors=list(cmapgens.values())

for ax, cl in zip(fig.axes, colors): 
    ax.set_xlim([0,1])
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))
    
data=joyd.set_index('pip_generation_clean').drop(columns='color')


cmap={'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989'} 
groups=list(cmap.keys())
bins=np.linspace(0,1,num=10)
fig=plt.figure(figsize=((3.13,3.13)), constrained_layout=True)
for i, gr in enumerate(groups):
    sel=data.loc[gr]
    ax=plt.subplot(4, 1, i+1)
    sns.distplot(sel['pip_implemented'], hist=True, bins=bins, kde=True,color=cmap[gr])
    ax.set_title(gr, color=cmap[gr], loc='left')
    # xaxis
    ax.set_xlim([0,1])
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))
    ax.xaxis.set_visible(False)
    ax.grid(False)
       
    # yaxis
    ax.yaxis.set_visible(False)

    ax.spines['left'].set_visible(False)
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(True) 
    if i==3: 
        ax.xaxis.set_visible(True)
        ax.tick_params(which='x', direction='out', bottom=True, size=6, width=2) # can't make ticks visible check later
        ax.set_xlabel("% of plan completed \n(in % 0-100)")
        ax.grid(False)


plt.subplots_adjust(hspace=0.6)
plt.figtext(0, -0.05, "Total n=962" , size='small',  ha="left") 
plt.suptitle("Integrated Farm-management plan completion\nby generation", y=1.1)
plt.savefig(graphs/'descr_pip_compl_bygen.svg', bbox_inches='tight')
fig.tight_layout()
fig.show()


