 %% ----- Deleta Arquivos e Variaveis de Outras Simulacoes----- %%
clc
clear all
delete USP108x_EXP_Summary.csv
delete interm.xlsx

 %% ----- Declaração de Variáveis da Simulação----- %%
circuito = 'USP108x_EXP_Summary.csv';
totalsemana = 501;                            % Numero de Semanas a serem simuladas
Cenarios = 1;                               % Numero de Cenários a serem simulados
Carregamento = 0.59;                           % Carregamento atual dos trafos 
ContribuicaoRes = .9;                       % Composição geográfica de residência/comércio 
ContribuicaoCom = 1 - Contribui0caoRes;      % Composição de residência/comércio 
tx = 3.7;                                   % Taxa de crescimento anual da demanda elétrica em % (crescimento linear)
txv = 2.83;                                 % Taxa de crescimento anual da veículos em SP em % (crescimento linear)
Ncarros = 2186;                            % Número de carros na região estudada 

Ajuste;
Principal;
    
