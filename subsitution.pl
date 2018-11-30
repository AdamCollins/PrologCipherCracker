%given character C, I is the index in the alphabet.
letter_ind(C, I):- nth0(I,['a','b','c','d','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],C).

substitution_cipher_chars([],_,[]).
%Given list of characters PlainTextList and a list of alphabet mappings, K. return Ciphered Text with no alphabet mapping.
substitution_cipher_chars([C|PlainTextList],Key,[SC|CipheredText]):-
    letter_ind(C, SI),       %SI = subsitute index for C.
    nth0(SI,Key,SC),         %SC = Subsituted character.
    substitution_cipher_chars(PlainTextList,Key,CipheredText).

%Given string PlainText and a Key, CipherText is text with altered alphabet.
substitution_cipher(PlainText,Key,CipheredText):-
    string_chars(PlainText, PTL),
    string_chars(Key, KL),
    substitution_cipher_chars(PTL,KL,CipheredText).

