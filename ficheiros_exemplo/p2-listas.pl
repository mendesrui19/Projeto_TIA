:-dynamic(lista1/1).

% 2.1
adiciona(X,L,[X|L]).

% 2.2
apaga(X,[X|R],R).
apaga(X,[Y|R1],[Y|R2]):- apaga(X,R1,R2).

% 2.3
membro( X, [X|_] ).
membro( X, [_|R] ) :- membro( X, R ).

% 2.4
concatena([],L,L).
concatena([X|L1],L2,[X|L3]):- concatena(L1,L2,L3).

% 2.5
sublista(S,L):-
  concatena(_,L2,L),
  concatena(S,_,L2).

% 2.6
comprimento(0,[]).
comprimento(N,[_|R]):- 
	comprimento(N1,R),
        N is 1 + N1.

% 2.7
max(X,[X]).
max(X,[Y|R]):- max(X,R), X > Y, !. 
%max(Y,[Y|R]):- max(X,R), X < Y, !. 
max(Y,[Y|_]).

% 2.8
somatorio(0,[]).
somatorio(X,[Y|R]):- somatorio(S,R),
                     X is S+Y.
media(X,L):-      
        comprimento(N,L), somatorio(S,L),
        X is S/N.

% 2.9
nelem(N,L,X):-
        nelem(N,1,L,X). 
        nelem(N,N,[X|_],X):-!. 
        nelem(N,I,[_|R],X):-    
                I1 is I+1,
                nelem(N,I1,R,X).


% ---------------------
% testar os predicados: 
lista1([5,7,3,8,3,2]).

q1a(LR):-adiciona(1,[2,3],LR).
q1b(X):-adiciona(X,[2,3],[1,2,3]).
q1c(LR):-lista1(L),adiciona(1,L,LR).
q1d:-lista1(L),adiciona(1,L,LR),retract(lista1(L)),assert(lista1(LR)).

q2a(LR):-apaga(a,[a,b,a,c],LR).
q2b(LR):-apaga(a,LR,[b,c]).
q2c(LR):- lista1(L), apaga(3,L,LR).
q2d(LR):- lista1(L), findall(L2,apaga(3,L,L2),LR).

q3a:-membro(b,[a,b,c]).
q3b(X):-membro(X,[a,b,c]).
q3c(LR):-findall(X,membro(X,[a,b,c]),LR).
q3d1:- lista1(L),membro(8,L).
q3d2:- lista1(L),membro(9,L).

q4a(LR):-concatena([1,2],[3,4],LR).
q4b(LR):-concatena([1,2],LR,[1,2,3,4]).
q4c(LR):-concatena(LR,[3,4],[1,2,3,4]).
q4d(LR):-lista1(L),concatena([9,9,9],L,LR).

q5a(X):-comprimento(X,[a,b,c]).
q5b(X):-lista1(L),comprimento(X,L).

q6a:- sublista([rui,ana],[rita,rui,ana,ivo]). 
q6b(L):-sublista(L,[rita,rui,ana,ivo]).

q7a(X):-max(X,[3,2,1,7,4]).
q7b(X):-lista1(L),max(X,L).

q8(X):-media(X,[1,2,3,4,5]). 

q9a:-nelem(2,[1,2,3],2).
q9b(X):-nelem(3,[1,2,3],X).
q9c(X):-nelem(4,[a,b,c,d,e,f,g],X). 
