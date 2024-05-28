This is probably not the best way to do it and CPS is not really used either
but it works. Labels are also just numeric, which sucks too.

You can write stuff like:

```ocaml
let () = 
  let i = ref 10_000 in
  run [|
  0 >> begin fun goto -> 
    print_endline "Hello world!";
    goto 2
  end;
  1 >> begin fun goto -> 
    print_endline "Exit";
    goto 4
  end;
  2 >> begin fun goto ->
    i := !i - 1;
    if !i mod 2 = 0 then goto 3 else goto 2
  end;
  3 >> begin fun goto -> 
    i := (!i / 2) + 1;
    Printf.printf "%d\n" !i;
    if !i <= 1 then goto 1 else goto 2; 
  end;
  4 >> begin fun _goto -> 
    print_endline "Goodbye world!";
    exit 0
  end
  |]
```
