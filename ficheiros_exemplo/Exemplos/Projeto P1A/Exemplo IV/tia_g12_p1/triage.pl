:- module(triage, [evaluate_triage/5]).
:- use_module(knowledge, [triage_rule/4, rule_explanation/3]).

% evaluate_triage(+CaseType, +Symptoms, -Color, -CF, -Explanation)
evaluate_triage(CaseType, Symptoms, Color, CF, Explanation) :-
    findall(
        color(C, Cert, Expl),
        (
            triage_rule(CaseType, C, Symptoms, Cert),
            Cert > 0.2,  % minimum certainty threshold
            rule_explanation(C, Title, Points),
            Expl = [Title|Points]
        ),
        Results
    ),
    % Get highest certainty result or default to blue
    (Results = [] ->
        Color = blue,
        CF = 0.5,
        rule_explanation(blue, Title, Points),
        Explanation = [Title|Points]
    ;
        sort(2, @>=, Results, [color(Color, CF, Explanation)|_])
    ).