:- dynamic fact/2.

% Operadores alinhados a sns24v2_incert.pl (aulas)
:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).

:- discontiguous( (if)/1 ).
:- multifile( (if)/1 ).

% 1. BASE DE DADOS (perguntas = sintomas observaveis; respostas em fact/2)

% ---- respiratorio ----
pergunta( tosse,              'Tem tosse nova ou agravamento do padrao habitual').
pergunta( tosse_agravada,     'A tosse esta pior do que o habitual').
pergunta( tosse_persistente,  'A tosse dura ha varios dias').
pergunta( tosse_produtiva,    'Tem tosse com catarro ou expectoracao').
pergunta( tosse_com_sangue,   'Tem tosse com sangue').
pergunta( falta_ar,           'Tem falta de ar ou dificuldade em respirar').
pergunta( falta_ar_repouso,   'Tem falta de ar mesmo em repouso').
pergunta( falta_ar_leve,      'Sente falta de ar ligeira ao fazer esforco').
pergunta( pieira_ou_tiragem,  'Tem pieira, tiragem no peito ou labios/unhas azulados').
pergunta( dor_garganta,       'Tem dor de garganta').
pergunta( congestao_nasal,    'Tem o nariz entupido').
pergunta( espirros,           'Tem tido varios espirros seguidos').

% ---- febre ----
pergunta( febre,              'Tem febre ou sensacao febril').
pergunta( febre_alta_40,      'A febre axilar e superior a 40C ou retal superior a 41C').
pergunta( febre_persistente,  'Tem febre ha mais de 48 horas').
pergunta( nao_melhora_antipiretico, 'A febre mantem-se mesmo com paracetamol ou ibuprofeno').
pergunta( convulsao_febril,   'Teve episodio de convulsao associada a febre').

% ---- neurologico ----
pergunta( dor_cabeca,         'Tem dores de cabeca').
pergunta( dor_cabeca_forte,   'A dor de cabeca e forte ou intensa').
pergunta( rigidez_pescoco,    'Tem rigidez no pescoco').
pergunta( sensibilidade_luz,  'Tem sensibilidade incomum a luz').
pergunta( manchas_pele,       'Tem manchas, pontos vermelhos ou roxos na pele').
pergunta( sonolencia_anormal, 'Tem sonolencia fora do normal ou dificuldade em manter-se acordado').
pergunta( confusao,           'Apresenta confusao ou desorientacao').
pergunta( alteracao_consciencia, 'Perdeu a consciencia ou desmaiou recentemente').
pergunta( convulsoes,         'Teve convulsoes').
pergunta( fraqueza_lado_corpo,'Tem fraqueza ou paralisia de um lado do corpo').

% ---- emergencia ----
pergunta( compromisso_via_aerea, 'Sente a garganta a fechar ou lingua/labios muito inchados').
pergunta( dor_toracica,       'Tem dor no peito intensa ou opressiva').
pergunta( sangramento_abundante, 'Tem sangramento abundante').

% ---- olfato / paladar ----
pergunta( alteracao_olfato,   'Tem perda ou alteracao subita do olfato nos ultimos 7 dias').
pergunta( olfato_quimio,      'Essa perda de olfato surgiu depois de quimioterapia').
pergunta( olfato_trauma,      'Essa perda de olfato surgiu depois de trauma ou cirurgia nasal').
pergunta( alteracao_paladar,  'Tem perda ou alteracao subita do paladar nos ultimos 7 dias').
pergunta( paladar_quimio,     'Essa alteracao do paladar surgiu depois de quimioterapia').
pergunta( paladar_trauma,     'Essa alteracao do paladar surgiu depois de trauma ou cirurgia').

% ---- digestivo ----
pergunta( nausea,             'Tem nauseas').
pergunta( vomitos,            'Tem vomitos').
pergunta( vomitos_intensos,   'Os vomitos sao intensos ou frequentes').
pergunta( diarreia,           'Tem diarreia').
pergunta( diarreia_grave,     'A diarreia e muito abundante ou frequente').
pergunta( dor_abdominal,      'Tem dor abdominal').
pergunta( dor_abdominal_forte,'A dor abdominal e forte ou intensa').
pergunta( disuria,            'Tem dor, ardor ou desconforto ao urinar').
pergunta( desidratacao,       'Tem sinais de desidratacao (boca seca, pouca urina, olhos encovados)').

% ---- sintomas gerais ----
pergunta( fadiga_mialgias,    'Tem cansaco ou dores musculares generalizadas').
pergunta( agravamento,        'Os sintomas tem vindo a piorar').
pergunta( agravamento_48h,    'Esse agravamento aconteceu nas ultimas 48 horas').

% ---- contexto / risco ----
pergunta( imunodeprimido,     'E imunodeprimido, tem problema renal grave ou esta em dialise').
pergunta( tratamento_oncologico, 'Esta atualmente em tratamento oncologico ativo').
pergunta( gravidez,           'Esta gravida ou teve parto recente').
pergunta( doenca_cronica,     'Tem alguma doenca cronica (cardiaca, respiratoria, renal, diabetes)').
pergunta( idade_risco,        'Tem 65 ou mais anos, ou e crianca com menos de 5 anos').
pergunta( apoio_domicilio,    'Tem telemovel e alguem que o possa auxiliar em casa').
pergunta( contacto_recente,   'Contacto proximo com infecao respiratoria confirmada nos ultimos 14 dias').
pergunta( trauma_recente,     'Fez cirurgia, biopsia ou teve traumatismo recente').
pergunta( sintomas_pos_trauma,'Apos esse evento teve dor, febre ou agravamento do estado geral').

% ---- disposicoes ----
disposicao( inem,                  'INEM / 112 - emergencia medica imediata').
disposicao( adr_su,                'ADR-SU - deslocar-se ao Servico de Urgencia').
disposicao( adr_csp,               'ADR-CSP - contactar Centro de Saude (CSP)').
disposicao( contactar_medico,      'Contactar o medico assistente').
disposicao( autocuidado_seguimento,'Autocuidado com isolamento domiciliario + seguimento telefonico').
disposicao( autocuidado,           'Autocuidado com isolamento no domicilio').
disposicao( transferir_triagem,    'Transferencia SNS24 - Triagem (orientacao pela linha)').

% Ordem de gravidade para escolha final (primeiro com confianca acima do corte ganha).
ordem_disposicao( [
    inem, adr_su, adr_csp, contactar_medico,
    autocuidado_seguimento, autocuidado, transferir_triagem
] ).


% 2. BASE DE CONHECIMENTO — if Cond then Conclusao with CF (aulas)

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

:- ( exists_file('regras_aprendidas.pl') -> consult('regras_aprendidas') ; true ).


% 3. MOTOR DE INFERENCIA (encadeamento para a frente + certeza, estilo sns24v2)

corte_certeza( 0.08 ).

composed_fact( Cond, Cf ) :-
    fact( Cond, Cf ),
    corte_certeza( T ),
    Cf > T.

composed_fact( Cond1 and Cond2, Cf ) :-
    composed_fact( Cond1, Cf1 ),
    composed_fact( Cond2, Cf2 ),
    Cf is min( Cf1, Cf2 ).

composed_fact( Cond1 or Cond2, Cf ) :-
    composed_fact( Cond1, Cf1 ),
    composed_fact( Cond2, Cf2 ), !,
    Cf is max( Cf1, Cf2 ).

composed_fact( Cond1 or _Cond2, Cf ) :-
    composed_fact( Cond1, Cf ), !.

composed_fact( _Cond1 or Cond2, Cf ) :-
    composed_fact( Cond2, Cf ).

novo_facto_derivado( Concl, CfFinal ) :-
    if Cond then Concl with CfRegra,
    \+ fact( Concl, _ ),
    composed_fact( Cond, CfCond ),
    CfFinal is CfCond * CfRegra,
    corte_certeza( T ),
    CfFinal > T.

inferir_para_frente :-
    novo_facto_derivado( Novo, Cf ), !,
    assert( fact( Novo, Cf ) ),
    inferir_para_frente.
inferir_para_frente.


% 4. INTERFACE

% Ja respondeu (sim com 1.0 ou nao com 0.0 — ambos bloqueiam nova pergunta).
ja_sabe( F ) :-
    fact( F, _ ), !.

% Resposta afirmativa para ramificar perguntas de aprofundamento.
resposta_sim( F ) :-
    fact( F, C ),
    C >= 0.5.

perguntar( F ) :-
    ja_sabe( F ), !.
perguntar( F ) :-
    pergunta( F, Texto ),
    nl, write('  '), write( Texto ), write('? ' ),
    read( X ),
    retractall( fact( F, _ ) ),
    ( (X == s ; X == sim) ->
        assert( fact( F, 1.0 ) )
    ;
        assert( fact( F, 0.0 ) )
    ).

perguntar_e_inferir( F ) :-
    perguntar( F ),
    inferir_para_frente.

decidido_grave :-
    fact( inem, C ),
    C > 0.08,
    !.
decidido_grave :-
    fact( adr_su, C2 ),
    C2 > 0.08,
    !.

perguntar_se_nao_grave( _ ) :-
    decidido_grave, !.
perguntar_se_nao_grave( F ) :-
    perguntar_e_inferir( F ).


% 5. SUBFLUXOS (ordem e nomes distintos do projetoV4 do colega:
%    aqui febre ANTES do bloco de contexto/risco)

bloqueio_emergencia :-
    nl, write('--- Alerta: emergencia ---'), nl,
    perguntar_se_nao_grave( compromisso_via_aerea ),
    perguntar_se_nao_grave( dor_toracica ),
    perguntar_se_nao_grave( pieira_ou_tiragem ),
    perguntar_se_nao_grave( alteracao_consciencia ),
    perguntar_se_nao_grave( convulsoes ),
    perguntar_se_nao_grave( fraqueza_lado_corpo ),
    perguntar_se_nao_grave( sangramento_abundante ),
    perguntar_se_nao_grave( tosse_com_sangue ),
    perguntar_se_nao_grave( confusao ).

triagem_termica :-
    nl, write('--- Febre e sinais associados ---'), nl,
    perguntar_se_nao_grave( febre ),
    ( resposta_sim( febre ) ->
        perguntar_se_nao_grave( febre_alta_40 ),
        ( resposta_sim( febre_alta_40 ) -> true
        ;   perguntar_se_nao_grave( febre_persistente ),
            ( resposta_sim( febre_persistente ) ->
                perguntar_se_nao_grave( nao_melhora_antipiretico )
            ;   true )
        ),
        perguntar_se_nao_grave( convulsao_febril ),
        perguntar_se_nao_grave( manchas_pele ),
        perguntar_se_nao_grave( dor_cabeca_forte ),
        ( resposta_sim( dor_cabeca_forte ) ->
            perguntar_se_nao_grave( rigidez_pescoco ),
            perguntar_se_nao_grave( sensibilidade_luz )
        ;   true )
    ;   true ).

triagem_perfil_risco :-
    nl, write('--- Perfil e contexto ---'), nl,
    perguntar_se_nao_grave( idade_risco ),
    perguntar_se_nao_grave( doenca_cronica ),
    perguntar_se_nao_grave( tratamento_oncologico ),
    perguntar_se_nao_grave( gravidez ),
    perguntar_se_nao_grave( imunodeprimido ),
    perguntar_se_nao_grave( trauma_recente ),
    ( resposta_sim( trauma_recente ) -> perguntar_se_nao_grave( sintomas_pos_trauma ) ; true ),
    perguntar_se_nao_grave( contacto_recente ),
    perguntar_se_nao_grave( apoio_domicilio ).

triagem_respiratoria :-
    nl, write('--- Via aerea e tosse ---'), nl,
    perguntar_se_nao_grave( falta_ar ),
    ( resposta_sim( falta_ar ) ->
        perguntar_se_nao_grave( falta_ar_repouso ),
        perguntar_se_nao_grave( falta_ar_leve )
    ;   true ),
    perguntar_se_nao_grave( tosse ),
    ( resposta_sim( tosse ) ->
        perguntar_se_nao_grave( tosse_agravada ),
        perguntar_se_nao_grave( tosse_persistente ),
        perguntar_se_nao_grave( tosse_produtiva )
    ;   true ),
    perguntar_se_nao_grave( dor_garganta ),
    perguntar_se_nao_grave( congestao_nasal ),
    perguntar_se_nao_grave( espirros ).

triagem_chemosensorial :-
    nl, write('--- Olfato e paladar ---'), nl,
    perguntar_se_nao_grave( alteracao_olfato ),
    ( resposta_sim( alteracao_olfato ) ->
        perguntar_se_nao_grave( olfato_quimio ),
        ( resposta_sim( olfato_quimio ) -> true
        ;   perguntar_se_nao_grave( olfato_trauma ) )
    ;   true ),
    perguntar_se_nao_grave( alteracao_paladar ),
    ( resposta_sim( alteracao_paladar ) ->
        perguntar_se_nao_grave( paladar_quimio ),
        ( resposta_sim( paladar_quimio ) -> true
        ;   perguntar_se_nao_grave( paladar_trauma ) )
    ;   true ).

triagem_digestiva :-
    nl, write('--- Abdomen e hidratacao ---'), nl,
    perguntar_se_nao_grave( nausea ),
    perguntar_se_nao_grave( vomitos ),
    ( resposta_sim( vomitos ) -> perguntar_se_nao_grave( vomitos_intensos ) ; true ),
    perguntar_se_nao_grave( diarreia ),
    ( resposta_sim( diarreia ) -> perguntar_se_nao_grave( diarreia_grave ) ; true ),
    perguntar_se_nao_grave( dor_abdominal ),
    ( resposta_sim( dor_abdominal ) -> perguntar_se_nao_grave( dor_abdominal_forte ) ; true ),
    perguntar_se_nao_grave( disuria ),
    perguntar_se_nao_grave( desidratacao ).

triagem_sistema_geral :-
    nl, write('--- Estado geral ---'), nl,
    perguntar_se_nao_grave( fadiga_mialgias ),
    perguntar_se_nao_grave( agravamento ),
    ( resposta_sim( agravamento ) -> perguntar_se_nao_grave( agravamento_48h ) ; true ).


iniciar :-
    retractall( fact( _, _ ) ),
    banner,
    bloqueio_emergencia,
    triagem_termica,
    triagem_perfil_risco,
    triagem_respiratoria,
    triagem_chemosensorial,
    triagem_digestiva,
    triagem_sistema_geral,
    concluir.

banner :-
    nl,
    write('   TRIAGEM SNS24  -  808 24 24 24   |   Emergencia: 112'), nl,
    write('   Responda a cada pergunta com:  s.   (sim)    ou   n.   (nao)'), nl,
    write('   (nao esquecer o ponto final depois da letra!)'), nl,
    write('   Nota: nao = grau 0.0; sim = 1.0 (modelo das aulas com fact/2).'), nl.

concluir :-
    inferir_para_frente,
    ( decisao_encaminhamento( Melhor, Cf ) ->
        apresentar( Melhor, Cf )
    ;
        apresentar_default
    ).

decisao_encaminhamento( D, Cf ) :-
    ordem_disposicao( Lista ),
    member( D, Lista ),
    fact( D, Cf ),
    corte_certeza( T ),
    Cf > T,
    !.

apresentar_default :-
    nl, write('------------------------------------------------------------'), nl,
    write('RESULTADO: Transferencia SNS24 - Triagem'), nl,
    write('(nenhuma disposicao acima do corte de confianca)'), nl.

apresentar( D, Cf ) :-
    disposicao( D, Txt ),
    regras_ativas_decisao( D, RegrasAtivas ),
    nl, write('------------------------------------------------------------'), nl,
    write('RESULTADO: '), write( Txt ), nl,
    write('Confianca (facto derivado): '), write( Cf ), nl,
    nl, write('Explicacao (regras ativas para a decisao):'), nl,
    mostrar_regras_ativas( RegrasAtivas ),
    nl, write('Respostas sim (perguntas com grau >= 0.5):'), nl,
    listar_respostas_positivas.

listar_respostas_positivas :-
    forall(
        ( fact( F, C ), C >= 0.5, pergunta( F, T ) ),
        ( write('  - '), write( T ), nl )
    ).

regras_ativas_decisao( D, Regras ) :-
    findall(
        (Cond, CfRegra, CfCond, CfFinal),
        (
            if Cond then D with CfRegra,
            composed_fact( Cond, CfCond ),
            CfFinal is CfCond * CfRegra,
            corte_certeza( T ),
            CfFinal > T
        ),
        Regras
    ).

mostrar_regras_ativas( [] ) :-
    write('  - (sem regras ativas acima do corte)'), nl.
mostrar_regras_ativas( Regras ) :-
    forall(
        member( (Cond, CfRegra, CfCond, CfFinal), Regras ),
        (
            write('  - if '), write( Cond ),
            write(' then ... with '), write( CfRegra ),
            write(' | cond='), write( CfCond ),
            write(' | final='), write( CfFinal ), nl
        )
    ).
