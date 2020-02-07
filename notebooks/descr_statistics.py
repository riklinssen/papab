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





#var and valuelables
#vallabsf=r"C:\Users\RikL\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean\ValueLabels_PAPAB.xls"
#varlabsf=r"C:\Users\RikL\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\2. Clean\VariableLabels_PAPAB.xlsx"

#tables for descriptives sociodemographics -->descr



#descriptive stats --> respondent characteristics

#make % for men

respgender=descr.loc[['female'],['group','mean']]
respgender['men']=1-respgender['mean']
respgender.set_index(['group'], inplace=True)
respgender.columns=['Men', 'Women']
respgender=pd.DataFrame(respgender.stack())
respgender.columns=['prop']


respgender=respgender.rename(columns={'level_1': 'category'})

# make educ with cats in col
educcats=[c for c in descr.index if 'educ_cat' in c]
respeduc=descr[descr.index.isin(educcats)][['group', 'mean']]

# rows to cols pivot
#
respeduc=pd.pivot_table(respeduc, index=['group', 'variable']).reset_index()




##agecategories with weighted stats
# load in clean data

clean=pd.read_stata(clean/"PAPAB Impact study - Ready for analysis.dta")

#  
ages_df=clean.loc[:,['age','pip_generation_clean','weight_generation', 'weight_generation_inv']]
print(ages_df.age.isna().sum()) # no missing values
bins = [0, 24, 34, 44, 54, 64, np.inf]
names = ['<24', '25-34', '35-44', '45-54', '55-64', '65+']
ages_df['agerange'] = pd.cut(ages_df['age'], bins, labels=names)
ages_dum=pd.get_dummies(ages_df['agerange'])

ages_df=pd.concat([ages_df, ages_dum], axis=1,sort=False)

#now aggregate averages across cats + a weight for all pip

ages_df_allpip=ages_df.loc[ages_df['pip_generation_clean'] != '5. NON-PIP-COMPARISON GROUP']
ages_df_allpip['group']='PIP - All generations (weighted)'
ages_df_allpip_wt=grouped_weights_statsdf(ages_df_allpip, names, 'group', 'weight_generation_inv').reset_index().pivot(index='groups', columns='outcome', values='weighted mean').reset_index()
ages_df_allpip_wt.rename(columns={'groups': 'group'}, inplace=True)



#make set for non weighted ages

respage=ages_df.groupby('pip_generation_clean')[names].mean().reset_index().rename(columns={'pip_generation_clean': 'group'})

#append weighted stats
respage=respage.append(ages_df_allpip_wt.iloc[0,:],sort=False).reset_index(drop=True)
respage.set_index('group', inplace=True)
respage=pd.DataFrame(respage.stack())
respage.columns=['prop']
respage.reset_index(inplace=True)
respage=respage.rename(columns={'level_1': 'category'})


# proper labeling
newlabels=['G 1',
            'G 2',
            'G 3',
            'G 4',
            'Comparison \n group',
            'All PIP* \n (average)']
glabeldict = dict(zip([c for c in gender['group']], newlabels)) # for group labels from descriptives set
glabeldict_cl=dict(zip([c for c in respage['group'].unique()], newlabels))  # for group labels from clean data


#make similar labels across resp dfs
respgender.reset_index(drop=False, inplace=True)
respgender.columns=['group', 'category', 'prop']
respgender['group']=respgender['group'].map(glabeldict)

respeduc['group']=respeduc['group'].map(glabeldict)

respage['group']=respage['group'].map(glabeldict_cl)

#label categories
respeduc['category']=respeduc['variable'].map(descr_d)



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

cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22',
            'All PIP* \n (average)': '#61A534'}


#add colors 
respgender['color']=respgender['group'].map(cmapgens)
respeduc['color']=respeduc['group'].map(cmapgens)
respage['color']=respage['group'].map(cmapgens)


respeduc.columns=['group', 'variable', 'prop', 'category', 'color']





#groupslist to iterate over

grouplist=list(respgender['group'].unique())
#switch the order (comparison group last)
grouplist[-1], grouplist[-2] = grouplist[-2], grouplist[-1]



####################descriptive statistics respondents###################


fig, ((ax1, ax2, ax3, ax4, ax5, ax6), (ax7, ax8, ax9, ax10, ax11, ax12), (ax13, ax14, ax15, ax16, ax17, ax18))=plt.subplots(nrows=3, ncols=6, sharex='col', sharey='row', figsize=(6.26,6.26))
#gender
genderax=fig.axes[:6]
for ax, gr in zip(genderax, grouplist): 
    sel=respgender.loc[respgender['group']==gr]
    ax.barh(y=sel['category'], width=sel['prop'], color=cmapgens[gr])
    ax.set_title(gr, color=cmapgens[gr])



#educ
educax=fig.axes[6:12]
for ax, gr in zip(educax, grouplist):
        sel=respeduc.loc[respeduc['group']==gr]
        ax.barh(y=sel['category'], width=sel['prop'], color=cmapgens[gr])

#age
ageax=fig.axes[12:]
for ax, gr in zip(ageax, grouplist):
        sel=respage.loc[respage['group']==gr]
        ax.barh(y=sel['category'], width=sel['prop'], color=cmapgens[gr])
    
#labels on y axis:
ax1.set_ylabel('Gender', fontstyle='oblique')
ax7.set_ylabel('Education', fontstyle='oblique')
ax13.set_ylabel('Age categories', fontstyle='oblique')
fig.align_ylabels()




#ticks for upper ax removed
for l in [genderax, educax]: 
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
            x_place= rect.get_width()*1.1
            y_value = rect.get_y() + rect.get_height() / 2
            label = "{:.0%}".format(x_value)
            kleur=rect.get_facecolor()
            ax.text(x_place, y_value, label, verticalalignment='center', size='small', color=kleur)

#bottom axs
for ax in ageax:
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
        x_place= rect.get_width()*1.1
        y_value = rect.get_y() + rect.get_height() / 2
        label = "{:.0%}".format(x_value)
        kleur=rect.get_facecolor()
        ax.text(x_place, y_value, label, verticalalignment='center', size='small', color=kleur)


##footnotes
plt.figtext(0, 0, "Total n=962 \n*Average of all PIP-farmers is computed using sampling weights", size='small',  ha="left") 


plt.subplots_adjust(hspace=0.05, wspace=0.3)

plt.savefig(graphs/'descr_resp.pdf', bbox_inches='tight')

#######################################


####################PREP for Farm characteristics###################



#farm chars
descr
chars=['r_inc_farm_farm', 'land_hectares', 'land_plots', 'farmtype1', 'farmtype2', 'farmtype3', 'land_own','land_rent', 'land_communal', 'pip_implemented']


farmchars=(
    descr[descr['variable'].isin(chars)]
    .rename(columns={'variable':'category', 'mean': 'prop'})
    .filter(['category','group','prop'])
    .assign(outcome=lambda x: x.category.replace(['farmtype1','farmtype2', 'farmtype3'], (['farmtype']*3)))
    .
)
    

])
            'farmtype1': 'farmtype',
            'farmtype2' : 'farmtype',
            'farmtype3' :  'farmtype',



        }
        ))
    )

        
color_filter=lambda x: np.where((x.hue > 1) & (x.ci > 7), 1, 0)
)))
    )





farmchars=descr.loc[descr.index.isin(chars), ['group', 'mean']].reindex()
farmchars.reset_index(inplace=True)

#variable col is weird
farmchars=farmchars.rename(columns={'variable':'category', 'mean': 'prop'})
ovar=[c for c in farmchars['category'].unique()]
nvar=['r_inc_farm_farm',
 'land_hectares',
 'land_plots',
 'land_ownership',
 'land_ownership',
 'land_ownership',
 'farmtype',
 'farmtype',
 'farmtype',
 'pip_implemented']
farmchars['outcome']=farmchars['category'].map(dict(zip(ovar, nvar)))
#mapping cats and groupnames

farmchars['category']=farmchars['category'].map(descr_d)
farmchars['group']=farmchars['group'].map(glabeldict)


farmchars=pd.pivot_table(farmchars, index=['outcome', 'group', 'category'], values='prop' ).sort_index()



##############

fig, ax=plt.subplots(nrows=2, ncols=6, sharex='col', sharey='row', figsize=(6.26,6.26))

topr=fig.axes[:6]
#plot the farmtypes on top row
for ax, gr in zip(topr, grouplist):
    sel=farmchars.loc[('farmtype', gr)]
    ax.barh(y=sel.index, width=sel['prop'], color=cmapgens[gr])
    ax.set_title(gr, color=cmapgens[gr])


    #plot
for ax, gr in zip(genderax, grouplist): 
    sel=respgender.loc[respgender['group']==gr]
    ax.barh(y=sel['category'], width=sel['prop'], color=cmapgens[gr])
    ax.set_title(gr, color=cmapgens[gr])

botr=fig.axes[7:]
for ax in botr: 
    #plot



#make a dict with vars to cats (merging some cats in to a single var)

# plt.clf()
# print(genderax)

# ###
# import matplotlib.pyplot as plt
# import matplotlib.gridspec as gridspec

# fig = plt.figure()

# gs1 = gridspec.GridSpec(5, 5)
# countries = ["Country " + str(i) for i in range(1, 26)]
# axs = []
# for c, num in zip(countries, range(1,26)):
#     axs.append(fig.add_subplot(gs1[num - 1]))
#     axs[-1].plot([1, 2, 3], [1, 2, 3])

# plt.show()


# # However, to answer your question, you'll need to create the subplots at a slightly lower level to use gridspec. If you want to replicate the hiding of shared axes like subplots does, you'll need to do that manually, by using the sharey argument to Figure.add_subplot and hiding the duplicated ticks with plt.setp(ax.get_yticklabels(), visible=False).

# #As an example:

# import matplotlib.pyplot as plt
# from matplotlib import gridspec

# fig = plt.figure()
# gs = gridspec.GridSpec(1,2)
# ax1 = fig.add_subplot(gs[0])
# ax2 = fig.add_subplot(gs[1], sharey=ax1)
# plt.setp(ax2.get_yticklabels(), visible=False)

# plt.setp([ax1, ax2], title='Test')
# fig.suptitle('An overall title', size=20)
# gs.tight_layout(fig, rect=[0, 0, 1, 0.97])

# plt.show()
