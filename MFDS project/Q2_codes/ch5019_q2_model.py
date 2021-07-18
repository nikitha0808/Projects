#!/usr/bin/env python
# coding: utf-8

# In[1]:



import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn import preprocessing 
import matplotlib.pyplot as plt
from sklearn.preprocessing import StandardScaler
from sklearn import preprocessing
from sklearn.metrics import confusion_matrix,f1_score


# In[2]:


label_encoder = preprocessing.LabelEncoder() 
data=pd.read_csv('ch5019.csv')
data['Test']= label_encoder.fit_transform(data['Test']) 
data


# In[3]:


#scaling feauture values
X=data.drop(['Test'],axis=1)
Y=data['Test']
X = preprocessing.scale(X)
X


# In[4]:



xtrain, xtest, ytrain, ytest = train_test_split(X, Y, test_size=0.3)
xtrain.shape


# In[5]:


lossplot=[]
class LogisticRegression:
    def __init__(self, lr=0.1, epochs=28000):
        self.lr = lr
        self.num_iter = epochs
        
    
    def add_intercept(self, X):
        intercept = np.ones((X.shape[0], 1))
        return np.concatenate((intercept, X), axis=1)
    
    def sigmoid(self, z):
        return 1 / (1 + np.exp(-z))
    def loss(self, h, y):
        return (-y * np.log(h) - (1 - y) * np.log(1 - h)).mean()
    
    def fit(self,X, y,initial):
       
        X = self.add_intercept(X)
        
        self.theta = np.full((X.shape[1],),initial)
        
        for i in range(self.num_iter):
            z = np.dot(X, self.theta)
            h = self.sigmoid(z)
            
            gradient = np.dot(X.T, (h - y))/ y.size
            self.theta -= self.lr * gradient
            
            z = np.dot(X, self.theta)
            h = self.sigmoid(z)
            loss = self.loss(h, y)
            
            if(i % 700 == 0):
                print(f' loss: {loss} \t')
                lossplot.append(loss)
                
        #print("Initialtheta:",initial,", Loss:",loss)
        
    
    def predict_prob(self, X):
            X = self.add_intercept(X)
    
            return self.sigmoid(np.dot(X, self.theta))
    
    def predict(self, X):
        return self.predict_prob(X).round()


# In[6]:


#finding optimal theta


#model = LogisticRegression()

#for initial in range(-10,10):
    
    #model.fit(xtrain,ytrain,float(initial))


# In[7]:


#training model
model=LogisticRegression()
initial=5.0   
model.fit(xtrain,ytrain,initial)


# In[8]:


lossplot

plt.plot(lossplot)
plt.ylabel("loss")


# In[9]:


model.theta


# In[10]:


#testing model
pred = model.predict(xtest)
accuracy=(pred == ytest).mean()
print("Accuracy of trained model on test set:",accuracy)


# In[11]:


model.theta


# In[12]:


#confusion matrix
m = confusion_matrix(ytest, pred)
print("Confusion matrix:\n",m)
#f1_score
print("F1 score:",f1_score(pred,ytest))


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:




