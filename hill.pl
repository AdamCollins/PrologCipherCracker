% Hill Cipher
% http://practicalcryptography.com/ciphers/classical-era/hill/

% make the length of Num_list an even number for matrix multiplication
even_list(Num_list, Even_list) :-
  length(Num_list, L),
  Even is L mod 2,
  ( Even \= 0 ->
    append([Num_list, [26]], Even_list)
    ; append([Num_list, []], Even_list)
  ).

% split a list into [N1, N2] and the tail list
% pre-condition: length of the first argv >= 2
split_list([], [], []).
split_list([N1 | [N2 | N3]], [Sub1 | [Sub2 | []]], Remaining) :-
  Sub1 is N1,
  Sub2 is N2,
  append([N3, []], Remaining).

% group every two elements of the Num_list into a list of list
group_to_matrix([], []).
group_to_matrix(Num_list, [MatrixH | MatrixT]) :-
  split_list(Num_list, SubNum_list, Remaining),
  append([SubNum_list, []], MatrixH),
  group_to_matrix(Remaining, MatrixT).

% convert Char list to Num list: a = 0, b = 1, ..., z = 25
map_to_num([], []).
map_to_num([Chead | CTail], [Nhead | Ntail]) :-
  char_code(Chead, Ascii),
  Nhead is Ascii - 65,
  map_to_num(CTail, Ntail).

% succeed if the length of key is 4, fail otherwise
validate_key(Key) :-
  atom_length(Key, L),
  ( L \= 4 ->
    writeln("Invalid Key."),
    fail
    ; L is 4
  ).

% eg: input String: "abcde"
%     output matrix: [[1, 2], [3, 4], [5, 26]]
convert_to_matrix(String, Matrix_list) :-
  string_upper(String, Upper_string),
  string_chars(Upper_string, Char_list),
  map_to_num(Char_list, Num_list),
  even_list(Num_list, Even_list),
  group_to_matrix(Even_list, Matrix_list).

% encipher every two element of the Plain_text
% pre-condition: the length of arg1 and arg2 should be 2
encipher_text([], _, []).
encipher_text([KeyM_head | KeyM_tail], TextM_head, [EcdH | EcdT]) :-
  nth0(0, KeyM_head, K0),
  nth0(1, KeyM_head, K1),
  nth0(0, TextM_head, T0),
  nth0(1, TextM_head, T1),
  Matrix_multi is K0 * T0 + K1 * T1,
  EcdH is Matrix_multi,
  encipher_text(KeyM_tail, TextM_head, EcdT).

% pre-condition: the length of each element in Key and Text matrix should be the same
cipher(_, [], []).
cipher(Key_matrix, [TextM_head | TextM_tail], [EcdH | EcdT]) :-
  encipher_text(Key_matrix, TextM_head, Encoded_matrix),
  append([Encoded_matrix, []], EcdH),
  cipher(Key_matrix, TextM_tail, EcdT).

% convert Num list to Char list
convert_firsttwo([], []).
convert_firsttwo([EcdH | EcdT], [T1 | T2]) :-
  % X is div(EcdH, 26),
  R is mod(EcdH, 26) + 65,
  % char_code(T0, X),
  char_code(T1, R),
  convert_firsttwo(EcdT, T2).

% convert encoded number matrix to ciphered text
convert_to_ciphered_text([], []).
convert_to_ciphered_text([EcdH | EcdT], [CtlH | CtlT]) :-
  convert_firsttwo(EcdH, Text),
  text_to_string(Text, CtlH),
  convert_to_ciphered_text(EcdT, CtlT).

en_de_cipher(Key_matrix, Target_matrix, Result) :-
  cipher(Key_matrix, Target_matrix, Encoded_matrix),
  convert_to_ciphered_text(Encoded_matrix, Ciphered_text_list),
  atomics_to_string(Ciphered_text_list, Result).

hill_encipher_Char(Key_matrix, Plain_text, Ciphered_text) :-
  convert_to_matrix(Plain_text, Text_matrix),
  en_de_cipher(Key_matrix, Text_matrix, Ciphered_text).

hill_encipher_list(_, [], []).
hill_encipher_list(Key_matrix, [Pl_head | Pl_tail], [Ci_head | Ci_tail]) :-
  hill_encipher_Char(Key_matrix, Pl_head, Ci_head),
  hill_encipher_list(Key_matrix, Pl_tail, Ci_tail).

% pre-condition: Key has to be a list of 4 elements which will be viewed as a 2*2 matrix
hill_encipher(Key, Plain_text_list, Ciphered_text_list) :-
  validate_key(Key),
  convert_to_matrix(Key, Key_matrix),
  hill_encipher_list(Key_matrix, Plain_text_list, Ciphered_text_list).


% -- not in use
% hill_encipher("abcd", "abcdefg", E).
% E = "\000\B\000\D\000\D\000\N\000\F\000\X\001\A\003\M"

% hill_decipher("abcd", "\000\B\000\D\000\D\000\N\000\F\000\X\001\A\003\M", P).
% P = "abcdefg"
% --

% in use
% hill_encipher("hill", ["algo", "ogla"], E).
% E = ["KRYM", "QMZR"].

% hill_decipher("hill", ["KRYM", "QMZR"], P).
% P = ["ALGO", "OGLA"].

choose_Deter(D) :- member(D, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]).

extract_elements(Key_matrix, A, B, C, D) :-
  nth0(0, Key_matrix, First),
  nth0(0, First, A),
  nth0(1, First, B),
  nth0(1, Key_matrix, Second),
  nth0(0, Second, C),
  nth0(1, Second, D).

mod_ele(A, B, C, D, F, S, T, L) :-
  F is mod(A, 26),
  S is mod(B, 26),
  T is mod(C, 26),
  L is mod(D, 26).

cal_determinant(Key_matrix, Deter) :-
  extract_elements(Key_matrix, A, B, C, D),
  M is mod(A * C - B * D, 26),
  choose_Deter(N),
  Deter is rdiv(26 * N + 1, M),
  integer(Deter).

adj_matrix(Key_matrix, Adj_matrix) :-
  extract_elements(Key_matrix, A, B, C, D),
  mod_ele(A, -B, -C, D, F, S, T, L),
  append([[L, S]], [], First),
  append(First, [[T, F]], Adj_matrix).

get_inverse(Deter, Adj_matrix, Inverse_matrix) :-
  extract_elements(Adj_matrix, A, B, C, D),
  A1 is Deter * A,
  B1 is Deter * B,
  C1 is Deter * C,
  D1 is Deter * D,
  mod_ele(A1, B1, C1, D1, A2, B2, C2, D2),
  append([[A2, B2]], [], First),
  append(First, [[C2, D2]], Inverse_matrix).

inverse_matrix(Key_matrix, Inverse_matrix) :-
  cal_determinant(Key_matrix, Deter),
  adj_matrix(Key_matrix, Adj_matrix),
  get_inverse(Deter, Adj_matrix, Inverse_matrix).

hill_decipher_Char(Key_matrix, Ciphered_text, Plain_text) :-
  convert_to_matrix(Ciphered_text, Text_matrix),
  en_de_cipher(Key_matrix, Text_matrix, Plain_text).

hill_decipher_list(_, [], []).
hill_decipher_list(Key_matrix, [Ci_head | Ci_tail], [Pl_head | Pl_tail]) :-
  hill_decipher_Char(Key_matrix, Ci_head, Pl_head),
  hill_decipher_list(Key_matrix, Ci_tail, Pl_tail).

hill_decipher(Key, Ciphered_text_list, Plain_text_list) :-
  convert_to_matrix(Key, Key_matrix),
  inverse_matrix(Key_matrix, Inverse_matrix),
  hill_encipher_list(Inverse_matrix, Ciphered_text_list, Plain_text_list).