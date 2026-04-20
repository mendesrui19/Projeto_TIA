% ============================================================
% BASE DE CONHECIMENTO — Triagem SNS24
% Regras de producao: if Cond then Conclusao with CF
% Sintaxe alinhada com sns24v2_incert.pl (aulas)
% ============================================================

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).

:- discontiguous( (if)/1 ).
:- multifile( (if)/1 ).

% ---- taxonomia ----
if febre_alta_40                then febre             with 1.0.
if febre_persistente            then febre             with 1.0.
if tosse_persistente            then tosse             with 1.0.
if tosse_produtiva              then tosse             with 1.0.
if tosse_agravada               then tosse             with 1.0.
if falta_ar_repouso             then falta_ar          with 1.0.
if falta_ar_leve                then falta_ar          with 1.0.
if pieira_ou_tiragem            then falta_ar          with 1.0.
if vomitos_intensos             then vomitos           with 1.0.
if diarreia_grave               then diarreia          with 1.0.
if dor_abdominal_forte          then dor_abdominal     with 1.0.
if tratamento_oncologico        then imunodeprimido    with 1.0.
if alteracao_consciencia        then confusao          with 1.0.
if sonolencia_anormal           then confusao          with 1.0.
if fraqueza_lado_corpo          then confusao          with 1.0.

% ---- agrupamentos clinicos ----
if tosse                        then sintoma_respiratorio with 1.0.
if falta_ar                     then sintoma_respiratorio with 1.0.
if dor_garganta                 then sintoma_respiratorio with 1.0.
if congestao_nasal              then sintoma_respiratorio with 1.0.
if febre                        then sintoma_geral        with 1.0.
if fadiga_mialgias              then sintoma_geral        with 1.0.
if nausea                       then sintoma_digestivo    with 1.0.
if vomitos                      then sintoma_digestivo    with 1.0.
if diarreia                     then sintoma_digestivo    with 1.0.
if dor_abdominal                then sintoma_digestivo    with 1.0.
if dor_cabeca                   then sintoma_neurologico  with 1.0.
if dor_cabeca_forte             then sintoma_neurologico  with 1.0.

% ---- cefaleia_grave ----
if dor_cabeca_forte and rigidez_pescoco   then cefaleia_grave with 1.0.
if dor_cabeca_forte and sensibilidade_luz then cefaleia_grave with 1.0.
if dor_cabeca_forte and manchas_pele      then cefaleia_grave with 1.0.

% ---- fatores de risco ----
if imunodeprimido               then risco_agravamento with 1.0.
if doenca_cronica               then risco_agravamento with 1.0.
if idade_risco                  then risco_agravamento with 1.0.
if gravidez                     then risco_agravamento with 1.0.

% ---- inem ----
if compromisso_via_aerea                         then inem with 0.98.
if pieira_ou_tiragem                             then inem with 0.95.
if dor_toracica and falta_ar                     then inem with 0.95.
if alteracao_consciencia                         then inem with 0.98.
if convulsoes                                    then inem with 0.98.
if fraqueza_lado_corpo                           then inem with 0.97.
if tosse_com_sangue                              then inem with 0.96.
if sangramento_abundante                         then inem with 0.98.
if confusao                                      then inem with 0.93.
if cefaleia_grave and febre                      then inem with 0.94.
if trauma_recente and alteracao_consciencia      then inem with 0.96.

% ---- adr-su ----
if febre_alta_40 and imunodeprimido              then adr_su with 0.92.
if convulsao_febril                              then adr_su with 0.9.
if febre and manchas_pele                        then adr_su with 0.88.
if dor_abdominal_forte                           then adr_su with 0.9.
if vomitos_intensos                              then adr_su with 0.88.
if desidratacao and febre                        then adr_su with 0.87.
if diarreia_grave and desidratacao               then adr_su with 0.86.
if falta_ar and febre                            then adr_su with 0.85.
if agravamento_48h and risco_agravamento         then adr_su with 0.9.
if trauma_recente and sintomas_pos_trauma        then adr_su with 0.88.

% ---- adr-csp / medico ----
if febre_alta_40                                 then adr_csp with 0.82.
if febre_persistente and nao_melhora_antipiretico then adr_csp with 0.8.
if dor_abdominal and febre                       then adr_csp with 0.78.
if dor_abdominal and disuria                     then adr_csp with 0.8.
if disuria                                       then contactar_medico with 0.75.

% ---- autocuidado + seguimento ----
if tosse and febre and contacto_recente          then autocuidado_seguimento with 0.85.
if febre and fadiga_mialgias and apoio_domicilio then autocuidado_seguimento with 0.82.
if sintoma_respiratorio and sintoma_geral and apoio_domicilio then autocuidado_seguimento with 0.8.
if febre and apoio_domicilio                     then autocuidado_seguimento with 0.75.

% ---- autocuidado ----
if tosse and tosse_produtiva and apoio_domicilio then autocuidado with 0.78.
if alteracao_olfato and apoio_domicilio          then autocuidado with 0.76.
if alteracao_paladar and apoio_domicilio         then autocuidado with 0.76.
if espirros and congestao_nasal                  then autocuidado with 0.72.
if dor_garganta and apoio_domicilio              then autocuidado with 0.74.
if tosse and apoio_domicilio                     then autocuidado with 0.7.

% ---- fallback triagem ----
if febre                                         then transferir_triagem with 0.55.
if tosse                                         then transferir_triagem with 0.5.
if falta_ar                                      then transferir_triagem with 0.55.
if sintoma_digestivo                             then transferir_triagem with 0.52.
