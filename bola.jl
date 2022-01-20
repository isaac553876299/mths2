
using LinearAlgebra, Quaternions
using Gtk, Graphics, Logging, Printf

function axis_angle_to_mat(u,θ)
    R = cos(θ)*I + (1-cos(θ))*(u*u') + sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
    return R
end

win = GtkWindow("SO(3)")

canvas = @GtkCanvas(800,600)
@guarded draw(canvas) do widget
    draw_the_canvas(canvas)
end
show(canvas)

msg_label = GtkLabel("No message at this time")

default_value = Dict("v_x" => 0, "v_y" => 0, "v_z" => 0, "alpha" => 0, "q_x" => 0, "q_y" => 0, "q_z" => 0, "q_w" => 0)

entry_list = []
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

function normalize_q()
    q_x = read_original_box("q_x")
    q_y = read_original_box("q_y")
    q_z = read_original_box("q_z")
    q_w = read_original_box("q_w")

    q = normalize(Quaternion(q_x,q_y,q_z,q_w))

    output_normalized("q_x_normalized", q.x)
    output_normalized("q_y_normalized", q.y)
    output_normalized("q_z_normalized", q.z)
    output_normalized("q_w_normalized", q.w)
end

function normalize_alpha()
    output_normalized("alpha_normalized", read_original_box("alpha"))
end

function entry_box_callback(widget)
    name = get_gtk_property(widget, :name, String)
    text = get_gtk_property(widget, :text, String)

    GAccessor.text(msg_label, name * " changed to " * text)

    if name[1] == 'v'
        normalize_v()
    elseif name[1] == 'a'
        normalize_alpha()
    elseif name[1] == 'q'
        normalize_quat()
    end

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

function quat_angle_box()
    vbox = GtkBox(:v)
    push!(vbox, bold_label("quat"))
    for label in ["q_x", "q_y", "q_z", "q_w"]
        push!(vbox, entry_box(label))
    end
    return vbox
end

function init_window(win, canvas)
    control_box = GtkBox(:v)
    push!(control_box, vector_angle_box())
    push!(control_box, GtkLabel(""))
    push!(control_box, quat_angle_box())
    push!(control_box, GtkLabel(""))
    push!(control_box, msg_label)

    canvas_box = GtkBox(:v)
    push!(canvas_box, canvas)

    global_box = GtkBox(:h)
    push!(global_box, control_box)
    push!(global_box, GtkLabel("   ")) # a very basic separator
    push!(global_box, canvas_box)

    push!(win, global_box)
end

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

function draw_circle(ctx, cx, cy, axis, angle)
    R=axis_angle_to_mat(axis,(90*pi/180)+angle)
    for i in 1:180
        p=200*[cosd(2*i);sind(2*i)]
        p=R*[p;1]
        circle(ctx, cx + p[1], cy + p[2], 1)
        fill(ctx)
    end
end

function draw_the_canvas(canvas)
    h = height(canvas)
    w = width(canvas)
    ctx = getgc(canvas)

    rectangle(ctx, 0, 0, w, h)
    set_source_rgb(ctx, 1, 1, 1)
    fill(ctx)

    v_x = 50 * read_normalized_label("v_x_normalized")
    v_y = 50 * read_normalized_label("v_y_normalized")
    v_z = 50 * read_normalized_label("v_z_normalized")
    # 50* ???
    q_x = 50 * read_normalized_label("q_x_normalized")
    q_y = 50 * read_normalized_label("q_y_normalized")
    q_z = 50 * read_normalized_label("q_z_normalized")
    q_w = 50 * read_normalized_label("q_w_normalized")

    set_source_rgb(ctx, 1,0,0)
    draw_circle(ctx,w/2,h/2,[1;0;0],0)
    set_source_rgb(ctx, 0,1,0)
    draw_circle(ctx,w/2,h/2,[0;1;0],0)
    set_source_rgb(ctx, 0,0,1)
    draw_circle(ctx,w/2,h/2,[0;0;1],0)
end

init_window(win, canvas)
showall(win)
