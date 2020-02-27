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

#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"
graphs=root/"graphs"



vallabelfilename=interim/"ValueLabels_PAPAB.xls"
varlabelfilename=interim/"VariableLabels_PAPAB.xlsx"


vallabs=pd.read_excel(vallabelfilename, header=None, names=['labelname', 'value', 'valuelabel'])
varlabs=pd.read_excel(varlabelfilename, usecols=['name', 'vallab', 'varlab']).dropna(subset=['vallab'])


#resultsset
csvfiles = glob.glob("data\interim\*.csv")
dflist=[]
pillars=['motivation', 'stewardship', 'resilience']
for f in csvfiles: 
    name=f[13:17] # # pip_ =allpip
    pillar=[ p for p in pillars if p in f]
    df=((pd.read_csv(f, sep=';', decimal=',', header=0))
    .assign(pillar=lambda x: pillar[0])
    .rename(columns=str.lower)
    .assign(category_nr=lambda x: name) # add generations
    .assign(generation=lambda x: x['category_nr'].map({
         'pip1': 'G 1', 
         'pip2': 'G 2',
         'pip3': 'G 3',
         'pip4': 'G 4',
         'pip_': "All PIP* \n (average)"
         })) 
         #add pillar

          )
    dflist.append(df)


results=pd.concat(dflist, ignore_index=True)


#rename varlabs or ease referencings later
varlabs.columns=['name', 'vallab', 'titles']

missingvals=[77,88,99]
#drop missing values
vallabs=vallabs.loc[~vallabs.value.isin(missingvals)]

labelnames=vallabs.labelname.unique()

labelset=[]
#telkens een rij er bij 
for label in labelnames:
    #select relevant rows in vallabs df
    sel=vallabs.loc[vallabs['labelname']==label]
    #get index of min and max values (in case these are not sorted)
    low=sel['value'].idxmin()
    high=sel['value'].idxmax()
    #then select the value and the label
    yminv=sel.loc[low,'value']
    yminl=sel.loc[low,'valuelabel']
    ymaxv=sel.loc[high, 'value']
    ymaxl=sel.loc[high,'valuelabel']
    #add the varname as wel
    labelset.append([label, yminv, yminl, ymaxv, ymaxl])    

vallabelset=pd.DataFrame(labelset, columns=['vallab', 'yminv', 'yminl', 'ymaxv', 'ymaxl'])

# remove the ymin and ymax values
for v, l in zip(['yminv', 'ymaxv'],['yminl', 'ymaxl']): 
    vallabelset[l]=vallabelset[l].str.replace('\d+', '')
    vallabelset[l]=vallabelset[v].astype(str)+vallabelset[l] 




plotlabels=pd.merge(left=varlabs, right=vallabelset, left_on=['vallab'], right_on=['vallab'] )


plotlabels_figs=plotlabels.loc[plotlabels.name.isin(results.name)]
plotlabels_figs.rename(columns={'name':'resultvar'}, inplace=True )

plotlabels_f_dict=plotlabels_figs.set_index('resultvar').to_dict(orient='index')



###############
#errorsbar
results['err']=results['ub']-results['mean']
#colors
cmapgens = {'G 1': '#0B9CDA',
            'G 2': '#53297D',
            'G 3': '#630235',
            'G 4': '#E43989',
            'Comparison \n group': '#F16E22',
            'All PIP* \n (average)': '#61A534'}

results['color']= results.generation.map(cmapgens)

#scales and percentages

results['ispercentage']=results['name'].isin(plotlabels_figs.loc[plotlabels_figs.vallab=='binary','resultvar'])
results.rename(columns={'name':'resultvar'}, inplace=True )
avg=results.loc[results.group.isin(['PIP'+ str(i) for i in range(1,5)]  + ['PIP_allpip'])] #leave out the allpip
dif=results.loc[results.group =='Difference']

#greyed out for non-significant differences 
dif['color']=np.where(dif.pvalue > 0.05, '#d3d3d3',dif['color'])

avg=avg.set_index(['resultvar', 'generation', ]).sort_index()
dif=dif.set_index(['resultvar', 'generation', ]).sort_index()


##motivation plots
motivation=list(avg.loc[avg.pillar=='motivation'].index.get_level_values('resultvar').unique())
idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(motivation), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1, 1], 'wspace':0.1} , figsize=(4, 7))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(motivation)*2,2), motivation):

    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apmean=avg.loc[idx[var, 'All PIP* \n (average)'],:]

    seldif=dif.loc[idx[var, 'G 1':'G 4'],:]
    apdifs=dif.loc[idx[var, 'All PIP* \n (average)'],:]

    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    axs[i].set_title(var)
    axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color, alpha=0.4, edgecolor=selmean.color, linewidth=2,
    yerr=selmean.err, ecolor=selmean.color)
    
       
        

    # left plot for differences




        





