open Yojson.Basic.Util
open Yojson.Basic
open Machine
open Types

(* module StringMap = Map.Make(String) *)
module StringSet = Set.Make(String)


let extract_strings_from_json json name =
  let string_list = json |> member name |> to_list |> List.map to_string
  in List.map (fun s -> String.sub s 1 (String.length s - 2)) string_list


let extract_string_from_json json name =
  let s = json |> member name |> to_string in
  String.sub s 1 (String.length s - 2)

let convert_string_to_char s =
  if String.length s <> 1 then
    raise (Parsing_error ("Invalid char: " ^ s))
  else
    String.get s 0

let convert_strings_to_chars lst =
  List.map convert_string_to_char lst

let convert_string_to_action s =
  match s with
  | "LEFT" -> Left
  | "RIGHT" -> Right
  | _ -> raise (Parsing_error "Invalid action :")

let check_string_length s =
  let len = String.length s in
  len >= 1 && len <= 32

let extract_and_validate_name json =
  let name = extract_string_from_json json "name" in
  if check_string_length name then
    name
  else
    raise (Parsing_error "Invalid name")

(* let extract_and_validate_transitions json alphabet states finals = *)

let check_no_duplicates lst =
  let set_of_strings = List.fold_left (fun acc str -> StringSet.add str acc) StringSet.empty lst in
  StringSet.cardinal set_of_strings = List.length lst

let check_no_duplicates_in_transitions lst =
  let set_of_strings = List.fold_left (fun acc (state, _) -> StringSet.add state acc) StringSet.empty lst in
  StringSet.cardinal set_of_strings = List.length lst

let validate_alphabet alphabet =
  if not (check_no_duplicates alphabet) then
    Error "There are duplicate symbols"
  else
    Ok alphabet

let extract_and_validate_alphabet json =
  let alphabet = extract_strings_from_json json "alphabet" in
  match validate_alphabet alphabet with
  | Ok valid_alphabet -> valid_alphabet |> convert_strings_to_chars
  | Error msg -> raise (Parsing_error ("Invalid Alphabet: " ^ msg))

let validate_blank blank alphabet =
  if not (List.mem (String.get blank 0) alphabet) then
    Error "Blank symbol is not in the alphabet"
  else
    Ok blank

let extract_and_validate_blank json alphabet =
  let blank = extract_string_from_json json "blank" in
  match validate_blank blank alphabet with
  | Ok valid_blank -> valid_blank |> convert_string_to_char
  | Error msg -> raise (Parsing_error ("Invalid blank symbol: " ^ msg))

let validate_states states =
  if not (check_no_duplicates states) then
    Error "There are duplicate states"
  else if not (List.for_all check_string_length states) then
    Error "Some states are not between 1 and 32 characters"
  else
    Ok states

let extract_and_validate_states json =
  let states = extract_strings_from_json json "states" in
  match validate_states states with
  | Ok valid_states -> valid_states
  | Error msg -> raise (Parsing_error ("There are duplicate states: " ^ msg))

let validate_initial initial states =
  if not (List.mem initial states) then
    Error "Initial state is not in the list of states"
  else if not (check_string_length initial) then
    Error "Initial state is not between 1 and 32 characters"
  else if List.length states = 0 then
    Error "Need at least one final state"
  else
    Ok initial

let extract_and_validate_initial json states =
  let initial = extract_string_from_json json "initial" in
  match validate_initial initial states with
  | Ok valid_initial -> valid_initial
  | Error msg ->  raise (Parsing_error ("Initial state is not in the list of states : " ^ msg))

let validate_finals finals states =
  if not (List.for_all (fun s -> List.mem s states) finals) then
    Error "Some final states are not in the list of states"
  else
    Ok finals

let extract_and_validate_finals json states =
  let finals = extract_strings_from_json json "finals" in
  match validate_finals finals states with
  | Ok valid_finals -> valid_finals
  | Error msg -> raise (Parsing_error ("Final state is not in the list of states : " ^ msg))

let validate_transition transition alphabet states name =
  if not (List.mem transition.read alphabet) then
    Error "Read symbol is not in the alphabet"
  else if not (List.mem transition.write alphabet) then
    Error "Write symbol is not in the alphabet"
  else if not (List.mem transition.to_state states) then
    Error "to_state is not in the list of states"
  else if transition.action <> Left && transition.action <> Right then
    Error "Action must be either LEFT or RIGHT"
  else if not (List.mem name states) then
    Error "is not defined in the list of states"
  else
    Ok transition

let validate_transitions transitions states =
  if not (check_no_duplicates_in_transitions transitions) then
    Error "There are duplicate states in the transitions"
  else
    Ok transitions

let extract_read t =
  let read = extract_string_from_json t "read" in
  convert_string_to_char read

let extract_to_state t =
  let to_state = extract_string_from_json t "to_state" in
  to_state

let extract_write t =
  let write = extract_string_from_json t "write" in
  convert_string_to_char write

let extract_action t =
  let action = extract_string_from_json t "action" in
  convert_string_to_action action

let extract_and_validate_transitions json alphabet states finals =
  let transitions = json |> member "transitions" |> to_assoc |> List.map (fun (state, transitions) ->
    (state, transitions |> to_list |> List.map (fun t ->
          let read = extract_read t in
          let to_state = extract_to_state t in
          let write = extract_write t in
          let action = extract_action t in
          {
            read = read;
            to_state = to_state;
            write = write;
            action = action;
          }
          ))
    )
  in
  let states_without_finals = List.filter (fun s -> not (List.mem s finals)) states in
  let all_key = List.map (fun (k, _) -> k) transitions in
  if not (List.for_all (fun s -> List.mem s all_key) states_without_finals) then
    raise (Parsing_error "Some states are not defined in the transitions");

  List.iter (fun (state, transitions) ->
    List.iter (fun t ->
      match validate_transition t alphabet states state with
      | Ok _ -> ()
      | Error msg -> raise (Parsing_error ("Invalid transition: in state " ^ state ^ ": " ^ msg))
    ) transitions
  ) transitions;

  match validate_transitions transitions states with
  | Ok valid -> valid
  | Error msg -> raise (Parsing_error ("Invalid transitions: " ^ msg))

let machine_of_json json =
    let name = extract_and_validate_name json in
    Printf.printf "Title: %s \n" name;
    let alphabet = extract_and_validate_alphabet json in
    let blank = extract_and_validate_blank json alphabet in
    let states = extract_and_validate_states json in
    let initial = extract_and_validate_initial json states in
    let finals = extract_and_validate_finals json states in
    let transitions = extract_and_validate_transitions json alphabet states finals in
    {
      name = name;
      alphabet= alphabet;
      blank= blank;
      states= states;
      initial= initial;
      finals= finals;
      transitions= transitions;
    }
            
let parse_jsonfile jsonfile =
  let json = Yojson.Basic.from_file jsonfile in
  let machine = machine_of_json json in
  machine
    
let machine_parsing jsonfile =
    let machine = parse_jsonfile jsonfile in
    machine
  
let parse_input input alphabet blank =
  if String.length input = 0 then
    raise (Input_error "Input is empty")
  else if not (List.for_all (fun c -> List.mem c alphabet) (List.init (String.length input) (String.get input))) then
    raise (Input_error "Input contains symbols not in the alphabet")
  else if String.contains input blank then
    raise (Input_error "Input contains the blank symbol")
  else
    input