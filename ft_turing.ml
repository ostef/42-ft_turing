open Printf
open Types

exception Execute_Error of string

(* Todo:
check for duplicates in states
for all states, check that read is in alphabet, write is in alphabet, to_state is in states,
every state in states is defined in transitions, except for final states *)
(* let is_machine_valid machine =
  List.exists (fun char -> char = machine.blank) machine.alphabet &&
  List.exists (fun state -> state = machine.initial) machine.states &&
  List.for_all (fun final -> List.exists (fun state -> state = final) machine.states) machine.finals

let is_input_valid machine input =
  String.length input > 0 &&
  input |> String.to_seq |> List.of_seq |>
  List.for_all (fun char -> char <> machine.blank && List.exists (fun a -> a = char) machine.alphabet) 
    
let print_transition state transition =
  printf "(%s, %c) -> (%s, %c, %s)\n"
    state
    transition.read
    transition.to_state
    transition.write
    (match transition.action with |Left -> "LEFT" |Right -> "RIGHT")

let print_machine machine =
  printf "Alphabet: [ " ;
  List.iter (printf "%c ") machine.alphabet ;
  printf "]\n" ;
  printf "States: [ " ;
  List.iter (printf "%s ") machine.states ;
  printf "]\n" ;
  printf "Initial: %s\n" machine.initial ;
  printf "Finals: [ " ;
  List.iter (printf "%s ") machine.finals ;
  printf "]\n" ;
  StringMap.iter (fun key list -> List.iter (print_transition key) list) machine.transitions

(** Execute the next instruction based on a machine description and a machine state
Returns a new machine_state *)
let execute_next_step machine machine_state =
  let transitions = match StringMap.find_opt machine_state.state machine.transitions with
    | None -> raise (Execute_Error "Unknown state")
    | Some (x) -> x in
  let cur_char = machine_state.input.[machine_state.cursor] in
  let transition = List.find (fun a -> a.read = cur_char ) transitions in
  {
    state = transition.to_state;
    input = String.mapi
        (fun index c -> if index = machine_state.cursor then transition.write else c)
        machine_state.input;
    cursor = match transition.action with
      | Left -> machine_state.cursor - 1
      | Right -> machine_state.cursor + 1
  }

  type machine = {
    name: string;
    alphabet: char list;
    blank: char;
    states: string list;
    initial: string;
    finals: string list;
    transitions: transition list StringMap.t;
  }

  type machine_state = {
    state: string;
    input: string;
    cursor: int;
  }

<<<<<<< HEAD:ft_turing.ml
let machine = {
  name = "unary_sub";
  alphabet = ['1';'.';'-';'='];
  blank = '.';
  states = ["scanright";"eraseone";"subone";"skip";"HALT"];
  initial = "scanright";
  finals = ["HALT"];
  transitions = StringMap.empty
  |> StringMap.add "scanright" [
    {read='.';to_state="scanright";write='.';action=Right};
    {read='1';to_state="scanright";write='1';action=Right};
    {read='-';to_state="scanright";write='-';action=Right};
    {read='=';to_state="eraseone";write='.';action=Left}
    ]
    |> StringMap.add "eraseone" [
      {read='1';to_state="subone";write='=';action=Left};
      {read='-';to_state="HALT";write='.';action=Left}
      ]
      |> StringMap.add "subone" [
        {read='1';to_state="subone";write='1';action= Left};
        {read='-';to_state="skip";write='-';action=Left}
        ]
        |> StringMap.add "skip" [
          {read='.';to_state="skip";write='.';action=Left};
          {read='1';to_state="scanright";write='.';action=Right}
          ]
<<<<<<< HEAD
} *)

let execute_machine machine input =
  print_endline (Printf.sprintf "Input: %s" input)