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

% Base case: If the current room contains the treasure, return the route
bfs([[Route, CurrentRoom, _] | _], Route) :- 
    treasure(CurrentRoom).

% Recursive case: If no treasure yet, explore adjacent rooms
bfs([[Route, CurrentRoom, Keys] | Queue], FinalRoute) :-
    % Explore all possible next routes
    findall(
        [NewRoute, AdjacentRoom, NewKeys],
        (
            open_passage(CurrentRoom, AdjacentRoom, Keys),  % Check if the passage is open
            \+ member(move(CurrentRoom, AdjacentRoom), Route),  % Prevent revisiting the same room
            collect_keys(AdjacentRoom, Keys, NewKeys),  % Collect keys in the adjacent room
            append(Route, [move(CurrentRoom, AdjacentRoom)], NewRoute)  % Build the new route
        ),
        PossibleRoutes
    ),
    % Add the newly discovered routes to the queue
    (PossibleRoutes \= [] ->
        append(Queue, PossibleRoutes, UpdatedQueue),
        bfs(UpdatedQueue, FinalRoute)  % Continue the search with updated queue
    ;
        % If no new routes, backtrack or terminate the search (depending on logic)
        FinalRoute = Route
    ).
