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


#paths
root=Path.cwd()
interim=root/"data"/"interim"
clean=root/"data"/"clean"

cleanf=clean/"PAPAB Impact study - Ready for analysis.dta"
clean=pd.read_stata(cleanf)


####mosaic plot for income profile.
clean.head()