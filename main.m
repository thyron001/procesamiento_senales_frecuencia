clc;
clear all;

%%

%Importacion del audio
[a, fs] = audioread("audio.wav");

d = length(a)/fs;

%.' Transpuesta
a_m = 0.5 * (a(:,1) + a(:,2)).';

% Waveform plot

t = linspace(0, d, length(a_m));

figure();
plot(t, a_m);
title("Audio waveform");
xlabel("Tiempo [s]");
ylabel("Amplitud");
grid on;

%Frecuencia

A_m = fftshift(fft(a_m));

f = linspace(-fs/2, fs/2, length(A_m));

mag_A = abs(A_m);

figure();
plot(f, mag_A/max(mag_A));
title("Espectro de frecuencia del Audio");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on, grid minor;

ax = gca;
ax.XAxis.Exponent = 3;





%******************************************************************
%******************************************************************
                    %Creación de Filtros ideales
%******************************************************************
%******************************************************************

%==================================================================
%                   Filtro paso bajo
%==================================================================

%% Generación del filtro

%Filtrado de los valores en frecuencia que esten entre los 500KHz
lpf = 1.*(abs(f)<=500); 

%% Grafica del filtro

figure();
plot(f, lpf,'r');
%------------------------------------------
title("Low Pass Filter");
xlabel("Frequency[Hz]");
ylabel("Amplitude");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;
%------------------------------------------

%% Grafica de la superposición del filtro y el espectro de la senial de Audio 

figure();
plot( f, mag_A/max(mag_A) );%Graficar el espectro
hold on;
plot(f,lpf,'r');            %Superponer el filtro
%------------------------------------------
legend("Audio","Filter");
xlabel("Frequency[Hz]");
ylabel("Amplitude");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;
%------------------------------------------

%% Aplicacion del filtro

A_lpf = A_m .* lpf;

figure()
plot( f, abs(A_lpf)/max(abs(A_lpf)) );%Graficar el filtrado
hold on;
plot(f,lpf,'r');                      %Superponer el filtro
%------------------------------------------
legend("Filtered Frequencies","Filter");
xlabel("Frequency[Hz]");
ylabel("Amplitude");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;
%------------------------------------------

%% Reconstrucción de la señal a partir del espectro filtrado

%Retorno del desplazamiento  y trasformada inversa
a_lpf = ifft( fftshift(A_lpf));

%Se considera unicamente la parte real de la transformada inversa
a_lpf = real(a_lpf);

%% Reproducción de audios procesados
sound(a_lpf,fs);
pause( d + 1 );
sound( a_m, fs );