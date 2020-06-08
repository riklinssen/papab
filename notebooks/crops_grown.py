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
import squarify
from statsmodels.stats.weightstats import DescrStatsW
from pandas.core.dtypes.dtypes import CategoricalDtype

#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"

cleanf=clean/"PAPAB Impact study - Ready for analysis.dta"
clean=pd.read_stata(cleanf, preserve_dtypes=True, index_col='id')
graphs=root/"graphs"


#annual crops cultivated
ancrops_l=[c for c in clean.columns if 'r_crop_ann_cult' in c and 'text' not in c and 'total' not in c]
percrops_l=[c for c in clean.columns if 'r_crop_per_cult' in c and 'text' not in c and 'change' not in c and 'total' not in c]
for c in ancrops_l: 
    print(clean[c].cat.categories)


allc_l=ancrops_l + percrops_l

#make crops_df

crops_df=clean.loc[:,allc_l]
cat_yn= CategoricalDtype(categories=["No", "Yes"],ordered=True)

for c in allc_l: 
    print(crops_df[c].value_counts(dropna=False))
    crops_df[c]=crops_df[c].astype(cat_yn)
    print(crops_df[c].value_counts(dropna=False))

#add Soja, Peanut, Ananas, jackfruit for perannual crops
texts=[ 'r_crop_ann_cult_other1_text',
 'r_crop_ann_cult_other2_text', 
  'r_crop_per_cult_other1_text',
 'r_crop_per_cult_other2_text']

#make a df with text only
cropstxt_df=pd.DataFrame(index=clean.index)
for c in texts:
    #lowercase
    cropstxt_df[c]=clean[c].str.lower()
    print(clean[c].value_counts(dropna=False))
    print(cropstxt_df[c].value_counts(dropna=False))
cropstxt_df['allstr']=cropstxt_df.sum(axis=1)
#add categories
#tea
cropstxt_df['r_crop_per_cult_tea']=cropstxt_df['allstr'].apply(lambda x: 'Yes' if 'tea' in x else "No").astype(cat_yn)
#soja
cropstxt_df['r_crop_per_cult_soya']=cropstxt_df['allstr'].apply(lambda x: 'Yes' if 'soja' in x else "No").astype(cat_yn)
#peanuts
cropstxt_df['r_crop_per_cult_peanut']=cropstxt_df['allstr'].apply(lambda x: 'Yes' if 'peanut' in x or 'arachides' in x else "No").astype(cat_yn)

#jackfruit
cropstxt_df['r_crop_per_cult_jackfruit']=cropstxt_df['allstr'].apply(lambda x: 'Yes' if 'jack' in x  else "No").astype(cat_yn)
#pineapple
cropstxt_df['r_crop_per_cult_pineapple']=cropstxt_df['allstr'].apply(lambda x: 'Yes' if 'ananas' in x  else "No").astype(cat_yn)
cropstxt_df=cropstxt_df.loc[:,'r_crop_per_cult_tea':]
crops_df=pd.concat([crops_df, cropstxt_df], axis=1 )
#numerical

for c in crops_df.columns: 
    crops_df[c]=crops_df[c].cat.codes


crops_df['pip_generation_clean']=clean['pip_generation_clean']
crops_bygen=crops_df.groupby('pip_generation_clean').mean().T
crops_df['total']='Total'
crops_t=crops_df.groupby('total').mean().T
#labels
crops_t['label']=crops_t.index
crops_t['label']=crops_t['label'].apply(lambda x: x.rsplit('_', 1)[1])
#annual and perennial division (# top 15)
ancrop=[c for c in crops_t.index if c not in texts and 'r_crop_ann' in c and 'other' not in c]
crops_t_an=crops_t.loc[
    crops_t.index.isin(
        [c for c in crops_t.index if c not in texts and 'r_crop_ann' in c and 'other' not in c]
        )].head(15).sort_values(by='Total', ascending=True)
crops_t_per=crops_t.loc[
    crops_t.index.isin(
        [c for c in crops_t.index if c not in texts and 'r_crop_per' in c and 'other' not in c]
        )].head(15).sort_values(by='Total', ascending=True)


fig, (ax1, ax2)=plt.subplots(nrows=2, ncols=1, sharex=True, figsize=(3,7))
ax1.barh(y=crops_t_an.label, width=crops_t_an.Total, color='#61A534')
ax1.set_title('annual', fontstyle='italic')

ax2.barh(y=crops_t_per.label, width=crops_t_per.Total, color='#61A534')
ax2.set_title('perennial', fontstyle='italic')

for ax in fig.axes: 
    ax.set_xlim([0,1])
    ax.xaxis.set_major_formatter(mtick.PercentFormatter(xmax=1))

    #label
    rects = ax.patches
# For each bar: Place a label
    for rect in rects:
        # Get X and Y placement of label from rect.
        x_value = rect.get_width()
        label = "{:.0%}".format(x_value)
        x_place= rect.get_width()+0.03
        y_place= rect.get_y() + rect.get_height() / 2
        kleur=rect.get_facecolor()
        ax.text(x_place, y_place, label, verticalalignment='center', size='x-small', color=kleur)
sns.despine()


fig.suptitle('Crops cultivated:\n% of farmers that cultivate crop', x=0, y=1.05, ha='left')
plt.figtext(x=0, y=-0.05, s='Percentages represent share of respondents that cultivate crop.\n most often cultivated crops shown for brevity\nn=962 (all generations, incl. comparison group)',fontweight='light', color='gray', size='small')

plt.subplots_adjust(hspace=0.6)
fig.tight_layout()
plt.savefig(graphs/'crops_grown.svg', bbox_inches='tight')


plt.suptitle()
plt.suptitle()