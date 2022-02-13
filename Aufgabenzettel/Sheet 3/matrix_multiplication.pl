% Exercise 11

% Implement a Prolog predicate matrix_multiplication(M1, M2, MP) that takes two
% matrices M1 and M2 as inputs and computes their corresponding matrix product MP!
% A matrix is represented as a list of rows. A row, on the other hand, is represented as
% a list of elements.

% This is a dotproduct function. From two vectors of same length, represented by lists, it produces the mathematical dotproduct.
% The helper function multiplies the single indices within the lists, while the main function sums these resulting products up.
dotpr(V1, V2, PR) :- dotpr_helper(V1,V2,PRODUCTS), sum(PRODUCTS, PR).
dotpr_helper([],[],[]).
dotpr_helper([E1|V1], [E2|V2], [PRODUCT|PR]) :- PRODUCT is E1 * E2, dotpr_helper(V1,V2,PR).

% The transposer is used to transpose a matrix diagonally.
% Recursively, it always takes the first entries within the given matrix rows and combines them into one list.
% These lists, integrated into another list then make up the transposed matrix.
transposer([[]|_], []).
transposer(M, [TROW | TROWS]) :- transposer_helper(M, TROW, REST), transposer(REST, TROWS).

% transposer_helper transposes the first column of a matrix into a row that can be used in transposer as TRow (TransposedRow)
transposer_helper([],[],[]).
transposer_helper([[FirstColumn|RestOfFirstRow]|RestRows], [FirstColumn|RestColumns], [RestOfFirstRow|RestOfOtherRows]) :- transposer_helper(RestRows, RestColumns, RestOfOtherRows).

% The matrix_multiplication predicate is used to start the multiplication of two matrices. 
% It starts by transposing the second matrix "M2" and feeds this into its helper-predicate.
matrix_multiplication(M1, M2, MP) :- transposer(M2,M2T), matrix_multiplication_helper(M1,M2T,MP), !.

% The matrix_multiplication_helper calls for the row_multiplicator predicate.
% The result is stored in a nested list which is extended by the result of a recursive call of itself containing the rest of the "M1"-Rows.
matrix_multiplication_helper([],_,[]).
matrix_multiplication_helper([Row1|M1], M2, [R1|MP]) :- row_multiplicator(Row1, M2, R1), matrix_multiplication_helper(M1, M2, MP).

% The row_multiplicator is used for getting the dotproducts of the given "M1"-Row and each of the transposed "M2"-Rows.
% It eventually returns a list of all dotproducts.
row_multiplicator(_, [],[]).
row_multiplicator(Row, [E1|M2], [DP|RestDP]) :- dotpr(Row, E1, DP), row_multiplicator(Row, M2, RestDP).

% Example:
% ?- matrix_multiplication([[1,2,3], [4,5,6]], [[7,8], [9,10], [11,12]], MP).
% MP = [[58, 64], [139, 154]].