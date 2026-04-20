% P1B — regras aprendidas a partir de dataset_triagem.csv (sem limite artificial
% ao numero de regras: uma por folha da arvore de decisao sobre os dados).
% CF = proporcao da classe majoritaria na folha (como suporte empirico).

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- multifile( (if)/1 ).

if agravamento then adr_su with 0.75.
if agravamento and dor_abdominal and dor_abdominal_forte then adr_su with 0.75.
if agravamento and febre_alta_40 and convulsao_febril then adr_su with 0.75.
if agravamento and febre_alta_40 and doenca_cronica then adr_su with 0.75.
if agravamento and febre_alta_40 and falta_ar then adr_su with 0.75.
if agravamento and febre_alta_40 and gravidez then adr_su with 0.75.
if agravamento and febre_alta_40 and idade_risco then adr_su with 0.75.
if agravamento and febre_alta_40 and imunodeprimido then adr_su with 0.75.
if agravamento and febre_alta_40 and manchas_pele then adr_su with 0.75.
if agravamento and febre_alta_40 and tratamento_oncologico then adr_su with 0.75.
if agravamento_48h then adr_su with 0.75.
if desidratacao then adr_su with 0.75.
if dor_abdominal_forte then adr_su with 0.75.
if febre and convulsao_febril then adr_su with 0.75.
if febre and desidratacao then adr_su with 0.75.
if febre and dor_abdominal and dor_abdominal_forte then adr_su with 0.75.
if febre and falta_ar then adr_su with 0.75.
if febre and febre_alta_40 and convulsao_febril then adr_su with 0.75.
if febre and febre_alta_40 and doenca_cronica then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and convulsao_febril then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and doenca_cronica then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and falta_ar then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and gravidez then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and idade_risco then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and imunodeprimido then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and manchas_pele then adr_su with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and tratamento_oncologico then adr_su with 0.75.
if febre and febre_alta_40 and falta_ar then adr_su with 0.75.
if febre and febre_alta_40 and gravidez then adr_su with 0.75.
if febre and febre_alta_40 and idade_risco then adr_su with 0.75.
if febre and febre_alta_40 and imunodeprimido then adr_su with 0.75.
if febre and febre_alta_40 and manchas_pele then adr_su with 0.75.
if febre and febre_alta_40 and tratamento_oncologico then adr_su with 0.75.
if febre and manchas_pele then adr_su with 0.75.
if febre and trauma_recente then adr_su with 0.75.
if febre and vomitos_intensos then adr_su with 0.75.
if sintomas_pos_trauma then adr_su with 0.75.
if vomitos_intensos then adr_su with 0.75.
if apoio_domicilio then autocuidado with 0.75.
if espirros and dor_cabeca then autocuidado with 0.75.
if espirros and fadiga_mialgias then autocuidado with 0.75.
if espirros and nausea then autocuidado with 0.75.
if agravamento and congestao_nasal then transferir_triagem with 0.75.
if agravamento and disuria then transferir_triagem with 0.75.
if agravamento and dor_abdominal then transferir_triagem with 0.75.
if agravamento and dor_cabeca_forte then transferir_triagem with 0.75.
if agravamento and dor_garganta then transferir_triagem with 0.75.
if agravamento and falta_ar_leve then transferir_triagem with 0.75.
if agravamento and febre_alta_40 then transferir_triagem with 0.75.
if agravamento and febre_persistente then transferir_triagem with 0.75.
if disuria then transferir_triagem with 0.75.
if espirros then transferir_triagem with 0.75.
if espirros and congestao_nasal then transferir_triagem with 0.75.
if febre then transferir_triagem with 0.75.
if febre and disuria then transferir_triagem with 0.75.
if febre and dor_abdominal then transferir_triagem with 0.75.
if febre and dor_cabeca_forte then transferir_triagem with 0.75.
if febre and falta_ar_leve then transferir_triagem with 0.75.
if febre and febre_alta_40 then transferir_triagem with 0.75.
if febre and febre_alta_40 and congestao_nasal then transferir_triagem with 0.75.
if febre and febre_alta_40 and dor_garganta then transferir_triagem with 0.75.
if febre and febre_alta_40 and fadiga_mialgias then transferir_triagem with 0.75.
if febre and febre_alta_40 and fadiga_mialgias and dor_cabeca then transferir_triagem with 0.75.
if febre and febre_persistente then transferir_triagem with 0.75.
if nao_melhora_antipiretico then transferir_triagem with 0.75.
