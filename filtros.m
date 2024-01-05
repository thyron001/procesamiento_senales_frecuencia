clc;
clear all;
close all;

%% Importación del audio
% Se lee el archivo de audio "audio.wav"
[datos_audio, frecuencia_muestreo] = audioread("counting_stars_cut.wav");

% Se calcula la duración del audio
duracion_audio = length(datos_audio) / frecuencia_muestreo;

% Se obtiene la señal promediada de ambos canales de audio
senal_promediada = 0.5 * (datos_audio(:, 1) + datos_audio(:, 2)).'; % Transpuesta



%% Análisis en frecuencia
espectro_audio = fftshift(fft(senal_promediada)); % Transformada de Fourier centrada
frecuencias = linspace(-frecuencia_muestreo/2, frecuencia_muestreo/2, length(espectro_audio));
mag_espectro = abs(espectro_audio);

% Gráfico del espectro de frecuencia del audio
figure(2);
sgtitle('Sistema en el dominio de la frecuencia');
subplot(3,3,[1,3]);
plot(frecuencias, mag_espectro/max(mag_espectro));
title("Espectro de frecuencia del Audio");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on, grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%% Creación de Filtros ideales

% Filtro paso bajo
filtro_paso_bajo = (abs(frecuencias)<=200); % Filtro que mantiene frecuencias menores a 400 Hz
filtro_pasa_banda = ((abs(frecuencias)>=1000).*(abs(frecuencias)<=2000)); 
filtro_pasa_alta = (abs(frecuencias)>=2500);

% Gráfico del filtro paso bajo
subplot(3,3,4);
plot(frecuencias, filtro_paso_bajo,'r');
title("Filtro Pasa Bajo");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
ylim([-0.1 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Gráfico del filtro paso banda
subplot(3,3,5);
plot(frecuencias, filtro_pasa_banda,'g');
title("Filtro Pasa Banda");
xlabel("Frecuencia [Hz]");
ylim([-0.1 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Gráfico del filtro paso alto
subplot(3,3,6);
plot(frecuencias, filtro_pasa_alta,'c');
title("Filtro Pasa Alto");
xlabel("Frecuencia [Hz]");
ylim([-0.1 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%%----------- Aplicación del filtros -------------%%
filtrado_lpf = espectro_audio .* filtro_paso_bajo;
filtrado_bpf = espectro_audio .* filtro_pasa_banda;
filtrado_hpf = espectro_audio .* filtro_pasa_alta;
%%------------------------------------------------%%

% Gráfico del espectro de frecuencia filtrado y superposición con el filtro
%%--------------------------filtro pasa bajo------------------------------%%
figure(2);
subplot(3,3,7);
plot(frecuencias, abs(filtrado_lpf)/max(abs(filtrado_lpf))); % Espectro filtrado
hold on;
plot(frecuencias, filtro_paso_bajo,'r'); % Superposición del filtro
legend("Frecuencias filtradas","Filtro");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
ylim([0 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%%--------------------------filtro pasa banda------------------------------%%
figure(2);
subplot(3,3,8);
plot(frecuencias, abs(filtrado_bpf)/max(abs(filtrado_bpf))); % Espectro filtrado
hold on;
plot(frecuencias, filtro_pasa_banda,'g'); % Superposición del filtro
legend("Frecuencias filtradas","Filtro");
xlabel("Frecuencia [Hz]");
ylim([0 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%%--------------------------filtro pasa alto------------------------------%%
figure(2);
subplot(3,3,9);
plot(frecuencias, abs(filtrado_hpf)/max(abs(filtrado_hpf))); % Espectro filtrado
hold on;
plot(frecuencias, filtro_pasa_alta,'c'); % Superposición del filtro
legend("Frecuencias filtradas","Filtro");
xlabel("Frecuencia [Hz]");
ylim([0 1.1])
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%%-----------------Graficas del dominio del tiempo--------------------------
%%
%% Gráfico de la forma de onda del audio
tiempo = linspace(0, duracion_audio, length(senal_promediada));

figure(1);
sgtitle('Sistema en el dominio del tiempo');
subplot(3,3,[1,3]);
plot(tiempo, senal_promediada/max(senal_promediada));
title("Forma de onda del audio");
ylabel("Amplitud");
grid on;

%% Transformada inversa para pasar el filtro al dominio del tiempo
o = length(tiempo)/2;
r = o-1000:o+1000;
%%--------------------------filtro paso bajo------------------------------%%
lpf_tiempo = fftshift(ifft(fftshift(filtro_paso_bajo))); % Transformada inversa
lpf_tiempo = lpf_tiempo/max(lpf_tiempo);
t_lpf = linspace(-duracion_audio/2, duracion_audio/2, length(lpf_tiempo));

%%--------------------------filtro pasa banda------------------------------%%
bpf_tiempo = fftshift(ifft(fftshift(filtro_pasa_banda))); % Transformada inversa
bpf_tiempo = bpf_tiempo/max(bpf_tiempo);
t_bpf = linspace(-duracion_audio/2, duracion_audio/2, length(bpf_tiempo));

%%--------------------------filtro pasa alto------------------------------%%
hpf_tiempo = fftshift(ifft(fftshift(filtro_pasa_alta))); % Transformada inversa
hpf_tiempo = hpf_tiempo/max(hpf_tiempo);
t_hpf = linspace(-duracion_audio/2, duracion_audio/2, length(hpf_tiempo));

% Gráfico del filtros en el dominio del tiempo
figure(1);
subplot(3,3,4);
plot(t_lpf(r), real(lpf_tiempo(r)));
title("Filtro Pasa Bajo");
ylabel("Amplitud");
grid on;

subplot(3,3,5);
plot(t_bpf(r), real(bpf_tiempo(r)));
title("Filtro Pasa Banda");
grid on;

subplot(3,3,6);
plot(t_hpf(r), real(hpf_tiempo(r)));
title("Filtro Pasa Alto");
grid on;

%% Transformada inversa para pasar la señal filtrada al dominio del tiempo
salida_tiempo_l = fftshift(ifft(fftshift(filtrado_lpf))); % Transformada inversa
salida_tiempo_l =  salida_tiempo_l/max(salida_tiempo_l).';

salida_tiempo_b = fftshift(ifft(fftshift(filtrado_bpf))); % Transformada inversa
salida_tiempo_b =  salida_tiempo_b/max(salida_tiempo_b).';

salida_tiempo_h = fftshift(ifft(fftshift(filtrado_hpf))); % Transformada inversa
salida_tiempo_h =  salida_tiempo_h/max(salida_tiempo_h).';

% Gráfico de la forma de onda del audio filtrado 

tiempo_l = linspace(0, duracion_audio, length(salida_tiempo_l)); %%(LPF)
tiempo_b = linspace(0, duracion_audio, length(salida_tiempo_b)); %%(BPF)
tiempo_h = linspace(0, duracion_audio, length(salida_tiempo_h)); %%(HPF)

figure(1);
subplot(3,3,7);
plot(tiempo, real(salida_tiempo_l));
title("Forma de onda de señal filtrada(LPF)");
xlabel("Tiempo [s]");
ylabel("Amplitud");
grid on;

subplot(3,3,8);
plot(tiempo, real(salida_tiempo_b));
title("Forma de onda de señal filtrada(BPF)");
xlabel("Tiempo [s]");
grid on;

subplot(3,3,9);
plot(tiempo, real(salida_tiempo_h));
title("Forma de onda de señal filtrada(HPF)");
xlabel("Tiempo [s]");
grid on;

%--------------------------------------------------------------------------

%% Reconstrucción de la señal a partir del espectro filtrado
audio_filtrado_l = ifft(fftshift(filtrado_lpf)); % Transformada inversa
audio_filtrado_l = real(audio_filtrado_l); % Se toma solo la parte real

audio_filtrado_b = ifft(fftshift(filtrado_bpf)); 
audio_filtrado_b = real(audio_filtrado_b); 

audio_filtrado_h = ifft(fftshift(filtrado_hpf)); 
audio_filtrado_h = real(audio_filtrado_h);


% Reproducción de audios procesados
sound(audio_filtrado_l,frecuencia_muestreo); % Audio filtrado (LPF)
pause( duracion_audio + 1 );

sound(audio_filtrado_b,frecuencia_muestreo); % Audio filtrado (BPF)
pause( duracion_audio + 1 ); 

sound(audio_filtrado_h,frecuencia_muestreo); % Audio filtrado (HPF)
pause( duracion_audio + 1 );

sound(senal_promediada, frecuencia_muestreo); % Audio original