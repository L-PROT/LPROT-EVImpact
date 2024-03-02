%% ----- Construção dos Cenários de Tipo de Recarga ----- %%

%     switch cen
%          case {1,3,5}
%             ParticRes = 100;
%             ParticCom = 10;
%             ParticPosto = 1; 
% 
%          otherwise %{4,5,6}
%             ParticRes = 30;
%             ParticCom = 10;
%             ParticPosto = 3; 
%     end 

 %% ----- Construção dos Cenários de Crescimento de Frota ----- %%
 
      if  (sem/52)<5 
              cresveic = (0.0061*(sem/52)^2 + 0.0381*(sem/52)+ 0.0133);
 
              else
              cresveic = (-0.0016*(sem/52)^2 + 0.0655*(sem/52)+ 0.0709);
           end
 if cen == 1
     cresveic = -9E-05*(sem/52)^3 + 0.0039*(sem/52)^2 - 0.0077*(sem/52) + 0.0207;
 end
       
 %% ----- Função de crescimento anual ----- %%

 crescv = (1 + (txv/100))^((sem-1)/52);       % Função de crescimento linear em pg
 
 %% ----- Declaração de Variáveis ----- %%

     DemandaVeicCom = [96;1];
     DemandaVeicRes = [96;1];
     DemandaVeic = [96;1];
     DemandaVeicPosto = zeros (96,1);
     soma = ParticRes + ParticCom ;%+ ParticPosto;  % Definição das Participações em Percentual
     ParticRes1 = ParticRes/soma;
     ParticCom1 = ParticCom/soma;
%      ParticPosto1 = ParticPosto/soma;
     
%% ----- Definição número de recargas posto ----- %%     
     rec=fposto*Ncarros * crescv * cresveic/200;      % Calcula o numero de recargas esperada por posto por dia (200 = artigo)
     Nrecargas = floor(rec);
     frac=rec-Nrecargas;
     rand1=rand;
     if frac>rand1
          Nrecargas=Nrecargas+1;
     end 

 %% ----- Leitura do arquivo média e desvio de consumo - Recarga Comercial ----- %%

    
    filename = 'CurvaVeiculoComercialDom.xlsx';
    A1 = readtable(filename);              % Lê o arquivo de carga
    A = table2array(A1);
    Media = A(:,2);                     % Lê as médias
    Desvio = A(:,3);                    % Lê os Desvios
    QtdPontos=size(A,1);                % Lê Quantidade de pontos
    
 %% ----- Leitura do arquivo média e desvio de consumo - Recarga Residencial ----- %%
 
    filename = 'CurvaVeiculoResidencialDom.xlsx';
    B1 = readtable (filename);              % Lê o arquivo de carga
    B = table2array(B1);
    Media1 = B(:,2);                    % Lê as médias
    Desvio1 = B(:,3);                   % Lê os Desvios
    
 %% ----- Leitura do arquivo de probabilidades - Recarga em Posto ----- %%
 
    filename = 'Curvaposto.xlsx';
    C1 = readtable(filename);              % Lê o arquivo de carga
    C = table2array(C1);
    Media2 = C(:,2);                    % Lê as médias
    Prob = Media2/sum(Media2);
    Probacum=cumsum(Prob);
   
    
 %% ----- Sorteio diário dos valores das cargas de Recarga ----- %%  
 
     for j = (Numcargas+1):Numcargas*2   % Para cada carga de veículo, gera matriz de números randomicos
g=j-Numcargas;
     Rands=randn(96,3);           % Gera os números randômicos   
            
        for i = 1:96

            %% ----- Manipulação do arquivo média e desvio de consumo - Recarga Comercial ----- %%

            DemandaVeicCom(i,1) = (Media(i,1) + Desvio(i) * Rands (i,1)) * fcom; % Soma Média com Desvio Aleatório e multiplica pela quantidade de carros
            if DemandaVeicCom(i,1)<0            % Trata os casos de potência negativa recarga Comercial
               DemandaVeicCom(i,1)=0;
            end

            %% ----- Manipulação do arquivo média e desvio de consumo - Recarga Residencial ----- %%

            DemandaVeicRes(i,1) = (Media1(i,1) + Desvio1(i) * Rands (i,2)) * fres; % Soma Média com Desvio Aleatório
            if DemandaVeicRes(i,1)<0            % Trata os casos de potência negativa recarga residencial
               DemandaVeicRes(i,1)=0;
            end

            %% ----- Agrega as recargas comerciais e residenciais de acordo com o cenário analisado ----- %%
            r1=randn+1;
if r1<0
    r1=0;
end
     r4=AJ(g)*r1;
     AK(g)=r4;

            DemandaVeic(i,1)= AK(g)*Ncarros * crescv * cresveic *(DemandaVeicCom(i,1)*ParticCom1+ DemandaVeicRes(i,1)*ParticRes1);
            

            
        end

            %% ----- Escreve os arquivo de loadshape a ser utilizado para uma carga específica em um dia específico ----- %%
            arquivo = 'Loadshape' + string (j) + '.csv';
            writematrix (DemandaVeic, arquivo);

     end
     
     %% ----- Sorteio do horário de recarga no Posto ----- %%
                for i = 1:Nrecargas
                    z=rand;
                    [val,idx]=min(abs(Probacum-z));
                    DemandaVeicPosto (idx,1) = DemandaVeicPosto (idx,1)+1;
                end 
            arquivo2 = 'loadposto.csv';
            writematrix (DemandaVeicPosto, arquivo2);
