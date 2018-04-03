import sys
import numpy
from collections import defaultdict
import math

class hole:
    __slots__ = 'ID', 'x', 'y', 'time', 'map', 'accel', 'accel_map', 'xy', 'xya'

    def __init__(self, ID):
        self.ID = ID
        self.x = []
        self.y = []
        self.xy = []
        self.xya = [] # x, y, acceleration
        self.time = []
        self.accel = []
        self.map = {}
        self.accel_map = {}

    def __iter__(self):
        return [iter(self.map.values())]

    def __str__(self):
        return "\n X: %s \n Y: %s \n A: %s" % (self.x, self.y, self.accel)

    def __calc_accel(self, curr, next):
        if list is None:
            return
        return (abs(((next[0] - curr[0]) + (next[1] - curr[1]))) / 0.9375)

    def calc_accel(self):
        for prev, curr, nxt in iterate(self.map.values()):
            # print(prev, curr, nxt)
            self.accel.append(self.__calc_accel(curr, nxt))

    def make_accel_map(self):
        index = 0
        for k in self.map:
            if index == 0:
                continue
            self.accel_map[k] = self.accel[index]
            index += 1

        for k,v in self.accel_map.items():
            print('Time: ' + k + '\n Acceleration: ' + v)

    # def set_xya(self):
    #     for x,y,a in hole.x and hole.y and hole.accel:
    #         hole.xya.append(str(x) + ' ' + str(y) + ' ' + str(a))


def __parse(tokens, holes):
    if tokens[0] == '1':
        holes[0].time.append(float(tokens[1]))
        holes[0].x.append(float(tokens[2]))
        holes[0].y.append(float(tokens[3]))
        holes[0].xy.append(tokens[2] + ' ' + tokens[3])
        holes[0].map[float(tokens[1])] = [float(tokens[2]), float(tokens[3])]
    elif tokens[0] == '2':
        holes[1].time.append(float(tokens[1]))
        holes[1].x.append(float(tokens[2]))
        holes[1].y.append(float(tokens[3]))
        holes[1].xy.append(tokens[2] + ' ' + tokens[3])
        holes[1].map[float(tokens[1])] = [float(tokens[2]), float(tokens[3])]
    elif tokens[0] == '3':
        holes[2].time.append(float(tokens[1]))
        holes[2].x.append(float(tokens[2]))
        holes[2].y.append(float(tokens[3]))
        holes[2].xy.append(tokens[2] + ' ' + tokens[3])
        holes[2].map[float(tokens[1])] = [float(tokens[2]), float(tokens[3])]
    else:
        print("Error...")

def parse(filename, holes):
    with open(filename) as file:
        for line in file:
            tokens = line.strip().split()
            __parse(tokens, holes)

def create_holes():
    return [hole(1), hole(2), hole(3)]

def iterate(my_list):
    prv, cur, nxt = None, iter(my_list), iter(my_list)
    next(nxt)

    while True:
        try:
            if prv:
                yield next(prv), next(cur), next(nxt)
            else:
                yield None, next(cur), next(nxt)
                prv = iter(my_list)
        except StopIteration:
            break

def main():
    assert len(sys.argv) == 2, "Useage: parse.py"
    file_name = sys.argv[1]
    holes = create_holes()
    try:
        parse(file_name, holes)
        for hole in holes:
            hole.calc_accel()
            hole.make_accel_map()

        for hole in holes:
            print('Hole ' + str(hole.ID) + " : " + str(hole))

        write_files(holes)

    except FileNotFoundError:
        print(file_name + " not found")
        exit()

def write_files(holes):

    with open('time', 'w') as f:
        for val in holes[0].time:
            f.write(str(val) + '\n')

    # with open('xya1', 'w') as f:
    #     f.write('Hole: ' + str(holes[0].ID) + '\n')
    #     for val in holes[0].xya:
    #         f.write(str(val) + '\n')
    #
    # with open('xya2', 'w') as f:
    #     f.write('Hole: ' + str(holes[1].ID) + '\n')
    #     for val in holes[1].xya:
    #         f.write(str(val) + '\n')
    #
    # with open('xya3', 'w') as f:
    #     f.write('Hole: ' + str(holes[2].ID) + '\n')
    #     for val in holes[2].xya:
    #         f.write(str(val) + '\n')


    # with open('x1', 'w') as f:
    #     f.write('Hole: ' + str(holes[0].ID) + '\n')
    #     for val in holes[0].x:
    #         f.write(str(val) + '\n')
    #
    # with open('y1', 'w') as f:
    #     f.write('Hole: ' + str(holes[0].ID) + '\n')
    #     for val in holes[0].y:
    #         f.write(str(val) + '\n')
    #
    # with open('xy1', 'w') as f:
    #     f.write('Hole: ' + str(holes[0].ID) + '\n')
    #     for val in holes[0].xy:
    #         f.write(str(val) + '\n')
    #
    # with open('accel1', 'w') as f:
    #     f.write('Hole: ' + str(holes[0].ID) + '\n')
    #     for val in holes[0].accel:
    #         f.write(str(val) + '\n')
    #
    # with open('x2', 'w') as f:
    #     f.write('Hole: ' + str(holes[1].ID) + '\n')
    #     for val in holes[1].x:
    #         f.write(str(val) + '\n')
    #
    # with open('y2', 'w') as f:
    #     f.write('Hole: ' + str(holes[1].ID) + '\n')
    #     for val in holes[1].y:
    #         f.write(str(val) + '\n')
    #
    # with open('xy2', 'w') as f:
    #     f.write('Hole: ' + str(holes[1].ID) + '\n')
    #     for val in holes[1].xy:
    #         f.write(str(val) + '\n')
    #
    # with open('accel2', 'w') as f:
    #     f.write('Hole: ' + str(holes[1].ID) + '\n')
    #     for val in holes[1].accel:
    #         f.write(str(val) + '\n')
    #
    # with open('x3', 'w') as f:
    #     f.write('Hole: ' + str(holes[2].ID) + '\n')
    #     for val in holes[2].x:
    #         f.write(str(val) + '\n')
    #
    # with open('y3', 'w') as f:
    #     f.write('Hole: ' + str(holes[2].ID) + '\n')
    #     for val in holes[2].y:
    #         f.write(str(val) + '\n')
    #
    # with open('xy3', 'w') as f:
    #     f.write('Hole: ' + str(holes[2].ID) + '\n')
    #     for val in holes[2].xy:
    #         f.write(str(val) + '\n')
    #
    #
    # with open('accel3', 'w') as f:
    #     f.write('Hole: ' + str(holes[2].ID) + '\n')
    #     for val in holes[2].accel:
    #         f.write(str(val) + '\n')


if __name__ == '__main__':
    main()