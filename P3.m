% APLICAÇÕES ESTRUTURAIS DE MATERIAIS COMPÓSITOS - ESAE001-23 PROVA 3 - TRABALHO

clc

% Item 1 - número de camadas n

n = 2

% Item 2 - espessura t da camada (espessuras iguais para todas as camadas)

t = 6.35e-4 %% [m]

% Item 3 - vetores com orientação de cada camada

orientation = [55 * pi/180, -55 * pi/180] %% º - [camada(1), camada(2), camada(3), ..., camada(n)]

% Item 4 - Receber as propriedades da lâmina

% Módulo de elasticidade
E1 = 19.981E+9    %% Pa
E2 = 11.389E+9    %% Pa

% Coeficiente de Poisson
v12 = 0.2740
v13 = 0.3850
v23 = 0.3850
v21 = v12*E2/E1

% Módulo de cisalhamento
G12 = 3.789E+9
G23 = 3.789E+9
G13 = 3.789E+9    %% Pa

% Coeficiente de expansão térmica
alfa1 = 8.42E-6   %% 1/C
alfa2 = 2.98E-5   %% 1/C

% Resistência da lâmina
Xt = 1035E+006; %% Pa
Xc = 1035E+006; %% Pa
Yt = 27.6E+006; %% Pa
Yc = 138E+006;  %% Pa
S6 = 41.4E+006; %% Pa

% Item 5 - Matrizes Q e vetor {a}xy
S0 = [[1/E1,   -v21/E2, 0],
      [-v12/E1, 1/E2,   0],
      [0,       0,      1/G12]]

alphaXY = [alfa1, alfa2, 0]

% Item 6 - Variação da temperatura e carregamento mecânico
DT = -100 %% ºC

Nx = 0  %% N
Ny = 0  %% N
Nxy = 0 %% N

Mx = 0  %% N
My = 0  %% N
Mxy = 0 %% N
Nmec = [Nx, Ny, Nxy]
Mmec = [Mx, My, Mxy]

% Item 7 – Calcular as matrizes [A], [B], [D] e [As]; 
