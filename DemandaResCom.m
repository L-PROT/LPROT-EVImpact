 %% ----- Função de crescimento anual da demanda elétrica ----- %%
                           
    cresc = (1 + (tx/100))^((sem-1)/52);       % Função de crescimento linear em pg
    
 %% ----- Leitura do arquivo média e desvio de consumo - Residencial ----- %%

    filename = 'CurvaResidencial.xlsx';
    A1 = readtable(filename);              % Lê o arquivo de carga
    A = table2array(A1);
    Media = A(:,2);                     % Lê as médias
    Desvio = A(:,3);                    % Lê os Desvios

   
 %% ----- Leitura do arquivo média e desvio de consumo - Comercial ----- %%
 
    filename = 'CurvaComercial.xlsx';
    B1 = readtable(filename);              % Lê o arquivo de carga
     B = table2array(B1);
    Media1 = B(:,2);                    % Lê as médias
    Desvio1 = B(:,3);                   % Lê os Desvios
 
 %% ----- Declaração de Variáveis ----- %%

     DemandaCom = [96;1];
     DemandaRes = [96;1];
     DemandaAtual = [96;1];

 %% ----- Sorteio diário dos valores das cargas ----- %%
 
    for j = 1:Numcargas                 % Para cada carga, gera matriz de números randomicos
    
    %rng('default');                     % SOMENTE NO DEBUG
    Rands=randn(96,2);           % Gera os números randômicos
   
     %% ----- Manipulação do arquivo média e desvio de consumo - Residencial ----- %%
     
        for i = 1:96
            DemandaRes(i,1) = (Media(i,1) + Desvio(i) * Rands (i,1))*Carregamento;  % Soma Média com Desvio Aleatório e usa o Carregamento
            if DemandaRes(i,1)<0            % Trata os casos de potência negativa
               DemandaRes(i,1)=0;
            end
        

     %% ----- Manipulação do arquivo média e desvio de consumo - Comercial ----- %%
     
            DemandaCom(i,1) = (Media1(i,1) + Desvio1(i) * Rands (i,2))*Carregamento; % Soma Média com Desvio Aleatório e usa o Carregamento
            if DemandaCom(i,1)<0            % Trata os casos de potência negativa
               DemandaCom(i,1)=0;
            end
        
    
    %% ----- Agrega os consumos comerciais e residenciais de acordo com a geografia do local ----- %%
    
             DemandaAtual (i,1) = (DemandaRes(i,1)*ContribuicaoRes + DemandaCom(i,1)*ContribuicaoCom)* cresc; % Soma Demanda Residencial e Comercial com fator de contribuicao
        end
    
    %% ----- Escreve o arquivo de loadshape a ser utilizado para uma carga específica em um dia específico ----- %%
    
    arquivo = 'Loadshape' + string (j) + '.csv';
    writematrix (DemandaAtual, arquivo); % Escreve o arquivo a ser usado pelo loadshape
    
end 