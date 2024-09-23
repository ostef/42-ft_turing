open Printf

module StringMap = Map.Make(String)

type machine_action = Left | Right

type transition = {
  read: char;
  to_state: string;
  write: char;
  action: machine_action;
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

exception Execute_Error of string

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

(** Execute all instructions in the input until we reach a final state
Returns a new machine_state *)
let rec execute_all machine machine_state =
  match List.find_opt (fun a -> a = machine_state.state) machine.finals with
  | Some (_) -> machine_state
  | None -> let new_state = execute_next_step machine machine_state
      in execute_all machine new_state

(** Execute the input according to a machine description *)
let execute_input machine input =
  let () = print_machine machine in
  let machine_state = {
    state =machine.initial;
    input = input;
    cursor = 0
  } in
  let res = execute_all machine machine_state in
  printf "%s\n" res.input

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
                  {read='1';to_state="subone";write='1';action=Left};
                  {read='-';to_state="skip";write='-';action=Left}
                ]
                |> StringMap.add "skip" [
                  {read='.';to_state="skip";write='.';action=Left};
                  {read='1';to_state="scanright";write='.';action=Right}
                ]
}

let () = execute_input machine "1111-11"
