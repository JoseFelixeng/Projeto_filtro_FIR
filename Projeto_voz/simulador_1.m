disp('Carregando o arquivo .wav');
filename = 'Church Schellingwoude.wav';
[y, Fs] = audioread(filename);
y = mean(y, 2); % Usar apenas o canal mono do áudio
disp('Carregamento Completo');

disp('Gravando a voz de entrada...');
minha_voz = audiorecorder(44100, 16, 1);
recordblocking(minha_voz, 4);
disp('Voz Gravada com sucesso');

play(minha_voz);

dados = getaudiodata(minha_voz);

disp('Salvando arquivo de áudio da voz...');
audiowrite('minha_voz.wav', dados, 44100);

% Normalizando a energia do sinal
resposta = y;
a = var(dados);
b = var(y);
dados = (dados / a) * b;

% Fazendo a convolução
convolucao = conv(dados, resposta);

player = audioplayer(convolucao, Fs);
play(player);

% Salvando a convolução em um novo arquivo de áudio
disp('Salvando a convolução...');
audiowrite('convolucao.wav', convolucao, Fs);
disp('Arquivo Salvo com Sucesso: convolucao.wav');

% Plot da resposta ao impulso (Church)
disp('Gerando gráfico da resposta ao impulso...');
figure(1); clf;
plotspec(resposta, 1/Fs); % y é a resposta ao impulso

% Plot do sinal após a convolucaoo 
disp('Gerando gráfico do sinal convoluído...');
figure(2); clf;
plotspec(convolucao, 1/Fs);

disp('Fim da execução.');

