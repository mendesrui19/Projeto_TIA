:- use_module(knowledge).
:- use_module(triage).
:- use_module(interface).

% Starts the consultation process
start_triage :-
    interface:start_consultation.

% Initializes the system
:- initialization(start_triage).