:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- op( 800, xfx, <=).
demo( P, P) :- fact( P).
demo( P, P <= CondProof) :-
if Cond then P, demo( Cond, CondProof).
demo( P1 and P2, Proof1 and Proof2) :-
demo( P1, Proof1), demo( P2, Proof2).
demo( P1 or P2, Proof) :-
demo( P1, Proof);
demo( P2, Proof).

if positiva and sem_faltas then passo.
if estudei then positiva.
if nao_estudei then negativa.

fact(estudei).
fact(sem_faltas).