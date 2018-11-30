helloworld :-
    write('Hello World!'),
    nl.

start :-
    readhal(N),
    write('Enter a number:'),
    write(N),
    isTwo(N).


isTwo(N) :-
    N is 2. 

% adam,and, apple ape, banana
tree(apple, tree(ape, adam, apes), banana).



%Given a string S, W is a word inside of S.
word_in_string(W,S):-
    split_string(S," ","",L),
    member(W,L).

%Given a char C and a shift amount A, S is character C shiften A times(including looping)
char_shift(Char1,0,Char1).
char_shift(Char1,A,S):-
	member(Code1, [65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]),
	char_code(Char1, Code1),
    C2 is (Code1-65+A) mod 26 + 65, %shifts C1 over by A while looping around if overflow.
    char_code(S, C2). %converts character code into char

% char_shift("A", 2, A).
% A = 'C'



%Given a char C and a shift amount A, S is character C shiften A times(including looping)
char_shift(Char1,A,S):-
	char_code(Char1, Code1),
	Code1 > 96, Code1 < 123,
    C2 is (Code1-97+A) mod 26 + 97, %shifts C1 over by A while looping around if overflow.
    char_code(S, C2). %converts character code into char

% char_shift("a", 2, A).
% A = c

%given a string, S1, S2 is S1 with all chars shifted by A
string_shift(S1, A, S2):-
    string_chars(S1,L1),
    charlist_shift(L1, A, L2),
    string_chars(S2,L2).

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