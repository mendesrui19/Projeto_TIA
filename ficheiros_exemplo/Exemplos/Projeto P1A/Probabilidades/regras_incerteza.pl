:- dynamic fact/1.
:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- op( 800, xfx, <=).
democ( P, Cert) :- fact( P: Cert).
democ( Cond1 and Cond2, Cert) :-
democ( Cond1, Cert1), democ( Cond2, Cert2), Cert is min( Cert1,
Cert2).
democ( Cond1 or Cond2, Cert) :-
democ( Cond1, Cert1), democ( Cond2, Cert2),
Cert is max( Cert1, Cert2).
democ( P, Cert) :-
if Cond then P : C1, democ( Cond, C2),
Cert is C1 * C2.

% regras: base de conhecimento
if hall_molhado and cozinha_seco then fuga_banho:0.5.
if hall_molhado and banho_seco then problema_cozinha:0.9.
if janela_fechada or nao_chove then nao_agua:0.7.
if hall_seco and banho_molhado then torneira_aberta:0.5.
if problema_cozinha and janela_fechada then inundacao:1.0.
% factos: base de dados, situação actual
fact(hall_molhado:0.8).
fact(banho_seco:1.0).
fact(janela_fechada:0.3).