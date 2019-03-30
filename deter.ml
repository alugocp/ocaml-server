open Printf
open List

let rec determinant (x:int list list):int =
  let l=(length x) in
  if l=2 then
    let ad=(nth (nth x 0) 0)*(nth (nth x 1) 1) in
    let bc=(nth (nth x 1) 0)*(nth (nth x 0) 1) in
    ad-bc
  else
    let total=ref 0 in
    for a=0 to (l-1) do
      let coef=if (a mod 2)=0 then 1 else -1 in
      let next:(int list list ref)=ref [] in
      for b=1 to (l-1) do
        let row:(int list ref)=ref [] in
        for c=0 to (l-1) do
          if c!=a then row:=(!row)@[(nth (nth x b) c)]
        done;
        next:=(!next)@[!row]
      done;
      total:=(!total)+(coef*(nth (nth x 0) a)*(determinant !next))
    done;
    !total
;;
