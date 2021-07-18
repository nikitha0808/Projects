# -*- coding: utf-8 -*-
"""
Created on Fri Jun 18 15:03:32 2021

@author: admin
"""

#libraries
import pandas as pd
import numpy as np

#build matrix proteins * plants
plant_protein_mat = np.zeros((19195,1628))

##filling in values
#construct plant cid matrix

plant_cid_map = pd.read_csv('mapping_plants_cids.txt')
cid_count = plant_cid_map['cids'].max() + 1 #assuming ids start from 0
pc_mat = np.zeros((1628, cid_count))
pc_map = plant_cid_map.to_numpy()

for i in range(len(pc_map)):
    id = pc_map[i]
    pc_mat[id[0],id[1]] = 1
    
#construct cid protein matrix

cid_protein_map = pd.read_csv('mapping_cids_proteins.txt')
cpro_mat = np.zeros((cid_count, 19195))
cpro_mat_bool = np.zeros((cid_count, 19195))
cpro_map = cid_protein_map.to_numpy()

for i in range(len(cpro_map)):
    id = cpro_map[i]
    cpro_mat[id[0],id[1]] = id[2]
    cpro_mat_bool[id[0],id[1]] = 1
  
#final plant protein matrix
plant_protein_mat = np.transpose(pc_mat @ cpro_mat)
plant_protein_mat_bool = np.transpose(pc_mat @ cpro_mat_bool)

#defining the optimisation problem for an example disease protein list
#creating protein vector
alz_proteins = pd.read_csv("obesity_proteins.txt",sep = "\t")
all_proteins = pd.read_csv('index_proteins.txt')

protein_vector = np.zeros((19195,1))

for index1, row1 in alz_proteins.iterrows():
    for index2, row2 in all_proteins.iterrows():
        if row1[0]==row2['target_proteins']:
            protein_vector[index2] = 1

#capacity vector
capacity = np.sum(np.transpose(plant_protein_mat_bool),axis=1)

#getting the submatrices
alz_pp_mat = np.empty((0,1628), int)
alz_pp_mat_bool = np.empty((0,1628), int)

for i in range(len(protein_vector)):
    if protein_vector[i]==1:
        alz_pp_mat = np.append(alz_pp_mat, [plant_protein_mat[i,:]],axis=0)
        alz_pp_mat_bool = np.append(alz_pp_mat_bool, [plant_protein_mat_bool[i,:]],axis=0)

#defining the optimisation problem
from pyomo.environ import *
from pao.pyomo import *
from pyomo.opt import SolverFactory

N = 1628;
M = len(alz_pp_mat);

b = dict(np.ndenumerate(alz_pp_mat))
boolean = dict(np.ndenumerate(alz_pp_mat_bool))
c = dict(np.ndenumerate(capacity))

model = ConcreteModel()

#defining variables
#model.N = Param( within=PositiveIntegers ) #number of plants
#model.P = Param( within = RangeSet(model.N))
#model.M = Param( within = PositiveIntegers ) #number of proteins

model.Plants = range(N)
model.Proteins = range(M)

#model.b = Param( model.Plants, model.Proteins )
#model.boolean = Param( model.Plants, model.Proteins )
#model.c = Param( model.Plants )

model.y = Var( model.Plants, within=Binary )
model.x = Var( range(M), range(N), within=Binary)

'''
model.sub = SubModel()
model.sub.Plants = range(N)
model.sub.Proteins = range(M)
model.sub.x = Var( range(M), range(N), within=Binary)

#defining objective
def obj(model):
    model.sub.x = Var( range(M), range(N), within=Binary)
    total = 0
    for n in model.Plants:
        for m in range(M):
            total = total + b[m,n]*model.sub.x[m,n]
    return total
model.sub.obj1 = Objective(rule = obj, sense=maximize)
'''
model.obj2 = Objective(expr = sum( model.y[n] for n in model.Plants ) )

#constraints
model.single_x = ConstraintList()
for m in range(M):
    model.single_x.add( sum( model.x[m,n] for n in model.Plants) >= 1.0 )

model.bound_y = ConstraintList()
for m in model.Proteins:
    for n in model.Plants:
        model.bound_y.add(model.x[m,n] - (boolean[m,n]*model.y[n]) == 0.0)

model.num_facilities = ConstraintList()
for n in model.Plants:
    model.num_facilities.add(sum( model.x[m,n] for m in range(M)) <= c[n,]) 

opti = SolverFactory('cplex')
#model.obj2.deactivate()
result = opti.solve(model)

predicted_plants = []
for n in model.Plants:
    predicted_plants.append(model.y[n].value)
    
#to cross check with plant list
all_plants = pd.read_csv('index_plants.txt', sep='|', header=None)
alz_plants = pd.read_csv("obesity_expected.txt",header=None)
plant_vector = np.zeros((1628,1))

for index1, row1 in alz_plants.iterrows():
    for index2, row2 in all_plants.iterrows():
        if row1[0]==row2[0]:
            plant_vector[index2] = 1
 
#storing the predicted plants
f = open('predicted_fib_plants.txt','w')
for n in model.Plants:
    if predicted_plants[n]==1:
        f.write(all_plants.iloc[n][0] + '\n')
f.close()
           
#storing the common plants
f = open('fib_intersections.txt','w')
for n in model.Plants:
    if predicted_plants[n]==1:
        if plant_vector[n] ==1:
            f.write(all_plants.iloc[n][0] + '\n')
f.close()