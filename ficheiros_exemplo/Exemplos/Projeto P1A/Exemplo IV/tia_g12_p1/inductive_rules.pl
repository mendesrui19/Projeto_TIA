:- module(inductive_rules, [inductive_triage/2]).

% Decision tree rules based on the learned model
inductive_triage(Symptoms, Color) :-
    find_color(Symptoms, Color),
    !.  % Cut to ensure single result

% Default case
inductive_triage(_, blue).  % Default to blue if no rules match

find_color(Symptoms, red) :-
    (member(hoarseness, Symptoms),
        member(agitation, Symptoms),
        \+ member(dilated_pupils, Symptoms),
        member(dry_mouth, Symptoms)) ;
    (member(hoarseness, Symptoms),
        \+ member(pinpoint_pupils, Symptoms),
        member(laceration, Symptoms),
        \+ member(agitation, Symptoms)) ;
    (member(hoarseness, Symptoms),
        member(pinpoint_pupils, Symptoms),
        member(laceration, Symptoms),
        member(dry_mouth, Symptoms)).

find_color(Symptoms, orange) :-
    (member(hoarseness, Symptoms),
        \+ member(pinpoint_pupils, Symptoms),
        \+ member(laceration, Symptoms),
        \+ member(burn_odor, Symptoms)) ;
    (member(hoarseness, Symptoms),
        \+ member(pinpoint_pupils, Symptoms),
        member(laceration, Symptoms),
        member(agitation, Symptoms)) ;
    (\+ member(hoarseness, Symptoms),
        member(agitation, Symptoms),
        \+ member(dilated_pupils, Symptoms),
        \+ member(dry_mouth, Symptoms)) ;
    (\+ member(hoarseness, Symptoms),
        \+ member(agitation, Symptoms),
        member(burn_odor, Symptoms),
        \+ member(vomiting, Symptoms)).

find_color(Symptoms, yellow) :-
    (\+ member(hoarseness, Symptoms),
        \+ member(agitation, Symptoms),
        \+ member(burn_odor, Symptoms),
        member(pinpoint_pupils, Symptoms)) ;
    (\+ member(hoarseness, Symptoms),
        \+ member(agitation, Symptoms),
        member(burn_odor, Symptoms),
        member(vomiting, Symptoms)).

find_color(Symptoms, green) :-
    (member(hoarseness, Symptoms),
        \+ member(pinpoint_pupils, Symptoms),
        \+ member(laceration, Symptoms),
        member(burn_odor, Symptoms)) ;
    (member(hoarseness, Symptoms),
        member(pinpoint_pupils, Symptoms),
        member(laceration, Symptoms),
        \+ member(confusion, Symptoms)).

find_color(Symptoms, blue) :-
    (\+ member(hoarseness, Symptoms),
        \+ member(agitation, Symptoms),
        \+ member(burn_odor, Symptoms),
        \+ member(pinpoint_pupils, Symptoms)) ;
    (member(hoarseness, Symptoms),
        member(pinpoint_pupils, Symptoms),
        \+ member(laceration, Symptoms),
        \+ member(dry_mouth, Symptoms)) ;
    (member(hoarseness, Symptoms),
        member(pinpoint_pupils, Symptoms),
        member(laceration, Symptoms),
        member(confusion, Symptoms)).

% Important symptoms based on feature importance
important_symptoms([
    laceration,
    pinpoint_pupils,
    confusion,
    agitation,
    burn_odor,
    dry_mouth,
    hoarseness,
    dilated_pupils,
    vomiting
]).