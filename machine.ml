open Yojson.Basic.Util
open Types

let print_machine machine =
    let print_string_list label lst =
      Printf.printf "%s: [ %s ]\n" label (String.concat ", " lst)
    in

    let print_char_list label lst =
      Printf.printf "%s: [ %s ]\n" label (String.concat ", " (List.map (String.make 1) lst))
    in

    let convert_direction_to_string d =
      match d with
      | Left -> "LEFT"
      | Right -> "RIGHT"
    in

    let print_frame label = (* Header frame *)
      let width = 80 in
      let border = String.make width '*' in
      let spacer =
        let padding = String.make (width - 2) ' ' in
        "*" ^ padding ^ "*"
      in
      let total_padding = width - String.length label - 2 in
      let left_padding = total_padding / 2 in
      let right_padding = total_padding - left_padding in
      let padding_left = String.make left_padding ' ' in
      let padding_right = String.make right_padding ' ' in
      Printf.printf "%s\n%s\n*%s%s%s*\n%s\n%s\n" border spacer padding_left label padding_right spacer border
    in

    print_frame machine.name;
		print_char_list "Alphabet" machine.alphabet;
		print_string_list "States" machine.states;
		Printf.printf "Initial: %s\n" machine.initial;
		print_string_list "Finals" machine.finals; 

		List.iter (fun (state, transitions) ->
			List.iter (fun t ->
				Printf.printf "(%s, %c) -> (%s, %c, %s)\n"
					state t.read t.to_state t.write (convert_direction_to_string t.action)
			) transitions
		) machine.transitions;

    let end_frame = String.make 80 '*' in
		  Printf.printf "%s\n" end_frame;