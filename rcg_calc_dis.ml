open Pervasives;;

(*
type dis =
| Dis of float
;;

type agent_dis =
| A_teaminf of string
| Distance of dis
;;

type agent_dist =
| Agent_d of ( agent_dis * agent_dis)

type agent_distance =
| Record_dis of (sec * agent_dist list)
| Records_dis of (sec * agent_dist list) list
;;

*)

let rcg_matc op =
  match op with
  | Rcg_m(a) -> []
  | Rcg_p(a) -> []
  | Rcg_ab(a) -> [a]
;;

let rec rcg_matcrec =
  function
  | [] ->[]
  | h :: t -> rcg_matc h @ rcg_matcrec t
;;

(* elm -> agent_distance *)

let elm_agent e =
  match e with
  | Records(a) ->  (rcg_matcrec a)
  | _ -> failwith "fail calc_dis"
;;

let test_data = elm_agent rcg_data;;

let rec get_ball_x_y c =
  match c with
  | [] -> []
  | (Cycle num , rest) :: rest2 ->
    match rest with
    | [] -> failwith "fail"
    | Ball(B_Pos_x x,B_Pos_y y,B_V_x vx, B_V_y vy) :: t ->
      (x,y) :: get_ball_x_y rest2
    | _ -> failwith "fail"
;;

let ball_xy = get_ball_x_y test_data;;

let rec get_aget_ball_list c =
  match c with
  | [] -> []
  | (Cycle num , rest) :: rest2 ->
    match rest with
    | [] -> failwith "fail"
    | h :: t -> t :: get_aget_ball_list rest2
;;

let agent_xy = get_aget_ball_list test_data;;

(* !!! *)



(* !!! *)

let rec calc_distance agent ball_d =
  match agent with
  | [] -> []
  | Agent (Team str , Label l, Pos_x x, Pos_y y, V_x vx, V_y vy) :: rest
    ->
    begin
      match ball_d with
      | (h1,h2) :: t ->
        (str^" "^(string_of_float l) ,
         sqrt(((x -. h1) ** 2.0) +. (y -. h2) ** 2.0))
        :: calc_distance rest t
      | _ -> failwith "no ball"
    end
  | _ -> failwith "fail calc_distance"
;;

let rec calc_distance2 agent ball_d =
  match agent with
  | [] -> []
  | head :: rest -> calc_distance head ball_d:: calc_distance2 rest ball_d
;;

let ball_agent_distance = calc_distance2 agent_xy ball_xy;;

let rec minimum l m =
  match l with
  | [] ->
    begin
    match m with
    | (a,b) as t -> if b < 3.0 then t else ("None",0.0)
    end
  | (s,f) as a :: r ->
    begin
    match m with
    | (s2,f2) ->
      if f < f2
      then minimum r a
      else minimum r m
    end

;;

let rec ball_holder ba =
  match ba with
  | [] -> []
  | h :: t -> minimum h ("Start",10000.0) :: ball_holder t
;;

let bf = ball_holder ball_agent_distance;;

let create_number_file filename strnum_tup =
  let outc = Out_channel.create "file-test.txt" in
  List.iter strnum_tup ~f:(fun (x,y) -> fprintf outc "%s, %f\n" x y);
  Out_channel.close outc
;;


create_number_file "file-test.txt" bf;;
