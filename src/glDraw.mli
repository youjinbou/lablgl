(* $Id: glDraw.mli,v 1.1 1998-01-29 11:45:45 garrigue Exp $ *)

open Gl

val color : rgb -> ?alpha:float -> unit
    (* Sets the current color *)
val index : float -> unit
    (* Sets the current index *)
val cull_face : face -> unit
    (* Specifies which faces are candidates for culling *)
val front_face : [ccw cw] -> unit
    (* Specifies wether front faces are clockwise or not *)
val edge_flag : bool -> unit
val line_width : float -> unit
val line_stipple : short -> ?factor:int -> unit
    (* [line_stipple pattern :factor] sets the line stipple to the
       16-bit integer [pattern]. Each bit is used [factor] times *)
val point_size : float -> unit
val polygon_mode : face:face -> [fill line point] -> unit
val polygon_stipple : GlPix.bitmap -> unit

val shade_model : [flat smooth] -> unit

val normal : ?x:float -> ?y:float -> ?z:float -> unit
val normal3 : vect3 -> unit
    (* [glNormal] *)

val rect : point2 -> point2 -> unit

type shape =
  [line_loop line_strip lines points polygon quad_strip quads triangle_fan
   triangle_strip triangles]
val begins : shape -> unit
val ends : unit -> unit

val vertex : x:float -> y:float -> ?z:float -> ?w:float -> unit
val vertex2 : point2 -> unit
val vertex3 : point3 -> unit
val vertex4 : point4 -> unit

val viewport : x:int -> y:int -> w:int -> h:int -> unit
