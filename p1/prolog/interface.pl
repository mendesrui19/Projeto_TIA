% ============================================================
% INTERFACE — Triagem SNS24
% Interacao com o utilizador: perguntas, apresentacao de resultados.
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
    nl, write('  '), write( Texto ), write('? ' ),
    read( X ),
    ( (X == s ; X == sim) ->
        assert( fact( F, 1.0 ) )
    ;
        assert( fact( F, 0.0 ) )
    ).

iniciar :-
    retractall( fact( _, _ ) ),
    banner,
    % --- Sinais de emergencia ---
    perguntar( compromisso_via_aerea ),
    perguntar( dor_toracica ),
    perguntar( pieira_ou_tiragem ),
    perguntar( alteracao_consciencia ),
    perguntar( convulsoes ),
    perguntar( fraqueza_lado_corpo ),
    perguntar( sangramento_abundante ),
    perguntar( tosse_com_sangue ),
    perguntar( confusao ),
    perguntar( sonolencia_anormal ),
    % --- Febre e sinais neurologicos ---
    perguntar( febre ),
    perguntar( febre_alta_40 ),
    perguntar( febre_persistente ),
    perguntar( nao_melhora_antipiretico ),
    perguntar( convulsao_febril ),
    perguntar( manchas_pele ),
    perguntar( dor_cabeca ),
    perguntar( dor_cabeca_forte ),
    perguntar( rigidez_pescoco ),
    perguntar( sensibilidade_luz ),
    % --- Via aerea e tosse ---
    perguntar( falta_ar ),
    perguntar( falta_ar_repouso ),
    perguntar( falta_ar_leve ),
    perguntar( tosse ),
    perguntar( tosse_agravada ),
    perguntar( tosse_persistente ),
    perguntar( tosse_produtiva ),
    perguntar( dor_garganta ),
    perguntar( congestao_nasal ),
    perguntar( espirros ),
    perguntar( alteracao_olfato ),
    perguntar( alteracao_paladar ),
    % --- Abdomen e hidratacao ---
    perguntar( nausea ),
    perguntar( vomitos ),
    perguntar( vomitos_intensos ),
    perguntar( diarreia ),
    perguntar( diarreia_grave ),
    perguntar( dor_abdominal ),
    perguntar( dor_abdominal_forte ),
    perguntar( disuria ),
    perguntar( desidratacao ),
    % --- Estado geral ---
    perguntar( fadiga_mialgias ),
    perguntar( agravamento ),
    perguntar( agravamento_48h ),
    % --- Perfil e contexto ---
    perguntar( imunodeprimido ),
    perguntar( tratamento_oncologico ),
    perguntar( gravidez ),
    perguntar( doenca_cronica ),
    perguntar( idade_risco ),
    perguntar( apoio_domicilio ),
    perguntar( contacto_recente ),
    perguntar( trauma_recente ),
    perguntar( sintomas_pos_trauma ),
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
    listar_respostas_positivas,
    % --- Explicacao P1MAX: arvore de prova ---
    nl, write('--- Arvore de Prova (P1MAX) ---'), nl,
    ( demo( D, Prova ) ->
        mostrar_prova( Prova, 0 )
    ;
        write('  (sem arvore de prova disponivel para esta disposicao)'), nl
    ).

listar_respostas_positivas :-
    forall(
        ( fact( F, C ), C >= 0.5, pergunta( F, T ) ),
        ( write('  - '), write( T ), nl )
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
