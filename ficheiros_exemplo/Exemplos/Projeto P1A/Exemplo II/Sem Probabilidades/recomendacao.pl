% Grupo 33: Carlos, João, José, Rui 
:-dynamic(fact/1),
[forward, base_dados, base_conhecimento].

:-assert(fact(preco_0_7)), assert(fact(idade_18_29)), assert(fact(apressado)), assert(fact('classificacao_>47')), assert(fact(carnes)), assert(fact(bebida_nao_incluida)), assert(fact(entregar)).

resultados(OUTPUT):-
	fact(TIPO),
    	fact(PRECO), 
	fact(DURACAO), 
	fact(CLASSIFICACAO), 
	fact(CATEGORIA), 
	fact(BEBIDA), 
    	(pedido(TIPO, PRECO, DURACAO, CLASSIFICACAO, X, BEBIDA, OUTPUT), memberchk(CATEGORIA, X)).

resultados(_).

consulta(C):-
    	demo,
    	findall(OUTPUT, resultados(OUTPUT), O1), list_to_set(O1, C).
