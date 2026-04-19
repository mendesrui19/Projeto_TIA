% P1B — regras aprendidas a partir de dataset_triagem.csv (sem limite artificial
% ao numero de regras: uma por folha da arvore de decisao sobre os dados).
% CF = proporcao da classe majoritaria na folha (como suporte empirico).

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- multifile( (if)/1 ).

if imunodeprimido then adr_su with 0.75.
if apoio_domicilio then autocuidado with 0.75.
if fadiga_mialgias then transferir_triagem with 0.75.
if nao_melhora_antipiretico then transferir_triagem with 0.75.
