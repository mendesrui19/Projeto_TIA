:- module(interface, [start_consultation/0]).
:- use_module(knowledge, [case_types/1, all_symptoms/2, symptom_question/2, case_type_question/2, triage_rule/4, rule_explanation/3, inductive_symptom_question/2]).
:- use_module(triage, [evaluate_triage/5]).
:- use_module(inductive_rules).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_json)).

% Main consultation interface
start_consultation :-
    repeat,
    writeln('Manchester Triage System - Patient Assessment'),
    writeln('---------------------------------------------'),
    writeln('Escolha o tipo de avaliação:'),
    writeln('1. Dedutiva'),
    writeln('2. Indutiva'),
    read_line_to_string(user_input, Choice),
    (
        Choice = "1" -> handle_deductive_approach ;
        Choice = "2" -> handle_inductive_approach ;
        writeln('Opção inválida!')
    ),
    format('~n~nDeseja avaliar outro caso? (y/n) '),
    read_line_to_string(user_input, Answer),
    (Answer = "n" ; Answer = "N"),
    !.

handle_deductive_approach :-
    get_case_type_by_questions(CaseType),
    (CaseType = 'Nenhuma das anteriores' ->
        writeln('Caso não se enquadra no sistema de triagem.')
    ;
        format('~nCaso Identificado: ~w~n', [CaseType]),
        writeln('---------------------------------------------'),
        gather_symptoms(CaseType, Symptoms),
        evaluate_triage(CaseType, Symptoms, Color, CF, Explanation),
        show_result(Color, CaseType, Symptoms, CF, Explanation)
    ).

handle_inductive_approach :-
    writeln('Avaliação Indutiva'),
    writeln('---------------------------------------------'),
    gather_inductive_symptoms(Symptoms),
    inductive_rules:inductive_triage(Symptoms, Color),
    rule_explanation(Color, Title, Points),
    show_inductive_result(Color, Symptoms, Title, Points).

gather_inductive_symptoms(Symptoms) :-
    findall(Symptom, (
        inductive_rules:important_symptoms(AllSymptoms),
        member(Symptom, AllSymptoms),
        knowledge:inductive_symptom_question(Symptom, Question),
        write(Question), write(' '),
        read_line_to_string(user_input, Answer),
        (Answer = "y" ; Answer = "Y")
    ), Symptoms).

show_inductive_result(Color, Symptoms, Title, Points) :-
    color_translation(Color, TranslatedColor),
    format('~nResultado da Triagem~n'),
    format('Tipo: Avaliação Indutiva~n'),
    format('Cor da Pulseira: ~w (Certeza: 80.0%)~n', [TranslatedColor]),
    format('Sintomas:~n'),
    maplist(print_point, Symptoms),
    format('~nExplicação:~n'),
    format('- ~w~n', [Title]),
    format('Razões:~n~n'),
    maplist(print_point, Points).

get_case_type_by_questions(CaseType) :-
    findall(Type, case_type_question(Type, _), Types),
    exclude(=(('Nenhuma das anteriores')), Types, RegularTypes),
    ask_case_types(RegularTypes, CaseType).

ask_case_types([Type|Rest], SelectedType) :-
    case_type_question(Type, Question),
    format('~w (y/n) ', [Question]),
    read_line_to_string(user_input, Answer),
    (
        (Answer = "y" ; Answer = "Y") -> 
        SelectedType = Type
        ;
        (Rest = [] -> 
            writeln('\nCaso não identificado!\n'),
            SelectedType = 'Nenhuma das anteriores'
            ;
            ask_case_types(Rest, SelectedType)
        )
    ).

% Collects all symptoms from user input and eturns list of confirmed symptoms
gather_symptoms(CaseType, Symptoms) :-
    knowledge:all_symptoms(CaseType, AllSymptoms),
    ask_all_symptoms(AllSymptoms, Symptoms).

% Recursively asks about each possible symptom
% Builds list of confirmed symptoms
ask_all_symptoms([], []) :- !.
ask_all_symptoms([Symptom|Rest], [Symptom|Symptoms]) :-
    ask_symptom(Symptom),
    !,
    ask_all_symptoms(Rest, Symptoms).
ask_all_symptoms([_|Rest], Symptoms) :-
    ask_all_symptoms(Rest, Symptoms).

% Asks user about a single symptom and returns true if user confirms the symptom
ask_symptom(Symptom) :-
    knowledge:symptom_question(Symptom, Question),
    write(Question), write(' '),
    read_line_to_string(user_input, Answer),
    (Answer = "y" ; Answer = "Y").

% Add color translation mapping
color_translation(red, 'Vermelho').
color_translation(orange, 'Laranja').
color_translation(yellow, 'Amarelo').
color_translation(green, 'Verde').
color_translation(blue, 'Azul').

% Displays the final triage result, certainty, identified symptoms and explanation
show_result(Color, CaseType, Symptoms, CF, [Title|Points]) :-
    color_translation(Color, TranslatedColor),
    Percentage is CF * 100,
    format('~nResultado da Triagem~n'),
    format('Tipo de Caso: ~w~n', [CaseType]),
    format('Cor da Pulseira: ~w (Certeza: ~0f%)~n', [TranslatedColor, Percentage]),
    format('Sintomas:~n'),
    maplist(print_point, Symptoms),
    format('~nExplicação:~n'),
    format('- ~w~n', [Title]),
    format('Razões:~n~n'),
    maplist(print_point, Points).

print_point(Point) :-
    format('- ~w~n', [Point]).

% Reads a number from user input and handles invalid input by asking again
read_number(Number) :-
    read_line_to_string(user_input, Input),
    (atom_number(Input, Number) -> true
    ; writeln('Por favor insira um número válido.'),
    read_number(Number)).

% HTTP server settings
:- http_handler(root(.),  http_reply_from_files('static', []), [prefix]).
:- http_handler('/api/case-types', handle_case_types, []).
:- http_handler('/api/symptoms', handle_symptoms, []).
:- http_handler('/api/evaluate', handle_evaluate, []).

% Add new HTTP handler for inductive evaluation
:- http_handler('/api/evaluate-inductive', handle_evaluate_inductive, []).

% Add new HTTP handler for inductive symptoms
:- http_handler('/api/inductive-symptoms', handle_inductive_symptoms, []).

% Start HTTP server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% API handlers
handle_case_types(_Request) :-
    findall(_{
        id: Type,
        question: Question
    }, knowledge:case_type_question(Type, Question), TypesList),
    reply_json_dict(TypesList).

handle_symptoms(Request) :-
    http_read_json_dict(Request, Data),
    atom_string(CaseType, Data.caseType),
    all_symptoms(CaseType, AllowedSymptoms),
    findall(_{
        id: Symptom,
        question: Question_NoYN
    }, (
        member(Symptom, AllowedSymptoms),
        symptom_question(Symptom, Question),
        % Remove (y/n) from the question for web display
        sub_string(Question, 0, L, 6, Question_NoYN),
        L >= 0
    ), SymptomsList),
    reply_json_dict(SymptomsList).

handle_evaluate(Request) :-
    http_read_json_dict(Request, Data),
    atom_string(CaseType, Data.caseType),
    % Convert symptoms from JSON array to Prolog list of atoms
    maplist(atom_string, Symptoms, Data.symptoms),
    evaluate_triage(CaseType, Symptoms, Color, CF, Explanation),
    reply_json_dict(_{
        color: Color,
        certainty: CF,
        caseType: CaseType,
        symptoms: Data.symptoms,
        explanation: Explanation
    }).

handle_evaluate_inductive(Request) :-
    http_read_json_dict(Request, Data),
    % Convert symptoms from JSON array to Prolog atoms
    maplist(atom_string, Symptoms, Data.symptoms),
    % Get color from inductive rules
    (inductive_rules:inductive_triage(Symptoms, Color) -> true ; Color = blue),
    % Get explanation for the color
    knowledge:rule_explanation(Color, Title, Points),
    % Build and send response
    reply_json_dict(_{
        color: Color,
        certainty: 0.8,  % Fixed certainty for inductive approach
        caseType: "Avaliação Indutiva",
        symptoms: Data.symptoms,
        explanation: [Title|Points]
    }).

% Add handler for inductive symptoms
handle_inductive_symptoms(_Request) :-
    findall(_{
        id: Symptom,
        question: Question_NoYN
    }, (
        inductive_rules:important_symptoms(AllSymptoms),
        member(Symptom, AllSymptoms),
        knowledge:inductive_symptom_question(Symptom, Question),
        % Remove (y/n) from the question for web display
        sub_string(Question, 0, L, 4, Question_NoYN),
        L >= 0
    ), SymptomsList),
    reply_json_dict(SymptomsList).

% Initialize server when loading the module
:- initialization(start_server(8080)).