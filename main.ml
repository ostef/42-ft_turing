let () =
  
  let args = Sys.argv in
  Parsing.parsing args;

  (* peut etre retourner un array avec machine et input puis appeler execute_input? *)