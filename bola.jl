
using LinearAlgebra, Quaternions
using Gtk, Graphics, Logging, Printf

function axis_angle_to_mat(u,θ)
    R = cos(θ)*I + (1-cos(θ))*(u*u') + sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
    return R
end

function axis_angle_to_quat(u,θ)
    q = [sin(θ/2)*u; cos(θ/2)]
    return q
end

function mat_to_axis_angle(m)
    θ = acos((tr(m)-1)/2)
    sm=[m[3,2]-m[2,3]; m[1,3]-m[3,1]; m[2,1]-m[1,2]]
    u=sm/norm(sm)
    return u,θ
end

function mat_to_quat(m)
    m00 = m[1, 1]
    m11 = m[2, 2]
    m22 = m[3, 3]
    q = [0.0; 0.0; 0.0; 0.0]
    q[1] = sqrt(max(0, 1+m00-m11-m22))/2;
    q[2] = sqrt(max(0, 1-m00+m11-m22))/2;
    q[3] = sqrt(max(0, 1-m00-m11+m22))/2;
    q[4] = sqrt(max(0, 1+m00+m11+m22))/2;
    return q
end

function quat_to_axis_angle(q)
    qw = q[4]
    θ = 2*acos(qw)
    b = sqrt(1-qw^2)
    u = (0.0001 > b) ? [1 0 0] : [q[1]/b q[2]/b q[3]/b]
    return u,θ
end

function quat_to_mat(q)
    q1 = q[2]
    q2 = q[3]
    q3 = q[4]
    q4 = q[1]
    #julia takes quaternion real part first
    #but on 2nd assignment i take it last as q[4]
    #so for this assignment i change it to q[1]

    r1 = 2 * [((q4^2)+(q1^2)), (q1*q2-q4*q3), (q1*q3+q4*q2)]
    r1[1] -= 1
    r2 = 2 * [(q1*q2+q4*q3), ((q4^2)+(q2^2)), (q2*q3-q4*q1)]
    r2[2] -= 1
    r3 = 2 * [(q1*q3-q4*q2), (q2*q3+q4*q1), ((q4^2)+(q3^2))]
    r3[3] -= 1

    R = [r1 r2 r3]'
    return R
end


win = GtkWindow("SO(3)")

canvas = @GtkCanvas(800,600)
@guarded draw(canvas) do widget
    draw_the_canvas(canvas)
end
show(canvas)

msg_label = GtkLabel("No message at this time")

default_value = Dict(
"v_x" => 0, "v_y" => 0, "v_z" => 0,
"alpha" => 0,
"q_x" => 0, "q_y" => 0, "q_z" => 0, "q_w" => 0,
"m11" => 0, "m12" => 0, "m13" => 0,
"m21" => 0, "m22" => 0, "m23" => 0,
"m31" => 0, "m32" => 0, "m33" => 0)

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

    q = Quaternion(q_w,q_x,q_y,q_z)
    q = normalize(q)

    output_normalized("q_x_normalized", q.v1)
    output_normalized("q_y_normalized", q.v2)
    output_normalized("q_z_normalized", q.v3)
    output_normalized("q_w_normalized", q.s)
end

function normalize_alpha()
    output_normalized("alpha_normalized", read_original_box("alpha"))
end

function update_from_v()
    normalize_v()
    v=[
    read_normalized_label("v_x_normalized"),
    read_normalized_label("v_y_normalized"),
    read_normalized_label("v_z_normalized")]
    a=read_normalized_label("alpha_normalized")
    q=axis_angle_to_quat(v,a)
    q=normalize(q)
    output_normalized("q_x_normalized", q[1])
    output_normalized("q_y_normalized", q[2])
    output_normalized("q_z_normalized", q[3])
    output_normalized("q_w_normalized", q[4])
    m=axis_angle_to_mat(v,a)
    output_normalized("m11", m[1])
    output_normalized("m12", m[2])
    output_normalized("m13", m[3])
    output_normalized("m21", m[4])
    output_normalized("m22", m[5])
    output_normalized("m23", m[6])
    output_normalized("m31", m[7])
    output_normalized("m32", m[8])
    output_normalized("m33", m[9])
end
function update_from_alpha()
    normalize_alpha()
    a=read_normalized_label("alpha_normalized")
    v=[
    read_normalized_label("v_x_normalized"),
    read_normalized_label("v_y_normalized"),
    read_normalized_label("v_z_normalized")]
    q=axis_angle_to_quat(v,a)
    q=normalize(q)
    output_normalized("q_x_normalized", q[1])
    output_normalized("q_y_normalized", q[2])
    output_normalized("q_z_normalized", q[3])
    output_normalized("q_w_normalized", q[4])
    m=axis_angle_to_mat(v,a)
    output_normalized("m11", m[1])
    output_normalized("m12", m[2])
    output_normalized("m13", m[3])
    output_normalized("m21", m[4])
    output_normalized("m22", m[5])
    output_normalized("m23", m[6])
    output_normalized("m31", m[7])
    output_normalized("m32", m[8])
    output_normalized("m33", m[9])
end
function update_from_q()
    normalize_q()
    q=[
    read_normalized_label("q_x_normalized"),
    read_normalized_label("q_y_normalized"),
    read_normalized_label("q_z_normalized"),
    read_normalized_label("q_w_normalized")]
    (v,a)=quat_to_axis_angle(q)
    v=normalize(v)
    output_normalized("v_x_normalized", v[1])
    output_normalized("v_y_normalized", v[2])
    output_normalized("v_z_normalized", v[3])
    output_normalized("alpha_normalized", a)
    m=axis_angle_to_mat(v,a)
    output_normalized("m11", m[1])
    output_normalized("m12", m[2])
    output_normalized("m13", m[3])
    output_normalized("m21", m[4])
    output_normalized("m22", m[5])
    output_normalized("m23", m[6])
    output_normalized("m31", m[7])
    output_normalized("m32", m[8])
    output_normalized("m33", m[9])
end

function entry_box_callback(widget)
    name = get_gtk_property(widget, :name, String)
    text = get_gtk_property(widget, :text, String)

    GAccessor.text(msg_label, name * " changed to " * text)

    if name[1] == 'v'
        update_from_v()
    elseif name[1] == 'a'
        update_from_alpha()
    elseif name[1] == 'q'
        update_from_q()
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

function quat_box()
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
    push!(control_box, quat_box())
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

function draw_circle(ctx, center, axis, angle)
    R=axis_angle_to_mat(axis,(90*pi/180)+angle)
    for i in 1:180
        p=200*[cosd(2*i);sind(2*i)]
        p=R*[p;1]
        circle(ctx, center[1] + p[1], center[2] + p[2], 1)
        fill(ctx)
    end
end

function reduzir(vector, scale, tras)
    if scale==0
        vector=normalize(vector)
    else
        vector=vector*scale
    end
    vector=vector+tras
    return vector
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

    q_x = read_normalized_label("q_x_normalized")
    q_y = read_normalized_label("q_y_normalized")
    q_z = read_normalized_label("q_z_normalized")
    q_w = read_normalized_label("q_w_normalized")

    center = [w/2;h/2]
    set_source_rgb(ctx, 1,0,0)
    draw_circle(ctx, center, [1;0;0], 0)
    set_source_rgb(ctx, 0,1,0)
    draw_circle(ctx, center, [0;1;0], 0)
    set_source_rgb(ctx, 0,0,1)
    draw_circle(ctx, center, [0;0;1], 0)
end

init_window(win, canvas)
showall(win)
