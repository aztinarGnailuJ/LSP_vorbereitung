membr(A,[]) :- fail.
membr(A, [A|L]):- !.
membr(A,[E|L]) :- membr(A, L).

dupl_search(_, [], []).
dupl_search(E,[E|L],Lw) :-
    dupl_search(E,L,Lw), !.
dupl_search(E, [A|L], [A|Lw]) :-
    dupl_search(E,L,Lw).

find_duplicates(L, D) :-
    find_duplicates(L, D), not(De = []).

find_duplicates_aux([E], []).
find_duplicates_aux([E|L], [E|D]) :- 
    membr(E, L), dupl_search(E, L, Lwoe), find_duplicates(Lwoe, D), !.
find_duplicates_aux([E|L], D) :- 
    find_duplicates(L, D).
