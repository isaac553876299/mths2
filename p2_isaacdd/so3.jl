#by Isaac Digón Donaire

using LinearAlgebra

function r2d(x)
    return x*pi/180
end

# first exercise
v=[0.5;1;1]
M=[v[1]*sin(r2d(-132)) v[2]*sin(r2d(97)) 0;
v[1]*cos(r2d(-132)) v[2]*cos(r2d(97)) 1]

# second exercise
function to_2d(vector3d)
    return M*vector3d
end

# third exercise
function rotate_phi_z(v,phi)
    z=[0;0;1]
    K=[
    0 -z[3] z[2];
    z[3] 0 -z[1];
    -z[2] z[1] 0
    ]
    r=(I+sin(phi)*K+(1-cos(phi))*K^2)
    return r*v
end

# the packages we need
using Gtk, Graphics, Logging, Printf

# the main window
win = GtkWindow("SO(3)")

function init_canvas(h,w)
    # create the drawing canvas
    c = @GtkCanvas(h,w)

    # create the initial drawing inside a try/catch loop
    @guarded draw(c) do widget
        #  draw the background with the canvas drawing context
        # the code for this comes later
        draw_the_canvas(c)
    end

    show(c)
    return c
end

# make the canvas
the_canvas = init_canvas(500,500)


# --------- part 2 -------------
# define all the widgets

# a widget for status messages that we define at the beginning so we can use it from the callback
msg_label = GtkLabel("No message at this time")

# defaults
default_value = Dict("phi" => 10, "v_x" => 1, "v_y" => 0, "v_z" => 0, "alpha" => 70)

# an array to store the entry boxes
entry_list = []

# an array of labels that we use to display normalized inputs,
# and which also gets modified from the callback
normalized_labels = []

function find_by_name(list, name)
    for item in list
        if get_gtk_property(item, :name, String) == name
            return item
        end
    end
    @warn name, "not found in list"
    @warn "available names are"
    for item in list
        @warn get_gtk_property(item, :name, String)
    end
end

function output_normalized(label, value)
    GAccessor.text(find_by_name(normalized_labels, label), @sprintf("%3.2f", value))
end

function normalize_v()
    v_x = read_original_box("v_x")
    v_y = read_original_box("v_y")
    v_z = read_original_box("v_z")

    norm = sqrt(v_x*v_x + v_y*v_y + v_z*v_z)

    output_normalized("v_x_normalized", v_x / norm)
    output_normalized("v_y_normalized", v_y / norm)
    output_normalized("v_z_normalized", v_z / norm)
end

function normalize_alpha()
    output_normalized("alpha_normalized", read_original_box("alpha"))
end

function normalize_phi()
    output_normalized("phi_normalized", read_original_box("phi"))
end


function entry_box_callback(widget)
    # who called us?
    name = get_gtk_property(widget, :name, String)
    text = get_gtk_property(widget, :text, String)

    # trumpet this out to the world
    GAccessor.text(msg_label, name * " changed to " * text)

    # change the correct normalized output
    if name[1] == 'v'
        normalize_v()
    elseif name[1] == 'a'
        normalize_alpha()
    elseif name[1] == 'p'
        normalize_phi()
    end

    # actually draw the changes
    draw_the_canvas(the_canvas)
    reveal(the_canvas)
end

function entry_box(label_string)
    # set up the entry
    entry = GtkEntry()
    set_gtk_property!(entry,:width_chars, 5)
    set_gtk_property!(entry,:max_length, 5)
    set_gtk_property!(entry,:name, label_string)

    default_text = string(default_value[label_string])
    GAccessor.text(entry, default_text)
    push!(entry_list, entry)

    # make it communicate changes
    signal_connect(entry_box_callback, entry, "changed")

    # set up the label and normalized output
    label = GtkLabel(label_string)
    normalized_output = GtkLabel(default_text)
    set_gtk_property!(normalized_output, :name, label_string * "_normalized")

    # make and return the containing box
    hbox = GtkButtonBox(:h)
    push!(hbox, label)
    push!(hbox, entry)
    push!(hbox, normalized_output)

    # export the normalized output for further use
    push!(normalized_labels, normalized_output)

    return hbox
end

function bold_label(label_string)
    label = GtkLabel("")
    GAccessor.markup(label, """<b>""" * label_string * """</b>""")
    return label
end

function phi_box()
    vbox = GtkBox(:v)
    push!(vbox, bold_label("Coordinate rotation"))
    push!(vbox, entry_box("phi"))
    return vbox
end

function vector_angle_box()
    vbox = GtkBox(:v)

    push!(vbox, bold_label("Axis"))

    for label in ["v_x", "v_y", "v_z"]
        push!(vbox, entry_box(label))
    end

    push!(vbox, bold_label("Angle"))

    push!(vbox, entry_box("alpha"))
    return vbox
end

# Now put everything into the window,
# including the canvas

function init_window(win, canvas)

    # make a vertically stacked box for the data entry widgets
    control_box = GtkBox(:v)
    push!(control_box, phi_box())
    push!(control_box, GtkLabel(""))
    push!(control_box, vector_angle_box())
    push!(control_box, GtkLabel(""))
    push!(control_box, msg_label)

    # make another box for the drawing canvas
    canvas_box = GtkBox(:v)
    push!(canvas_box, canvas)

    # make a containing box that will stack the widgets and the canvas side by side
    global_box = GtkBox(:h)
    push!(global_box, control_box)
    push!(global_box, GtkLabel("   ")) # a very basic separator
    push!(global_box, canvas_box)

    # put it all inside the window
    push!(win, global_box)
end


# --------- part 3 -------------
# now we make the canvas interactive

function read_box(name, from_which_list, what)
    the_box = find_by_name(from_which_list, name)
    result = parse(Float64, get_gtk_property(the_box, what, String))
    return result
end

function read_original_box(name)
    return read_box(name, entry_list, :text)
end

function read_normalized_label(name)
    return read_box(name, normalized_labels, :label)
end

# the background drawing
# fourth exercise
function draw_the_canvas(canvas)
    h   = height(canvas)
    w   =  width(canvas)
    ctx =  getgc(canvas)

    # clear the canvas
    rectangle(ctx, 0, 0, w, h)
    set_source_rgb(ctx, 1, 1, 1)
    fill(ctx)

    # read some normalized boxes and draw a line
    phi = 5  * read_normalized_label("phi_normalized")
    v_x = 50 * read_normalized_label("v_x_normalized")
    v_y = 50 * read_normalized_label("v_y_normalized")
    v_z = 50 * read_normalized_label("v_z_normalized")

    V=[v_x,v_y,v_z]
    v=rotate_phi_z(V,phi)
    v_v=to_2d(v)
    set_line_width(ctx, 5)
    set_source_rgb(ctx, 0, 0, 0)
    move_to(ctx, 250, 250)
    line_to(ctx, w/2+V[1],h/2-V[2])
    stroke(ctx)
    circle(ctx, w/2+V[1],h/2-V[2], 5)
    set_source_rgb(ctx, 0.5,0.5,0.5)
    fill(ctx)

    x=rotate_phi_z([1;0;0],phi)
    y=rotate_phi_z([0;1;0],phi)
    z=rotate_phi_z([0;0;1],phi)
    vx=to_2d(x)
    vy=to_2d(y)
    vz=to_2d(z)

    set_line_width(ctx, 5)
    set_source_rgb(ctx, 1, 0, 0)
    move_to(ctx, 250, 250)
    line_to(ctx, w/2+vx[1]*100,h/2-vx[2]*100)
    stroke(ctx)
    circle(ctx, w/2+vx[1]*100,h/2-vx[2]*100, 5)
    set_source_rgb(ctx, 0.5,0.5,0.5)
    fill(ctx)

    set_line_width(ctx, 5)
    set_source_rgb(ctx, 0, 1, 0)
    move_to(ctx, 250, 250)
    line_to(ctx, w/2+vy[1]*100,h/2-vy[2]*100)
    stroke(ctx)
    circle(ctx, w/2+vy[1]*100,h/2-vy[2]*100, 5)
    set_source_rgb(ctx, 0.5,0.5,0.5)
    fill(ctx)

    set_line_width(ctx, 5)
    set_source_rgb(ctx, 0, 0, 1)
    move_to(ctx, 250, 250)
    line_to(ctx, w/2+vz[1]*100,h/2-vz[2]*100)
    stroke(ctx)
    circle(ctx, w/2+vz[1]*100,h/2-vz[2]*100, 5)
    set_source_rgb(ctx, 0.5,0.5,0.5)
    fill(ctx)

end


# -------- initialize everything ---------


# prepare and show the initial widgets
init_window(win, the_canvas)
showall(win)
