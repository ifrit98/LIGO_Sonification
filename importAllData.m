   % Import and modify all data as needed
ACCEL = cell(1,3);
R = cell(1,3);
THETA = cell(1,3);
HRTFL = cell(1,72);
HRTFR = cell(1,72);
Y = cell(3,1);
F = cell(1,3);
F{1} = 164;
F{2} = 417;
F{3} = 639;

for i = 1:3
    fn = sprintf('accel%d.txt', i);
    if exist(fn, 'file')
        ACCEL{i} = importdata(fn);
    else
        fprintf('File %s does not exist.\n', fileName);
    end
   
    fnR = sprintf('R%d.txt', i);
    if exist(fnR, 'file')
        R{i} = importdata(fnR);
        R{i} = R{i}+1;
        R{i} = R{i}';
    else
        fprintf('File %s does not exist.\n', fileName);
    end
    
        fnT = sprintf('theta%dMod.txt', i);
    if exist(fnT, 'file')
        THETA{i} = importdata(fnT);
        THETA{i} = THETA{i}';
    else
        fprintf('File %s does not exist.\n', fileName);
    end

end

ACCEL{1} = (ACCEL{1}*5 + 1.25)';

ACCEL{2} = ACCEL{2}*15;
ACCEL1 = ACCEL{2}(1:44)*0.15;
ACCEL2 = ACCEL{2}(45:116)*0.1;
ACCEL3 = ACCEL{2}(117:121)*0.2;
ACCEL4 = ACCEL{2}(122:224)*0.05;
ACCEL5 = ACCEL{2}(225:end)*0.05;
ACCEL3M = [ACCEL1', ACCEL2', ACCEL3', ACCEL4', ACCEL5'];
ACCEL{2} = (ACCEL3M + 1.0)*1.75; 

ACCEL{3} = ACCEL{3}*15;
ACCEL1 = ACCEL{3}(1:44)*0.15;
ACCEL2 = ACCEL{3}(45:116)*0.1;
ACCEL3 = ACCEL{3}(117:121)*0.5;
ACCEL4 = ACCEL{3}(122:224)*0.05;
ACCEL5 = ACCEL{3}(225:end)*0.05;
ACCEL3M = [ACCEL1', ACCEL2', ACCEL3', ACCEL4', ACCEL5'];
ACCEL{3} = (ACCEL3M + 0.5)*1.75; 

k = 0;
for i = 1:72
    fileName = sprintf('elev0/L0e%da.wav', k);
    k = k + 5;
    if exist(fileName, 'file')
        HRTFL{i} = audioread(fileName);
    else
        fprintf('File %s does not exist.\n', fileName);
    end
   
end

k = 0;
for i = 1:72
    fileName = sprintf('elev0/R0e%da.wav', k);
    k = k + 5;
    if exist(fileName, 'file')
        HRTFR{i} = audioread(fileName);
    else
        fprintf('File %s does not exist.\n', fileName);
    end
   
end

for i = 1:72
    HRTFL{i} = HRTFL{i}';
    HRTFR{i} = HRTFR{i}';
end
