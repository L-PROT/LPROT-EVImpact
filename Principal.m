
    
% Declaração de Variáveis Matlab
%     U = [;];                          % Tabela com os dados horários a serem analisados
    cen = 1;
    codigo = string(circuito (1:7));
    sem =1;
    violmin = zeros(1,Cenarios);
    violmax = zeros(1,Cenarios);
    
% Inicia o OpenDSS e cria o objeto DSS
    DSSobj = actxserver('OpenDSSEngine.DSS');
    if ~DSSobj.Start(0)
        disp('Não foi possível iniciar o OpenDSS')
    return
    end
    
% Cria as variáveis de interface
    DSSText = DSSobj.Text;
    DSSCircuit = DSSobj.ActiveCircuit;
    DSSSolution = DSSCircuit.Solution;

 % Cria os arquivos de carga e loadshape para veículos
     filename = 'carga1.dss';                                
     A = importdata(filename);                               % Lê o aquivo de carga elétrica
%      Numcargas=(size(A,1)-1)/2;                                    % Lê Quantidade de cargas (número de linhas)
    Numcargas=162;
while cen<(Cenarios+1)
switch cen
         case {1,2}
            ParticRes = 75;
            ParticCom = 18;
            ParticPosto = 1; 
            fres=1;                                    
            fcom=1;
            fposto=1;

         case {3}
            ParticRes = 40;
            ParticCom = 28;
            ParticPosto = 1;
            fposto=1;
            
        otherwise
                        ParticRes = 40;
            ParticCom = 28;
            ParticPosto = 1;
            fres=3;                                    
            fcom=3;
            fposto=3;
end
% Cria e implementa as cargas 
    for sem = 500:totalsemana             %Numero de Semanas a serem simuladas

         for k = 1:1                %Numero de dias uteis da semana
        
        % Sorteia a carga elétrica e de veículo de dia útil   
             DemandaResCom;
             DemandaVeiculo;
         
        % Compila a carga no OpenDSS     
          DSSText.command =  'Compile (C:\Users\rmelo\Downloads\USP108x - OpenDSS\test.dss)';

        % Roda a solução
            DSSText.command = 'solve';

         end
         
        
        % Sorteia a carga de sábado  
        % ----------- SÁBADO ------------ % 
             DemandaResComSab;
             DemandaVeiculoSabado;
        
        % Compila a carga no OpenDSS     
             DSSText.command =  'Compile (C:\Users\rmelo\Downloads\USP108x - OpenDSS\test.dss)';
        
        % Roda a solução
             DSSText.command = 'solve';
        
        % ----------- DOMINGO ------------ %   
        
        % Sorteia a carga de domingo 
             DemandaResComDom;
             DemandaVeiculoDomingo;
        
        % Compila a carga no OpenDSS     
             DSSText.command =  'Compile (C:\Users\rmelo\Downloads\USP108x - OpenDSS\test.dss)';
        
        % Roda a solução
            DSSText.command = 'solve';
        
    end
%analise;
cen = cen + 1;
end

