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
encipher(_, [], []).
encipher(Key_matrix, [TextM_head | TextM_tail], [EcdH | EcdT]) :-
  encipher_text(Key_matrix, TextM_head, Encoded_matrix),
  append([Encoded_matrix, []], EcdH),
  encipher(Key_matrix, TextM_tail, EcdT).

% convert Num list to Char list
convert_firsttwo([], []).
convert_firsttwo([EcdH | EcdT], [T0 | [T1 | T2]]) :-
  X is div(EcdH, 26),
  R is mod(EcdH, 26) + 65,
  char_code(T0, X),
  char_code(T1, R),
  convert_firsttwo(EcdT, T2).

% convert encoded number matrix to ciphered text
convert_to_ciphered_text([], []).
convert_to_ciphered_text([EcdH | EcdT], [CtlH | CtlT]) :-
  convert_firsttwo(EcdH, Text),
  text_to_string(Text, CtlH),
  convert_to_ciphered_text(EcdT, CtlT).

% pre-condition: Key has to be a list of 4 elements which will be viewed as a 2*2 matrix
hill_encipher(Key, Plain_text, Ciphered_text) :-
  validate_key(Key),
  convert_to_matrix(Key, Key_matrix),
  convert_to_matrix(Plain_text, Text_matrix),
  encipher(Key_matrix, Text_matrix, Encoded_matrix),
  convert_to_ciphered_text(Encoded_matrix, Ciphered_text_list),
  atomics_to_string(Ciphered_text_list, Ciphered_text).


% hill_encipher("abcd", "abcdefg", E).
% E = "\000\B\000\D\000\D\000\N\000\F\000\X\001\A\003\M"

% hill_decipher(Ciphered_text, Key, Plain_text).
% hill_decipher("\000\B\000\D\000\D\000\N\000\F\000\X\001\A\003\M", "abcd", P).
% P = "abcdefg"