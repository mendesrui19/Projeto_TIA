:- dynamic(fact/1).

:- op(800, fx, if).
:- op(700, xfx, then).
:- op(600, xfx, with).
:- op(300, xfy, or).
:- op(200, xfy, and).



% Base de conhecimento (regras de triagem)
if comprometimento_via_aerea or respiracao_ineficaz or choque_sim or criança_não_responde then vermelho.
if dor_severa or grande_hemorragia or alteracao_consciencia or crianca_quente then laranja.
if dor_moderada or pequena_hemorragia or historia_inapropriada or vomitos_persistentes or quente then amarelo.
if dor or febre or vomitos or problema_recente then verde.




% Motor de inferência (forward chaining)
demo :- new_derived_fact( P), !, write( 'Derived: '), write( P), nl, assert( fact( P)).
%demo.
demo :- write( 'No more facts').

new_derived_fact( Concl) :-
if Cond then Concl, 
\+ fact( Concl),  
composed_fact( Cond). 

composed_fact( Cond) :- fact( Cond).
composed_fact( Cond1 and Cond2) :- composed_fact( Cond1), composed_fact( Cond2).
composed_fact( Cond1 or Cond2) :- composed_fact( Cond1)
;
composed_fact( Cond2).



fact(respiracao_ineficaz).
fact(pequena_hemorragia).

