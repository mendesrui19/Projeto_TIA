% ============================================================
% INTERFACE — Triagem SNS24
% Interacao com o utilizador: perguntas com ramificacao inteligente.
%
% Fluxo: perguntas agrupadas por area clinica.
%   - Se a pergunta-pai e "nao", salta os detalhes desse grupo.
%   - Se detectar emergencia, conclui imediatamente (INEM/112).
% ============================================================

:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).

ja_sabe( F ) :-
    fact( F, _ ), !.

perguntar( F ) :-
    ja_sabe( F ), !.
perguntar( F ) :-
    pergunta( F, Texto ),
    nl, write('[  '), write( Texto ), write('? '),
    read( X ),
    ( (X == s ; X == sim) ->
        assert( fact( F, 1.0 ) )
    ;
        assert( fact( F, 0.0 ) )
    ).

% perguntar_se( +Pai, +Filho )
% So pergunta Filho se Pai foi respondido com "sim" (grau >= 0.5).
perguntar_se( Pai, Filho ) :-
    ( fact( Pai, Cf ), Cf >= 0.5 ->
        perguntar( Filho )
    ;
        true
    ).

% respondeu_sim( +F ) — verdadeiro se o utilizador disse sim.
respondeu_sim( F ) :-
    fact( F, Cf ), Cf >= 0.5.

% ============================================================
% FLUXO PRINCIPAL — iniciar
% ============================================================

iniciar :-
    retractall( fact( _, _ ) ),
    banner,
    % --- 1. Sinais de emergencia imediata ---
    fase_emergencia,
    ( tentar_concluir_emergencia -> true
    ;
    % --- 2. Febre ---
    fase_febre,
    % --- 3. Neurologico ---
    fase_neurologico,
    % --- 4. Respiratorio ---
    fase_respiratorio,
    % --- 5. Garganta / nariz / olfato / paladar ---
    fase_orl,
    % --- 6. Digestivo ---
    fase_digestivo,
    % --- 7. Estado geral ---
    fase_estado_geral,
    % --- 8. Perfil de risco ---
    fase_risco,
    % --- 9. Contexto ---
    fase_contexto,
    % --- 10. Conclusao final ---
    concluir
    ).

% ============================================================
% FASE 1: Emergencia
% ============================================================

fase_emergencia :-
    nl, write('--- Sinais de alarme ---'), nl,
    perguntar( compromisso_via_aerea ),
    perguntar( dor_toracica ),
    perguntar( alteracao_consciencia ),
    perguntar( convulsoes ),
    perguntar( fraqueza_lado_corpo ),
    perguntar( sangramento_abundante ),
    perguntar( tosse_com_sangue ).

% Corre o motor; se ja ha INEM -> apresenta e para (true no iniciar).
tentar_concluir_emergencia :-
    inferir_para_frente,
    fact( inem, Cf ),
    corte_certeza( T ),
    Cf > T,
    apresentar( inem, Cf ).

% ============================================================
% FASE 2: Febre
% ============================================================

fase_febre :-
    nl, write('--- Febre ---'), nl,
    perguntar( febre ),
    ( respondeu_sim( febre ) ->
        perguntar( febre_alta_40 ),
        perguntar( febre_persistente ),
        perguntar( nao_melhora_antipiretico ),
        perguntar( convulsao_febril ),
        perguntar( manchas_pele )
    ;
        true
    ).

% ============================================================
% FASE 3: Neurologico
% ============================================================

fase_neurologico :-
    nl, write('--- Sintomas neurologicos ---'), nl,
    perguntar( dor_cabeca ),
    perguntar( confusao ),
    perguntar( sonolencia_anormal ),
    ( (respondeu_sim(dor_cabeca) ; respondeu_sim(confusao) ; respondeu_sim(sonolencia_anormal)) ->
        perguntar_se( dor_cabeca, dor_cabeca_forte ),
        perguntar_se( dor_cabeca, rigidez_pescoco ),
        perguntar_se( dor_cabeca, sensibilidade_luz ),
        perguntar( manchas_pele ),
        perguntar( pieira_ou_tiragem )
    ;
        true
    ).

% ============================================================
% FASE 4: Respiratorio
% ============================================================

fase_respiratorio :-
    nl, write('--- Sintomas respiratorios ---'), nl,
    perguntar( tosse ),
    perguntar( falta_ar ),
    ( respondeu_sim( tosse ) ->
        perguntar( tosse_agravada ),
        perguntar( tosse_persistente ),
        perguntar( tosse_produtiva )
    ;
        true
    ),
    ( respondeu_sim( falta_ar ) ->
        perguntar( falta_ar_repouso ),
        perguntar( falta_ar_leve ),
        perguntar( pieira_ou_tiragem )
    ;
        true
    ).

% ============================================================
% FASE 5: ORL (garganta, nariz, olfato, paladar)
% ============================================================

fase_orl :-
    nl, write('--- Garganta / nariz ---'), nl,
    perguntar( dor_garganta ),
    perguntar( congestao_nasal ),
    perguntar( espirros ),
    perguntar( alteracao_olfato ),
    perguntar( alteracao_paladar ).

% ============================================================
% FASE 6: Digestivo
% ============================================================

fase_digestivo :-
    nl, write('--- Sintomas digestivos ---'), nl,
    perguntar( nausea ),
    perguntar( vomitos ),
    perguntar( diarreia ),
    perguntar( dor_abdominal ),
    ( (respondeu_sim(vomitos) ; respondeu_sim(diarreia) ; respondeu_sim(dor_abdominal)) ->
        perguntar_se( vomitos, vomitos_intensos ),
        perguntar_se( diarreia, diarreia_grave ),
        perguntar_se( dor_abdominal, dor_abdominal_forte ),
        perguntar( disuria ),
        perguntar( desidratacao )
    ;
        true
    ).

% ============================================================
% FASE 7: Estado geral
% ============================================================

fase_estado_geral :-
    nl, write('--- Estado geral ---'), nl,
    perguntar( fadiga_mialgias ),
    perguntar( agravamento ),
    perguntar_se( agravamento, agravamento_48h ).

% ============================================================
% FASE 8: Perfil de risco
% ============================================================

fase_risco :-
    nl, write('--- Perfil de risco ---'), nl,
    perguntar( imunodeprimido ),
    perguntar_se( imunodeprimido, tratamento_oncologico ),
    perguntar( gravidez ),
    perguntar( doenca_cronica ),
    perguntar( idade_risco ).

% ============================================================
% FASE 9: Contexto
% ============================================================

fase_contexto :-
    nl, write('--- Contexto ---'), nl,
    perguntar( apoio_domicilio ),
    perguntar( contacto_recente ),
    perguntar( trauma_recente ),
    perguntar_se( trauma_recente, sintomas_pos_trauma ).

% ============================================================
% BANNER, CONCLUSAO, APRESENTACAO
% ============================================================

banner :-
    nl,
    write('   TRIAGEM SNS24  -  808 24 24 24   |   Emergencia: 112'), nl,
    write('   Responda a cada pergunta com:  s.   (sim)    ou   n.   (nao)'), nl,
    write('   (nao esquecer o ponto final depois da letra!)'), nl.

concluir :-
    inferir_para_frente,
    ( decisao_encaminhamento( Melhor, Cf ) ->
        apresentar( Melhor, Cf )
    ;
        apresentar_default
    ).

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
    % --- Explicacao P1MAX: arvore de prova ---
    nl, write('--- Arvore de Prova (P1MAX) ---'), nl,
    ( demo( D, Prova ) ->
        mostrar_prova( Prova, 0 )
    ;
        write('  (sem arvore de prova disponivel para esta disposicao)'), nl
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
