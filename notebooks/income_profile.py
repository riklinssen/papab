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
from statsmodels.graphics.mosaicplot import mosaic

#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"

cleanf=clean/"PAPAB Impact study - Ready for analysis.dta"
clean=pd.read_stata(cleanf, preserve_dtypes=True, index_col='id')

####mosaic plot for income profile.


inc_source=['r_inc_farm_sh_subscrop',
'r_inc_farm_sh_subslivestock',
'r_inc_farm_sh_salefieldcrop',
'r_inc_farm_sh_salecashcrop',
'r_inc_farm_sh_saleorchard',
'r_inc_farm_sh_salelivestock',
'r_inc_farm_sh_saleprepfood',
'r_inc_farm_sh_agrwage',
'r_inc_farm_sh_shepherd',
'r_inc_farm_sh_miller',
'r_inc_farm_sh_unskilledday',
'r_inc_farm_sh_skilled',
'r_inc_farm_sh_employee',
'r_inc_farm_sh_trade',
'r_inc_farm_sh_firewood',
'r_inc_farm_sh_handicrafts',
'r_inc_farm_sh_carpet',
'r_inc_farm_sh_mining',
'r_inc_farm_sh_military',
'r_inc_farm_sh_taxi',
'r_inc_farm_sh_remitt_out',
'r_inc_farm_sh_remitt_in',
'r_inc_farm_sh_pension',
'r_inc_farm_sh_govbenefit',
'r_inc_farm_sh_rental',
'r_inc_farm_sh_foodaid',
'r_inc_farm_sh_begging',
'r_inc_farm_sh_commerce',
'r_inc_farm_sh_other',
'r_inc_farm_sh_total'] 


inc_source_df=clean.loc[:,inc_source].fillna(value=0, axis=1)
#round here for decimals.

inc_source_df['sum']=inc_source_df.loc[:,inc_source[:-1]].sum(axis=1).round(2)
#check if addup. 
all((inc_source_df.loc[:,inc_source[:-1]].sum(axis=1).round(2))==inc_source_df['r_inc_farm_sh_total'])

inc_source_df['generation']=clean['pip_generation_clean'].cat.rename_categories(['Generation 1', 'Generation 2', 'Generation 3', 'Generation 4', 'Comparison group'])

bygen=inc_source_df.groupby('generation')[inc_source].mean().T
totals=pd.DataFrame(inc_source_df[inc_source].mean(), columns=['Total'])
shares=pd.concat([totals, bygen], axis=1).drop('r_inc_farm_sh_total', axis=0)

#categorizations of income

shares['agric']=np.where(shares.index.isin(['r_inc_farm_sh_subscrop',
 'r_inc_farm_sh_subslivestock',
 'r_inc_farm_sh_salefieldcrop',
 'r_inc_farm_sh_salecashcrop',
 'r_inc_farm_sh_saleorchard',
 'r_inc_farm_sh_salelivestock',
 'r_inc_farm_sh_agrwage',
 'r_inc_farm_sh_shepherd']), 'Agric', 'Non-agric')
#type
shares['type']=shares.index.map({
    'r_inc_farm_sh_subscrop': 'home consumption', 
    'r_inc_farm_sh_subslivestock': 'home consumption', 
    'r_inc_farm_sh_salefieldcrop': 'sales', 
    'r_inc_farm_sh_salecashcrop': 'sales', 
    'r_inc_farm_sh_saleorchard': 'sales', 
    'r_inc_farm_sh_salelivestock': 'sales', 
    'r_inc_farm_sh_saleprepfood': 'sales', 
    'r_inc_farm_sh_agrwage': 'wage labour', 
    'r_inc_farm_sh_shepherd': 'shepherding', 
    'r_inc_farm_sh_miller': 'wage labour', 
    'r_inc_farm_sh_unskilledday': 'wage labour', 
    'r_inc_farm_sh_skilled': 'wage labour', 
    'r_inc_farm_sh_employee': 'wage labour', 
    'r_inc_farm_sh_trade': 'handicrafts, small business, trading', 
    'r_inc_farm_sh_firewood': 'handicrafts, small business, trading', 
    'r_inc_farm_sh_handicrafts': 'handicrafts, small business, trading', 
    'r_inc_farm_sh_carpet': 'handicrafts, small business, trading', 
    'r_inc_farm_sh_mining': 'wage labour', 
    'r_inc_farm_sh_military': 'wage labour', 
    'r_inc_farm_sh_taxi': 'handicrafts, small business, trading', 
    'r_inc_farm_sh_remitt_out': 'pensions, gov. benefits, remittances', 
    'r_inc_farm_sh_remitt_in': 'pensions, gov. benefits, remittances', 
    'r_inc_farm_sh_pension': 'pensions, gov. benefits, remittances', 
    'r_inc_farm_sh_govbenefit': 'pensions, gov. benefits, remittances', 
    'r_inc_farm_sh_rental': 'other commercial activities', 
    'r_inc_farm_sh_foodaid': 'aid & begging', 
    'r_inc_farm_sh_begging': 'aid & begging', 
    'r_inc_farm_sh_commerce': 'other commercial activities', 
    'r_inc_farm_sh_other': 'other sources of income', 
    }) 

shares['finetype']=shares.index.map({
    'r_inc_farm_sh_subscrop': 'crops',
    'r_inc_farm_sh_subslivestock': 'livestock',
    'r_inc_farm_sh_salefieldcrop': 'field crops',
    'r_inc_farm_sh_salecashcrop': 'cash crops',
    'r_inc_farm_sh_saleorchard': 'orchard prod.',
    'r_inc_farm_sh_salelivestock': 'livestock',
    'r_inc_farm_sh_saleprepfood': 'prepared foods',
    'r_inc_farm_sh_agrwage': 'agric wage labour ',
    'r_inc_farm_sh_shepherd': 'shepherding',
    'r_inc_farm_sh_miller': 'milling',
    'r_inc_farm_sh_unskilledday': 'unskilled daily wage',
    'r_inc_farm_sh_skilled': 'skilled daily wage',
    'r_inc_farm_sh_employee': 'salaried employee',
    'r_inc_farm_sh_trade': 'trade',
    'r_inc_farm_sh_firewood': 'firewood collection',
    'r_inc_farm_sh_handicrafts': 'handicrafts',
    'r_inc_farm_sh_carpet': 'carpet weaving',
    'r_inc_farm_sh_mining': 'mining',
    'r_inc_farm_sh_military': 'military',
    'r_inc_farm_sh_taxi': 'taxi',
    'r_inc_farm_sh_remitt_out': 'remittances (foreign)',
    'r_inc_farm_sh_remitt_in': 'remittances (domestic)',
    'r_inc_farm_sh_pension': 'pensions',
    'r_inc_farm_sh_govbenefit': 'gov. benefits',
    'r_inc_farm_sh_rental': 'rental income',
    'r_inc_farm_sh_foodaid': '(sale of) food aid',
    'r_inc_farm_sh_begging': 'begging',
    'r_inc_farm_sh_commerce': 'other commercial activities',
    'r_inc_farm_sh_other': 'other sources of income'
})

#10 most often occuring shares
top10=shares.sort_values(by='Total', ascending=False).head(10)
notin10=pd.Series(shares[~shares.index.isin(top10.index)].mean(axis=0), name='other sources of income')
top10=top10.append(notin10)
toplabels={'r_inc_farm_sh_subscrop': 'Crop production\nhome consumption', 
    'r_inc_farm_sh_salefieldcrop': 'Prod. & sale \nof field crops', 
    'r_inc_farm_sh_salecashcrop': 'Prod. & sales of\ncash crops', 
    'r_inc_farm_sh_salelivestock': 'Prod. & sales of\nlivestock\n& products', 
    'r_inc_farm_sh_unskilledday': 'Unskilled\ndaily labour', 
    'r_inc_farm_sh_commerce': 'Trading goods\nother\ncommercial\nact.', 
    'r_inc_farm_sh_subslivestock': 'Livestock\nproduction\nhome\nconsumption', 
    'r_inc_farm_sh_agrwage': 'Agric\nwage labour', 
    'r_inc_farm_sh_employee': 'Salaried\nemployee', 
    'r_inc_farm_sh_skilled': 'Skilled\ndaily\nlabour',
    'other sources of income': 'other income'}  
top10['label']=top10.index.map(toplabels)
top10['colors']=['#a6cee3','#1f78b4','#b2df8a','#33a02c','#fb9a99','#e31a1c','#fdbf6f','#ff7f00','#cab2d6','#6a3d9a','#ffff99']
top10['vallab']=[c + '\n{:.1%}'.format(s) for (c,s) in zip(top10.label, top10.Total)]

fig, ax=plt.subplots(nrows=1, ncols=1, figsize=(6,6))
ax1=squarify.plot(sizes=top10.Total, label=top10.vallab, text_kwargs={'fontsize':9}, color=top10.colors)
fig.show()


#label the income sources

for c in inc_source_df.columns: 
    print(inc_source_df[c].value_counts(dropna=False))
all(inc_source_df['r_inc_farm_sh_total']==1)
all(inc_source_df['sum']==1)



import squarify
from numpy.random import rand

fig, axes = plt.subplots(2, 3, figsize=(14, 8))
plt.subplots_adjust(top=0.95, bottom=0.05, left=0.05, right=0.95, hspace=0.35)

sq = 8

def random_colors(n):
    return list(zip(rand(n), rand(n), rand(n)))

labels = ['Sq{0}'.format(i) for i in range(sq)]

axes[0, 0].set_title('Default')
squarify.plot(rand(sq), ax=axes[0, 0])

axes[0, 1].set_title('Specify single color')
squarify.plot(rand(sq), color='r', ax=axes[0, 1])

axes[0, 2].set_title('Specify each colors')
squarify.plot(rand(sq), color=random_colors(sq), ax=axes[0, 2])

axes[1, 0].set_title('Specify labels')
squarify.plot(rand(sq), label=labels, ax=axes[1, 0])

sizes = rand(sq)
values = ['{0:0.2f}'.format(s) for s in sizes]
axes[1, 1].set_title('Specify values')
squarify.plot(sizes, value=values, ax=axes[1, 1])

axes[1, 2].set_title('Specify labels and values')
squarify.plot(sizes, label=labels, value=values, ax=axes[1, 2])
plt.show()
