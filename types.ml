module StringMap = Map.Make(String)

type machine_action = Left | Right

type transition = {
  read: char;
  to_state: string;
  write: char;
  action: machine_action;
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
  transitions: transition list StringMap.t;
}