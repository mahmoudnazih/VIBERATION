clc,clear;

pkg load instrument-control;
pkg load io;
# Opens serial port ttyUSB1 with baudrate of 115200 (config defaults to 8-N-1)
s1 = serial("/dev/ttyACM1", 38400)    #for linux devices
# Flush input and output buffers
srl_flush(s1); 

filename = 'data.txt';        #name of the output file
fle = fopen(filename,'w');    #open the output file to write to
N = 1000;                         #Record N-0.2*N value in file

 for i=1:N
 data = srl_read(s1, 12);   #Accept data as 12 bytes
# Convert uint8 array to string, 
fputs(fle,char(data));        # convert data to char value and write to a file
 end                          #end of receive

 fclose(fle);                 #close the file

 fle = fopen(filename,'r');
data_values= dlmread(filename);

a_x = data_values(:,1);
a_y = data_values(:,2);
a_z = data_values(:,3);


n = numel (a_x);                         % number of readings that we iterate on 

v_x(1) = 0;                                  % initial condition for velocity
v_y(1) = 0;
v_z(1) = 0;

s_x(1) = 0;                                   % initial condition for displacement
s_y(1) = 0;
s_z(1) = 0;

del_t = 0.00001;                                  % sampling time

for i = 1 :n
    v_x(i+1) =  v_x(i) + ( a_x (i) * del_t );              %��� ��������
    v_y(i+1) =  v_y(i) + ( a_y (i) * del_t );
    v_z(i+1) =  v_z(i) + ( a_z (i) * del_t );
end

for i = 1 :n
    s_x(i+1) = s_x(i) + ( v_x(i) * del_t );              %���� ��������
    s_y(i+1) = s_y(i) + ( v_y(i) * del_t );
    s_z(i+1) = s_z(i) + ( v_z(i) * del_t );
end


s_x=s_x.' ;
s_y=s_y.' ;
s_z=s_z.' ;
                                   % transposing from rows to vectors                                                   
v_x=v_x.' ;
v_y=v_y.' ;
v_z=v_z.' ;

S = [s_x;s_y;s_z];
Fs = 200;             #sampling frequency
T = 1/Fs;             #Sampling Period
L = numel(S);             % Length of signal
t = (0:L-1)*T;        % Time vector

%figure 1;
%plot(1000*t(1:L),S(1:L))

Y = fft(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:numel(P1)-1) = 2*P1(2:numel(P1)-1);
f = Fs*(0:(L/2))/L;
plot(f,P1) 
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

