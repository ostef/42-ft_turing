open Machine
open Types


let () =
  
  let args = Sys.argv in
  let machine = 
    try
      Parsing.machine_parsing args
    with
    | Parsing_error msg -> print_endline msg; exit 1
    | Sys_error msg -> print_endline msg; exit 1
    | Yojson.Json_error msg -> Printf.eprintf "JSON format error: %s\n" msg; exit 1
    | Yojson.Basic.Util.Type_error (msg, _) ->  (* Remarque : le second argument correspond à la position de l'erreur *)
    Printf.eprintf "JSON format error: %s\n" msg;
    exit 1
  in
    machine

    (* parser d'abord la machine pour ensuite parser l'input selon le blank et l'alphabet de la machine *)
    (* ensuite utiliser la machine pour lancer turing et  *)
  (* Printf.printf "Result: %s\n" result *)
