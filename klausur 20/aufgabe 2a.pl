membr(_,[]) :- fail.
membr(A, [A|_]):- !.
membr(A,[_|L]) :- membr(A, L).

dupl_search(_, [], []).
dupl_search(E,[E|L],Lw) :-
    dupl_search(E,L,Lw), !.
dupl_search(E, [A|L], [A|Lw]) :-
    dupl_search(E,L,Lw).

find_duplicates(L, D) :-
    find_duplicates_aux(L, D), not(D = []).

find_duplicates_aux([], []).
find_duplicates_aux([E|L], [E|D]) :-
    member(E,L), !, dupl_search(E, L, Lwoe), find_duplicates_aux(Lwoe, D).
find_duplicates_aux([E|L], D) :-
    not(member(E,L)), find_duplicates_aux(L,D).