% Main entry point for parsing, assuming X is the list of tokens.
parse(X) :- lines(X, []).

lines(X, Z) :-
    line(X, Y),          % Parse a Line
    (   rest_lines(Y, Z)  % If semicolon follows, parse more lines
    ;   Z = Y            % Otherwise, end parsing here (no semicolon)
    ).

lines(X, Z) :- 
    line(X, Z).       % If no semicolon, just parse one Line.

% Rest of the lines after the first one, separated by ';'
rest_lines([';' | W], Z) :- 
    lines(W, Z).  % Continue parsing the next lines after semicolon.

line(X, Z) :-
    num(X, Y),  % Parse a Num
    line_continuation(Y, Z). % Parse continuation of the line.

line(X, Z) :- 
    num(X, Z).   % Base case: just a Num (no comma).

% Continuation of a Line, which can be a comma and another Line.
line_continuation([',' | W], Z) :- 
    line(W, Z).   % After a comma, expect another Line.

line_continuation(W, W).  % No continuation, base case.

num(X, Z) :-
    digit(X, Y),     % Parse a single digit.
    num_tail(Y, Z).  % Parse the rest of the number (if any).

num_tail([D | T], Z) :- 
    digit([D | T], Y),  % If another digit follows.
    num_tail(Y, Z).      % Continue parsing the rest of the number.

num_tail(Y, Y).   % Base case: no more digits.

digit([D | T], T) :-
    member(D, ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']).  % Check if the character is a digit.


% Example execution:
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2']).
% true.
% ?- parse(['3', '2', ',', '0', ';', '1', ',', '5', '6', '7', ';', '2', ',']).
% false.
% ?- parse(['3', '2', ',', ';', '0']).
% false.
