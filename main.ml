open Machine
open Types
open Ft_turing

let print_usage () =
  print_endline "Usage: ft_turing [-h] jsonfile input";
  print_endline "";
  print_endline "positional arguments:";
  print_endline "  jsonfile    json description of the machine";
  print_endline "";
  print_endline "  input       input of the machine";
  print_endline "";
  print_endline "optional arguments:";
  print_endline "  -h, --help  show this help message and exit"

let run_machine machine input =
  ignore (execute_machine machine input)
  let () =
    match Array.to_list Sys.argv with
    | [_; "-h"] | [_; "--help"] -> print_usage ()
    | [_; jsonfile; input] ->
      let machine = 
        try
          Parsing.machine_parsing jsonfile
        with
        | Parsing_error msg -> print_endline msg; exit 1
        | Sys_error msg -> print_endline msg; exit 1
        | Yojson.Json_error msg -> Printf.eprintf "JSON format error: %s\n" msg; exit 1
        | Yojson.Basic.Util.Type_error (msg, _) -> 
          Printf.eprintf "JSON format error: %s\n" msg;
          exit 1
      in
      let input =
        try
          Parsing.parse_input input machine.alphabet machine.blank
        with
        | Input_error msg -> print_endline msg; exit 1
      in
      Machine.print_machine machine;
      (try
        run_machine machine input
      with
      | Read_Not_Found msg -> Printf.eprintf "Read not found: %s\n" msg; exit 1
      | Infinite_loop msg -> Printf.eprintf "Infinite loop: %s\n" msg; exit 1
      )
    | _ -> print_usage ()