membr(X,[X|_]).
membr(X,[_|Xs]) :- membr(X,Xs).

product('cappucino', 2).
product('hotchocolate', 3).
product('tea', 2.5).

can_i_buy(Budget) :-
    product(_, Cost), Cost =< Budget.

possible_orders(Budget, [Name]) :-
    product(Name, Cost), NewBudget is Budget - Cost, NewBudget >= 0, not(can_i_buy(NewBudget)).
possible_orders(Budget, [Name|Order]) :-
    product(Name, Cost),
    NewBudget is Budget - Cost,
    NewBudget >= 0,
    can_i_buy(NewBudget),
    possible_orders(NewBudget, Order).