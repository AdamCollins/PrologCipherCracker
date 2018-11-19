% UBC CPSC312-2018 Functional and Logical Programming
% Author: Junsu Shin
% Deciphering Algorithm for Caesar Cipher

:- [main].

stringlist_shift([], _, []).
stringlist_shift([H1|T1], A, [H2|T2]) :-
	string_shift(H1, A, H2),
	stringlist_shift(T1, A, T2).

shift_amount(A) :- member(A, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]).

%caesar_decipher(L, H, R): 	ciphered string list L is converted into R 
% 							utilizing Hint string list H
caesar_decipher([], _, []).
caesar_decipher(L, H, R) :-
	shift_amount(A),
	stringlist_shift(L, A, R), %SR = Shifted Result
	member(W, R),
	member(W, H).

% caesar_decipher(["efgfoe","uif","fbtu","xbmm","pg","uif","dbtumf"], ["castle"], R).
% R = ["defend", "the", "east", "wall", "of", "the", "castle"].

