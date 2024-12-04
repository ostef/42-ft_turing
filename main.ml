let main () =
  
  let args = Sys.argv in
  let machine_and_input = Parsing.parsing args in
  machine_and_input

let () =
  let result = main () in
  ()
  (* Printf.printf "Result: %s\n" result *)
