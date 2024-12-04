val padding_size : int

type action = Left | Right

type transition = {
  read: char;
  to_state: string;
  write: char;
  action: action;
}

type machine_state = {
  state: string;
  input: string;
  cursor: int;
}

type machine = {
  name: string;
  alphabet: char list;
  blank: char;
  states: string list;
  initial: string;
  finals: string list;
  transitions: (string * transition list) list;
}

exception Parsing_error of string
exception Input_error of string
exception Infinite_loop of string
exception Read_Not_Found of string