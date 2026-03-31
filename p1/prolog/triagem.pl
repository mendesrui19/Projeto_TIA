% P1 — Triagem sintomática SNS24 (SWI-Prolog).
:- use_module(library(lists)).

% --- Base de dados (enunciado: factos / dados que o sistema usa) ---
% Listas de sintomas recolhidos; operações usadas em todo o programa.
membro( X, [X|_] ).
membro( X, [_|R] ) :- membro( X, R ).

concatena([], L, L).
concatena([X|L1], L2, [X|L3]) :- concatena(L1, L2, L3).

% Faixa etária derivada da idade em anos.
texto_idade(crianca, 'Criança').
texto_idade(adulto, 'Adulto').
texto_idade(idoso, 'Idoso').

idade_categoria(Anos, crianca) :- Anos < 18, !.
idade_categoria(Anos, idoso) :- Anos >= 65, !.
idade_categoria(_, adulto).

% Ordem das perguntas (entrada fixa e complemento).
entrada_algoritmo_ordem([tosse, febre, falta_ar, alteracao_olfato, alteracao_paladar]).

ordem_apos_entrada([
    contacto_infeccao_recente,
    febre_alta,
    congestao_nasal,
    fadiga_mialgias,
    sinais_graves_resp,
    compromisso_via_aerea,
    dor_toracica,
    cefaleia,
    confusao,
    dor_abdominal,
    disuria,
    vomitos_persistentes,
    desidratacao,
    lipotimia
]).

% Condições para mostrar cada pergunta do complemento (ramificação).
tem_febre_confirmada(Sintomas_confirmados) :-
    membro(febre, Sintomas_confirmados).

tem_nucleo_respiratorio(Sintomas_confirmados) :-
    ( membro(febre, Sintomas_confirmados)
    ; membro(tosse, Sintomas_confirmados)
    ; membro(falta_ar, Sintomas_confirmados)
    ).

tem_algum_sintoma_entrada(Sintomas_confirmados) :-
    ( tem_nucleo_respiratorio(Sintomas_confirmados)
    ; membro(alteracao_olfato, Sintomas_confirmados)
    ; membro(alteracao_paladar, Sintomas_confirmados)
    ).

prereq_resto(contacto_infeccao_recente, Sintomas_confirmados) :-
    tem_algum_sintoma_entrada(Sintomas_confirmados).
prereq_resto(febre_alta, Sintomas_confirmados) :-
    tem_febre_confirmada(Sintomas_confirmados).
prereq_resto(congestao_nasal, Sintomas_confirmados) :-
    membro(tosse, Sintomas_confirmados).
prereq_resto(fadiga_mialgias, Sintomas_confirmados) :-
    tem_nucleo_respiratorio(Sintomas_confirmados).
prereq_resto(sinais_graves_resp, Sintomas_confirmados) :-
    tem_nucleo_respiratorio(Sintomas_confirmados).
prereq_resto(compromisso_via_aerea, Sintomas_confirmados) :-
    ( membro(falta_ar, Sintomas_confirmados)
    ; membro(sinais_graves_resp, Sintomas_confirmados)
    ).
prereq_resto(dor_toracica, Sintomas_confirmados) :-
    tem_nucleo_respiratorio(Sintomas_confirmados).
prereq_resto(cefaleia, Sintomas_confirmados) :-
    tem_algum_sintoma_entrada(Sintomas_confirmados).
prereq_resto(confusao, Sintomas_confirmados) :-
    ( membro(cefaleia, Sintomas_confirmados)
    ; tem_febre_confirmada(Sintomas_confirmados)
    ).
prereq_resto(dor_abdominal, Sintomas_confirmados) :-
    tem_algum_sintoma_entrada(Sintomas_confirmados).
prereq_resto(disuria, Sintomas_confirmados) :-
    ( membro(dor_abdominal, Sintomas_confirmados)
    ; tem_nucleo_respiratorio(Sintomas_confirmados)
    ).
prereq_resto(vomitos_persistentes, Sintomas_confirmados) :-
    ( membro(dor_abdominal, Sintomas_confirmados)
    ; tem_nucleo_respiratorio(Sintomas_confirmados)
    ).
prereq_resto(desidratacao, Sintomas_confirmados) :-
    ( membro(vomitos_persistentes, Sintomas_confirmados)
    ; tem_febre_confirmada(Sintomas_confirmados)
    ; membro(dor_abdominal, Sintomas_confirmados)
    ).
prereq_resto(lipotimia, Sintomas_confirmados) :-
    ( membro(confusao, Sintomas_confirmados)
    ; membro(falta_ar, Sintomas_confirmados)
    ; membro(desidratacao, Sintomas_confirmados)
    ; membro(cefaleia, Sintomas_confirmados)
    ; membro(vomitos_persistentes, Sintomas_confirmados)
    ).

% Texto de cada pergunta ao utilizador (átomo de sintoma → enunciado).
texto_sintoma(tosse,
    'Tosse nova ou claramente pior que o habitual').
texto_sintoma(febre,
    'Febre ou sensação febril').
texto_sintoma(falta_ar,
    'Dispneia — falta de ar, ofegação ou não completa uma frase ao falar').
texto_sintoma(alteracao_olfato,
    'Perda ou alteração súbita do olfato (cheiro)').
texto_sintoma(alteracao_paladar,
    'Perda ou alteração súbita do paladar (sabor)').
texto_sintoma(contacto_infeccao_recente,
    'Contacto próximo com infeção respiratória nos últimos 14 dias (ex. gripe/COVID no mesmo agregado)').
texto_sintoma(febre_alta,
    'Febre muito alta — ≥40 °C axilar ou ≥41 °C retal').
texto_sintoma(congestao_nasal,
    'Nariz entupido ou corrimento nasal').
texto_sintoma(fadiga_mialgias,
    'Fadiga ou dores musculares').
texto_sintoma(sinais_graves_resp,
    'Pieira, tiragens no peito/barriga, lábios ou unhas azulados ou arroxeados').
texto_sintoma(compromisso_via_aerea,
    'Sensação de garganta a fechar ou língua/lábios muito inchados (via aérea)').
texto_sintoma(dor_toracica,
    'Dor no peito').
texto_sintoma(cefaleia,
    'Cefaleia — dor de cabeça forte ou a piorar').
texto_sintoma(confusao,
    'Alteração de consciência — confusão, sonolência anormal ou desorientação').
texto_sintoma(dor_abdominal,
    'Dor ou desconforto forte no abdómen').
texto_sintoma(disuria,
    'Dor ou ardor ao urinar').
texto_sintoma(vomitos_persistentes,
    'Vómitos repetidos ou contínuos').
texto_sintoma(desidratacao,
    'Desidratação — pouca urina escura, sede forte, boca seca ou olhos fundos').
texto_sintoma(lipotimia,
    'Lipotimia — fraqueza súbita ou sensação de ir desmaiar').

% --- Base de conhecimento (regras; prioridade menor = mais urgente) ---
% Regras aprendidas (P1B): ficheiro regras_auto.pl (carregado abaixo).
:- consult(regras_auto).

regra_encaminhamento(1, encaminhar_112_imediato, Sintomas, _, _, Certeza) :-
    membro(compromisso_via_aerea, Sintomas),
    Certeza = 0.99.

regra_encaminhamento(1, encaminhar_112_imediato, Sintomas, _, _, Certeza) :-
    membro(sinais_graves_resp, Sintomas),
    Certeza = 0.98.

regra_encaminhamento(1, encaminhar_112_imediato, Sintomas, _, _, Certeza) :-
    membro(dor_toracica, Sintomas),
    membro(falta_ar, Sintomas),
    Certeza = 0.95.

regra_encaminhamento(1, encaminhar_112_imediato, Sintomas, _, _, Certeza) :-
    membro(confusao, Sintomas),
    Certeza = 0.92.

regra_encaminhamento(1, encaminhar_112_imediato, Sintomas, _, _, Certeza) :-
    membro(lipotimia, Sintomas),
    Certeza = 0.9.

regra_encaminhamento(2, contactar_sns24_urgente, Sintomas, idoso, _, Certeza) :-
    membro(febre_alta, Sintomas),
    Certeza = 0.88.

regra_encaminhamento(2, contactar_sns24_urgente, Sintomas, _, sim, Certeza) :-
    membro(febre_alta, Sintomas),
    Certeza = 0.88.

regra_encaminhamento(2, contactar_sns24_urgente, Sintomas, _, _, Certeza) :-
    membro(febre_alta, Sintomas),
    Certeza = 0.85.

regra_encaminhamento(2, contactar_sns24_urgente, Sintomas, crianca, _, Certeza) :-
    membro(vomitos_persistentes, Sintomas),
    membro(desidratacao, Sintomas),
    Certeza = 0.85.

regra_encaminhamento(3, linha_sns24_orientacao, Sintomas, adulto, _, Certeza) :-
    membro(contacto_infeccao_recente, Sintomas),
    ( membro(febre, Sintomas) ; membro(tosse, Sintomas) ),
    \+ membro(sinais_graves_resp, Sintomas),
    \+ membro(falta_ar, Sintomas),
    Certeza = 0.76.

regra_encaminhamento(3, linha_sns24_orientacao, Sintomas, adulto, _, Certeza) :-
    membro(febre, Sintomas),
    \+ membro(febre_alta, Sintomas),
    \+ membro(dor_toracica, Sintomas),
    \+ membro(falta_ar, Sintomas),
    Certeza = 0.75.

regra_encaminhamento(3, linha_sns24_orientacao, Sintomas, _, _, Certeza) :-
    membro(tosse, Sintomas),
    membro(congestao_nasal, Sintomas),
    \+ membro(falta_ar, Sintomas),
    \+ membro(dor_toracica, Sintomas),
    Certeza = 0.7.

regra_encaminhamento(3, linha_sns24_orientacao, Sintomas, _, _, Certeza) :-
    membro(fadiga_mialgias, Sintomas),
    ( membro(febre, Sintomas) ; membro(tosse, Sintomas) ),
    \+ membro(falta_ar, Sintomas),
    Certeza = 0.68.

regra_encaminhamento(3, linha_sns24_orientacao, Sintomas, _, _, Certeza) :-
    ( membro(dor_abdominal, Sintomas) ; membro(disuria, Sintomas) ),
    \+ membro(confusao, Sintomas),
    \+ membro(falta_ar, Sintomas),
    Certeza = 0.66.

regra_encaminhamento(4, autocuidado_e_observacao, Sintomas, _, _, Certeza) :-
    ( membro(alteracao_olfato, Sintomas)
    ; membro(alteracao_paladar, Sintomas)
    ),
    \+ membro(falta_ar, Sintomas),
    \+ membro(febre_alta, Sintomas),
    \+ membro(sinais_graves_resp, Sintomas),
    Certeza = 0.6.

regra_encaminhamento(4, autocuidado_e_observacao, Sintomas, _, _, Certeza) :-
    membro(cefaleia, Sintomas),
    \+ membro(confusao, Sintomas),
    \+ membro(dor_toracica, Sintomas),
    Certeza = 0.65.

regra_encaminhamento(5, informacao_geral_prevencao, Sintomas, _, _, Certeza) :-
    membro(assintomatico, Sintomas),
    Certeza = 0.5.

regra_encaminhamento(6, linha_sns24_orientacao, Sintomas, _, _, Certeza) :-
    Sintomas \= [],
    Certeza = 0.55.

regra_encaminhamento(7, informacao_geral_prevencao, [], _, _, Certeza) :-
    Certeza = 0.4.

% Conclusão → mensagem curta para o utilizador.
texto_recomendacao(encaminhar_112_imediato,
    '112 — emergência imediata.').

texto_recomendacao(contactar_sns24_urgente,
    'SNS24 808 24 24 24 — com urgência.').

texto_recomendacao(linha_sns24_orientacao,
    'SNS24 808 24 24 24 — orientação / triagem.').

texto_recomendacao(autocuidado_e_observacao,
    'Autocuidado; se piorar, SNS24.').

texto_recomendacao(informacao_geral_prevencao,
    'Sem sintomas indicados; dúvidas: SNS24.').

% Conclusão → justificação (usada na inferência e no P1MAX · explicação).
explicacao_regra(encaminhar_112_imediato,
    'Alarme: via aérea, respiração grave, tórax + dispneia, ou neurológico.').

explicacao_regra(contactar_sns24_urgente,
    'Febre muito alta ou desidratação relevante em criança.').

explicacao_regra(linha_sns24_orientacao,
    'Triagem telefónica / exposição / sintomas sem emergência imediata.').

explicacao_regra(autocuidado_e_observacao,
    'Quadro ligeiro sem critérios de alarme imediato.').

explicacao_regra(informacao_geral_prevencao,
    'Nenhum sintoma assinalado.').

% --- Sistema de inferência ---
% Agrega regras manuais e aprendidas; ordena por prioridade (keysort); aplica conclusão e textos.
todas_regras(Prioridade, Acao, Sintomas, Faixa_etaria, Imunodeprimido, Certeza) :-
    regra_encaminhamento(Prioridade, Acao, Sintomas, Faixa_etaria, Imunodeprimido, Certeza).
todas_regras(Prioridade, Acao, Sintomas, Faixa_etaria, Imunodeprimido, Certeza) :-
    candidato_aprendido(Prioridade, Acao, Sintomas, Faixa_etaria, Imunodeprimido, Certeza).

avaliar(Sintomas, Faixa_etaria, Imunodeprimido, resultado(Acao, Texto, Explicacao)) :-
    findall(
        Prioridade-(Acao_cand, Certeza),
        todas_regras(Prioridade, Acao_cand, Sintomas, Faixa_etaria, Imunodeprimido, Certeza),
        Candidatos
    ),
    Candidatos \= [],
    keysort(Candidatos, [_-(Acao, _Certeza_escolhida)|_]),
    texto_recomendacao(Acao, Texto),
    explicacao_regra(Acao, Explicacao),
    !.

avaliar(Sintomas, _, _, resultado(linha_sns24_orientacao, Texto, Explicacao)) :-
    Sintomas \= [],
    texto_recomendacao(linha_sns24_orientacao, Texto),
    explicacao_regra(linha_sns24_orientacao, Explicacao).

avaliar([], _, _, resultado(informacao_geral_prevencao, Texto, Explicacao)) :-
    texto_recomendacao(informacao_geral_prevencao, Texto),
    explicacao_regra(informacao_geral_prevencao, Explicacao).

% --- P1MAX (opcional na avaliação do P1; até 20% da nota de P1) ---
% · Incerteza (~50% do bónus): factor de certeza (CF) nas regras; avaliar_com_certeza/5 devolve o CF da regra escolhida.
% · Explicação (~50% do bónus): explicacao_regra/2 no resultado/3 e no rever pelo menu.
avaliar_com_certeza(Sintomas, Faixa_etaria, Imunodeprimido, resultado(Acao, Texto, Explicacao), Certeza) :-
    findall(
        Prioridade-(Acao_cand, Certeza0),
        todas_regras(Prioridade, Acao_cand, Sintomas, Faixa_etaria, Imunodeprimido, Certeza0),
        Candidatos
    ),
    Candidatos \= [],
    keysort(Candidatos, [_-(Acao, Certeza)|_]),
    texto_recomendacao(Acao, Texto),
    explicacao_regra(Acao, Explicacao),
    !.

avaliar_com_certeza(Sintomas, Faixa_etaria, Imunodeprimido, Resultado, Certeza) :-
    avaliar(Sintomas, Faixa_etaria, Imunodeprimido, Resultado),
    Certeza = 0.5.

% --- Interface (interação com o utilizador) ---
executar :-
    format('~nTriagem sintomática — SNS24~n808 24 24 24 | 112~n', []),
    perguntar_idade_anos(Anos),
    idade_categoria(Anos, Faixa_etaria),
    perguntar_imuno(Imunodeprimido),
    perguntar_fluxo_completo(Sintomas),
    avaliar_com_certeza(Sintomas, Faixa_etaria, Imunodeprimido, resultado(Acao, Texto, Explicacao), Certeza),
    texto_idade(Faixa_etaria, Grupo_txt),
    Percentagem is Certeza * 100,
    format(
        '~n--- ~d anos (~w) ---~n~w~n~w~n~w~n~n[P1MAX] Factor de certeza da regra escolhida: ~1f %~n',
        [Anos, Grupo_txt, Acao, Texto, Explicacao, Percentagem]
    ),
    menu_extra(Sintomas, Faixa_etaria, Imunodeprimido).

perguntar_idade_anos(Anos) :-
    format('~nIdade (anos): ', []),
    read_line_to_string(user_input, Linha_bruta),
    normalize_space(string(Linha), Linha_bruta),
    ( Linha = "" ->
        perguntar_idade_anos(Anos)
    ; number_string(N, Linha),
      integer(N),
      between(0, 120, N) ->
        Anos = N
    ;
        perguntar_idade_anos(Anos)
    ).

perguntar_so_sn(Rotulo, Resposta) :-
    format('~n~w s/n: ', [Rotulo]),
    read_line_to_string(user_input, Linha_bruta),
    normalize_space(string(Linha), Linha_bruta),
    ( Linha = "" ->
        perguntar_so_sn(Rotulo, Resposta)
    ; string_lower(Linha, Linha_minusculas),
      ( sub_string(Linha_minusculas, 0, 1, _, "s") ->
          Resposta = sim
      ; sub_string(Linha_minusculas, 0, 1, _, "n") ->
          Resposta = nao
      ; perguntar_so_sn(Rotulo, Resposta)
      )
    ).

perguntar_imuno(Imunodeprimido) :-
    perguntar_so_sn('Imunodeprimido (ex. defesas fracas por doença ou tratamento)?', R),
    ( R = sim -> Imunodeprimido = sim ; Imunodeprimido = nao ).

menu_extra(Sintomas, Faixa_etaria, Imunodeprimido) :-
    format('~n1=rever P1MAX (certeza e explicação)  0=terminar~n', []),
    read_line_to_string(user_input, Linha_bruta),
    normalize_space(string(Linha), Linha_bruta),
    string_lower(Linha, Linha_minusculas),
    ( Linha_minusculas = "" ->
        menu_extra(Sintomas, Faixa_etaria, Imunodeprimido)
    ; sub_string(Linha_minusculas, 0, 1, _, Caracter),
      ( ( Caracter = "1" ; Caracter = "s" ) ->
        avaliar_com_certeza(Sintomas, Faixa_etaria, Imunodeprimido, resultado(_, Texto2, Explicacao2), Certeza),
        Percentagem is Certeza * 100,
        format('~n~0f%% — ~w~n~w~n', [Percentagem, Texto2, Explicacao2])
      ; ( Caracter = "0" ; Caracter = "n" ) ->
        true
      ; menu_extra(Sintomas, Faixa_etaria, Imunodeprimido)
      )
    ).

perguntar_fluxo_completo(Sintomas_finais) :-
    format('~n[Entrada — vias respiratórias / COVID]~n', []),
    entrada_algoritmo_ordem(Ordem_entrada),
    perguntar_lista_sintomas(Ordem_entrada, [], Sintomas_apos_entrada),
    ( entrada_sem_sintomas(Sintomas_apos_entrada) ->
        format('~n(Nenhum dos cinco critérios de entrada.)~n', []),
        perguntar_so_sn('Confirma assintomático para este ramo (não tem estes sintomas de entrada)', Resposta),
        ( Resposta = sim -> Sintomas_finais = [assintomatico] ; Sintomas_finais = [] )
    ; format('~n[Questionário complementar]~n', []),
      ordem_apos_entrada(Ordem_complemento),
      perguntar_lista_condicional(Ordem_complemento, Sintomas_apos_entrada, Sintomas_finais)
    ).

entrada_sem_sintomas([]).

perguntar_lista_sintomas([], Sintomas_acumulados, Sintomas_acumulados).
perguntar_lista_sintomas([Sintoma_cand|Resto], Antes, Final) :-
    texto_sintoma(Sintoma_cand, Texto),
    atom_concat(Texto, '?', Pergunta),
    perguntar_so_sn(Pergunta, Resposta),
    ( Resposta = sim ->
        concatena(Antes, [Sintoma_cand], Proximo)
    ; Proximo = Antes
    ),
    perguntar_lista_sintomas(Resto, Proximo, Final).

perguntar_lista_condicional([], Sintomas_acumulados, Sintomas_acumulados).
perguntar_lista_condicional([Sintoma_cand|Resto], Antes, Final) :-
    ( prereq_resto(Sintoma_cand, Antes) ->
        texto_sintoma(Sintoma_cand, Texto),
        atom_concat(Texto, '?', Pergunta),
        perguntar_so_sn(Pergunta, Resposta),
        ( Resposta = sim ->
            concatena(Antes, [Sintoma_cand], Proximo)
        ; Proximo = Antes
        )
    ; Proximo = Antes
    ),
    perguntar_lista_condicional(Resto, Proximo, Final).
