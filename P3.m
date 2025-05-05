% APLICAÇÕES ESTRUTURAIS DE MATERIAIS COMPÓSITOS - ESAE001-23 PROVA 3 - TRABALHO

clc

% Item 1 - número de camadas n

n = 2;
n
% Item 2 - espessura t da camada (espessuras iguais para todas as camadas)

t = 6.35e-4; %% [m]

% Item 3 - vetores com orientação de cada camada

orientation = [55 * pi/180, -55 * pi/180]; %% º - [camada(1), camada(2), camada(3), ..., camada(n)]

% Item 4 - Receber as propriedades da lâmina

% Módulo de elasticidade
E1 = 1.9981e+10;    %% Pa
E2 = 1.1389e+10;    %% Pa
E3 = 1.1389e+10;    %% Pa
% Coeficiente de Poisson
v12 = 0.2740;
v13 = 0.3850;
v23 = 0.3850;
v21 = v12*E2/E1;

% Módulo de cisalhamento
G12 = 3.789E+9;
G23 = 3.789E+9;
G13 = 3.789E+9;    %% Pa

% Coeficiente de expansão térmica
alfa1 = 8.42E-6;   %% 1/C
alfa2 = 2.98E-5;   %% 1/C

% Resistência da lâmina
Xt = 1.0350e+09; %% Pa
Xc = 1.0350e+09; %% Pa
Yt = 2.7600e+07; %% Pa
Yc = 1.3800e+08;  %% Pa
S6 = 4.1400e+07; %% Pa

% Item 5 - Matrizes Q e vetor {a}xy
alphaXY = [alfa1; alfa2; 0];
alphaXY

S0 = [[1/E1,   -v21/E2, 0],
      [-v12/E1, 1/E2,   0],
      [0,       0,      1/G12]];
S0


% Item 6 - Variação da temperatura e carregamento mecânico
DT = -100; %% ºC

Nx = 0;  %% N
Ny = 0;  %% N
Nxy = 0; %% N

Mx = 0;  %% N
My = 0;  %% N
Mxy = 0; %% N
Nmec = [Nx; Ny; Nxy];
Mmec = [Mx; My; Mxy];

% Item 7 – Calcular as matrizes [A], [B], [D] e [As];

% Primeiro, vamos calcular a matriz Q0
Q0 = inverse(S0); %  Inversa da matriz S0
Q0

% Agora, vamos calcular as matriz para os angulos (Ex. Q+55 e Q-55)

c = cos(orientation);
s = sin(orientation);


L1 = [];
L2 = [];
Q = [];

% Matrizes L
for k = 1:n
    L1{k} = [[c(k)^2,     s(k)^2,     -2*c(k)*s(k)],
              [s(k)^2,     c(k)^2,      2*c(k)*s(k)],
              [c(k)*s(k), -c(k)*s(k),   c(k)^2 - s(k)^2]];
end

for k = 1:n
    L2{k} = L1{k}';
end

L2

% Matrizes Q
for k = 1:n
    Q{k} = [[L1{k}*Q0*L2{k}]];
end

Q

% Vetores Alfa
alfa = zeros(3,1);

for camada = 1:n
    camada_alfa = inv(L2{camada}) * reshape(alphaXY, [], 1);
    alfa = [alfa, camada_alfa];
end

alfa = alfa(:, 2:end);
alfa = alfa.';

alfa

% Matriz z - espessura

function indices = vetor_z(n, t)
    if mod(n, 2) == 1
        % n ímpar
        camadas = (n - 1) / 2;
        indices = linspace((n * t) / 2, 0, camadas);

        indices_b = -flip(indices);
        indices = [indices, t/2, -t/2, indices_b];
    else
        % n par
        indices = linspace((n * t) / 2, -(n * t) / 2, n + 1);
    end
end

z = vetor_z(n, t);

z

% Calculando matriz A


A = zeros(3);

for i = 1:n
    A = A + (z(i) - z(i+1)) * Q{i};
end

A

% Calculando matriz B
B = zeros(3);

for i = 1:n
    B = B + (1/2) * ((z(i)^2 - z(i+1)^2) * Q{i});
end

B

% Calculando matriz D
D = zeros(3);

for i = 1:n
    D = D + (1/3) * ((z(i)^3 - z(i+1)^3) * Q{i});
end

D

% Item 8 - deformações na superfície média do laminado
NT = zeros(3,1);
MT = zeros(3,1);

for k = 1:n
    delta_z = z(k) - z(k+1);
    NT = NT + Q{k} * alfa(k,:).' * DT * delta_z;

    zk = z(k);
    zk1 = z(k+1);
    MT = MT + Q{k} * alfa(k,:).' * DT * (zk^2 - zk1^2)/2;
end

NT
MT

Nmec
Mmec

N_total = Nmec + NT;
M_total = Mmec + MT;

% Atualiza vetor total de esforços e momentos
NM_total = [N_total; M_total];

% Resolve o sistema [A B; B D] * [epsilon0; kappa] = [N_total; M_total]
solucao_total = ABD \ NM_total;

e0 = solucao_total(1:3);
kapa = solucao_total(4:6);

e0
kapa

% Item 9 - variável npl

npl = 3;
npl

% Item 10 - valor da coordenada z para cada ponto analisado ao longo do laminado e armazenar esses valores na variável zpos

zpos = [];

for k = 1:n
    z_top = z(k); % limite superior da camada k
    z_bot = z(k+1); % limite inferior da camada k

    z_layer = linspace(z_top, z_bot, npl); % Divide igualmente a espessura da camada em npl pontos

    zpos = [zpos; z_layer(:)]; % Armazena os pontos como vetor coluna (z_layer(:))
end

zpos
