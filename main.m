clc;
clear ;
close all;

%% Importación del audio
% Se lee el archivo de audio "audio.wav"
[datos_audio, frecuencia_muestreo] = audioread("rain.wav");

% Se calcula la duración del audio
duracion_audio = length(datos_audio) / frecuencia_muestreo;

% Se obtiene la señal promediada de ambos canales de audio
senal_promediada = 0.5 * (datos_audio(:, 1) + datos_audio(:, 2)).'; % Transpuesta



% Análisis en frecuencia
espectro_audio = fftshift(fft(senal_promediada)); % Transformada de Fourier centrada
frecuencias = linspace(-frecuencia_muestreo/2, frecuencia_muestreo/2, length(espectro_audio));
mag_espectro = abs(espectro_audio);

% Gráfico del espectro de frecuencia del audio
figure();
sgtitle('Sistema en el dominio de la frecuencia');
subplot(3,1,1);
plot(frecuencias, mag_espectro/max(mag_espectro));
title("Espectro de frecuencia del Audio");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on, grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Creación de Filtros ideales

% Filtro paso bajo
filtro_paso_bajo = 1.*(abs(frecuencias)<=500); % Filtro que mantiene frecuencias menores a 500 Hz

% Gráfico del filtro paso bajo
subplot(3,1,2);
plot(frecuencias, filtro_paso_bajo,'r');
title("Filtro Pasa Bajo");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Aplicación del filtro
espectro_filtrado = espectro_audio .* filtro_paso_bajo;

% Gráfico del espectro de frecuencia filtrado y superposición con el filtro
subplot(3,1,3);
plot(frecuencias, abs(espectro_filtrado)/max(abs(espectro_filtrado))); % Espectro filtrado
hold on;
plot(frecuencias, filtro_paso_bajo,'r'); % Superposición del filtro
legend("Frecuencias filtradas","Filtro");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%-----------------Graficas del dominio del tiempo--------------------------

%% Gráfico de la forma de onda del audio
tiempo = linspace(0, duracion_audio, length(senal_promediada));
figure();
sgtitle('Sistema en el dominio del tiempo');
subplot(3,1,1);
plot(tiempo, senal_promediada/max(senal_promediada));
title("Forma de onda del audio");
ylabel("Amplitud");
grid on;

%% Transformada inversa para pasar el filtro al dominio del tiempo
filtro_tiempo = fftshift(ifft(fftshift(filtro_paso_bajo))); % Transformada inversa
o = length(tiempo)/2;
r = o-1000:o+1000;
filtro_tiempo = filtro_tiempo/max(filtro_tiempo);
t_filtro = linspace(-duracion_audio/2, duracion_audio/2, length(filtro_tiempo));
% Gráfico del filtro paso bajo en el dominio del tiempo
subplot(3,1,2);
plot(t_filtro(r), real(filtro_tiempo(r)));
title("Filtro Pasa Bajo");
ylabel("Amplitud");
grid on;

%% Transformada inversa para pasar la señal filtrada al dominio del tiempo
salida_tiempo = fftshift(ifft(fftshift(espectro_filtrado))); % Transformada inversa
salida_tiempo =  salida_tiempo/max(salida_tiempo).';

% Gráfico de la forma de onda del audio
tiempo = linspace(0, duracion_audio, length(salida_tiempo));
subplot(3,1,3);
plot(tiempo, real(salida_tiempo));
title("Forma de onda de señal filtrada");
xlabel("Tiempo [s]");
ylabel("Amplitud");
grid on;

%--------------------------------------------------------------------------

%% Reconstrucción de la señal a partir del espectro filtrado
audio_filtrado = ifft(fftshift(espectro_filtrado)); % Transformada inversa
audio_filtrado = real(audio_filtrado); % Se toma solo la parte real

% Reproducción de audios procesados
sound(audio_filtrado,frecuencia_muestreo); % Audio filtrado
pause( duracion_audio + 1 );
sound(senal_promediada, frecuencia_muestreo); % Audio original
