(* $Id: double.ml,v 1.1 1998-01-15 08:34:38 garrigue Exp $ *)

class view togl :title as self =
  val togl = togl
  val title = title
  val mutable corner_x = 0.
  val mutable corner_y = 0.
  val mutable corner_z = 0.
  val font_base = Togl.load_bitmap_font togl font:`fixed_8x13
  val mutable x_angle = 0.
  val mutable y_angle = 0.
  val mutable z_angle = 0.

  method togl = togl

  method reshape =
    let width = Togl.width togl and height = Togl.height togl in
    let aspect = float width /. float height in
    Gl.viewport x:0 y:0 w:width h:height;
    (* Set up projection transform *)
    Gl.matrix_mode `projection;
    Gl.load_identity ();
    Gl.frustum
      left:(-.aspect) right:aspect bottom:(-1.0) top:1.0 near:1.0 far:10.0;
    corner_x <- -. aspect;
    corner_y <- -1.0;
    corner_z <- -1.1;
    (* Change back to model view transform for rendering *)
    Gl.matrix_mode `modelview

  method print_string s =
    Gl.list_base font_base;
    Gl.call_lists (`byte s)

  method display =
    Gl.clear [`color;`depth];
    Gl.load_identity();	(* Reset modelview matrix to the identity matrix *)
    Gl.translate z:(-3.0);      (* Move the camera back three units *)
    Gl.rotate angle:x_angle x:1.0;  (* Rotate by X, Y, and Z angles *)
    Gl.rotate angle:y_angle y:1.0;
    Gl.rotate angle:z_angle z:1.0;
    
    Gl.enable `depth_test;

    (* Front face *)
    Gl.begin_block `quads;
    Gl.color (0.0, 0.7, 0.1);	(* Green *)
    Gl.vertex3 (-1.0, 1.0, 1.0);
    Gl.vertex3(1.0, 1.0, 1.0);
    Gl.vertex3(1.0, -1.0, 1.0);
    Gl.vertex3(-1.0, -1.0, 1.0);
    (* Back face *)
    Gl.color (0.9, 1.0, 0.0);   (* Yellow *)
    Gl.vertex3(-1.0, 1.0, -1.0);
    Gl.vertex3(1.0, 1.0, -1.0);
    Gl.vertex3(1.0, -1.0, -1.0);
    Gl.vertex3(-1.0, -1.0, -1.0);
    (* Top side face *)
    Gl.color (0.2, 0.2, 1.0);   (* Blue *)
    Gl.vertex3(-1.0, 1.0, 1.0);
    Gl.vertex3(1.0, 1.0, 1.0);
    Gl.vertex3(1.0, 1.0, -1.0);
    Gl.vertex3(-1.0, 1.0, -1.0);
    (* Bottom side face *)
    Gl.color (0.7, 0.0, 0.1);   (* Red *)
    Gl.vertex3(-1.0, -1.0, 1.0);
    Gl.vertex3(1.0, -1.0, 1.0);
    Gl.vertex3(1.0, -1.0, -1.0);
    Gl.vertex3(-1.0, -1.0, -1.0);
    Gl.end_block();
   
    Gl.disable `depth_test;
    Gl.load_identity();
    Gl.color( 1.0, 1.0, 1.0 );
    Gl.raster_pos x:corner_x y:corner_y z:corner_z;
    self#print_string title;
    Togl.swap_buffers togl

  method x_angle a = x_angle <- a; Togl.render togl
  method y_angle a = y_angle <- a; Togl.render togl
  method z_angle a = z_angle <- a; Togl.render togl
end

let create_view :parent :double =
  new view
    (Togl.create :parent width:200 height:200 depth:true rgba:true :double)

open Tk

let main () =
  let top = openTk () in
  let f = Frame.create parent:top in
  let single = create_view parent:f double:false title:"Single buffer"
  and double = create_view parent:f double:true title:"Double buffer" in
  let sx =
    Scale.create parent:top label:"X Axis" from:0. to:360. orient:`Horizontal
      command:(fun x -> single#x_angle x; double#x_angle x)
  and sy =
    Scale.create parent:top label:"Y Axis" from:0. to:360. orient:`Horizontal
      command:(fun y -> single#y_angle y; double#y_angle y)
  and button =
    Button.create parent:top text:"Quit" command:(fun () -> destroy top)
  in

  List.iter [single;double] fun:
    begin fun o ->
      Togl.display_func o#togl cb:(fun () -> o#display);
      Togl.reshape_func o#togl cb:(fun () -> o#reshape);
      bind o#togl events:[[`Button1],`Motion] action:
	(`Set([`MouseX;`MouseY], fun ev ->
	  let width = Togl.width o#togl
	  and height =Togl.height o#togl
	  and x = ev.ev_MouseX
	  and y = ev.ev_MouseY in
	  let x_angle = 360. *. float y /. float height
	  and y_angle = 360. *. float (width - x) /. float width in
	  Scale.set sx to:x_angle;
	  Scale.set sy to:y_angle))
    end;

  pack [single#togl; double#togl] side:`Left padx:(`Pix 3) pady:(`Pix 3)
    fill:`Both expand:true;
  pack [f] fill:`Both expand:true;
  pack [coe sx; coe sy; coe button] fill:`X;
  mainLoop ()

let _ = main ()
