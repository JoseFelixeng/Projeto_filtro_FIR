% === Parte 1: Parâmetros ===
Fc = 14000;      % Frequência de amostragem (processamento e gravação)
dur = 5;         % Duração da gravação (s)
d_s = 0.0316;    % Delta de frequência de transição no domínio do sinal
d_w = 0.04*pi;   % Largura de transição no domínio de frequência
d_f = d_w / (2*pi);
a1 = 0.5;
a2 = 0.5;
f1 = 5400;       % Frequência do primeiro ruído (Hz)
f2 = 5700;       % Frequência do segundo ruído (Hz)

% === Parte 2: Gravação de voz ===
voz = audiorecorder(Fc, 16, 1);  % Mono, 16 bits
disp('Gravando... Fale agora.');
recordblocking(voz, dur);
disp('Gravação finalizada.');

vt = getaudiodata(voz);   % Sinal de voz

audiowrite('voz_original.wav', vt, Fc);  % Salva voz original
soundsc(vt, Fc);   % Reproduz voz original

t = (0:length(vt)-1)/Fc;  % Vetor de tempo

% === Parte 3: Adição de ruído senoidal ===
rt = a1*cos(2*pi*f1*t') + a2*cos(2*pi*f2*t');
zt = vt + rt;

soundsc(zt, Fc);  % Reproduz sinal corrompido

% === Parte 4: Projeto do filtro FIR rejeita-faixa ===
M = 156;                         % Ordem do filtro
n = 0:M;                         % Vetor de índices
N = n - M/2;                     % Centralizado em zero

w1 = 2*pi*f1/Fc;
w2 = 2*pi*f2/Fc;
fc = (f1 + f2)/2;
wc = 2*pi*fc/Fc;

% Resposta ideal (rejeita-faixa)
hd = 1 - ((sin(w2*N) - sin(w1*N)) ./ (pi*N));
hd(M/2 + 1) = 1 - (w2 - w1)/pi;  % Corrige divisão por zero

% Janela de Hanning
wHann = 0.5 - 0.5*cos(2*pi*n/M);

% Resposta ao impulso final
hc = hd .* wHann;

% === Parte 5: Aplicação do filtro ===
yt = filter(hc, 1, zt);  % Sinal filtrado
soundsc(yt, Fc);
audiowrite('voz_filtrada.wav', yt, Fc);

% === Parte 6: Análise no tempo ===
figure;
subplot(3,1,1); plot(t, vt); title('Sinal de Voz v[n]'); xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,2); plot(t, zt); title('Sinal Corrompido z[n]'); xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;
subplot(3,1,3); plot(t, yt); title('Sinal Filtrado y[n]'); xlabel('Tempo (s)'); ylabel('Amplitude'); grid on;

% === Parte 7: Análise no domínio da frequência ===
Nfft = length(vt);
f = linspace(-Fc/2, Fc/2, Nfft);

V = fftshift(fft(vt));
Z = fftshift(fft(zt));
Y = fftshift(fft(yt));

VdB = 20*log10(abs(V) + 1e-6);
ZdB = 20*log10(abs(Z) + 1e-6);
YdB = 20*log10(abs(Y) + 1e-6);

figure;
subplot(3,1,1); plot(f, VdB); title('Espectro de v[n] (dB)'); xlabel('Frequência (Hz)'); ylabel('|V(f)| (dB)'); grid on;
subplot(3,1,2); plot(f, ZdB); title('Espectro de z[n] (dB)'); xlabel('Frequência (Hz)'); ylabel('|Z(f)| (dB)'); grid on;
subplot(3,1,3); plot(f, YdB); title('Espectro de y[n] (dB)'); xlabel('Frequência (Hz)'); ylabel('|Y(f)| (dB)'); grid on;

% === Parte 8: Resposta ao impulso ===
figure;
plot(N, hc, 'r'); title('Resposta ao Impulso do Filtro FIR'); xlabel('n'); ylabel('Amplitude'); grid on;

% === Parte 9: Resposta em frequência (freqz) ===
[Hf, wf] = freqz(hc, 1, 1024, Fc);
figure;
subplot(2,1,1); plot(wf, abs(Hf)); title('Magnitude da Resposta em Freq.'); xlabel('Frequência (Hz)'); ylabel('|H(f)|'); grid on;
subplot(2,1,2); plot(wf, unwrap(angle(Hf))); title('Fase da Resposta em Freq.'); xlabel('Frequência (Hz)'); ylabel('Fase (rad)'); grid on;

