% Base de conhecimento (P1B): candidato_aprendido/6 gerado por mine_rules.py; integrado em todas_regras/6.

candidato_aprendido(9, linha_sns24_orientacao, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    \+ membro(febre_alta, S),
    \+ membro(cefaleia, S),
    \+ membro(vomitos_persistentes, S),
    \+ membro(assintomatico, S),
    \+ membro(alteracao_olfato, S).
candidato_aprendido(10, autocuidado_e_observacao, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    \+ membro(febre_alta, S),
    \+ membro(cefaleia, S),
    \+ membro(vomitos_persistentes, S),
    \+ membro(assintomatico, S),
    membro(alteracao_olfato, S).
candidato_aprendido(11, informacao_geral_prevencao, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    \+ membro(febre_alta, S),
    \+ membro(cefaleia, S),
    \+ membro(vomitos_persistentes, S),
    membro(assintomatico, S).
candidato_aprendido(12, contactar_sns24_urgente, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    \+ membro(febre_alta, S),
    \+ membro(cefaleia, S),
    membro(vomitos_persistentes, S).
candidato_aprendido(13, autocuidado_e_observacao, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    \+ membro(febre_alta, S),
    membro(cefaleia, S).
candidato_aprendido(14, contactar_sns24_urgente, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    membro(febre_alta, S),
    \+ membro(alteracao_olfato, S).
candidato_aprendido(15, autocuidado_e_observacao, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    \+ membro(confusao, S),
    membro(febre_alta, S),
    membro(alteracao_olfato, S).
candidato_aprendido(16, encaminhar_112_imediato, S, _Idade, _Imuno, 0.65) :-
    \+ membro(falta_ar, S),
    membro(confusao, S).
candidato_aprendido(17, encaminhar_112_imediato, S, _Idade, _Imuno, 0.65) :-
    membro(falta_ar, S).
