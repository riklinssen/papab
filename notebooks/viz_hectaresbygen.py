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
import joypy


################################################################
# visualisationpip implementation(joyplots on clean data)



#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"
#graphs=root/"graphs"

graphs=Path(r"C:\Users\RikL\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\5. Report\Graphs")


clean=pd.read_stata(clean/"PAPAB Impact study - Ready for analysis.dta")
joyd=clean[['pip_implemented', 'pip_generation_clean']]

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

fig,axes=joypy.joyplot(joyd, by='pip_generation_clean', xlim=[0,1], color=list(cmapgens.values()))


