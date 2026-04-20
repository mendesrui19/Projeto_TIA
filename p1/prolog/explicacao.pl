% ============================================================
% EXPLICACAO — Triagem SNS24 (P1MAX)
% Backward chaining com arvore de prova e mecanismo de explicacao.
% Inspirado nos exemplos I, III e Probabilidades dos colegas.
% ============================================================

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- op( 800, xfx, <=).

% ============================================================
% 1. BACKWARD CHAINING simples (demo/1)
%    Verifica se um facto e demonstravel a partir da base.
% ============================================================

demo( Q ) :-
    fact( Q, Cf ), Cf > 0.08.

demo( Q ) :-
    if Cond then Q with _CfRegra,
    demo( Cond ).

demo( Q1 and Q2 ) :-
    demo( Q1 ),
    demo( Q2 ).

demo( Q1 or Q2 ) :-
    demo( Q1 )
    ;
    demo( Q2 ).

% ============================================================
% 2. ARVORE DE PROVA (demo/2)
%    Constroi uma estrutura de prova que pode ser mostrada.
%    demo( +Proposicao, -Prova )
% ============================================================

demo( P, facto(P, Cf) ) :-
    fact( P, Cf ), Cf > 0.08.

demo( P, P <= regra(Cond, CfRegra, CondProva) ) :-
    if Cond then P with CfRegra,
    demo( Cond, CondProva ).

demo( P1 and P2, e(Prova1, Prova2) ) :-
    demo( P1, Prova1 ),
    demo( P2, Prova2 ).

demo( P1 or P2, ou(Prova) ) :-
    ( demo( P1, Prova )
    ; demo( P2, Prova )
    ).

% ============================================================
% 3. VISUALIZACAO DA PROVA (mostrar_prova/2)
%    Apresenta a arvore de prova de forma indentada.
% ============================================================

mostrar_prova( Prova ) :-
    mostrar_prova( Prova, 0 ).

mostrar_prova( facto(P, Cf), Indent ) :-
    tab( Indent ),
    write('FACTO: '), write( P ),
    write(' [cf='), write( Cf ), write(']'), nl.

mostrar_prova( P <= regra(Cond, CfRegra, CondProva), Indent ) :-
    tab( Indent ),
    write('REGRA: if '), write( Cond ),
    write(' then '), write( P ),
    write(' with '), write( CfRegra ), nl,
    Indent2 is Indent + 4,
    tab( Indent2 ), write('PORQUE:'), nl,
    Indent3 is Indent2 + 2,
    mostrar_prova( CondProva, Indent3 ).

mostrar_prova( e(Prova1, Prova2), Indent ) :-
    tab( Indent ), write('E (conjuncao):'), nl,
    Indent2 is Indent + 2,
    mostrar_prova( Prova1, Indent2 ),
    mostrar_prova( Prova2, Indent2 ).

mostrar_prova( ou(Prova), Indent ) :-
    tab( Indent ), write('OU (disjuncao):'), nl,
    Indent2 is Indent + 2,
    mostrar_prova( Prova, Indent2 ).

% ============================================================
% 4. PORQUÊ (porque/1) — Explica porque uma disposicao foi escolhida
%    Uso: ?- porque( inem ).
% ============================================================

porque( Disposicao ) :-
    ( fact( Disposicao, Cf ) ->
        nl, write('=== EXPLICACAO: Porque '), write( Disposicao ), write('? ==='), nl,
        write('Confianca derivada: '), write( Cf ), nl, nl,
        write('Arvore de prova:'), nl,
        ( demo( Disposicao, Prova ) ->
            mostrar_prova( Prova, 2 )
        ;
            write('  (nao foi possivel reconstruir a prova por backward chaining)'), nl
        ),
        nl,
        write('Regras que contribuiram:'), nl,
        forall(
            ( if Cond then Disposicao with CfR,
              composed_fact( Cond, CfC ),
              CfF is CfC * CfR, CfF > 0.08 ),
            ( write('  - if '), write( Cond ),
              write(' then '), write( Disposicao ),
              write(' with '), write( CfR ),
              write(' => cf_final='), write( CfF ), nl )
        )
    ;
        nl, write( Disposicao ), write(' nao foi derivado nesta sessao.'), nl
    ).

% ============================================================
% 5. COMO (como/1) — Mostra o caminho logico ate uma conclusao
%    Uso: ?- como( adr_su ).
% ============================================================

como( Conclusao ) :-
    ( demo( Conclusao, Prova ) ->
        nl, write('=== COMO se chega a: '), write( Conclusao ), write(' ==='), nl, nl,
        mostrar_prova( Prova, 0 ), nl
    ;
        nl, write('Nao e possivel demonstrar '), write( Conclusao ),
        write(' com os factos atuais.'), nl
    ).
