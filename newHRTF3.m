% fLen=1992;
fLen = 2492;
% duration [s]
T = 42;
% sample rate [Hz]
sr = 48000;
% # of samples (2,016,000)
N = T*sr + 402; % 2016402
% samples vector
% t = 0 : N;
t = 0 : 1/sr : 0.06255; % To make buffer 2503 samples
% t = 0 : 1/sr : 0.05214; % To make buffer 1992 samples

% reverb = reverberator('PreDelay',0.5,'WetDryMix',1);
% audioOut = reverb(audioIn) USAGE

for m=1:3
    % Initialize output array
    outputL = zeros(1, N); % length(bufferL));
    outputR = zeros(1, N); % length(bufferR));
    % Convolution
    i = 1;
    ft = 500; % number of samples
    filtLen=length(HRTFL{1}); % filter length 
    f = F{m}; % Get current frequency
    for j=1:length(THETA{m})-1
        buffer = rand(1,length(t)); % Generate random noise (white noise)
        [B,A]=biquadbpf(f*ACCEL{m}(j), 0.01 ,sr); % Design new filter with new Center frequency (dependent on ACCEL data)
        buffer = filter(B,A,buffer).*300; % Apply filter
        
        % Update index parameters for each iteration
        src_index = i+(1:fLen+filtLen-1);
        cf_index = i+(1:ft);
        wr_index = i+ft+(1:fLen);
        bf_index = i+(1:fLen+filtLen-1);
        
        temp = conv(buffer,HRTFL{THETA{m}(j)},'valid')*(1/(R{m}(j))^2);
        temp = fadeouts(ft,fadeins(ft,temp));
        temp(1:ft)=temp(1:ft)+outputL(cf_index);
        outputL(i:i+fLen-1) = temp;

        temp = conv(buffer,HRTFR{THETA{m}(j)},'valid')*(1/(R{m}(j))^2);
        temp = fadeouts(ft,fadeins(ft,temp));
        temp(1:ft)=temp(1:ft)+outputR(cf_index);
        outputR(i:i+fLen-1) = temp;
        i = i + fLen - ft;
    end
    j = 1;
    % Transpose to columns for LR channels
    y = [outputL', outputR'];
%     sound(y(1:sr*3), sr);
    Y{m} = y;
    
end

% scope = dsp.SpectrumAnalyzer;
% scope(y);

% Condense all three objects to 2 channels by scalar addition
z = Y{1} + Y{2} + Y{3};

% Uncomment to hear y or z vectors
% sound(y(1:sr*5),sr);
% sound(z(1:sr*5),sr);
% audiowrite('bpf_all_ver1EXTENDED.wav',z,sr,'BitsPerSample',24);

% SOURSE: Audio EQ cookbook (github)
function out = fadeins(s,in)
% s = samples    
% a typical function of fadein/out => equal-power mode:: sin^2 + cos^2 = 1    
    p = sin(pi.*[0:1/s:1]/2); 
    

    out = in;
    for i=1:s
        out(i) = out(i) * p(i);
    end
end

function out = fadeouts(s,in)
% s = samples  
    p = sin(pi.*[0:1/s:1]/2);
    
    out = in;
    for i=1:s
        out(end-i+1) = out(end-i+1) * p(i);
    end
end

function [B,A]=biquadbpf(fc,Q,fs)
% fc = center frequency
% bw = bandwidth
% fs = sampling frequency
omega = 2*pi*fc/fs;
alpha = sin(omega) * Q;

B = [
    alpha
    0
   -alpha
];
A = [
    1 + alpha
   -2 * cos(omega)
    1 - alpha
];
end


function [B,A]=LPF(fc,Q,fs)
% fc = center frequency
% bw = bandwidth
% fs = sampling frequency
omega = 2*pi*fc/fs;
alpha = sin(omega) * Q; 

B = [
    (1-cos(omega))/2
    1-cos(omega)
    (1-cos(omega))/2
];
A = [
    1 + alpha
   -2 * cos(omega)
    1 - alpha
];
end


function [B,A]=HPF(fc,Q,fs)
% fc = center frequency
% bw = bandwidth
% fs = sampling frequency
omega = 2*pi*fc/fs;
alpha = sin(omega) * Q; 

B = [
    (1+cos(omega))/2
    -(1+cos(omega))
    (1+cos(omega))/2
];
A = [
    1 + alpha
   -2 * cos(omega)
    1 - alpha
];
end

function [B,A]=BPF(fc,Q,fs) % Constant-skirt gain
% fc = center frequency
% bw = bandwidth
% fs = sampling frequency
omega = 2*pi*fc/fs;
alpha = sin(omega) * Q; 

B = [
    Q*alpha
    0
    -Q*alpha
];
A = [
    1 + alpha
   -2 * cos(omega)
    1 - alpha
];
end