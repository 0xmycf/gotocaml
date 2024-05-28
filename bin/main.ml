exception Goto of int

let rec label_runner idx cont =
  let goto new_idx =
    if Int.equal new_idx idx
    then label_runner idx cont 
    else raise (Goto new_idx)
  in
  cont goto

let label _name _cont = 
  _name, fun () -> label_runner _name _cont

let (>>) _name _cont = label _name _cont

let run blocks =
  let rec aux i =
    try 
      let (_, f) = blocks.(i) in
      f ();
      aux (succ i)
    with Goto i -> aux i
       | Invalid_argument _ -> print_endline "oopsie"
  in aux 0

let () =
  print_newline();
  let i = ref 0 in
  run [|
    0>> begin fun goto ->
      if !i < 10 then () else goto 1;
      Printf.printf "%d: Hello, OCaml!\n" !i;
      i := !i + 1;
      goto 0;
    end;
    1>> begin fun _goto ->
      print_endline "Goodbye, OCaml!";
    end;
    2>> begin fun goto ->
      i := 0;
      print_endline "Lets start anew";
      goto 0
    end
      |]
