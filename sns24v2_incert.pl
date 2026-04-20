:- dynamic(fact/2).

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(600, xfx, with).
:- op(300, xfy, or).
:- op(200, xfy, and).


/* BASE DE CONHECIMENTO COM INCERTEZA */

if inconsciente or nao_respira or hemorragia_grave or convulsoes then ligar_112 with 1.
if dificuldade_respirar and dor_severa then ligar_112 with 0.95.
if dificuldade_respirar and febre_alta then ligar_112 with 0.9.
if dificuldade_respirar and vomitos_persistentes then ligar_112 with 0.85.
if dor_severa and vomitos_persistentes then ligar_112 with 0.8.

if dificuldade_respirar or febre_alta or dor_severa or vomitos_persistentes or tonturas_fortes then ir_urgencia with 0.9.
if febre_moderada and dor_moderada and dor_cabeca_forte then ir_urgencia with 0.85.
if febre_moderada and tosse_persistente and dor_cabeca_forte then ir_urgencia with 0.80.
if dor_moderada and vomitos then ir_urgencia with 0.75.
if tosse_persistente and vomitos then ir_urgencia with 0.70.

if febre_moderada or dor_moderada or tosse_persistente or infeccao_urinaria or dor_cabeca_forte then consulta_centro_saude with 0.85.
if dor_ligeira and febre_ligeira then consulta_centro_saude with 0.75.
if tosse_ligeira and febre_ligeira then consulta_centro_saude with 0.70.
if constipacao and dor_cabeca_forte then consulta_centro_saude with 0.65.

if tosse_ligeira or constipacao or dor_ligeira or febre_ligeira or cansaco then autocuidados with 0.90.



/*   MOTOR DE INFERÊNCIA FORWARD CHAINING  */


demo :-
    new_derived_fact(P, Cf), !,
    assert(fact(P, Cf)),
    demo.
demo.

new_derived_fact(Concl, CfFinal) :-
    if Cond then Concl with CfRegra,
    \+ fact(Concl, _),
    composed_fact(Cond, CfCond),
    CfFinal is CfCond * CfRegra.

composed_fact(Cond, Cf) :-
    fact(Cond, Cf).

composed_fact(Cond1 and Cond2, Cf) :-
    composed_fact(Cond1, Cf1),
    composed_fact(Cond2, Cf2),
    Cf is min(Cf1, Cf2).

composed_fact(Cond1 or Cond2, Cf) :-
    composed_fact(Cond1, Cf1),
    composed_fact(Cond2, Cf2), !,
    Cf is max(Cf1, Cf2).

composed_fact(Cond1 or _Cond2, Cf) :-
    composed_fact(Cond1, Cf), !.

composed_fact(_Cond1 or Cond2, Cf) :-
    composed_fact(Cond2, Cf).



/* DECISAO FINAL */ 

decisao_final(ligar_112, Cf) :-
    fact(ligar_112, Cf), !.
decisao_final(ir_urgencia, Cf) :-
    fact(ir_urgencia, Cf), !.
decisao_final(consulta_centro_saude, Cf) :-
    fact(consulta_centro_saude, Cf), !.
decisao_final(autocuidados, Cf) :-
    fact(autocuidados, Cf), !.
decisao_final(sem_decisao, 0.0).



resultado :-
    demo, nl,
    decisao_final(D, Cf),
    write('Decisao final: '), write(D), nl,
    write('Confianca: '), write(Cf), nl.



%fact(inconsciente, 0.9).
fact(dificuldade_respirar, 0.6).
fact(febre_alta, 0.5).
fact(febre_moderada, 0.8).


