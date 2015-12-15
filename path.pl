% -*- Mode: Prolog -*-

:- [graph].

% visited flag
:- dynamic visited/1.

% distance to vertex
:- dynamic d/3.

get_dist(U, D, F) :- d(U, D, F) -> ! ; D is 10000, F is 0.

% find closest vertex
get_alldists(V, D) :-
    v(V), not(visited(V)), get_dist(V, D, _).
extract_min(V) :-
    aggregate(min(D, V), get_alldists(V, D), min(D, V)).

update_adj(U) :- get_dist(U, Du, _), !,
    e(U, V, W), get_dist(V, Dv, _),
    Alt is Du + W, Alt < Dv, asserta(d(V, Alt, U)), fail.

search_graph() :- extract_min(U), asserta(visited(U)),
    not(update_adj(U)), search_graph().

search_graph(U) :- asserta(d(U, 0, U)), not(search_graph()).

trace_path(U, V, P, _) :- var(P), get_dist(V, D, _),
    trace_path(U, V, [], D), !.
trace_path(U, V, P, D) :- U =:= V,
    format('Path = ~w~nLength = ~4f', [[U|P], D]), !.
trace_path(U, V, P, D) :- get_dist(V, _, Fv),
    trace_path(U, Fv, [V|P], D).
