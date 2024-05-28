exception Exit of string

let rec label_runner _name cont =
  let goto name =
    if String.equal name _name
    then label_runner _name cont 
    else raise @@ Exit name
  in
  cont goto

let label _name _cont = 
  _name, fun () -> label_runner _name _cont

let (>>) _name _cont = label _name _cont

let getn key haystack = 
  let rec go i = function
    | (k, _) :: _ when k = key -> Some i
    | _ :: tl -> go (succ i) tl
    | [] -> None
  in go 0 haystack

let drop n lst =
  let rec go i = function
    | _ :: tl when i > 0 -> go (pred i) tl
    | lst -> lst
  in go n lst

let run blocks =
  let rec aux ls =
    try 
      match ls with
      | (_, f) :: tl -> f (); aux tl
      | [] -> ()
    with Exit name ->
      match getn name blocks with
      | Some i -> aux begin drop i blocks end
      | None -> ()
  in aux blocks

let () =
  print_newline();
  let i = ref 0 in
  run [
    "loop">> begin fun goto ->
      if !i < 10 then () else goto "end";
      Printf.printf "%d: Hello, OCaml!\n" !i;
      i := !i + 1;
      goto "loop";
    end;
    "end">> begin fun _goto ->
      print_endline "Goodbye, OCaml!";
    end;
    "_">> begin fun goto ->
      i := 0;
      print_endline "lets start anew";
      goto "loop"
    end
  ]
