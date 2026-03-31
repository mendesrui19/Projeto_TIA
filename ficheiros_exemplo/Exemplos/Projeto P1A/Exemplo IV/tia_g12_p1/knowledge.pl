:- module(knowledge, [
    triage_rule/4, 
    rule_explanation/3,
    symptom_question/2, 
    all_symptoms/2, 
    case_types/1, 
    case_type_question/2,
    inductive_symptom_question/2
]).

% Replace case_types/1 with case_type_question/2
case_type_question('Agressão', 'Existem sinais de violência física ou verbal na vítima?').
case_type_question('Doença Mental', 'A vítima apresenta alterações graves de comportamento ou pensamento?').
case_type_question('Embriaguez Aparente', 'A vítima apresenta sinais de intoxicação por álcool?').
case_type_question('Overdose e envenenamento', 'Houve ingestão de substâncias potencialmente tóxicas?').
case_type_question('Queimaduras', 'A vítima sofreu queimaduras ou lesões por calor?').
case_type_question('Nenhuma das anteriores', 'O caso não se enquadra em nenhuma das situações anteriores?').

% Helper predicate to get all case types
case_types(Types) :-
    findall(Type, case_type_question(Type, _), Types).

% Symptoms for each case type
all_symptoms('Agressão', [
    obstrucao_vias_aereas,          % red
    hemorragia_exanguinante,        % red
    dispneia_aguda,                 % orange
    dor_intensa,                    % orange
    hemorragia_menor_incontrolavel, % yellow
    dor_moderada,                   % yellow
    dor_leve_recente,               % greenn
    evento_recente                  % blue
]).

all_symptoms('Doença Mental', [
    obstrucao_vias_aereas,                 % red
    hipoglicemia,                          % red
    alto_risco_agredir_outros,             % orange
    alto_risco_autoagressao,               % orange
    risco_moderado_agredir_outros,         % yellow
    historia_psiquiatrica,                 % yellow
    agitacao_psicomotora,                  % green
    comportamento_conturbador              % blue
]).

all_symptoms('Embriaguez Aparente', [
    obstrucao_vias_aereas,              % red
    convulsoes,                         % red
    alteracao_consciencia_nao_alcool,   % orange
    hipotermia,                         % orange
    alteracao_consciencia_alcool,       % yellow
    traumatismo_craniano,               % yellow
    dor_leve_recente,                   % green
    trauma_recente                      % blue
]).

all_symptoms('Overdose e envenenamento', [
    obstrucao_vias_aereas,          % red
    convulsoes,                     % red
    mortalidade_alta,               % orange
    sat_o2_muito_baixa,             % orange
    mortalidade_moderada,           % yellow
    sat_o2_baixa,                   % yellow
    historia_psiquiatrica,          % green
    agitacao_psicomotora            % blue
]).

all_symptoms('Queimaduras', [
    obstrucao_vias_aereas,         % red
    estridor,                      % red
    lesao_inalacao,                % orange
    dor_intensa,                   % orange
    queimadura_eletrica,           % yellow
    dor_moderada,                  % yellow
    dor_leve_recente,              % green
    inflamacao_local               % blue
]).

% Questions for symptoms
symptom_question(obstrucao_vias_aereas, 'Existe dificuldade ou um bloqueio na passagem de ar pela garganta ou nariz? (y/n)').
symptom_question(respiracao_inadequada, 'A pessoa está com dificuldades em respirar ou respiração anormal? (y/n)').
symptom_question(hemorragia_exanguinante, 'Existe uma perda grave de sangue que coloca a vida em risco? (y/n)').
symptom_question(choque, 'A pessoa apresenta uma pele pálida, suor frio e alteração de consciência? (y/n)').
symptom_question(mecanismo_trauma_significativo, 'Houve um acidente ou impacto de alta intensidade? (y/n)').
symptom_question(dispneia_aguda, 'A pessoa está com falta de ar súbita ou dificuldade em respirar? (y/n)').
symptom_question(hemorragia_maior_incontrolavel, 'Existe um sangramento abundante que não para com pressão direta? (y/n)').
symptom_question(alteracao_subita_consciencia, 'Houve uma mudança repentina no nível de consciência ou confusão mental? (y/n)').
symptom_question(defice_neurologico_agudo, 'Apareceram subitamente sintomas como fraqueza, dificuldade na fala ou paralisia? (y/n)').
symptom_question(dor_intensa, 'A pessoa relata dor muito forte ou insuportável? (y/n)').
symptom_question(hemorragia_menor_incontrolavel, 'Existe um sangramento pequeno mas persistente que não para? (y/n)').
symptom_question(historia_inconsciencia, 'A pessoa desmaiou ou perdeu a consciência recentemente? (y/n)').
symptom_question(defice_neurologico_novo, 'Surgiram novos sintomas neurológicos como formigamento ou fraqueza? (y/n)').
symptom_question(disturbio_coagulacao, 'A pessoa tem problemas de coagulação ou toma anticoagulantes? (y/n)').
symptom_question(historia_discordante, 'As explicações sobre o que aconteceu são contraditórias ou pouco claras? (y/n)').
symptom_question(dor_moderada, 'A pessoa relata dor considerável mas suportável? (y/n)').
symptom_question(edema, 'Existe inchaço significativo em alguma parte do corpo? (y/n)').
symptom_question(deformidade, 'Existe alguma parte do corpo visivelmente deformada ou fora do normal? (y/n)').
symptom_question(dor_leve_recente, 'A pessoa tem uma dor leve que começou há pouco tempo? (y/n)').
symptom_question(evento_recente, 'O incidente ou problema aconteceu nas últimas horas? (y/n)').
symptom_question(hipoglicemia, 'O nível de açúcar no sangue está muito baixo (abaixo de 70mg/dL)? (y/n)').
symptom_question(alto_risco_agredir_outros, 'A pessoa demonstra sinais de que pode agredir alguém de forma grave? (y/n)').
symptom_question(alto_risco_autoagressao, 'Há sinais claros de que a pessoa pode se agredir a si mesma gravemente? (y/n)').
symptom_question(historia_psiquiatrica, 'Existe histórico de problemas psiquiátricos graves ou internamentos? (y/n)').
symptom_question(risco_moderado_agredir_outros, 'A pessoa está agressiva mas ainda controlável? (y/n)').
symptom_question(risco_moderado_autoagressao, 'A pessoa fala em se magoar mas sem planos concretos? (y/n)').
symptom_question(agitacao_psicomotora, 'A pessoa está muito agitada, inquieta ou não consegue ficar parada? (y/n)').
symptom_question(comportamento_conturbador, 'A pessoa está a causar confusão ou perturbação no ambiente? (y/n)').
symptom_question(crianca_nao_reativa, 'A criança está muito sonolenta ou não responde normalmente? (y/n)').
symptom_question(convulsoes, 'A pessoa está a ter convulsões ou tremores incontroláveis? (y/n)').
symptom_question(alteracao_consciencia_nao_alcool, 'A pessoa está confusa ou desorientada e não bebeu álcool? (y/n)').
symptom_question(historia_inadequada, 'As informações fornecidas sobre o caso parecem incompletas ou suspeitas? (y/n)').
symptom_question(hipotermia, 'A temperatura corporal está igual ou inferior a 35°C? (y/n)').
symptom_question(alteracao_consciencia_alcool, 'A pessoa está confusa ou desorientada devido ao consumo de álcool? (y/n)').
symptom_question(traumatismo_craniano, 'Houve alguma pancada ou impacto na cabeça recentemente? (y/n)').
symptom_question(pulso_anormal, 'O batimento cardíaco está muito rápido (>100) ou muito lento (<60)? (y/n)').
symptom_question(mortalidade_alta, 'A substância ingerida tem alto risco de morte (ex: pesticidas, ácidos)? (y/n)').
symptom_question(sat_o2_muito_baixa, 'A saturação de oxigênio está abaixo de 85%? (y/n)').
symptom_question(mortalidade_moderada, 'A substância ingerida tem risco moderado de morte? (y/n)').
symptom_question(sat_o2_baixa, 'A saturação de oxigênio está entre 85% e 92%? (y/n)').
symptom_question(estridor, 'A pessoa está a fazer um som agudo ao respirar? (y/n)').
symptom_question(edema_facial, 'Existe inchaço significativo no rosto? (y/n)').
symptom_question(lesao_inalacao, 'Há sinais de queimadura na boca ou vias respiratórias? (y/n)').
symptom_question(inalacao_fumaca, 'A pessoa inalou fumo ou gases tóxicos? (y/n)').
symptom_question(queimadura_eletrica, 'A queimadura foi causada por corrente elétrica? (y/n)').
symptom_question(queimadura_quimica, 'A queimadura foi causada por produto químico? (y/n)').
symptom_question(inflamacao_local, 'A área afetada está vermelha, quente ou inchada? (y/n)').
symptom_question(infecao_local, 'Há sinais de infecção como pus ou mau cheiro? (y/n)').
symptom_question(trauma_recente, 'Houve algum acidente ou ferimento nas últimas horas? (y/n)').

% Inductive symptom questions
inductive_symptom_question(laceration, 'Apresenta algum sinal de laceração ou corte? (y/n)').
inductive_symptom_question(pinpoint_pupils, 'As pupilas estão contraídas (pupilas puntiformes)? (y/n)').
inductive_symptom_question(confusion, 'O doente apresenta sinais de confusão mental? (y/n)').
inductive_symptom_question(agitation, 'O doente encontra-se agitado? (y/n)').
inductive_symptom_question(burn_odor, 'Sente-se cheiro a queimado? (y/n)').
inductive_symptom_question(dry_mouth, 'Apresenta a boca seca? (y/n)').
inductive_symptom_question(hoarseness, 'Apresenta rouquidão na voz? (y/n)').
inductive_symptom_question(dilated_pupils, 'As pupilas estão dilatadas? (y/n)').
inductive_symptom_question(vomiting, 'O doente apresenta vómitos? (y/n)').

% Triage rules considering case type
triage_rule('Agressão', red, Symptoms, CF) :-
    (member(obstrucao_vias_aereas, Symptoms) -> CF1 = 0.9 ; CF1 = 0),
    (member(respiracao_inadequada, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(hemorragia_exanguinante, Symptoms) -> CF3 = 1.0 ; CF3 = 0),
    (member(choque, Symptoms) -> CF4 = 0.95 ; CF4 = 0),
    combine_cf([CF1, CF2, CF3, CF4], CF).

triage_rule('Agressão', orange, Symptoms, CF) :-
    \+ triage_rule('Agressão', red, Symptoms, _),
    (member(mecanismo_trauma_significativo, Symptoms) -> CF1 = 0.8 ; CF1 = 0),
    (member(dispneia_aguda, Symptoms) -> CF2 = 0.85 ; CF2 = 0),
    (member(hemorragia_maior_incontrolavel, Symptoms) -> CF3 = 0.9 ; CF3 = 0),
    (member(alteracao_subita_consciencia, Symptoms) -> CF4 = 0.9 ; CF4 = 0),
    (member(defice_neurologico_agudo, Symptoms) -> CF5 = 0.85 ; CF5 = 0),
    (member(dor_intensa, Symptoms) -> CF6 = 0.8 ; CF6 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6], CF).

triage_rule('Agressão', yellow, Symptoms, CF) :-
    \+ triage_rule('Agressão', red, Symptoms, _),
    \+ triage_rule('Agressão', orange, Symptoms, _),
    (member(hemorragia_menor_incontrolavel, Symptoms) -> CF1 = 0.7 ; CF1 = 0),
    (member(historia_inconsciencia, Symptoms) -> CF2 = 0.75 ; CF2 = 0),
    (member(defice_neurologico_novo, Symptoms) -> CF3 = 0.7 ; CF3 = 0),
    (member(disturbio_coagulacao, Symptoms) -> CF4 = 0.7 ; CF4 = 0),
    (member(historia_discordante, Symptoms) -> CF5 = 0.65 ; CF5 = 0),
    (member(dor_moderada, Symptoms) -> CF6 = 0.7 ; CF6 = 0),
    (member(edema, Symptoms) -> CF7 = 0.65 ; CF7 = 0),
    (member(deformidade, Symptoms) -> CF8 = 0.65 ; CF8 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6, CF7, CF8], CF).

triage_rule('Agressão', green, Symptoms, CF) :-
    \+ triage_rule('Agressão', red, Symptoms, _),
    \+ triage_rule('Agressão', orange, Symptoms, _),
    \+ triage_rule('Agressão', yellow, Symptoms, _),
    (member(dor_leve_recente, Symptoms) -> CF1 = 0.5 ; CF1 = 0),
    (member(evento_recente, Symptoms) -> CF2 = 0.5 ; CF2 = 0),
    combine_cf([CF1, CF2], CF).

triage_rule('Agressão', blue, Symptoms, CF) :-
    \+ triage_rule('Agressão', red, Symptoms, _),
    \+ triage_rule('Agressão', orange, Symptoms, _),
    \+ triage_rule('Agressão', yellow, Symptoms, _),
    \+ triage_rule('Agressão', green, Symptoms, _),
    (member(evento_recente, Symptoms) -> CF = 0.3 ; CF = 0).

triage_rule('Doença Mental', red, Symptoms, CF) :-
    (member(obstrucao_vias_aereas, Symptoms) -> CF1 = 0.9 ; CF1 = 0),
    (member(respiracao_inadequada, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(choque, Symptoms) -> CF3 = 0.95 ; CF3 = 0),
    (member(hipoglicemia, Symptoms) -> CF4 = 0.9 ; CF4 = 0),
    combine_cf([CF1, CF2, CF3, CF4], CF).

triage_rule('Doença Mental', orange, Symptoms, CF) :-
    \+ triage_rule('Doença Mental', red, Symptoms, _),
    (member(alteracao_subita_consciencia, Symptoms) -> CF1 = 0.85 ; CF1 = 0),
    (member(alto_risco_agredir_outros, Symptoms) -> CF2 = 0.8 ; CF2 = 0),
    (member(alto_risco_autoagressao, Symptoms) -> CF3 = 0.8 ; CF3 = 0),
    combine_cf([CF1, CF2, CF3], CF).

triage_rule('Doença Mental', yellow, Symptoms, CF) :-
    \+ triage_rule('Doença Mental', red, Symptoms, _),
    \+ triage_rule('Doença Mental', orange, Symptoms, _),
    (member(historia_psiquiatrica, Symptoms) -> CF1 = 0.7 ; CF1 = 0),
    (member(risco_moderado_agredir_outros, Symptoms) -> CF2 = 0.7 ; CF2 = 0),
    (member(risco_moderado_autoagressao, Symptoms) -> CF3 = 0.7 ; CF3 = 0),
    combine_cf([CF1, CF2, CF3], CF).

triage_rule('Doença Mental', green, Symptoms, CF) :-
    \+ triage_rule('Doença Mental', red, Symptoms, _),
    \+ triage_rule('Doença Mental', orange, Symptoms, _),
    \+ triage_rule('Doença Mental', yellow, Symptoms, _),
    (member(agitacao_psicomotora, Symptoms) -> CF1 = 0.5 ; CF1 = 0),
    (member(comportamento_conturbador, Symptoms) -> CF2 = 0.5 ; CF2 = 0),
    combine_cf([CF1, CF2], CF).

triage_rule('Doença Mental', blue, Symptoms, CF) :-
    \+ triage_rule('Doença Mental', red, Symptoms, _),
    \+ triage_rule('Doença Mental', orange, Symptoms, _),
    \+ triage_rule('Doença Mental', yellow, Symptoms, _),
    \+ triage_rule('Doença Mental', green, Symptoms, _),
    (member(comportamento_conturbador, Symptoms) -> CF = 0.3 ; CF = 0).

triage_rule('Embriaguez Aparente', red, Symptoms, CF) :-
    (member(obstrucao_vias_aereas, Symptoms) -> CF1 = 0.9 ; CF1 = 0),
    (member(respiracao_inadequada, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(choque, Symptoms) -> CF3 = 0.95 ; CF3 = 0),
    (member(crianca_nao_reativa, Symptoms) -> CF4 = 0.9 ; CF4 = 0),
    (member(convulsoes, Symptoms) -> CF5 = 0.9 ; CF5 = 0),
    (member(hipoglicemia, Symptoms) -> CF6 = 0.9 ; CF6 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6], CF).

triage_rule('Embriaguez Aparente', orange, Symptoms, CF) :-
    \+ triage_rule('Embriaguez Aparente', red, Symptoms, _),
    (member(alteracao_consciencia_nao_alcool, Symptoms) -> CF1 = 0.85 ; CF1 = 0),
    (member(defice_neurologico_agudo, Symptoms) -> CF2 = 0.8 ; CF2 = 0),
    (member(historia_inadequada, Symptoms) -> CF3 = 0.75 ; CF3 = 0),
    (member(hipotermia, Symptoms) -> CF4 = 0.8 ; CF4 = 0),
    combine_cf([CF1, CF2, CF3, CF4], CF).

triage_rule('Embriaguez Aparente', yellow, Symptoms, CF) :-
    \+ triage_rule('Embriaguez Aparente', red, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', orange, Symptoms, _),
    (member(alteracao_consciencia_alcool, Symptoms) -> CF1 = 0.7 ; CF1 = 0),
    (member(defice_neurologico_novo, Symptoms) -> CF2 = 0.7 ; CF2 = 0),
    (member(historia_inconsciencia, Symptoms) -> CF3 = 0.75 ; CF3 = 0),
    (member(historia_discordante, Symptoms) -> CF4 = 0.65 ; CF4 = 0),
    (member(traumatismo_craniano, Symptoms) -> CF5 = 0.7 ; CF5 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5], CF).

triage_rule('Embriaguez Aparente', green, Symptoms, CF) :-
    \+ triage_rule('Embriaguez Aparente', red, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', orange, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', yellow, Symptoms, _),
    (member(trauma_recente, Symptoms) -> CF1 = 0.5 ; CF1 = 0),
    (member(dor_leve_recente, Symptoms) -> CF2 = 0.5 ; CF2 = 0),
    combine_cf([CF1, CF2], CF).

triage_rule('Embriaguez Aparente', blue, Symptoms, CF) :-
    \+ triage_rule('Embriaguez Aparente', red, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', orange, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', yellow, Symptoms, _),
    \+ triage_rule('Embriaguez Aparente', green, Symptoms, _),
    (member(trauma_recente, Symptoms) -> CF = 0.3 ; CF = 0).

triage_rule('Overdose e envenenamento', red, Symptoms, CF) :-
    (member(obstrucao_vias_aereas, Symptoms) -> CF1 = 0.9 ; CF1 = 0),
    (member(respiracao_inadequada, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(choque, Symptoms) -> CF3 = 0.95 ; CF3 = 0),
    (member(crianca_nao_reativa, Symptoms) -> CF4 = 0.9 ; CF4 = 0),
    (member(hipoglicemia, Symptoms) -> CF5 = 0.9 ; CF5 = 0),
    (member(convulsoes, Symptoms) -> CF6 = 0.9 ; CF6 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6], CF).

triage_rule('Overdose e envenenamento', orange, Symptoms, CF) :-
    \+ triage_rule('Overdose e envenenamento', red, Symptoms, _),
    (member(pulso_anormal, Symptoms) -> CF1 = 0.8 ; CF1 = 0),
    (member(mortalidade_alta, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(alteracao_subita_consciencia, Symptoms) -> CF3 = 0.85 ; CF3 = 0),
    (member(alto_risco_autoagressao, Symptoms) -> CF4 = 0.8 ; CF4 = 0),
    (member(sat_o2_muito_baixa, Symptoms) -> CF5 = 0.85 ; CF5 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5], CF).

triage_rule('Overdose e envenenamento', yellow, Symptoms, CF) :-
    \+ triage_rule('Overdose e envenenamento', red, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', orange, Symptoms, _),
    (member(mortalidade_moderada, Symptoms) -> CF1 = 0.7 ; CF1 = 0),
    (member(risco_moderado_autoagressao, Symptoms) -> CF2 = 0.7 ; CF2 = 0),
    (member(historia_psiquiatrica, Symptoms) -> CF3 = 0.7 ; CF3 = 0),
    (member(historia_inconsciencia, Symptoms) -> CF4 = 0.75 ; CF4 = 0),
    (member(agitacao_psicomotora, Symptoms) -> CF5 = 0.65 ; CF5 = 0),
    (member(historia_discordante, Symptoms) -> CF6 = 0.65 ; CF6 = 0),
    (member(sat_o2_baixa, Symptoms) -> CF7 = 0.7 ; CF7 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6, CF7], CF).

triage_rule('Overdose e envenenamento', green, Symptoms, CF) :-
    \+ triage_rule('Overdose e envenenamento', red, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', orange, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', yellow, Symptoms, _),
    CF = 0.5.

triage_rule('Overdose e envenenamento', blue, Symptoms, CF) :-
    \+ triage_rule('Overdose e envenenamento', red, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', orange, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', yellow, Symptoms, _),
    \+ triage_rule('Overdose e envenenamento', green, Symptoms, _),
    (member(agitacao_psicomotora, Symptoms) -> CF = 0.3 ; CF = 0).

triage_rule('Queimaduras', red, Symptoms, CF) :-
    (member(obstrucao_vias_aereas, Symptoms) -> CF1 = 0.9 ; CF1 = 0),
    (member(respiracao_inadequada, Symptoms) -> CF2 = 0.9 ; CF2 = 0),
    (member(estridor, Symptoms) -> CF3 = 0.9 ; CF3 = 0),
    (member(choque, Symptoms) -> CF4 = 0.95 ; CF4 = 0),
    (member(crianca_nao_reativa, Symptoms) -> CF5 = 0.9 ; CF5 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5], CF).

triage_rule('Queimaduras', orange, Symptoms, CF) :-
    \+ triage_rule('Queimaduras', red, Symptoms, _),
    (member(edema_facial, Symptoms) -> CF1 = 0.8 ; CF1 = 0),
    (member(lesao_inalacao, Symptoms) -> CF2 = 0.85 ; CF2 = 0),
    (member(dispneia_aguda, Symptoms) -> CF3 = 0.85 ; CF3 = 0),
    (member(mecanismo_trauma_significativo, Symptoms) -> CF4 = 0.8 ; CF4 = 0),
    (member(alteracao_subita_consciencia, Symptoms) -> CF5 = 0.85 ; CF5 = 0),
    (member(sat_o2_muito_baixa, Symptoms) -> CF6 = 0.85 ; CF6 = 0),
    (member(dor_intensa, Symptoms) -> CF7 = 0.8 ; CF7 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6, CF7], CF).

triage_rule('Queimaduras', yellow, Symptoms, CF) :-
    \+ triage_rule('Queimaduras', red, Symptoms, _),
    \+ triage_rule('Queimaduras', orange, Symptoms, _),
    (member(sat_o2_baixa, Symptoms) -> CF1 = 0.7 ; CF1 = 0),
    (member(inalacao_fumaca, Symptoms) -> CF2 = 0.7 ; CF2 = 0),
    (member(historia_discordante, Symptoms) -> CF3 = 0.65 ; CF3 = 0),
    (member(queimadura_eletrica, Symptoms) -> CF4 = 0.7 ; CF4 = 0),
    (member(queimadura_quimica, Symptoms) -> CF5 = 0.7 ; CF5 = 0),
    (member(dor_moderada, Symptoms) -> CF6 = 0.7 ; CF6 = 0),
    combine_cf([CF1, CF2, CF3, CF4, CF5, CF6], CF).

triage_rule('Queimaduras', green, Symptoms, CF) :-
    \+ triage_rule('Queimaduras', red, Symptoms, _),
    \+ triage_rule('Queimaduras', orange, Symptoms, _),
    \+ triage_rule('Queimaduras', yellow, Symptoms, _),
    (member(inflamacao_local, Symptoms) -> CF1 = 0.5 ; CF1 = 0),
    (member(infecao_local, Symptoms) -> CF2 = 0.5 ; CF2 = 0),
    (member(dor_leve_recente, Symptoms) -> CF3 = 0.5 ; CF3 = 0),
    (member(evento_recente, Symptoms) -> CF4 = 0.5 ; CF4 = 0),
    combine_cf([CF1, CF2, CF3, CF4], CF).

triage_rule('Queimaduras', blue, Symptoms, CF) :-
    \+ triage_rule('Queimaduras', red, Symptoms, _),
    \+ triage_rule('Queimaduras', orange, Symptoms, _),
    \+ triage_rule('Queimaduras', yellow, Symptoms, _),
    \+ triage_rule('Queimaduras', green, Symptoms, _),
    (member(inflamacao_local, Symptoms) -> CF = 0.3 ; CF = 0).

% Helper predicate to combine certainty factors
combine_cf([], 0).
combine_cf([CF], CF).
combine_cf([CF1, CF2|Rest], Final) :-
    Combined is CF1 + CF2 * (1 - CF1),
    combine_cf([Combined|Rest], Final).

% Add explanation texts for each color
rule_explanation(red, 'Emergência', [
    'Risco imediato de vida',
    'Necessita atendimento urgente',
    'Condição extremamente grave'
]).

rule_explanation(orange, 'Muito Urgente', [
    'Risco elevado',
    'Pode aguardar até 10 minutos',
    'Condição grave'
]).

rule_explanation(yellow, 'Urgente', [
    'Risco moderado',
    'Pode aguardar até 60 minutos',
    'Condição potencialmente grave'
]).

rule_explanation(green, 'Pouco Urgente', [
    'Risco baixo',
    'Pode aguardar até 120 minutos',
    'Condição estável'
]).

rule_explanation(blue, 'Não Urgente', [
    'Sem risco imediato',
    'Pode aguardar até 240 minutos',
    'Caso não prioritário'
]).