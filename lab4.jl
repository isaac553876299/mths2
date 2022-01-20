
using LinearAlgebra
using Quaternions

# 1.
pA=[3;4]
pB=[-2.5;0.5]
Ba=[pA;1]
Bb=[pB;1]
angle=-60*pi/180
# pA=aRb*pB+aDab
# pB=aRb^*pA-aRb^*aDab -> pB=bRa*pA-bDba
# AT=[I t; 0 0 0 1]
# AR=[R [0;0;0]; 0 0 0 1]
# AT*AR=A=[R t; 0 0 0 1]
# BAA=[bRa bDba; 0 0 0 1]
# AAB=[aRb aDab; 0 0 0 1]
R=[cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1]
A=[R (Ba-Bb); 0 0 0 1]
println(A)
qB=[3;1]
qA=R*Bb-(Ba-Bb)

oAb=Ba-Bb
println("oAb = $oAb")
oBa=Bb-Ba
println("oBa = $oBa")
println("qA = $qA")

# 2.
oBa=[3;1;-2]
oCb=[-3;1;-2]

v1c=[0;2;0]
v2c=[0;2;5]

q=(1/7)*[-7*sqrt(3)/2;3;-1;-3/2]
Q=Quaternion(q[1],q[2],q[3],q[4])
println(Q)
Q=normalize(Q)
println(Q)
function quat_to_mat(q)
    q1 = q[1]
    q2 = q[2]
    q3 = q[3]
    q4 = q[4]

    r1 = 2 * [((q4^2)+(q1^2)), (q1*q2-q4*q3), (q1*q3+q4*q2)]
    r1[1] -= 1
    r2 = 2 * [(q1*q2+q4*q3), ((q4^2)+(q2^2)), (q2*q3-q4*q1)]
    r2[2] -= 1
    r3 = 2 * [(q1*q3-q4*q2), (q2*q3+q4*q1), ((q4^2)+(q3^2))]
    r3[3] -= 1

    R = [r1 r2 r3]'
    return R
end
R=quat_to_mat(q)
A=[R oCb; 0 0 0 1]

w=[1;2;3]
qw=Quaternion(w)
qrw=Q*qw*conj(Q)
#imag(Q)
rw=[qrw.v1;qrw.v2;qrw.v3]
new_w=rw+oCb
println(new_w)
println(A*[w;1])


function axis_angle_to_mat(u,θ)
    R = cos(θ)*I + (1-cos(θ))*(u*u') + sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
    return R
end
Rz=axis_angle_to_mat([0;0;1],-25*pi/180)
Ry=axis_angle_to_mat([0;1;0],-145*pi/180)
Rx=axis_angle_to_mat([1;0;0],-30*pi/180)
R=Rz*Ry*Rx
show(stdout, "text/plain", R)
A=[R oBa; 0 0 0 1]
# 3.
println()
camera=[1;6;1]
f=1/34
Rz=axis_angle_to_mat([0;1;0],90*pi/180)
Ry=axis_angle_to_mat([0;0;1],-20*pi/180)
R=Rz*Ry
A=[R camera; 0 0 0 1]
using DelimitedFiles
circle_points=readdlm("circle.txt",'	')
points=Vector{Vector{Float64}}()
open("circle.txt") do file
    for p in eachline(file)
        p=split(p,"	")
        p=[parse(Float64, x) for x in p]
        push!(points,p)
    end
end

using Gtk, Graphics, Logging, Printf

win = GtkWindow("lab4.3.1")
canvas = @GtkCanvas(1000,500)
@guarded draw(canvas) do widget
    draw_the_canvas(canvas)
end
show(canvas)

function init_window(win, canvas)
    ex1 = GtkBox(:v)
    push!(ex1, canvas)
    push!(ex1, GtkLabel("ex1"))
    ex2 = GtkBox(:v)
    push!(ex2, canvas)
    push!(ex2, GtkLabel("ex2"))
    global_box = GtkBox(:h)
    push!(global_box, ex1)
    push!(global_box, ex2)
    push!(win, global_box)
end

function draw_the_canvas(canvas)
    h = height(canvas)
    w = width(canvas)
    ctx = getgc(canvas)
    #ex1
    rectangle(ctx, 0, 0, w/2, h)
    set_source_rgb(ctx, 1, 1, 1)
    fill(ctx)
    set_line_width(ctx, 2)
    move_to(ctx, 0, h/2)
    line_to(ctx, w, h/2)
    move_to(ctx, w/4, 0)
    line_to(ctx, w/4, h)
    set_source_rgb(ctx, 0, 0, 0)
    stroke(ctx)
    for p in points
        pc=A*[p;1]
        x=2000*f*pc[1]/pc[3]
        y=2000*f*pc[2]/pc[3]
        circle(ctx, x+w/4, y+h/2, 2)
    end
    set_source_rgb(ctx, 0.75,0,0)
    stroke(ctx)
    #
    set_line_width(ctx, 10)
    set_source_rgb(ctx, 0, 0, 0.75)
    move_to(ctx, w/2, 0)
    line_to(ctx, w/2, h)
    stroke(ctx)
    #ex2
    rectangle(ctx, w/2, 0, w, h)
    set_source_rgb(ctx, 1, 1, 1)
    fill(ctx)
    set_line_width(ctx, 2)
    move_to(ctx, w/2, h/2)
    line_to(ctx, w, h/2)
    move_to(ctx, w*3/4, 0)
    line_to(ctx, w*3/4, h)
    set_source_rgb(ctx, 0, 0, 0)
    stroke(ctx)
    for p in points
        pc=p
        x=2000*f*pc[1]/pc[3]
        y=2000*f*pc[2]/pc[3]
        circle(ctx, x+w*3/4, y+h/2, 2)
    end
    set_source_rgb(ctx, 0,0.75,0)
    stroke(ctx)
    cx=20*camera[1]/camera[3]
    cy=20*camera[2]/camera[3]
    circle(ctx, cx+w*3/4, cy+h/2, 10)
    set_source_rgb(ctx, 0.9,0.9,0)
    fill(ctx)
end

init_window(win, canvas)
showall(win)
# 4.
m=[
0.9115 3.7207 1.9659 2.6663;
1.9397 2.8794 1.0000 3.8191;
3.3304 4.4372 3.2588 4.5087]
a=m[:,1]
b=m[:,2]
c=m[:,3]
d=m[:,4]
sab=[a,b]
scd=[c,d]
oG=[4.665;3.735;-0.5395]
angle=-150*pi/180
u=[0.01;-0.2;1]

#println(intersect(sab,scd))

function anglee(a, b)
    return acosd(clamp(dot(a,b)/(norm(a)*norm(b)), -1, 1))
end
println(anglee(sab,scd))

println("\nfinished")
