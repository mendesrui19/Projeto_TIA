% ============================================================
% MOTOR DE INFERENCIA — Triagem SNS24
% Encadeamento para a frente com fatores de certeza (estilo sns24v2)
% ============================================================

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).

corte_certeza( 0.08 ).

composed_fact( Cond, Cf ) :-
    fact( Cond, Cf ),
    corte_certeza( T ),
    Cf > T.

composed_fact( Cond1 and Cond2, Cf ) :-
    composed_fact( Cond1, Cf1 ),
    composed_fact( Cond2, Cf2 ),
    Cf is min( Cf1, Cf2 ).

composed_fact( Cond1 or Cond2, Cf ) :-
    composed_fact( Cond1, Cf1 ),
    composed_fact( Cond2, Cf2 ), !,
    Cf is max( Cf1, Cf2 ).

composed_fact( Cond1 or _Cond2, Cf ) :-
    composed_fact( Cond1, Cf ), !.

composed_fact( _Cond1 or Cond2, Cf ) :-
    composed_fact( Cond2, Cf ).

novo_facto_derivado( Concl, CfFinal ) :-
    if Cond then Concl with CfRegra,
    \+ fact( Concl, _ ),
    composed_fact( Cond, CfCond ),
    CfFinal is CfCond * CfRegra,
    corte_certeza( T ),
    CfFinal > T.

inferir_para_frente :-
    novo_facto_derivado( Novo, Cf ), !,
    assert( fact( Novo, Cf ) ),
    inferir_para_frente.
inferir_para_frente.

% Decisao: percorre a lista de disposicoes por ordem de gravidade,
% devolve a primeira cuja confianca supere o corte.
decisao_encaminhamento( D, Cf ) :-
    ordem_disposicao( Lista ),
    member( D, Lista ),
    fact( D, Cf ),
    corte_certeza( T ),
    Cf > T,
    !.

% Regras ativas para uma disposicao (para explicacao)
regras_ativas_decisao( D, Regras ) :-
    findall(
        (Cond, CfRegra, CfCond, CfFinal),
        (
            if Cond then D with CfRegra,
            composed_fact( Cond, CfCond ),
            CfFinal is CfCond * CfRegra,
            corte_certeza( T ),
            CfFinal > T
        ),
        Regras
    ).
