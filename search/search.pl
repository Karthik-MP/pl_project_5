%%%%%%%%%%%%%%%%%%%%%%
% Your code goes here:
%%%%%%%%%%%%%%%%%%%%%%

search(Moves) :-
    initial(InitialRoom), 
    bfs([[[ ], InitialRoom, []]], Moves). 

% Case where the door is open without needing a key (either direction)
open_passage(CurrentRoom, NextRoom, _) :-
    (door(CurrentRoom, NextRoom) ; door(NextRoom, CurrentRoom)).

% Case where the door is locked, but we have the key
open_passage(CurrentRoom, NextRoom, Keys) :-
    (locked_door(CurrentRoom, NextRoom, LockType) ; locked_door(NextRoom, CurrentRoom, LockType)),
    member(LockType, Keys).

    collect_keys(CurrentRoom, Keys, UpdatedKeys) :-
        key(CurrentRoom, KeyType),
        \+ member(KeyType, Keys),
        !, % Cut to prevent backtracking once the key is collected
        UpdatedKeys = [KeyType | Keys].
    
    collect_keys(_, Keys, Keys).

bfs([[Route, CurrentRoom, _] | _], Route) :- 
    treasure(CurrentRoom). 

bfs([[Route, CurrentRoom, Keys] | Queue], FinalRoute) :-
    findall(
        [NewRoute, AdjacentRoom, NewKeys],
        (
            open_passage(CurrentRoom, AdjacentRoom, Keys), 
            \+ member(move(CurrentRoom, AdjacentRoom), Route),
            collect_keys(AdjacentRoom, Keys, NewKeys), 
            append(Route, [move(CurrentRoom, AdjacentRoom)], NewRoute)
        ),
        PossibleRoutes
    ),
    append(Queue, PossibleRoutes, UpdatedQueue),
    bfs(UpdatedQueue, FinalRoute). 