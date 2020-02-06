


####################REFACTOR BELOW###################
###descriptive stats plot 1##

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

#plt.savefig(r"C:\Users\RikL\Box\ONL-IMK\2.0 Projects\Current\2018-05 PAPAB Burundi\07. Analysis & reflection\Data & Analysis\5. Report\Graphs\descr_resp.svg", bbox_inches='tight')





##############Farmer chars plot

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
