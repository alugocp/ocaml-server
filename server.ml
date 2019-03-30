open Cohttp_lwt_unix
open Yojson
open Printf
open Deter
open Lwt

let rec listify (json):int list list =
  let rec intify (list):int list =
    match list with
      | [] -> []
      | (`Int x)::rest -> x::(intify rest)
      | _ -> raise (Json_error "Does not support")
  in match json with
    | [] -> []
    | (`List l)::rest -> (intify l)::(listify rest)
    | _ -> raise (Json_error "Does not support")
;;

let server = begin
  let callback conn req body =
    body |> Cohttp_lwt.Body.to_string >|= (fun data ->
      eprintf "Body: %s\n" data;flush stderr;
      let json=Yojson.Basic.from_string data in
      match json with
        | (`List l) -> let m=(listify l) in let d=(determinant m) in (sprintf "%i\n" d)
        | _ -> raise (Json_error "Does not support")
    )
    >>= (fun body -> Server.respond_string ~status:`OK ~body ())
  in begin
    eprintf "Server is online\n";flush stderr;
    Server.create ~mode:(`TCP (`Port 2017)) (Server.make ~callback ())
  end
end

let _ = Lwt_main.run server
