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
plottitlefilename=interim/"plottitles.xlsx"

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

#plot titles
plottitles=pd.read_excel(plottitlefilename)

plotlabels=pd.merge(left=plotlabels, right=plottitles, left_on=['name'], right_on=['resultvar'])

plotlabels.drop(columns=['resultvar'], inplace=True)

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





def labelscalemid(bars, xpos='center'):
    """
    Attach a text label above each bar in *ax*, displaying its height.

    *xpos* indicates which side to place the text w.r.t. the center of
    the bar. It can be one of the following {'center', 'right', 'left'}.
    """

    xpos = xpos.lower()  # normalize the case of the parameter
    ha = {'center': 'center', 'right': 'left', 'left': 'right'}
    offset = {'center': 0.5, 'right': 0.57, 'left': 0.43}  # x_txt = x + w*off

    for bar in bars:
        heightp = round(bar.get_height(),1)
        height=bar.get_height()*0.5
        axs[i].text(bar.get_x() + bar.get_width()*offset[xpos], height,
                '{}'.format(heightp), ha=ha[xpos], va='bottom', color='white', alpha=1, size='small')





def labelpercmid(bars, xpos='center'):
    """
    Attach a text label above each bar in *ax*, displaying its height.

    *xpos* indicates which side to place the text w.r.t. the center of
    the bar. It can be one of the following {'center', 'right', 'left'}.
    """

    xpos = xpos.lower()  # normalize the case of the parameter
    ha = {'center': 'center', 'right': 'left', 'left': 'right'}
    offset = {'center': 0.5, 'right': 0.57, 'left': 0.43}  # x_txt = x + w*off

    for bar in bars:
        heightp = format(bar.get_height(), ".0%")
        height=bar.get_height()*0.5
        axs[i].text(bar.get_x() + bar.get_width()*offset[xpos], height,
                '{}'.format(heightp), ha=ha[xpos], va='bottom', color='white', alpha=1, size='small')


idx = pd.IndexSlice

##motivation plots -leave out motivation score
motivation=list(avg.loc[avg.pillar=='motivation'].index.get_level_values('resultvar').unique())[:-1]


fig, axes = plt.subplots(nrows= len(motivation), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(motivation)*2,2), motivation):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apmean=avg.loc[idx[var, 'All PIP* \n (average)'],:]


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel(None)
    axs[i].set_yticks(np.arange(param['yminv'], param['ymaxv']+1, 1))
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]=param['yminl']
    ytick[-1]=param['ymaxl']
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    for label,kleur in zip(axs[i].get_xticklabels(), list(selmean.color)):
        label.set_color(kleur)
        label.set_fontsize('large')

    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(motivation)*2,2), motivation):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apdifs=dif.loc[idx[var, 'All PIP* \n (average)'],:]

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')



    #y-axis
    for label,kleur in zip(axs[i].get_yticklabels(), list(selmean.color)):
        label.set_color(kleur)
        label.set_fontsize('large')
    
    axs[i].invert_yaxis()
    
    axs[i].yaxis.tick_right()

    
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    
    #grid
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle("Motivation: subconstructs, by generation\n\nLeft: values on sub-construct, by generation\n\nRight: Impact: difference between generation \nand generation's comparison group", x=-0.4, y=1.1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=0,s='Left: Averages on subconstruct\nRight:  Generation- (matched) comparison (treatment effect)\nHorizontal lines represent 95% confidence intervals\nNon-significant differences greyed out', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"motivation.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 


#####Stewardship --knowledge and use of commons-





st_know=['s_awa_mean', 
's_farm_why_mean',
's_land_why_mean',
's_comm_mean']






idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(st_know), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(st_know)*2,2), st_know):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apmean=avg.loc[idx[var, 'All PIP* \n (average)'],:]


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel(None)
    axs[i].set_yticks(np.arange(param['yminv'], param['ymaxv']+1, 1))
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]=param['yminl']
    ytick[-1]=param['ymaxl']
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(st_know)*2,2), st_know):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apdifs=dif.loc[idx[var, 'All PIP* \n (average)'],:]

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Stewardship: knowledge and use of commons\nsubconstructs by generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=0,s='Left: Averages on subconstruct\nRight: differences Generation- (matched) comparison (treatment effect)\nThick lines represent 95% confidence intervals', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"st_know.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 




#####Stewardship --practices
st_pract=['s_land_physpract_contourlines',
's_land_physpract_conttrack',
's_land_mngmtpract_ploughing',
's_land_mngmtpract_mulching',
's_land_mngmtpract_covercrops',
's_farm_soil_compost',
's_farm_soil_manure']


idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(st_pract), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(st_pract)*2,2), st_pract):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apmean=avg.loc[idx[var, 'All PIP* \n (average)'],:]


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelpercmid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #yaxis
    axs[i].set_ylim([0,1])
    axs[i].set_ylabel(None)
    axs[i].yaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))


    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(st_pract)*2,2), st_pract):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)
    apdifs=dif.loc[idx[var, 'All PIP* \n (average)'],:]

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Stewardship:\nPractices: % of people that applies practice \nby generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=0,s='Left: % of people that applies practice\nRight: differences Generation- (matched) comparison (treatment effect)\nThick lines represent 95% confidence intervals\nDifferences that are not statistically significant (p<0.05) greyed out', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"st_pract.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 

###resilience

#crop diversity (smaller graph)


crop_div=['r_crop_cult_total', 
'r_crop_sell_total']





idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(crop_div), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10/2.5))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(crop_div)*2,2), crop_div):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #yaxis
    axs[i].set_ylim([0,15])
    axs[i].set_ylabel('Count')
    #axs[i].yaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))


    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(crop_div)*2,2), crop_div):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Resilience:\nCrop diversity: no. of different crops cultivated and sold\nby generation', x=-0.4, y=1.2, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.2, s='Left: % of people that applies practice\nRight: differences Generation- (matched) comparison (treatment effect)\nThick lines represent 95% confidence intervals\nDifferences that are not statistically significant (p<0.05) greyed out', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"crop_div.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()       
 

# livestock diversity

lvstock=['r_lvstck_total', 'r_lvstck_nutr_producefeed',
'r_lvstck_nutr_fodder']



idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(lvstock), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10/1.5))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(lvstock)*2,2), lvstock):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #yaxis
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel(None)
    axs[i].set_yticks(np.arange(param['yminv'], param['ymaxv']+1, 1))
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]=param['yminl']
    ytick[-1]=param['ymaxl']
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(lvstock)*2,2), lvstock):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    
    
    #adjustments on 1st axs y for counts
    axs[0].set_ylim([0,15])
    axs[0].set_yticks([0,5,10,15])
    axs[0].set_yticklabels(['0','5','10','15'])
    axs[0].set_ylabel('Count')
    
    #title
    fig.suptitle('Resilience: Livestock: livestock diversity and availability of fodder\nby generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.1, s='Left: % of people that applies practice\nRight: differences Generation- (matched) comparison (treatment effect)\nThick lines represent 95% confidence intervals\nDifferences that are not statistically significant (p<0.05) greyed out', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"lvstock.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()       
 

##household resilience and coping (smaller graph)

rescop=['r_res_mean','r_cop_mean']


idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(rescop), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,10/2.5))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(rescop)*2,2), rescop):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel(None)
    axs[i].set_yticks(np.arange(param['yminv'], param['ymaxv']+1, 1))
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]=param['yminl']
    ytick[-1]=param['ymaxl']
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(rescop)*2,2), rescop):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Resilience: Household resilience and coping ability \nsubconstructs by generation', x=-0.4, y=1.2, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.2,s='Left: Averages on subconstruct\nRight: differences Generation- (matched) comparison (treatment effect)\nThick lines represent 95% confidence intervals', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"rescop.svg", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 


# Overall/on pillar
mot=['motivation_score'] 

idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(mot), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,3.5*1.61))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(mot)*2,2), mot):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel('Motivation score', fontstyle='italic')
    axs[i].set_yticks([0, 25, 50, 75, 100])
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]='0-low motivation'
    ytick[-1]='100-high motivation'
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(mot)*2,2), mot):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Motivation: Overall score by generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.1,s='Left: Averages motivation score\nRight: differences Generation- (matched) comparison (treatment effect)\nHorizontal/vertical lines represent 95% confidence intervals', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"score_motivation.png", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 

 

# Overall/on pillar Resilience
resi=['resilience_score'] 

idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(mot), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,3.5*1.61))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(mot)*2,2), resi):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel('Resilience score', fontstyle='italic')
    axs[i].set_yticks([0, 25, 50, 75, 100])
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]='0-low resilience'
    ytick[-1]='100-high resilience'
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(mot)*2,2), mot):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Resilience: Overall score by generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.1,s='Left: Averages resilience score\nRight: differences Generation- (matched) comparison (treatment effect)\nHorizontal/vertical lines represent 95% confidence intervals', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"score_resilience.png", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            
 

stew=['stewardship_score_v2'] 

idx = pd.IndexSlice

fig, axes = plt.subplots(nrows= len(stew), ncols=2, sharex='col' , gridspec_kw={'width_ratios': [1.5, 1], 'wspace':0.1,} , figsize=(3.5 ,3.5*1.61))

axs=fig.axes

  #left hand plots
for i, var in zip(range(0,len(stew)*2,2), stew):
    selmean=avg.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)


    #draw out some parameters

    param={}
    param=plotlabels_f_dict[var]

    #plot left
    bars=axs[i].bar(x=selmean.index, height=selmean['mean'],  color=selmean.color,  linewidth=4,
    yerr=selmean.err, ecolor='black')

    #labels
    labelscalemid(bars)

    #titles
    axs[i].set_title(param['pltitle'])

    #y-axis   
    axs[i].set_ylim(param['yminv'], param['ymaxv'])
    axs[i].set_ylabel('Stewardship score', fontstyle='italic')
    axs[i].set_yticks([0, 25, 50, 75, 100])
    ytick=axs[i].get_yticks().tolist()    
    ytick[0]='0-low stewardship'
    ytick[-1]='100-high stewardship'
    axs[i].set_yticklabels(ytick, fontsize=8)

    #x-axis
    

    #spines
    axs[i].spines['left'].set_visible(True)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(False)
    axs[i].spines["left"].set_position(("outward", +5))
    
        
    
    
    

    # right plot for differences
for i, var in zip(range(1,len(stew)*2,2), stew):
    
    seldif=dif.loc[idx[var, 'G 1':'G 4'],:].droplevel(0)

    #plot right
    axs[i].errorbar(y=seldif.index, x=seldif['mean'], xerr=seldif.err, fmt='none', ecolor=seldif.color)
    axs[i].scatter(y=seldif.index, x=seldif['mean'], color=seldif.color)
    #x-axis
    axs[i].axvline(linewidth=1.5, ls='-', color='black')
    #y-axis
    axs[i].yaxis.tick_right()
    axs[i].tick_params(axis='y', which='major', labelright=True, labelleft=False, labelbottom=True)
    axs[i].invert_yaxis()
    #spines
    axs[i].spines['left'].set_visible(False)
    axs[i].spines['top'].set_visible(False)
    axs[i].spines['right'].set_visible(True)
    axs[i].spines["right"].set_position(("outward", +5))
    #grid
    axs[i].yaxis.grid(True)
    axs[i].grid(which='major', axis='y', linestyle=':',linewidth=1 )
    axs[-1].set_xlabel('difference: \n(target-comparison)')
    #title
    fig.suptitle('Stewardship: Overall score by generation', x=-0.4, y=1, horizontalalignment='left', verticalalignment='top', fontsize = 15)
    plt.figtext(x=-0.4, y=-0.1,s='Left: Averages stewardship score\nRight: differences Generation- (matched) comparison (treatment effect)\nHorizontal/vertical lines represent 95% confidence intervals', fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.subplots_adjust(hspace=0.4) 
    fig.tight_layout()
    plt.savefig(graphs/"score_stewardship.png", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()
            



##visualisations impacts on pillar joint per generation
pscales=mot + resi + stew 
gens=['G 1',
 'G 2',
 'G 3',
 'G 4']

compgroups=[c for c in results.group.unique() if 'Comparison' in c and 'allpip' not in c]


idx = pd.IndexSlice

pscales_df_pip=avg.loc[idx[pscales,gens],:]

#now construct similar set with comparison group means. 

pscales_df_nonpip=results.loc[results['group'].isin(compgroups) & results['resultvar'].isin(pscales)]
pscales_df_nonpip['generation']=pscales_df_nonpip.group.map(
    dict(
    zip(['Comparison PIP1', 'Comparison PIP2', 'Comparison PIP3',
       'Comparison PIP4', 'Comparison PIP_allpip'],
       ['G 1',
       'G 2',
       'G 3',
       'G 4']))
       )

pscales_df_nonpip=pscales_df_nonpip.set_index(
    ['resultvar', 'generation', ]
    ).sort_index()
pscales_df=pd.DataFrame(index=pscales_df_pip.index)
pscales_df['mean_target']=pscales_df_pip['mean']
pscales_df['mean_comparison']=pscales_df_nonpip['mean']
pscales_df['difference']=dif['mean']
pscales_df['pvalue']=dif['pvalue']
pscales_df['color']=dif['color']
pscales_df['sample']=dif['sample']
pscales_df['label']=pscales_df.index.get_level_values(
    'resultvar').map({
        'motivation_score': 'Motivation',
        'resilience_score': 'Resilience',
        'stewardship_score_v2': 'Stewardship'}
        )

#grey out if non sig

pscales_df['color']=np.where(pscales_df.pvalue > 0.05, '#d3d3d3',pscales_df['color'])

###differences (raw)

fig, axes = plt.subplots(nrows= 1, ncols=len(gens), sharey='row', sharex='col' , figsize=(3.5*2 ,3.5/1.61))

axs=fig.axes
for i, gen in enumerate(gens):
    sel=pscales_df.loc[idx[:,gen],:].droplevel(1).set_index('label')
    axs[i].barh(y=sel.index, height=0.5, width=sel['difference'], color=sel.color)
    #add labels
    rects = axs[i].patches
    # For each bar: Place a label
    for rect in rects:
        # Get X and Y placement of label from rect.
        x_value = rect.get_width()
        x_place= rect.get_width()*1.05
        y_value = rect.get_y() + rect.get_height() / 2
        label =  '{:.0f}'.format(round(x_value,1))
        kleur=rect.get_facecolor()
        axs[i].text(x_place, y_value, label, verticalalignment='center', size='small', color=kleur)

        
    sns.despine(ax=axs[i])
    #3axs[i].barh(y=sel.index, width=sel['mean_comparison'],  color=sel.color, alpha=0.8)
    #axs[i].hlines(y=sel.index, xmin=sel['mean_comparison'], xmax=sel['mean_target'], color=sel.color, alpha=0.8)
    axs[i].set_title(gen)
    axs[i].set_xlim(0,50)

    axs[i].invert_yaxis()
    #title
    fig.suptitle('Effect sizes: Motivation, resilience, and stewardship\nDifference in means (target - matched comparison group), by generation', x=-0, y=1.2, horizontalalignment='left', verticalalignment='top', fontsize = 'large')
    #footnotes
    plt.figtext(x=0, y=-0.1,s="All outcomes (motivation, stewardship & resilience) on the same scale ranging between 0 - 100\nx-axis represent difference=average in target group- average in matched comparison group", fontsize='small', fontstyle='italic', fontweight='light', color='gray')
    fig.tight_layout()
    plt.savefig(graphs/"pillar_effectsize.png", dpi=300, facecolor='w', bbox_inches='tight')
    fig.show()

