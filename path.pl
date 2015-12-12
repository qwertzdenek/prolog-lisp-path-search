% -*- Mode: Prolog -*-

:- [graph].

%% v(0).
%% v(1).
%% v(2).
%% v(3).
%% v(4).
%% v(5).
%% v(6).

%% e(0, 1, 0.5).
%% e(1, 5, 0.7).
%% e(1, 3, 0.2).
%% e(2, 0, 0.2).
%% e(2, 4, 1.2).
%% e(3, 2, 1).
%% e(3, 4, 1.5).
%% e(4, 5, 3).
%% e(5, 0, 2).
%% e(5, 6, 2).

infinity(10).

% navštíven
:- dynamic visited/1.

% vzdálenost do vrcholu
:- dynamic d/3.

get_dist(U, D, F) :- d(U, D, F) -> ! ; infinity(D), F is 0.
set_dist(U, D, F) :- asserta(d(U, D, F)), !.

:- discontiguous set_dist/3.

% najít nejbližší
extract_min(V) :- infinity(Dold), extract_min(V, _, Dold).
extract_min(V, D, Dold) :- v(V1), not(visited(V1)), get_dist(V1, D1, _),
			   D1 < Dold
			   -> (extract_min(V2, D2, D1)
			       -> D = D2, V = V2
			       ; D = D1, V = V1, D2 = D1, V2 = V1)
			   ; fail.

update_adj(U) :- get_dist(U, Du, _),
		 e(U, V, W), get_dist(V, Dv, _),
		 Alt = Du + W, Alt < Dv, set_dist(V, Alt, U).

search_graph() :- extract_min(U), asserta(visited(U)),
		  update_adj(U), search_graph().

search_graph(U) :- set_dist(U, 0, U), not(search_graph()).

trace_path(U, V, P) :- var(P), trace_path(U, V, []), !. % begin
trace_path(U, V, P) :- U =:= V, write([U|P]), !.     % end
trace_path(U, V, P) :- get_dist(V, _, Fv), trace_path(U, Fv, [V|P]). % trace
