  % Parâmetros do filtro FIR passa-faixa
  fc = 5400;    % Frequência de corte inferior (KHz)
  fs = 5700;    % Frequência de corte superior (KHz)
  Fs = 12000;   % Frequência de amostragem (KHz) - assumida maior que o dobro da maior frequencia


  % Normalização das frequências
  w1 = 2*pi*fc/Fs;  % Frequência normalizada inferior
  w2 = 2*pi*fs/Fs;  % Frequência normalizada superior

  fc = (w1 + w2)/2

  wc = 2 * pi * fc/ Fc;

  % Vetor de índices simétrico
  n = 0:M;       % Para M=156 (simétrico em torno de zero)

  N = n - (M/2)
  % Cálculo da resposta ideal (filtro passa-faixa)
  hd = 1 - (sin(w2*N) - sin(w1*N)) ./ (pi*N);
  hd(n == (M/2)) = wc/pi ;  % Tratamento para n=0

  % Janela de Hanning
  wHann = 0.5 - 0.5*cos(2*pi*n/(M));

  % Resposta ao impulso final
  hc = hd .* wHann';

  % Plotando o gráfico;
  Ts = 1/Fs;
  plotspec(hc,Ts);




