% === Parte 1: Gravação da voz ===
Fs = 12000;      % Frequência de amostragem
dur = 5;         % Duração da gravação (s)
voz = audiorecorder(Fs, 16, 1);  % Mono, 16 bits

disp('Gravando... Fale agora.');
recordblocking(voz, dur);
disp('Gravação finalizada.');

vt = getaudiodata(voz);   % Sinal de voz (v[n])
t = (0:length(vt)-1)/Fs;  % Vetor de tempo

audiowrite('voz_original.wav', vt, Fs);  % Salva voz original
soundsc(vt, Fs);   % Reproduz a voz original com ajuste automático de volume

% === Parte 2: Geração do ruído senoidal ===
a1 = 0.4;
a2 = 0.3;
f1 = 5400;   % Frequência do primeiro ruído (Hz)
f2 = 5700;   % Frequência do segundo ruído (Hz)

rt = a1*cos(2*pi*f1*t') + a2*cos(2*pi*f2*t');  % Ruído senoidal
zt = vt + rt;  % Sinal corrompido
soundsc(zt, Fs);  % Reproduz sinal corrompido

% === Parte 3: Projeto do filtro FIR rejeita-faixa ===
M = 156;  % Ordem do filtro (número de coeficientes - 1)

w1 = 2*pi*f1/Fs;  % Frequência angular inferior
w2 = 2*pi*f2/Fs;  % Frequência angular superior
wc = (w1 + w2)/2; % Frequência central angular

n = 0:M+1;               % Vetor de índices
N = n - M/2;           % Centralizado em zero

% Resposta ideal do filtro rejeita-faixa
hd = (sin(w2*N) - sin(w1*N)) ./ (pi*N);
hd(M/2 + 1) = (w2 - w1)/pi;  % Corrige divisão por zero no centro

% Janela de Hanning
wHann = (0.5 - 0.5*cos(2*pi*n/M));

% Resposta ao impulso final
hc = hd .* wHann;

% === Parte 4: Aplicação do filtro ===
yt = filter(hc, 1, zt);  % Sinal filtrado
soundsc(yt, Fs);  % Reproduz o sinal filtrado
audiowrite('voz_filtrada.wav', yt, Fs);  % Salva o sinal filtrado

% === Parte 5: Análise no tempo e frequência ===

% --- Tempo ---
figure;
subplot(3,1,1); plot(t, vt); title('Sinal de Voz v[n]'); xlabel('Tempo (s)'); ylabel('Amplitude');
subplot(3,1,2); plot(t, zt); title('Sinal Corrompido z[n]'); xlabel('Tempo (s)'); ylabel('Amplitude');
subplot(3,1,3); plot(t, yt); title('Sinal Filtrado y[n]'); xlabel('Tempo (s)'); ylabel('Amplitude');

% --- Frequência ---
V = abs(fftshift(fft(vt)));
Z = abs(fftshift(fft(zt)));
Y = abs(fftshift(fft(yt)));
f = linspace(-Fs/2, Fs/2, length(vt));

figure;
subplot(3,1,1); plot(f, V); title('Magnitude de v[n]'); xlabel('Frequência (Hz)'); ylabel('|V(f)|');
subplot(3,1,2); plot(f, Z); title('Magnitude de z[n]'); xlabel('Frequência (Hz)'); ylabel('|Z(f)|');
subplot(3,1,3); plot(f, Y); title('Magnitude de y[n]'); xlabel('Frequência (Hz)'); ylabel('|Y(f)|');

% --- Resposta ao impulso do filtro ---
figure;
plot(n - M/2, hc, 'r');
title('Resposta ao Impulso do Filtro FIR');
xlabel('n'); ylabel('Amplitude');

% --- Resposta em frequência (freqz) ---
[Hf, wf] = freqz(hc, 1, 1024, Fs);
figure;
subplot(2,1,1); plot(wf, abs(Hf)); title('Magnitude da Resposta em Freq.'); xlabel('Frequência (Hz)'); ylabel('|H(f)|');
subplot(2,1,2); plot(wf, unwrap(angle(Hf))); title('Fase da Resposta em Freq.'); xlabel('Frequência (Hz)'); ylabel('Fase (rad)');

