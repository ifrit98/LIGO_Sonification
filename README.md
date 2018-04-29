# LIGO_Sonification
Sonification of LIGO black hole merger simulation data

YouTube link to completed project:
https://www.youtube.com/watch?v=8sxf9IhrnDs

Files:
- parse.py: 
Takes input LIGOdata.txt file and parses all relevant data, and calculates acceleration based on x,y coordinates for each black hole.

- polarMOD.py:
Takes x,y coordinate input from LIGOdata.txt file and converts cartesian to polar coordinates, outputs a file that contains a pair <Theta, R> the angle and radius associated with each point converted from cartesian.

- newHRTF3.m:
MATLAB script to take input data and creates a sonification using convoultion with MIT HRTF data on the KEMAR mannequin.  Outputs a .wav file containing 2 binaural channels that represent the black hole merger from dataset LIGOdata.txt.

- importAllData.m:
MATLAB script that loads all relevant data into MATLAB in order to run script newHRTF3.m

- pipeHRTF.m:
MATLAB script that breaks up the convolution loop inside newHRTF.m so you can play with each black hole individually.

Data files:
- theta1mod.txt
- theta2mod.txt
- theta3mod.txt
- R1.txt
- R2.txt
- R3.txt
- accel1.txt
- accel2.txt
- accel3.txt

------------------------------------------MORE DOCUMENTATION TO COME--------------------------------------
