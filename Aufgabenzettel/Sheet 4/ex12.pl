% remove takes a possible list element and removes it from a given list.
% It returns a list without the given element.
remove(_, [], []).
remove(Element, [Element|RestList], List) :- 
	remove(Element, RestList, List), !.
remove(Element, [OtherElement|RestList], [OtherElement|List]) :- 
	OtherElement \= Element,
	remove(Element, RestList, List),!.

% remove_duplicates takes two lists.
% The first contains all nodes that are in the waitlist, the second all possible nodes to visit from the current node. 
% It removes all nodes that are already in the waitlist and returns only the unvisited nodes.
remove_duplicates([],PossibleNodes,PossibleNodes).
remove_duplicates([FirstWaiting|RestWaiting], PossibleNodes, PossibleNodesCleaned):-
	member(FirstWaiting, PossibleNodes),
	remove(FirstWaiting,PossibleNodes,Cleaned), 
	remove_duplicates(RestWaiting,Cleaned,PossibleNodesCleaned), !.

remove_duplicates([_|RestWaiting],PossibleNodes, PossibleNodesCleaned):- 
	remove_duplicates(RestWaiting,PossibleNodes, PossibleNodesCleaned), !.

% Search takes node from which possible edges shall be computed, a list of possible nodes to visit and a list of edges.
% It returns a list of nodes that can be visited from the first node.
search(_,[],_,[]).
search(SearchNode, [Node|Nodelist], Edges, [Node|R]) :-
	member((SearchNode,Node), Edges),
	search(SearchNode, Nodelist, Edges, R), !.

search(SearchNode, [Node|Nodelist], Edges, [Node|R]) :- 
	member((Node,SearchNode), Edges),
	search(SearchNode, Nodelist, Edges, R), !.

search(SearchNode, [_|Nodelist], Edges, R) :-
	search(SearchNode, Nodelist, Edges, R).

% bft_helper is a helper for bft. It expects either a list or a single Element as the first input.
% The second and third inputs are both lists of non-visited Nodes and a list of choosable edges.
% It returns a list of elements that are ordered in the breadth-first search manner.
bft_helper([],_,_,[]).
bft_helper(LastWaiting,[],_,LastWaiting).
bft_helper([FirstWaiting|RestWaiting], VisitableNodes, Edges,[FirstWaiting|SearchResult]):-
	remove(FirstWaiting, VisitableNodes, VisitableNodesCleaned),
	search(FirstWaiting,VisitableNodesCleaned,Edges,Visits),
	remove_duplicates(RestWaiting,Visits,VisitsCleaned),
	append(RestWaiting,VisitsCleaned,Waitlist),
	bft_helper(Waitlist,VisitableNodesCleaned,Edges,SearchResult),!.

% bft is a predicate to execute breadth first search.
% In essence this takes a starting node, a list of nodes within the graph and a list of edges within the graph.
% It returns a full list that is ordered in the manner of breadth first search.
bft(StartingNode,Nodes,Edges,[StartingNode|SearchResult]):-
	remove(StartingNode,Nodes,NodesWithoutStart),
	search(StartingNode,NodesWithoutStart,Edges,Waitlist),
	bft_helper(Waitlist,NodesWithoutStart,Edges,SearchResult).

