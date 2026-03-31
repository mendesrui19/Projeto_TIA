%:-[p2-listas], module(lists), dynamic(stand/2).
:-dynamic(stand/2), consult('p2-listas.pl').

% ------- base de dados --------
stand(vegas,[
		cliente(rui,2324,23,medico,[carro(audi,a2,20000),carro(bmw,serie3,30000)]),
		cliente(rita,2325,32,advogado,[carro(audi,a3,30000)]),
		cliente(joao,2326,26,professor,[moto(honda,gl1800,26000)]),
		cliente(ana,2327,49,medico,[carro(audi,a4,40000),
					    carro(bmw,serie3,32000),carro(ford,focus,24000)])
	    ]).

stand(miami,[ 
		cliente(rui,3333,33,operario,[carro(fiat,panda,12000)]),
		cliente(paulo,3334,22,advogado,[carro(audi,a4,36000)]),
		cliente(pedro,3335,46,advogado,[carro(honda,accord,32000),carro(audi,a2,20000)])
	    ]).

% - devolve uma lista com o nome de todos os clientes de um dado stand
listar_clientes(X,LC):- stand(X,L),
		        findall(C,member(cliente(C,_,_,_,_),L),LC).

% - devolve os dados de cliente (todos excepto o nome), atraves do nome do cliente e nome do stand          
listar_dados(X,C,D):- stand(X,L),
		      findall((N,ID,P),member(cliente(C,N,ID,P,_),L),D).
		     
% - devolve uma lista com o nome de todas as marcas de carros vendidas por um dado stand
listar_carros(X,LM):- stand(X,L),
		       findall(C,member(cliente(_,_,_,_,C),L),LC),
                       flatten(LC,LCC),
                       findall(M,member(carro(M,_,_),LCC),LM1),
		       list_to_set(LM1,LM).

% - devolve uma lista com o nome de todos os advogados de todos stands
listar_advogados(LA):- findall(L,stand(_,L),LL),
		       flatten(LL,LL2),
		       findall(C,member(cliente(C,_,_,advogado,_),LL2),LA1),
                       list_to_set(LA1,LA).

% - devolve o preço médio de todos os carros vendidos por um stand          
preco_medio(X,Med):- stand(X,L),
		     findall(C,member(cliente(_,_,_,_,C),L),LP),
                     flatten(LP,LP2),
                     findall(P,member(carro(_,_,P),LP2),LP3),
		     media(Med,LP3).

% - altera a idade do cliente C do stand X
altera_id(X,C,Id):- %stand(X,L),
                    retract(stand(X,L)),
                    altera_id(L,L2,C,Id),
                    assert(stand(X,L2)). 

altera_id(L,L2,C,NID):- select(cliente(C,N,_,P,V),L,L1),
		        append([cliente(C,N,NID,P,V)],L1,L2). 

% teste:
q1(X):- listar_clientes(vegas,X).
q2(X,Y):- listar_dados(vegas,X,Y).
q3(X):- listar_carros(vegas,X).
q4(X):- listar_advogados(X).
q5(X):- preco_medio(vegas,X).
teste:-listar_dados(vegas,ana,D),write(D),altera_id(vegas,ana,50),listar_dados(vegas,ana,D1),write(D1).

