open Yojson.Basic.Util
open Types

module StringMap = Map.Make(String)

let get_help args =
  if Array.length args > 1 && (args.(1) = "--help" || args.(1) = "-h") then
    (Printf.printf "usage: ft_turing [-h] jsonfile input\n\
      \n\
      positional arguments:\n\
      \ \ jsonfile \t \ json description of the machine\n\
      \ \ input \t \ (optional) input of the machine\n\
      \n\
      optional arguments:\n\
      \ \ -h, --help \t \ show this help message and exit\n";
    1)
  else
    -1

let get_input args pos_help =
  if pos_help = 1 then
    args.(3)
  else
    args.(2)

let get_jsonfile args pos_help =
  if pos_help = 1 then
    args.(2)
  else
    args.(1)

    
let action_of_string str =
  match str with
  | "LEFT" -> action.Left
  | "RIGHT" -> action.Right
  | _ -> failwith "Unknown action"

let transition_of_json json =
  {
    read = json |> member "read" |> to_string
    to_state = json |> member "to_state" |> to_string
    write = json |> member "write" |> to_string
    action = json |> member "action" |> to_string |> action_of_string
    }

let parse_jsonfile jsonfile =
  let json = Yojson.Basic.from_file jsonfile in
  let machine = machine_of_json json in
  machine

let machine_of_json json =
    {
      name = json |> member "name" |> to_string;
      alphabet = json |> member "alphabet" |> to_list |> filter_string |> List.map (fun s -> String.get s 0);
      blank = json |> member "blank" |> to_string |> String.get 0;
      states = json |> member "states" |> to_list |> filter_string;
      initial = json |> member "initial" |> to_string;
      finals = json |> member "finals" |> to_list |> filter_string;
      transitions = json |> member "transitions" |> to_assoc |> List.fold_left (fun acc (state, trans_list) ->
        StringMap.add state (trans_list |> to_list |> List.map transition_of_json) acc
      ) StringMap.empty;
    }
  
let parse_input args pos_help =
  if pos_help = 1 then
    args.(3)
  else
    args.(2)

let parsing args =
  let pos_help = get_help args in
  if Array.length args < 4  && pos_help = 1 then
    exit 1
  else if Array.length args < 3  && pos_help = -1 then
    (* rajout  d'un message d'erreur arg*)
    exit 1
  else
  let jsonfile = get_jsonfile args pos_help in
  let machine = parse_jsonfile jsonfile in
  let input = parse_input args pos_help in
  
  
