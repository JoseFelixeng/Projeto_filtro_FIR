% Fonte: Johnson Jr., C. R. e Sethares, W. A., Telecomunication Breakdown: Concepts of Communication transmitted via Software-Defined Radio, Pearson, 2004
% plotspec(x,Ts) calcula e apresenta o espectro do sinal x
% Ts = tempo (em segundos) entre amostras adjacentes em x

%function plotspec(x,Ts)

%N=length(x);                               % Comprimento do sinal x
%t=Ts*(1:N);                                % vetor de tempo 
%ssf=(-N/2:N/2-1)/(Ts*N);                   % vetor de frequ�ncia
%fx=fft(x(1:N));                            % calcula a DFT/FFT
%fxs=fftshift(fx);                          % desloca para o centro do espectro
%subplot(2,1,1), plot(t,x)                  % apresenta o gr�fico da forma de onda
%xlabel('segundos'); ylabel('amplitude')     % rotula os eixos
%ubplot(2,1,2), plot(ssf,abs(fxs))         % apresenta o gr�fico do espectro de magnitudes
%xlabel('frequ�ncia'); ylabel('magnitude')   % rotula os eixos

% Ajustes usados para que funcione corretamente no OCTAVE
function plotspec(x, Ts)
    N = length(x);
    t = linspace(0, (N-1)*Ts, N);            % Vetor de tempo corrigido
    ssf = (-N/2:N/2-1) / (Ts * N);           % Frequência
    fx = fft(x);
    fxs = fftshift(fx);

    subplot(2,1,1);
    plot(t, x);
    xlabel('Tempo (s)');
    ylabel('Amplitude');
    title('Sinal no Tempo');
    grid on;

    subplot(2,1,2);
    plot(ssf, abs(fxs));
    xlabel('Frequência (Hz)');
    ylabel('Magnitude');
    title('Espectro de Magnitude');
    grid on;

    drawnow;  % Força atualização dos gráficos
end
