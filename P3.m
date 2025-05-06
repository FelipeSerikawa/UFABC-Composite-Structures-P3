% APLICAÇÕES ESTRUTURAIS DE MATERIAIS COMPÓSITOS - ESAE001-23 PROVA 3 - TRABALHO

clc

% Item 1 - número de camadas n

n = 2;
n
% Item 2 - espessura t da camada (espessuras iguais para todas as camadas)

t = 6.35e-4; %% [m]

% Item 3 - vetores com orientação de cada camada

orientation = [[55 * pi/180, -55 * pi/180]]; %% º - [camada(1), camada(2), camada(3), ..., camada(n)]

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
ABD = [A B; B D];
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

% Item 11 - Calcular as componentes das deformações nas direções x e y (ex, ey, Yxy) para cada posição z
StrainXY = zeros(3, 1, length(zpos));

for i = 1:length(zpos)
    z_i = zpos(i);
    StrainXY(:, 1, i) = e0 + z_i * kapa;
end

fprintf('\nResults for Strains in XY directions\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        fprintf('StrainXY =\n');
        fprintf('  % .4e\n', StrainXY(:, 1, ponto));
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 12 - Calcular as componentes das tensões nas direções x e y (Sx, Sy, Txy) para cada posição z

StressXY = zeros(3, 1, length(zpos));

ponto = 1;
for camada = 1:n
    Qk = Q{camada};
    alpha_k = alfa(camada, :).';
    for j = 1:npl
        z_i = zpos(ponto);

        strain_total = e0 + z_i * kapa;

        StressXY(:, 1, ponto) = Qk * (strain_total - DT * alpha_k);

        ponto = ponto + 1;
    end
end

fprintf('\nResults for Stresses in XY directions\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        fprintf('StressXY =\n');
        fprintf('  % .4e\n', StressXY(:, 1, ponto));
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 13 - Calcular as componentes das tensões nas direções 1 e 2 (S1, S2, T12) para cada posição z
Stress12 = zeros(3, 1, length(zpos));

ponto = 1;
for camada = 1:n
    angulo = orientation(camada);
    c = cos(angulo);
    s = sin(angulo);
    
    % Matriz de transformação para tensões
    T_sigma = [c^2, s^2, 2*c*s;
               s^2, c^2, -2*c*s;
               -c*s, c*s, c^2-s^2];
    
    for j = 1:npl
        % Transforma as tensões de XY para 12
        Stress12(:, 1, ponto) = T_sigma \ StressXY(:, 1, ponto);
        
        ponto = ponto + 1;
    end
end

fprintf('\nResults for Stresses in 12 directions\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        fprintf('Stress12 =\n');
        fprintf('  % .4e\n', Stress12(:, 1, ponto));
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 14 - Calcular as componentes das deformações nas direções 1 e 2 (e1, e2, Y12) para cada posição z
Strain12 = zeros(3, 1, length(zpos));

ponto = 1;
for camada = 1:n
    angulo = orientation(camada);
    c = cos(angulo);
    s = sin(angulo);
    
    % Matriz de transformação para deformações
    T_epsilon = [c^2, s^2, c*s;
                 s^2, c^2, -c*s;
                 -2*c*s, 2*c*s, c^2-s^2];
    
    for j = 1:npl
        % Transforma as deformações de XY para 12
        Strain12(:, 1, ponto) = T_epsilon \ StrainXY(:, 1, ponto);
        
        ponto = ponto + 1;
    end
end

fprintf('\nResults for Strains in 12 directions\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        fprintf('Strain12 =\n');
        fprintf('  % .4e\n', Strain12(:, 1, ponto));
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 15 - Avaliar para cada posição z o critério de máxima tensão
fprintf('\nMaximum Stress Criterion Evaluation\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        S1 = Stress12(1, 1, ponto);
        S2 = Stress12(2, 1, ponto);
        T12 = Stress12(3, 1, ponto);
        
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        
        % Verificação de falha por tensão máxima
        if S1 > Xt || S1 < -Xc
            fprintf('FAILURE in fiber direction (1)\n');
            if S1 > 0
                fprintf('Mode: Tensile failure in fiber direction\n');
            else
                fprintf('Mode: Compressive failure in fiber direction\n');
            end
        elseif S2 > Yt || S2 < -Yc
            fprintf('FAILURE in transverse direction (2)\n');
            if S2 > 0
                fprintf('Mode: Tensile failure in matrix direction\n');
            else
                fprintf('Mode: Compressive failure in matrix direction\n');
            end
        elseif abs(T12) > S6
            fprintf('FAILURE in shear\n');
            fprintf('Mode: Shear failure\n');
        else
            fprintf('NO FAILURE detected\n');
        end
        
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 16 - Avaliar para cada posição z o critério de máxima deformação
fprintf('\nMaximum Strain Criterion Evaluation\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        e1 = Strain12(1, 1, ponto);
        e2 = Strain12(2, 1, ponto);
        Y12 = Strain12(3, 1, ponto);
        
        % Calcular deformações de falha
        e1t = Xt/E1;
        e1c = -Xc/E1;
        e2t = Yt/E2;
        e2c = -Yc/E2;
        Y12f = S6/G12;
        
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        
        % Verificação de falha por deformação máxima
        if e1 > e1t || e1 < e1c
            fprintf('FAILURE in fiber direction (1)\n');
            if e1 > 0
                fprintf('Mode: Tensile failure in fiber direction\n');
            else
                fprintf('Mode: Compressive failure in fiber direction\n');
            end
        elseif e2 > e2t || e2 < e2c
            fprintf('FAILURE in transverse direction (2)\n');
            if e2 > 0
                fprintf('Mode: Tensile failure in matrix direction\n');
            else
                fprintf('Mode: Compressive failure in matrix direction\n');
            end
        elseif abs(Y12) > Y12f
            fprintf('FAILURE in shear\n');
            fprintf('Mode: Shear failure\n');
        else
            fprintf('NO FAILURE detected\n');
        end
        
        fprintf('\n');
        ponto = ponto + 1;
    end
end

% Item 17 - Avaliar para cada posição z o critério de Tsai-Hill
fprintf('\nTsai-Hill Criterion Evaluation\n');
ponto = 1;
for camada = 1:n
    angulo_graus = orientation(camada) * 180 / pi;
    for j = 1:npl
        S1 = Stress12(1, 1, ponto);
        S2 = Stress12(2, 1, ponto);
        T12 = Stress12(3, 1, ponto);
        
        % Determinar as resistências apropriadas com base no sinal das tensões
        X = (S1 >= 0) * Xt + (S1 < 0) * Xc;
        Y = (S2 >= 0) * Yt + (S2 < 0) * Yc;
        
        % Calcular índice de Tsai-Hill
        if S1 >= 0
            % Tensão na direção 1 é de tração
            TsaiHill = (S1/X)^2 - (S1*S2/X^2) + (S2/Y)^2 + (T12/S6)^2;
        else
            % Tensão na direção 1 é de compressão
            TsaiHill = (S1/X)^2 + (S2/Y)^2 + (T12/S6)^2;
        end
        
        fprintf('layer = %d\n', camada);
        fprintf('angle = %.0f\n', angulo_graus);
        fprintf('z_coordinate = %.4e\n', zpos(ponto));
        fprintf('Tsai-Hill Index = %.4f\n', TsaiHill);
        
        if TsaiHill >= 1
            fprintf('FAILURE predicted by Tsai-Hill criterion\n');
            
            % Identificar modo de falha dominante
            [max_val, max_idx] = max([(S1/X)^2, (S2/Y)^2, (T12/S6)^2]);
            
            if max_idx == 1
                if S1 >= 0
                    fprintf('Dominant Mode: Tensile failure in fiber direction\n');
                else
                    fprintf('Dominant Mode: Compressive failure in fiber direction\n');
                end
            elseif max_idx == 2
                if S2 >= 0
                    fprintf('Dominant Mode: Tensile failure in matrix direction\n');
                else
                    fprintf('Dominant Mode: Compressive failure in matrix direction\n');
                end
            else
                fprintf('Dominant Mode: Shear failure\n');
            end
        else
            fprintf('NO FAILURE predicted by Tsai-Hill criterion\n');
        end
        
        fprintf('\n');
        ponto = ponto + 1;
    end
end