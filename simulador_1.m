disp('Carregando o arquivo .wav')
filename = 'Church Schellingwoude.wav';;
[y, Fs] = audioread(filename);
y = mean(y,2); % Utilizado para usar apenas o canal mono do audio
disp('Carregamento Completo')

disp('Gravando a voz de entrada!!!')
minha_voz = audiorecorder(44100, 16, 1);
recordblocking(minha_voz, 4);
disp('Voz Gravada com sucesso');

play(minha_voz);

dados = getaudiodata(minha_voz);

disp('Salvando arquivo de auvio da voz')
audiowrite('minha_voz.wav', dados,44100);

% Normalizando a energia do sinal
resposta = y;
a = var(dados);
b = var(y);
dados = (dados/a) * b;

% Fazendo a convolução
convolucao = conv(dados, resposta);


player = audioplayer(convolucao, Fs);  % Fs é a taxa de amostragem
play(player);


% Salvando a convolução em um novo arquivo de áudio
disp('Salvando aqui da convolução')
audiowrite('convolucao.wav', convolucao, Fs);

disp('Arquivo Salvo com Sucesso, convolucao.wav')


% Plot da Resposta ao Impulso (y)
figure;
t_ir = (0:length(y)-1)/Fs;  % Vetor de tempo
plot(t_ir, y);
xlabel('Tempo (s)');
ylabel('Amplitude');
title('Resposta ao Impulso do Filtro (Church Audio)');
grid on;

% Cálculo da Resposta em Frequência (FFT de y)
N = length(y);               % Número de amostras
Y = fft(y);                  % TFTD via FFT
freq = Fs*(0:N-1)/N;         % Vetor de frequência (0 a Fs Hz)

% Ajuste para frequências positivas (0 a Fs/2)
Y_one_sided = Y(1:floor(N/2)+1);
freq_one_sided = freq(1:floor(N/2)+1);

% Magnitude (em dB)
magnitude_dB = 20*log10(abs(Y_one_sided));

% Fase (desembaralhada)
phase_rad = unwrap(angle(Y_one_sided));

% Plot da Magnitude
figure;
subplot(2,1,1);
plot(freq_one_sided, magnitude_dB);
xlabel('Frequência (Hz)');
ylabel('Magnitude (dB)');
title('Resposta em Magnitude');
grid on;

% Plot da Fase
subplot(2,1,2);
plot(freq_one_sided, phase_rad);
xlabel('Frequência (Hz)');
ylabel('Fase (radianos)');
title('Resposta de Fase');
grid on;
