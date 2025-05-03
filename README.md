# UFABC-Composite-Structures-P3
Analysis and design of composite structures

Desenvolva um código em Matlab (ou Octave ou outra plataforma com extensão .m que 
seja executável no Matlab) que possua as seguintes funcionalidades: 
1 – Definir o número de n camadas do laminado, onde n deve definido pelo programador;  
2 – Todas as camadas devem ter a mesma espessura t que será definida pelo programador;  
3 – Deve ser criado um vetor com as orientações de cada camada seguindo o padrão:  
orientation(1) = ##; 
orientation(2) = ##; 
... 
orientation(n) = ##; 
onde os valores das orientações devem ser fornecidos em graus pelo programador; 
4 – Receber as propriedades da lâmina nas direções 1 e 2 (módulos de elasticidade - E1, 
E2, coeficientes de Poisson - v12, v13, v23, módulos de cisalhamento - G12, G13, G23, 
coeficientes de expansão térmica alpha1 e alpha2, resistências da lâmina - Xt,Xc,Yt,Yc,S6 
ou  Xet,Xec,Yet,Yec,Se); 
5 – Para cada camada do laminado calcular as as matrizes [𝑄̅] e o vetor {𝛼}𝑥𝑦. 
Para a matriz [𝑄̅] usar uma matriz Q=zeros(3,3,n) e para o vetor {𝛼}𝑥𝑦 usar uma matriz 
alphaXY=zeros(3,1,n), onde: 
Q=(3,3,1) e alphaXY=(3,1,1) são relativos à primeira camada; 
Q=(3,3,2) e alphaXY=(3,1,2) são relativos à segunda camada; 
... 
Q=(3,3,n) e alphaXY=(3,1,n) são relativos à camada n; 
6 – Receber o estado os carregamentos mecânicos Nmec = (Nx, Ny e Nxy), Mmec = (Mx, 
My e Mxy) e a variação de temperatura DT em graus Celsius; 
7 – Calcular as matrizes [A], [B], [D] e [As];  
Utilizando a Teoria Clássica da Laminação: 
8 – Calcular as deformações na superfície média do laminado: 
e0 = (e0x, e0y, Y0xy);  
kapa = (kapa_x, kapa _y, kapa _xy); 
9 – Criar a variável npl que define a quantidade de pontos dentro de uma camada onde as 
deformações, tensões e critérios de falhas serão analisados. O código deve funcionar para 
qualquer valor de npl. No mínimo usar npl igual a 3. 
10 – Calcular o valor da coordenada z para cada ponto analisado ao longo do laminado e 
armazenar esses valores na variável zpos; 
11 – Calcular as componentes das deformações nas direções x e y (ex, ey, Yxy) para cada 
posição z; 
Sugestão: defina o vetor uma matriz StrainXY = zeros(3,1,zpos) para que ela receba os 
valores das deformações de forma que: 
StrainXY = zeros(3,1,1) é uma matriz de 3 linhas e uma coluna com os valores das 
deformações no ponto zpos = 1; 
12 – Calcular as componentes das tensões nas direções x e y (Sx, Sy, Txy) para cada 
posição z; 
Sugestão: defina o vetor uma matriz StressXY = zeros(3,1,zpos) para que ela receba os 
valores das deformações de forma que: 
StressXY = zeros(3,1,1) é uma matriz de 3 linhas e uma coluna com os valores das 
deformações no ponto zpos = 1; 
13 – Calcular as componentes das tensões nas direções 1 e 2 (S1, S2, T12) para cada 
posição z; 
Sugestão: defina o vetor uma matriz Stress12 = zeros(3,1,zpos) para que ela receba os 
valores das deformações de forma que: 
Stress12 = zeros(3,1,1) é uma matriz de 3 linhas e uma coluna com os valores das 
deformações no ponto zpos = 1; 
14 – Calcular as componentes das deformações nas direções 1 e 2 (e1, e2, Y12) para cada 
posição z; 
Sugestão: defina o vetor uma matriz Strain12 = zeros(3,1,zpos) para que ela receba os 
valores das deformações de forma que: 
Strain12 = zeros(3,1,1) é uma matriz de 3 linhas e uma coluna com os valores das 
deformações no ponto zpos = 1; 
15 – Avaliar para cada posição z o critério de máxima tensão e caso haja falha, indique o 
modo de falha como foi solicitado na P2; 
16 – Avaliar para cada posição z o critério de máxima deformação e caso haja falha, 
indique o modo de falha como foi solicitado na P2; 
17 – Avaliar para cada posição z o critério de Tsai-Hill conforme solicitado na P2; 
18 – Avaliar para cada posição z o critério de Hoffmann conforme solicitado na P2; 
19 – Avaliar para cada posição z o critério de Tsai-Wu conforme solicitado na P2; 
As unidades a serem utilizadas são: 
• Metro 
• Newton 
• Pascal 
• Graus (ângulo) 
• Graus Celsius (temperatura)
