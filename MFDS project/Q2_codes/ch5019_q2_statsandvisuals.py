#!/usr/bin/env python
# coding: utf-8

# In[ ]:


import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')
import seaborn as sns; sns.set()
plt.rcParams["figure.figsize"] = [20, 20]
from sklearn.preprocessing import StandardScaler
import plotly.express as px


# In[ ]:


data=pd.read_csv("ch5019.csv")


# In[ ]:


data.describe()


# In[ ]:


data.head()


# In[ ]:


data.isnull().values.any()


# In[ ]:


features = ['Temperature','Pressure','Feed Flow rate','Inlet reactant concentration','Coolant Flow rate']# Separating out the features
x = data.loc[:, features].values# Separating out the target
y = data.loc[:,['Test']].values# Standardizing the features
x = StandardScaler().fit_transform(x)
x


# In[ ]:


sns.boxplot(data=x)


# In[ ]:


label = LabelEncoder()
data["Test"] =label.fit_transform(data["Test"])
data.head(11)


# In[ ]:



ax = data['Test'].value_counts().plot(kind='bar',
                                    figsize=(4,3),
                                    title="Test count")
ax.set_xlabel("Test result")
ax.set_ylabel("Count")


# In[ ]:


fig=px.scatter(data,y='Test',x='Coolant Flow rate')
fig.show()


# In[ ]:


fig=px.scatter(data,x='Feed Flow rate',y='Test',width=500,height=400)
fig.show()


# In[ ]:


fig=px.scatter(data,x='Temperature',y='Test',width=500,height=400)
fig.show()


# In[ ]:


fig=px.scatter(data,x='Pressure',y='Test',width=500,height=400)
fig.show()


# In[ ]:


fig=px.scatter(data,x='Inlet reactant concentration',y='Test',width=500,height=400)
fig.show()


# In[ ]:


features = ['Temperature','Pressure','Feed Flow rate','Inlet reactant concentration']# Separating out the features
x = data.loc[:, features].values# Separating out the target
y = data.loc[:,['Test']].values# Standardizing the features
x = StandardScaler().fit_transform(x)
x


# In[ ]:


#taking PCs for 3d plot
from sklearn.decomposition import PCA
pca = PCA(n_components=2)
principalComponents = pca.fit_transform(x)
principaldf = pd.DataFrame(data = principalComponents, columns = ['principal component 1', 'principal component 2'])
finaldf = pd.concat([principaldf, data['Test']], axis = 1)
finaldf=pd.concat([finaldf,data['Coolant Flow rate']],axis=1)
finaldf


# In[ ]:


#3d plot
fig=px.scatter_3d(finaldf,x='Coolant Flow rate',y='principal component 1',z='principal component 2',color='Test',height=1000,width=1000)
fig.show()


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




