# -*- coding: utf-8 -*-
"""
Created on Sat Apr 17 12:10:27 2021

@author: admin
"""

import pandas as pd
import numpy as np
import re
import matplotlib.pyplot as plt
protein_df = pd.read_csv('9606.protein.links.v11.0.txt',sep='\s+')
target_proteins = pd.read_csv('index_proteins.txt')
target_proteins.head()


def modify_id(x):
    return re.sub('9606.ENSP','',x)

protein_df['protein1'] = protein_df['protein1'].apply(modify_id)
protein_df['protein2'] = protein_df['protein2'].apply(modify_id)
target_proteins['target_proteins'] = target_proteins['target_proteins'].apply(modify_id)

#to matrix

protein = protein_df.to_numpy()
targets = target_proteins.to_numpy()

total_proteins = np.concatenate((targets[:,0],protein[:,0],protein[:,1]),axis =0)
order_list,idx = np.unique(total_proteins, return_index = True)
ordered_list = total_proteins[np.sort(idx)]

enum_dict = {v:k for k,v in enumerate(ordered_list)}
pro1_ids = [enum_dict[n] for n in protein[:,0]]
pro2_ids = [enum_dict[n] for n in protein[:,1]]
target_protein_num = [enum_dict[n] for n in targets[:,0]]

ppi_coords = np.array(list(zip(pro1_ids,pro2_ids)))

uni = len(list(set(total_proteins)))
ppi_map = np.zeros((uni,uni),dtype=int)

ppi_map[ppi_coords[:,0],ppi_coords[:,1]] = 1

ppi_map = ppi_map+ np.transpose(ppi_map)
ppi_map[ppi_map==2] = 1

idx = np.array(target_protein_num)
ppi_map_new = ppi_map[idx[:,None],idx]

pd.DataFrame(np.concatenate((ppi_coords,np.expand_dims(protein[:,2],axis=1)),axis=1)).to_csv('ppi_coords.csv')
pd.DataFrame(target_protein_num).to_csv('target_proteins id.csv')
#save the ppi matrix  

pd.DataFrame(ppi_map_new).to_csv('ppi_map.csv',index = False)
   