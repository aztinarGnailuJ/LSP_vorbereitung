% Exercise 10
% Consider the following Prolog program:

sublists([], []).
sublists([X|I], [[X|E]|R]) :- sublists(I, [E|R]), member(X, E).
sublists([X|I], [[X]|R]) :- sublists(I, R).

% In its current form, the predicate sublists(L, R) takes a list L as input and calculates
% all possible sublists of L in which all elements are equal. The list R holds all of these
% sublists. The built-in predicate member(X, L) is used to check whether X is a member
% of list L.

% Adapt the given program such that only the longest possible sublists are computed!
% Also, prevent duplicates in the output! You may only add the cut predicate (!) at
% appropriate position(s) in the program rules using conjunction (,). Add a comment to
% your adapted program code explaining why the added cut leads to the desired result!

longest_sublists([], []).
longest_sublists([X|I], [[X|E]|R]) :- longest_sublists(I, [E|R]),member(X, E), !.
longest_sublists([X|I], [[X]|R]) :- longest_sublists(I, R), !.

% Example:
% ?- sublists([a, b, b, b, c, d, d], S).
% S = [[a], [b, b, b], [c], [d, d]].