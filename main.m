clc;
clear all;

%% Importación del audio
% Se lee el archivo de audio "audio.wav"
[datos_audio, frecuencia_muestreo] = audioread("audio.wav");

% Se calcula la duración del audio
duracion_audio = length(datos_audio) / frecuencia_muestreo;

% Se obtiene la señal promediada de ambos canales de audio
senal_promediada = 0.5 * (datos_audio(:, 1) + datos_audio(:, 2)).'; % Transpuesta

% Gráfico de la forma de onda del audio
tiempo = linspace(0, duracion_audio, length(senal_promediada));
figure();
plot(tiempo, senal_promediada);
title("Audio waveform");
xlabel("Tiempo [s]");
ylabel("Amplitud");
grid on;

% Análisis en frecuencia
espectro_audio = fftshift(fft(senal_promediada)); % Transformada de Fourier centrada
frecuencias = linspace(-frecuencia_muestreo/2, frecuencia_muestreo/2, length(espectro_audio));
mag_espectro = abs(espectro_audio);

% Gráfico del espectro de frecuencia del audio
figure();
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
figure();
plot(frecuencias, filtro_paso_bajo,'r');
title("Low Pass Filter");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Superposición del filtro y el espectro de la señal de Audio
figure();
plot(frecuencias, mag_espectro/max(mag_espectro)); % Espectro de frecuencia original
hold on;
plot(frecuencias, filtro_paso_bajo,'r'); % Superposición del filtro
legend("Audio","Filter");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Aplicación del filtro
espectro_filtrado = espectro_audio .* filtro_paso_bajo;

% Gráfico del espectro de frecuencia filtrado y superposición con el filtro
figure()
plot(frecuencias, abs(espectro_filtrado)/max(abs(espectro_filtrado))); % Espectro filtrado
hold on;
plot(frecuencias, filtro_paso_bajo,'r'); % Superposición del filtro
legend("Filtered Frequencies","Filter");
xlabel("Frecuencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

% Transformada inversa para pasar el filtro al dominio del tiempo
filtro_tiempo = fftshift(ifft(filtro_paso_bajo)); % Transformada inversa
t_filtro = linspace(-duracion_audio/2, duracion_audio/2, length(filtro_tiempo));
% Gráfico del filtro paso bajo en el dominio del tiempo
figure();
plot(t_filtro .* 0.5, abs(filtro_tiempo) / min(abs(filtro_tiempo)));
title("Low Pass Filter (Time Domain)");
xlabel("Tiempo [s]");
ylabel("Amplitud");
grid on;

%% Reconstrucción de la señal a partir del espectro filtrado
audio_filtrado = ifft(fftshift(espectro_filtrado)); % Transformada inversa
audio_filtrado = real(audio_filtrado); % Se toma solo la parte real

% Reproducción de audios procesados
sound(audio_filtrado,frecuencia_muestreo); % Audio filtrado
pause( duracion_audio + 1 );
sound(senal_promediada, frecuencia_muestreo); % Audio original
