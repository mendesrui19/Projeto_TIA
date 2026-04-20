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
% ============================================================
% 1. ARVORE DE PROVA (demo/2)
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


