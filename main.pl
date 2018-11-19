%Given a string S, W is a word inside of S.
word_in_string(W,S):-
    split_string(S," ","",L),
    member(W,L).

%Given a char C and a shift amount A, S is character C shiften A times(including looping)
char_shift(C1,A,S):-
    C2 is (C1-97+A) mod 26 + 97, %shifts C1 over by A while looping around if overflow.
    char_code(S, C2). %converts character code into char

% char_shift("a", 2, A).
% A = c

%given a string, S1, S2 is S1 with all chars shifted by A
string_shift(S1, A, S2):-
    string_to_list(S1,L1),
    charlist_shift(L1, A, L2),
    string_to_list(S2, L2).

% string_shift("abcde", 1, A).
% A = "bcdef"

%given list of char, shift them over by A spaces.
charlist_shift([],_,[]).
charlist_shift([H1|S1],A,[SC|S2]):-
    char_shift(H1,A,SC),    %SC = Shifted character
    charlist_shift(S1,A,S2).

% charlist_shift(["a","b","c"], 1, A)
% A = [b, c, d].

% charlist_shift(["a","b","c"], 1, ["b","c","d","e"]).
% false.