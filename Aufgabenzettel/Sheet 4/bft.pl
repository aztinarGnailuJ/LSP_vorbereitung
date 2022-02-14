
% bft gets a starting vertex
%          a list of vertices
%          a list of edges
% and ouputs the breadth first traversal path

% bft(a,[a, b, c, d, e, f, g, h],[(b,a), (a,f), (c,b), (b,d), (b,f), (c,d), (c,h), (d,e),(f,g), (g,e), (f,h)],T).

% remove_vertex gets a list of vertices
%                    a single vertex
% returns the list of vertices without the single vertex
remove_vertex([], _, []).
remove_vertex([First|Vertices], First, Vertices):- !.
remove_vertex([First|Vertices], Start, [First|Visitable]) :- 
    remove_vertex(Vertices, Start, Visitable), !.

% remove_multiple gets a list of vertices
%                      a list of waiting vertices
% returns a list of vertices without the ones already in the waiting list
remove_multiple([],Vertices,Vertices).
remove_multiple([First_Waiting|Waitlist], Vertices, Visitable) :- 
    remove_vertex(Vertices, First_Waiting, Interm_Visitable),
    remove_multiple(Waitlist, Interm_Visitable, Visitable), !.

% push_to_waitlist gets a starting vertex
%                       a list of visitable vertices
%                       a list of edges
% returns a list of next vertices to visit
push_to_waitlist(_, [], _, []).
push_to_waitlist(Start, [First_Visitable|Visitable], Edges, [First_Visitable|New_Waitlist]) :- 
    (member((Start, First_Visitable), Edges); member((First_Visitable, Start), Edges)),
    push_to_waitlist(Start, Visitable, Edges, New_Waitlist), !.
push_to_waitlist(Start, [_|Visitable], Edges, New_Waitlist) :- 
    push_to_waitlist(Start, Visitable, Edges, New_Waitlist), !.

% bft_aux gets a waitlist of vertices
%              a list of visitable vertices
%              a list of edges
% returns a list of traversals corresponding to breadth first terminology
bft_aux(Waitlist, [], _, Waitlist).
bft_aux([First_Waiting|Waitlist], Vertices, Edges, [First_Waiting|Traversal]) :- 
    push_to_waitlist(First_Waiting, Vertices, Edges, New_Waitlist),
    append(Waitlist, New_Waitlist, Next_Waitlist),
    remove_multiple(New_Waitlist, Vertices, Visitable),
    bft_aux(Next_Waitlist, Visitable, Edges, Traversal), !.

% bft gets a starting vertex
%          a list of visitable vertices
%          a list of edges
% returns a list of traversals corresponding to breadth first terminology
bft(Start, Vertices, Edges, [Start|Traversal]) :- 
    (member((Start, _), Edges);member((_, Start), Edges)),
    remove_vertex(Vertices, Start, Visitable),
    push_to_waitlist(Start, Visitable, Edges, Waitlist),
    remove_multiple(Waitlist, Visitable, Visitable_Cleaned),
    bft_aux(Waitlist, Visitable_Cleaned, Edges, Traversal), !.