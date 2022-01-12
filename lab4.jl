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
using DelimitedFiles
circle_points=readdlm("circle.txt",'	')
Rz=axis_angle_to_mat([0;0;1],20*pi/180)
Ry=axis_angle_to_mat([0;1;0],-90*pi/180)
R=Rz*Ry
f=1/34
open("circle.txt") do file
    for p in eachline(file)
        println(p)
        #p=[f*[p[1];p[2]]]*R
        println(p)
    end
end

using Gtk, Graphics, Logging, Printf

win = GtkWindow("lab4.3.1")

function init_canvas(h,w)
    c = @GtkCanvas(h,w)
    @guarded draw(c) do widget
        draw_the_canvas(c)
    end
    show(c)
    return c
end

the_canvas = init_canvas(500,500)

function init_window(win, canvas)
    canvas_box = GtkBox(:v)
    push!(canvas_box, canvas)
    global_box = GtkBox(:h)
    push!(global_box, canvas_box)
    push!(win, global_box)
end

function draw_the_canvas(canvas)
    h = height(canvas)
    w = width(canvas)
    ctx = getgc(canvas)
    rectangle(ctx, 0, 0, w, h)
    set_source_rgb(ctx, 1, 1, 1)
    fill(ctx)

    #v_v=to_2d(v)
    set_line_width(ctx, 5)
    set_source_rgb(ctx, 0, 0, 0)
    move_to(ctx, 250, 250)
    line_to(ctx, w/2,h/2)
    stroke(ctx)
    circle(ctx, w/2,h/2, 100)
    set_source_rgb(ctx, 0.5,0.5,0.5)
    fill(ctx)

end

init_window(win, the_canvas)
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
oG=[4.665;3.735;-0.5395]
a=-150*pi/180
u=[0.01;-0.2;1]
println("\nfinished")
