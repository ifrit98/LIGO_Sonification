import numpy as np
import sys
from array import array
import math
import scipy as sp
from numpy.core.numeric import _mode_from_name

# Radians
QUADRANTS = { 'I' : 0,
              'II': np.pi,
             'III': np.pi,
              'IV': 2*np.pi}

class Polaroid:

    __slots__ = 'cartesian','polar','time'

    def __init__(self):
        self.cartesian = {}
        self.polar = {} # Dictionary at each time stamp
        self.time = []

    def __getData(self, tok):
        """
        Helper function that gets data from one hole
        :param tok: Tokens from line in data file
        :return: None
        """
        if tok[0] == '1':
            self.time.append(float(tok[1]))
            self.cartesian[float(tok[1])] = [float(tok[2]), float(tok[3])]

    def getData(self):
        """
        Opens file and calls helper function
        :return:
        """
#        fn = sys.argv[1]
        f = open('LIGOdata.txt', 'r')
        for line in f:
            tokens = line.strip().split()
            self.__getData(tokens)

    def writeData(self):
        f = open('theta1Mod.txt','w')
        for k,v in self.polar.items():
            f.write(str(v[1]) + '\n')

    def mod5(self, theta):
        if theta % 5 > 2:
            return int(np.ceil(theta/5) + 1)
        else:
            return int(np.floor(theta/5) + 1)

    def quadrant(self,x,y):
        """
        Determines quadrant of x,y coordinate for polar offset conversion
        :param x:
        :param y:
        :return:
        """
        if x>0 and y>0:
            key = 'I'
        elif x<0 and y>0:
            key = 'II'
        elif x<0 and y<0:
            key = 'III'
        else:
            key = 'IV'

        return QUADRANTS[key]

    def __polarize(self,key,values):
        """
        Take x,y coordinates and convert to polar.
        Determine quadrant
        Update quadrant var
        Apply proper function (theta = arctan(x/y) + quadrant)
        :param:
        :return: [theta, radius] for input tuple x,y
        """
        x = values[0]
        y = values[1]
        t = key
        quad = self.quadrant(x,y)
        h = np.sqrt(x**2 + y**2)
        theta = np.degrees(np.arctan(y/x) + quad)
        theta = self.mod5(theta)
        self.polar[t] = [h, theta]

    def polarize(self):
        for k, v in self.cartesian.items():
            self.__polarize(k,v)

    def convolve(self,a,v, mode='full'):
        """
        Computes the convolution of two functions via inversion and correlation
        --Taken from numpy source code--
        :return: None
        """
        a, v = array(a, ndmin=1), array(v, ndmin=1)
        if (len(v) > len(a)):
            a, v = v, a
        if len(a) == 0:
            raise ValueError('a cannot be empty')
        if len(v) == 0:
            raise ValueError('v cannot be empty')
        mode = _mode_from_name(mode)
        # Inverts g(x) to compute correlation that is equivalent to convolution of f * g
        return np.multiarray.correlate(a, v[::-1], mode)

def main():
    pol = Polaroid()
    print('Obj created')
    pol.getData()
    print('Got data')
    pol.polarize()
    print('Polarized')
    pol.writeData()
    print('Written')

if __name__ == "__main__":
    main()
