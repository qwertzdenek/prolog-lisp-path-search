% -*- Mode: Prolog -*-

:- [graph].

infinity(10).

:- dynamic visited/1.

% distance to vertex
:- dynamic d/3.

get_dist(U, D, F) :- d(U, D, F) -> ! ; infinity(D), F is 0.
set_dist(U, D, F) :- asserta(d(U, D, F)), !.

:- discontiguous set_dist/3.

% find closest vertex
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

trace_path(U, V, P, _) :- var(P), trace_path(U, V, [], 0), !. % begin
trace_path(U, V, P, D) :- U =:= V, write([U|P]), nl, write(D), !.     % end
trace_path(U, V, P, D) :- get_dist(V, Dv, Fv), Dsub is D+Dv,
			  trace_path(U, Fv, [V|P], Dsub). % trace
