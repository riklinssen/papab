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

#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"
graphs=root/"graphs"


cleaned=pd.read_stata(clean/"PAPAB Impact study - Ready for analysis.dta")


cleaned.groupby('pip_generation')['s_farm_soil_practchemfert'].value_counts(dropna=False, normalize=True)

cleaned.groupby('pip_generation')['s_farm_crop_rotation'].value_counts(dropna=False, normalize=True)

cleaned.groupby('pip_generation')['s_land_mngmtpract_staggering'].value_counts(dropna=False, normalize=True)

cleaned.groupby('pip_generation')['s_land_physpract_gullycontrol'].value_counts(dropna=False, normalize=True)



#check shocks 
shocks=[c for c in cleaned if 'shock' in c]
#remove totals

shocks=shocks[:-3]

# make sure coding is conistent
shocktype=CategoricalDtype(['Shock not mentioned', '3rd shock', '2nd shock', 'Main shock'], ordered=True)

new=[c + "_d" for c in shocks]
for c, n in zip(shocks, new):
    cleaned[c]=cleaned[c].astype(shocktype)
    cleaned[n]=cleaned[c].cat.codes.map({0:0, 1:0, 2:0, 3:1})
    print(cleaned[c].value_counts(normalize=True))
    print(cleaned[n].value_counts(normalize=True))

shockdesc =pd.pivot_table(cleaned, values=new, index=['pip_generation'],
                     aggfunc=np.mean).T
                     
shockdesc['total']=shockdesc.mean(axis=1)

shockdesc2=cleaned.groupby('pip_generation')[new].mean()
