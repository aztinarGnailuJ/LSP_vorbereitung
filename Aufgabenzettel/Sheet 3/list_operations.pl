% Exercise 9
% a)
% Implement a Prolog predicate remove(L, I, R) that takes a list L and an index
% number I as inputs and computes a result list R containing all elements of L except
% for the element at index I! Use zero-based indexing!
% Example:
% ?- remove([a, b, c], 2, R).
% R = [a,b]

% If the index is 0, return everything but the first element of the list.
remove([_|L], 0, L).
% Else, return the first element of the list, as well as the result of the rule operation.
% Then subtract 1 from the index and recall the slice predicate with the List-tail and the new index.
remove([X|L], I, [X|R]) :- I1 is I-1, remove(L,I1, R).

% b)
% Implement a Prolog predicate slice(L, I1, I2, R) that takes a list L and two
% index numbers I1 and I2 as inputs and computes a result list R containing all
% elements within the given index boundaries! Use zero-based indexing!
% Example:
% ?- slice([a, b, c, d], 1, 3, R).
% R = [b, c, d].

% If both indices reached 0, return first element in a list
slice([X|_], 0, 0, [X]).
% If first index reached 0, return first list element in List, as well as a placeholder for the slice operation.
% Then subtract 1 from the second index and recall the slice predicate with the new index.
slice([X|L], 0, I, [X|R]) :- I1 is I-1, slice(L, 0, I1, R).
% If both indices did not reach 0, recall the slice predicate without the first element and subtract 1 from both indices.
slice([_|L], I, U, R) :- I1 is I-1, U1 is U-1, slice(L, I1, U1, R).

% c)
% Implement a Prolog predicate mean(L, M) that takes a list L containing integers
% as input and computes the arithmetic mean M of all the elements!
% Example:
% ?- mean([1, 2, 3], M).
% M = 2.

% Sum helper, summing all list entries into one value.
sum([],0).
sum([X|L],R) :- sum(L,V), R is X + V.

% List length, calculator. Returns length of a list.
list_length([], 0).
list_length([_|X], L) :-  list_length(X, N),L is N+1.

% Main mean calculator makes use of the Helper predicates sum and list_length.
mean(Ls, M) :- sum(Ls, Sum), list_length(Ls, Length), M is Sum / Length.