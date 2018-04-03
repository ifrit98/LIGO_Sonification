# LIGO_Sonification
Sonification of LIGO black hole data from 2015 merger

Files:
- parse.py 
Takes input LIGOdata.txt file and parses all relevant data, and calculates acceleration based on x,y coordinates for each black hole.

- polarMOD.py
Takes x,y coordinate input from LIGOdata.txt file and converts cartesian to polar coordinates, outputs a file that contains a pair <Theta, R> the angle and radius associated with each point converted from cartesian.

- newHRTF3.m
MATLAB script to take input data and creates a sonification using convoultion with MIT HRTF data on the KEMAR mannequin.  Outputs a .wav file containing 2 binaural channels that represent the black hole merger from dataset LIGOdata.txt.

- importAllData.m
MATLAB script that loads all relevant data into MATLAB in order to run script newHRTF3.m

- pipeHRTF.m
MATLAB script that breaks up the convolution loop inside newHRTF.m so you can play with each black hole individually.

-----------------------------------------------------MORE DOCUMENTATION TO COME--------------------------------------------------
