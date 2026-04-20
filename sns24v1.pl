:- dynamic(fact/1).

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(300, xfy, or).
:- op(200, xfy, and).



if inconsciente or nao_respira or hemorragia_grave or convulsoes then ligar_112.
if dificuldade_respirar and dor_severa then ligar_112.
if dificuldade_respirar and febre_alta then ligar_112.
if dificuldade_respirar and vomitos_persistentes then ligar_112.
if dor_severa and vomitos_persistentes then ligar_112.

if dificuldade_respirar or febre_alta or dor_severa or vomitos_persistentes or tonturas_fortes then ir_urgencia.
if febre_moderada and dor_moderada and dor_cabeca_forte then ir_urgencia.
if febre_moderada and tosse_persistente and dor_cabeca_forte then ir_urgencia.
if dor_moderada and vomitos then ir_urgencia.
if tosse_persistente and vomitos then ir_urgencia.

if febre_moderada or dor_moderada or tosse_persistente or infeccao_urinaria or dor_cabeca_forte then consulta_centro_saude.
if dor_ligeira and febre_ligeira then consulta_centro_saude.
if tosse_ligeira and febre_ligeira then consulta_centro_saude.
if constipacao and dor_cabeca_forte then consulta_centro_saude.

if tosse_ligeira or constipacao or dor_ligeira or febre_ligeira or cansaco then autocuidados.



% motor de inferência forward chaining
demo :-
    new_derived_fact( P), !, assert( fact( P)),demo.
demo.

new_derived_fact(Concl) :-
    if Cond then Concl,
    \+ fact(Concl),
    composed_fact(Cond).

composed_fact(Cond) :-
    fact(Cond).
composed_fact(Cond1 and Cond2) :-
    composed_fact(Cond1),
    composed_fact(Cond2).
composed_fact(Cond1 or Cond2) :-
    composed_fact(Cond1);
    composed_fact(Cond2).



% validar a decisao mais prioritária

decisao_final(ligar_112) :-
    fact(ligar_112), !.
decisao_final(ir_urgencia) :-
    fact(ir_urgencia), !.
decisao_final(consulta_centro_saude) :-
    fact(consulta_centro_saude), !.
decisao_final(autocuidados) :-
    fact(autocuidados), !.
decisao_final(sem_decisao).

resultado :-
    demo,nl,
    decisao_final(D),
    write(D), nl.


%fact(inconsciente).
%fact(dificuldade_respirar).
fact(febre_alta).
fact(vomitos).
fact(tosse_persistente).
fact(tosse_ligeira).

