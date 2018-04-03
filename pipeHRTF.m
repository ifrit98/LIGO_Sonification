% 24 frames/sec
% 1012 total frames
% 42 sec duration
% 2,016,000 total samples @ 48kHz
% 42 ms/frame
% 48 samples/ms

% --------------------------Variable initialization----------------------%
% Full sample length of each frame
fLen=2492;
% duration [s]
T = 42;
% sample rate [Hz]
sr = 48000;
% Total # of samples (2,016,000)
N = T*sr;
% Buffer samples vector
t = 0 : 1/sr : 0.06255; % To make buffer correct length
% number of samples to fade per frame
ft = 500;
% filter length
filtLen=length(HRTFL{1}); 

% Initialize left and right channel output arrays
outputL = zeros(1, N); % length(bufferL));
outputR = zeros(1, N); % length(bufferR));
i = 1;

% ------------------Convolution for first black hole----------------------%
for j=1:length(THETA{1})-1
    % Create new buffer each iteration with length of one frame
%     buffer = square(f*2*pi*t);
    buffer = rand(1,length(t)); % Initialize buffer to random white noise
    [B,A]=biquadbpf(F{1}*ACCEL{1}(j),0.01,sr); % design new filter with new Center frequency (dependent on ACCEL data)
    buffer = filter(B,A,buffer).*100; % filtering and amplitude gain

    % Update index parameters for each iteration
    src_index = i+(1:fLen+filtLen-1);
    cf_index = i+(1:ft);              
    wr_index = i+ft+(1:fLen);         
    bf_index = i+(1:fLen+filtLen-1);

    % Convolve HRTF data at azimuth with current buffer signal modulated by amplitude
    temp = conv(buffer,HRTFL{THETA{1}(j)},'valid')*(1/(R{1}(j))^2);
    % Fade in and fade out 500 samples
    temp = fadeouts(ft,fadeins(ft,temp));
    % Blend first 500 samples of temp with end of previous output
    temp(1:ft)=temp(1:ft)+outputL(cf_index);
    % Update next frame of output vector
    outputL(i:i+fLen-1) = temp;

    % Same as above for right channel
    temp = conv(buffer,HRTFR{THETA{1}(j)},'valid')*(1/(R{1}(j))^2);
    temp = fadeouts(ft,fadeins(ft,temp));
    temp(1:ft)=temp(1:ft)+outputR(cf_index);
    outputR(i:i+fLen-1) = temp;
    i = i + fLen - ft;
    
end

Y{1} = [outputL', outputR'];
y = [outputL', outputR'];
% sound(y(1:sr*3), sr);


i = 1;
outputL = zeros(1, N); % length(bufferL));
outputR = zeros(1, N); % length(bufferR));

% ------------------Convolution for second black hole---------------------%
for j=1:length(THETA{2})-1

    buffer = rand(1,length(t)); % generate random noise (white noise)
    [B,A]=biquadbpf(F{2}*ACCEL{2}(j),0.01,sr); % design new filter with new Center frequency (dependent on ACCEL data)
    buffer = filter(B,A,buffer).*100; % filtering and amplitude gain

    src_index = i+(1:fLen+filtLen-1);
    cf_index = i+(1:ft);
    wr_index = i+ft+(1:fLen);
    bf_index = i+(1:fLen+filtLen-1);

    temp = conv(buffer,HRTFL{THETA{2}(j)},'valid')*(1/(R{2}(j))^2);
    temp = fadeouts(ft,fadeins(ft,temp));
    temp(1:ft)=temp(1:ft)+outputL(cf_index);
    outputL(i:i+fLen-1) = temp;

    temp = conv(buffer,HRTFR{THETA{2}(j)},'valid')*(1/(R{2}(j))^2);
    temp = fadeouts(ft,fadeins(ft,temp));
    temp(1:ft)=temp(1:ft)+outputR(cf_index);
    outputR(i:i+fLen-1) = temp;
    i = i + fLen - ft;
    
end

Y{2} = [outputL', outputR'];

i = 1;
% Initialize output array
outputL = zeros(1, N); % length(bufferL));
outputR = zeros(1, N); % length(bufferR));
% ------------------Convolution for third black hole----------------------%
for j=1:length(THETA{3})-1

    buffer = rand(1,length(t)); % generate random noise (white noise)
    [B,A]=biquadbpf(F{3}*ACCEL{3}(j),0.01,sr); % design new filter with new Center frequency (dependent on ACCEL data)
    buffer = filter(B,A,buffer).*100; % filtering and amplitude gain

    src_index = i+(1:fLen+filtLen-1);
    cf_index = i+(1:ft);
    wr_index = i+ft+(1:fLen);
    bf_index = i+(1:fLen+filtLen-1);

    temp = conv(buffer,HRTFL{THETA{3}(j)},'valid')*(1/(R{3}(j))^2);
    temp = fadeouts(ft,fadeins(ft,temp));
    temp(1:ft)=temp(1:ft)+outputL(cf_index);
    outputL(i:i+fLen-1) = temp;

    temp = conv(buffer,HRTFR{THETA{3}(j)},'valid')*(1/(R{3}(j))^2);
    temp = fadeouts(ft,fadeins(ft,temp));
    temp(1:ft)=temp(1:ft)+outputR(cf_index);
    outputR(i:i+fLen-1) = temp;
    i = i + fLen - ft;
    
end

Y{3} = [outputL', outputR'];
z = Y{1} + Y{2} + Y{3};
% sound(z(1:sr*5)); % Uncomment to hear

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
 % a typical function of fadein/out => equal-power mode:: sin^2 + cos^2 = 1
    p = sin(pi.*[0:1/s:1]/2);
    
    out = in;
    for i=1:s
        out(end-i+1) = out(end-i+1) * p(i);
    end
end

% Biquadradic linear bypass filter 
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
%--------------------------------------------------------------------
% Extra filters unused, here added for experimenation 

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