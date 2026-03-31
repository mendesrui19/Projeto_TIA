%a)
trabalhapara(joao,  rita,  c).
trabalhapara(rui,   rita,  c).
trabalhapara(iva,   joao,  c).
trabalhapara(miguel, rui,  s).
trabalhapara(rui,   vitor, s).
trabalhapara(tomas, vitor, s).
trabalhapara(ivo,   tomas, s).
% (b)
chefe(rita,  c).
chefe(vitor, s).
% (c)
mesmonivel(X, Y) :-
    X \== Y,
    trabalhapara(X, Chefe, _),
    trabalhapara(Y, Chefe, _).
% (d)
empregado(X, E) :-
    chefe(X, E).
empregado(X, E) :-
    trabalhapara(X, _, E).
empregado(X, E) :-
    trabalhapara(_, X, E).
% (e)
temchefe(X, Y) :-
    empregado(X, E),
    chefe(Y, E).
% (f)
acima(X, Y, E) :-
    trabalhapara(X, Y, E).
acima(X, Y, E) :-
    trabalhapara(X, Z, E),
    acima(Z, Y, E).
% (g)
sexo(joao,   m).
sexo(rui,    m).
sexo(iva,    f).
sexo(rita,   f).
sexo(tomas,  m).
sexo(ivo,    m).
sexo(miguel, m).
sexo(vitor,  m).
sexodif(X, Y) :-
    sexo(X, S1),
    sexo(Y, S2),
    S1 \== S2.
perigoassedio(X, Y) :-
    sexodif(X, Y),
    ( acima(X, Y, _) ; acima(Y, X, _) ).
% (h)
q1 :- acima(joao, rita, _).
q2(X) :- acima(X, rita, _).
q3a(X) :- mesmonivel(joao, X).
q3b(X) :- mesmonivel(rui, X).
q4(X) :- acima(ivo, X, _).
q5(X) :-
    chefe(rita, E),
    empregado(X, E).
q6(X) :-
    empregado(X, E1),
    empregado(X, E2),
    E1 \== E2.
q7(X) :- perigoassedio(joao, X).
q8(X) :-
    empregado(X, E),
    \+ (empregado(X, E2), E2 \== E).
