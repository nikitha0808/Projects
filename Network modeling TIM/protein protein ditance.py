# -*- coding: utf-8 -*-
"""
Created on Sat Apr 24 11:10:11 2021

@author: admin
"""
"""
This is a function to give in a set of plants and obtain the distance between them.
The distance is an obsolute measure of the shortest path between it's set of phytochemicals 
whose distances are again shortest distance between the target proteins

input = plantid1, plantid2
output = distance between them
"""
import pandas as pd
import numpy as np
import networkx as nx
from tqdm import tqdm
from networkx.algorithms.shortest_paths.generic import shortest_path_length,average_shortest_path_length

ppi = pd.read_csv('ppi_map.csv',index_col=False) 

def distance(plantid1, plantid2,ppi):
    
    #import the files needed
    
    #ppi.drop('0',inplace=True,axis=1)
    ppi_mat = ppi.to_numpy()

    ppiG = nx.from_numpy_matrix(ppi_mat)
    
    plant_cid = pd.read_csv('mapping_plants_cids.txt')
    target_protein_df = pd.read_csv('target_proteins id.csv').to_numpy()
    cid_protein = pd.read_csv('mapping_cids_proteins.txt')
    target_protein = target_protein_df[:,1]
    
    #get a list of phytochemical ids of both plants
    
    cid_protein = pd.read_csv('mapping_cids_proteins.txt')
    
    phytoA = plant_cid[plant_cid['plants']==plantid1]['cids'].to_numpy()
    phytoB = plant_cid[plant_cid['plants']==plantid2]['cids'].to_numpy()
    
    phyto_matrix = np.zeros((len(phytoA),len(phytoB)))
    
    #compute distance between each pair of phytochemical
    
    for i in phytoA:
        for j in phytoB:
            proteinsA = cid_protein[cid_protein['cids']==i]['proteins'].to_numpy()
            proteinsB = cid_protein[cid_protein['cids']==j]['proteins'].to_numpy()
            
            nodesA = target_protein[proteinsA]
            nodesB = target_protein[proteinsB]
            score = 0
            print(1)
            for a in nodesA:
                for b in nodesB:
                    score = score + shortest_path_length(ppiG,a,b)
            phyto_matrix[list(phytoA).index(i),list(phytoB).index(j)] = 2*score/(len(nodesA)+len(nodesB))

    phytoG = nx.from_numpy_matrix(phyto_matrix)
    dist = average_shortest_path_length(phytoG, weight=True)
    return dist
    