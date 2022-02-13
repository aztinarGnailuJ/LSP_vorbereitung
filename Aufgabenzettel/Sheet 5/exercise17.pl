:- use_module(library(clpfd)).
% Available Constructors
%truck(ID, SIZE, ARRIVAL,COST).
%dock(ID, SIZE, DURATION).

% These are all trucks to be evaluated for assignment.
truck(1, 1, 2, 10).
truck(2, 1, 0, 1).
truck(3,2,0,0).
% These are all available docks.
dock(1,2,5).
dock(2,1,4).
dock(3,2,1).


find_a_reihenfolge(Trucks, Docks, TW, Final_order, Final_cost) :-
    % get a member of dockid
    member([Truckid, Size, Arrival, Cost], Trucks),
    format('Trying truck: ~q~n', [Truckid]),
    % delete the truck from chooseable trucks
    delete(Trucks, [Truckid, Size, Arrival, Cost], Trucks_without_X),
    % get a possible docking for selected Truck
    member([Dockid, Size, _],Docks),
    format('Trying truck_dock: ~q~n', [[Truckid,Dockid]]),
    % start a helper with:
    %   Trucks without the truck that was just assigned
    %   all Docks
    %   the given Time Window TW
    %   an assignment array with a first assignment for truck 
    find_a_reihenfolge_helper(Trucks_without_X, Docks, TW, 0, [[Truckid, Dockid, Arrival]], Final_order, Final_cost).

find_a_reihenfolge_helper([], _, _, Final_cost, Final_order, Final_order, Final_cost) :-
    format('Finished with: ~n'),
    format('A =  ~q~n', [Final_order]),
    format('C =  ~q~n', [Final_cost]),
    format('__________________________________________ ~n').

find_a_reihenfolge_helper(Trucks, Docks, TW, Current_cost, Starting_order, Final_order, Final_cost) :-
    % get a member of dockid
    member([Truckid, Size, Arrival, Cost], Trucks),
    format('Trying truck: ~q~n', [Truckid]),
    % delete the truck from chooseable trucks
    delete(Trucks, [Truckid, Size, Arrival, Cost], Trucks_without_X),
    % get a possible docking for selected Truck
    member([Dockid, Size, Duration],Docks),
    format('Trying truck_dock: ~q~n', [[Truckid,Dockid]]),
    % from Starting_order find the beginning time of the last docking at the chosen dock
    helpr([Starting_order, [Dockid, Duration, Arrival]], [Processing_start, Added_cost]),
    % check if TW still in scope
    TW #>= (Processing_start + Duration),
    % Calculate added cost
    New_cost #= (Added_cost*Cost)+Current_cost,
    % append new assignment to Starting Order
    append(Starting_order, [[Truckid, Dockid, Processing_start]], New_order),
    % find next truck to process
    find_a_reihenfolge_helper(Trucks_without_X, Docks, TW, New_cost, New_order, Final_order, Final_cost).

% this helper gets all previous assignments, the current try (dockid, its duration and the arrival at the dock)
% and must return a processing_start and an added_cost_factor to later calculate the added cost
helpr([Assignments, [Dockid, Duration, Arrival]],[Processing_start, Added_cost_factor]) :-
    % this helper begins with finding all previous dockings at the given dock
    findall(Last_unload_begin, member([_,Dockid,Last_unload_begin], Assignments), Last_unload_begins),
    % from this list of previous docking times, it finds the maximum finishtime using the duration
    find_max_finishtime(Duration,Last_unload_begins, Max_finishtime),
    % if Max_finishtime is greater than the arrival time, processing may only start at maximum finishtime
    % the added cost factor therefore is the maximum_finishtime minus the arrival
    % Important: backtracking is not allowed for this rule
    ((Max_finishtime #> Arrival, Processing_start #= Max_finishtime, Added_cost_factor #= Max_finishtime - Arrival, !);
    % else, the truck may start processing right away, therefore the added cost equals zero. 
    (Max_finishtime #=< Arrival, Processing_start #= Arrival, Added_cost_factor #= 0)).

% find_max_finishtime returns the maximum finishtime from the last dockings adding the maximum and dockduration
find_max_finishtime(Duration, Unload_times, Max_finishtime) :-
    % if max_list => Max_finishtime is Maximum from list plus duration
    (max_list(Unload_times, Max), Max_finishtime #= Max + Duration);
    % else, the maximum finishtime is zero
    Max_finishtime #= 0.

% this is a showoff function to return all list elements and to print them
showall([]).
showall([Possible|List]) :-
    format('~q~n', [Possible]),
    showall(List).

% assignment_min gets a list of truck tuples and a list of dock tuples, as well as a time window.
% it returns one/the optimal assignment of trucks and the corresponding minimal cost
% if there exists no optimal solution, it returns false.
assignment_min(Trucks, Docks, Time_window, Assignments, Minimum_cost) :-
    % first obtain all possible solutions
    findall([A,B], find_a_reihenfolge(Trucks, Docks, Time_window, A, B), All_reihenfolgens),
    % find all costs
    findall(Cost, member([_,Cost],All_reihenfolgens),Costs),
    % find minimum cost
    min_list(Costs, Minimum_cost),
    % find member with minimum cost
    member([Assignments,Minimum_cost], All_reihenfolgens).




:- set_prolog_flag(verbose, silent).
:- initialization(main).

main :-
    format('This is one possible order: ~n'),
    % Demonstrate finding one possible order
    find_a_reihenfolge([[1,1,2,10],[2,1,0,1]], [[1,2,5],[2,1,4],[3,2,1]], 10, _, _),
    format('~n~n_________________________________~n~n~n'),
    
    format('Using the predicate findall we can obtain all possible orders: ~n'),
    % Demonstrate finding all possible orders
    findall([A,B], find_a_reihenfolge([[1,1,2,10],[2,1,0,1]], [[1,2,5],[2,1,4],[3,2,1]], 10, A, B), All_reihenfolgens),    
    
    % Show all possible orders
    format('These are all the possible orders and their cost: ~n'),
    showall(All_reihenfolgens),
    format('~n~n_________________________________~n~n~n'),

    format('Using assignment_min we can obtain one of/the optimal order: ~n'),
    % Show the optimal possible order using assignment_min
    assignment_min([[1,1,2,10],[2,1,0,1]], [[1,2,5],[2,1,4],[3,2,1]], 10, Assignments, Minimum_cost),
    format('This is one/the optimum for the given input and its cost: ~n'),
    format('A = ~q~n', [Assignments]),
    format('C = ~q~n', [Minimum_cost]),

    % This should fail
    format('This should fail: ~n'),
    assignment_min([[1,1,2,10],[2,1,0,1],[3,1,0,1]], [[1,2,5],[2,1,4],[3,2,1]], 10, Assignments, Minimum_cost).

