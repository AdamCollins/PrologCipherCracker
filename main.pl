%Given a string S, W is a word inside of S.
word_in_string(W,S):-
    split_string(S," ","",L),
    member(W,L).

%Given a char C and a shift amount A, S is character C shiften A times(including looping)
char_shift(C,A,S):-
    char_code(C,V),
    SV is (V-97+A) mod 26 + 97,
    char_code(S,SV).
