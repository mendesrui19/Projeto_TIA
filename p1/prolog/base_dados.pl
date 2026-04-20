% ============================================================
% BASE DE DADOS — Triagem SNS24
% Contem: perguntas (sintomas observaveis) e disposicoes possiveis.
% ============================================================

:- dynamic(fact/2).

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
