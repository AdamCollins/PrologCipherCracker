% UBC CPSC312-2018 Functional and Logical Programming
% Author: Junsu Shin
% Enciphering Algorithm for Enigma Machine

:- [main].

% rotor(Int, Char, Char, Char, Char)
rotor(Rotor_No, Visible_Char, Ring_Setting, Input, Output) :-
	char_code(Visible_Char, Visible_Code),
	char_code(Ring_Setting, Ring_Code),
	Changing_Offset is Visible_Code-65,
	Ring_Offset is Ring_Code-65,
	char_shift(Input, Changing_Offset-Ring_Offset, Input_Core),
	rotor_core_string(Rotor_No, String),
	rotor_core(String, Input_Core, Output_Core),
	char_shift(Output_Core, Ring_Offset-Changing_Offset, Output).

% rotor(Int, Char, Char, Char, Char)
rotor_backward(Rotor_No, Visible_Char, Ring_Setting, Input, Output) :-
	char_code(Visible_Char, Visible_Code),
	char_code(Ring_Setting, Ring_Code),
	Changing_Offset is Visible_Code-65,
	Ring_Offset is Ring_Code-65,
	char_shift(Output_Core, Ring_Offset-Changing_Offset, Output),
	rotor_core_string(Rotor_No, String),
	rotor_core(String, Input_Core, Output_Core),
	char_shift(Input, Changing_Offset-Ring_Offset, Input_Core).
	
% rotor_core(String, Char, Char)
rotor_core(String, Input, Output) :-
	string_chars(String, Core_Charlist),
	member(Input_Code1, [65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90]),
	char_code(Input, Input_Code1), % Input is upper case letter (code 65 ~ 90)
	Input_Code2 is Input_Code1-65,
	nth0(Input_Code2, Core_Charlist, Output).

% enciphering data for each rotor
rotor_core_string(1, "EKMFLGDQVZNTOWYHXUSPAIBRCJ").
rotor_core_string(2, "AJDKSIRUXBLHWTMCQGZNPYFVOE").
rotor_core_string(3, "BDFHJLCPRTXVZNYEIWGAKMUSQO").

% reflector panel for enigma, reflects the input into a designated output
% input/output works both ways, therefore reflector(Output, Input) will be also true if reflector(Input, Output) is true.
% reflector(Char Input, Char Output)
reflector(Input, Output) :-
	char_code(Input, Input_Code),
	string_chars("YRUHQSLDPXNGOKMIEBFZCWVJAT", Chars),
	Input_Code_Minused is Input_Code-65,
	nth0(Input_Code_Minused, Chars, Output).

% TBD: notch implementation
% e.g: after 26 words, rotor3 comes back into same position and rotor2 moves once forward.
% enigma_encipher(List<Upper_case_alphabet> Visible_List, List<Upper_case_alphabet> Visible_List, String Input, String Output)
enigma_encipher(_, _, "", "").
enigma_encipher(Visible_List, Ring_Setting_List, Input, Output) :-
	string_chars(Input, [HI|TI]),
	nth1(3, Visible_List, Rotor_III_Visible_Pre),
	char_shift(Rotor_III_Visible_Pre, 1, Rotor_III_Visible),
	nth1(2, Visible_List, Rotor_II_Visible),
	nth1(1, Visible_List, Rotor_I_Visible),
	nth1(1, Ring_Setting_List, Rotor_I_Ring_Setting),
	nth1(2, Ring_Setting_List, Rotor_II_Ring_Setting),
	nth1(3, Ring_Setting_List, Rotor_III_Ring_Setting),
	rotor(3, Rotor_III_Visible, Rotor_III_Ring_Setting, HI, Rotor_3_Output),
	rotor(2, Rotor_II_Visible, Rotor_II_Ring_Setting, Rotor_3_Output, Rotor_2_Output),
	rotor(1, Rotor_I_Visible, Rotor_I_Ring_Setting, Rotor_2_Output, Rotor_1_Output),
	reflector(Rotor_1_Output, Reflector_Output), % substitute HO for Reflector_Output if rotor works backwards
	rotor_backward(1, Rotor_I_Visible, Rotor_I_Ring_Setting, Rotor_3_Input, Reflector_Output),
	rotor_backward(2, Rotor_II_Visible, Rotor_II_Ring_Setting, Rotor_2_Input, Rotor_3_Input),
	rotor_backward(3, Rotor_III_Visible, Rotor_III_Ring_Setting, HO, Rotor_2_Input),
	nth1(1, Visible_List_New, Rotor_I_Visible),
	nth1(2, Visible_List_New, Rotor_II_Visible),
	nth1(3, Visible_List_New, Rotor_III_Visible),
	string_chars(Input_New, TI),
	enigma_encipher(Visible_List_New, Ring_Setting_List, Input_New, Output_New),
	string_chars(Output_New, TO),
	string_chars(Output, [HO|TO]).

% enigma_encipher(["A","A","A"], ["A","A","A"], "AAAAA", R).
% R = "BDZGO".