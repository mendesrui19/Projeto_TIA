% ============================================================
% TRIAGEM SNS24 — Ficheiro Principal
% Carrega todos os modulos do sistema de triagem.
%
% Estrutura modular (conforme enunciado do projeto):
%   base_dados.pl       — perguntas, disposicoes, fact/2
%   base_conhecimento.pl — regras de producao (if...then...with)
%   inferencia.pl       — motor de inferencia (forward chaining + CF)
%   explicacao.pl       — arvore de prova e backward chaining (P1MAX)
%   interface.pl        — interacao com o utilizador
%   regras_aprendidas.pl — regras geradas automaticamente (P1B)
%
% Para iniciar a triagem: ?- iniciar.
% Para ver a explicacao:  ?- porque( <disposicao> ).
% Para ver o caminho:     ?- como( <disposicao> ).
% ============================================================

:- dynamic(fact/2).

% Operadores alinhados a sns24v2_incert.pl (aulas)
:- op( 800, fx, if).
:- op( 700, xfx, then).
:- op( 600, xfx, with).
:- op( 300, xfy, or).
:- op( 200, xfy, and).
:- op( 800, xfx, <=).

:- discontiguous( (if)/1 ).
:- multifile( (if)/1 ).

% --- Carregar modulos ---
:- consult( base_dados ).
:- consult( base_conhecimento ).
:- consult( inferencia ).
:- consult( explicacao ).
:- consult( interface ).

% --- Regras aprendidas automaticamente (P1B) ---
:- ( exists_file('regras_aprendidas.pl') -> consult('regras_aprendidas') ; true ).
