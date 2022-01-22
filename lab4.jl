
using LinearAlgebra
using Quaternions
using DelimitedFiles
using Gtk, Graphics, Logging, Printf


function ex1()
    pA=[3;4]
    pB=[-2.5;0.5]
    angle=-60*pi/180
    R=[cos(angle) -sin(angle); sin(angle) cos(angle)]
    pBa=R*pB
    A=[R (pA-pBa); 0 0 1]
    oAb=inv(A)*[0;0;1]
    println("oAb = $oAb")
    oBa=A*[0;0;1]
    println("oBa = $oBa")
    qB=[3;1]
    qA=A*[qB;1]
    println("qA = $qA")
end

function ex2()
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
    rr=rotationmatrix(Q)
    R=quat_to_mat(q)
    show(stdout, "text/plain", rr)
    println()
    show(stdout, "text/plain", R)
    println()
    #A=[R oCb; 0 0 0 1]
    #expresión afín -> w = q*w*q'+oCb
    w=[1;2;3]
    #println(A*w)
    q=Q*Quaternion(w)*conj(Q)
    println()
    #xx=[xx.v1,xx.v2,xx.v3]+oCb
    println(xx)
    println()
    function axis_angle_to_mat(u,θ)
        R = cos(θ)*I + (1-cos(θ))*(u*u') + sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
        return R
    end
    Rz=axis_angle_to_mat([0;0;1],-25*pi/180)
    Ry=axis_angle_to_mat([0;1;0],-145*pi/180)
    Rx=axis_angle_to_mat([1;0;0],-30*pi/180)
    R=Rz*Ry*Rx
    A=[R oBa; 0 0 0 1]
    A=inv(A)
    show(stdout, "text/plain", A)
end

function ex3()
    println()
    camera=[1;6;1]
    f=1/34
    Ry=axis_angle_to_mat([0;1;0],90*pi/180)
    Rz=axis_angle_to_mat([0;0;1],-20*pi/180)
    R=Ry*Rz
    A=[R camera; 0 0 0 1]
    #circle_points=readdlm("circle.txt",'	')
    points=Vector{Vector{Float64}}()
    open("circle.txt") do file
        for p in eachline(file)
            p=split(p,"	")
            p=[parse(Float64, x) for x in p]
            push!(points,p)
        end
    end
    function ex_3_1()
        win_3_1 = GtkWindow("lab4.3.1")
        canvas_3_1 = @GtkCanvas(500,500)
        @guarded draw(canvas_3_1) do widget
            draw_3_1(canvas_3_1)
        end
        show(canvas_3_1)
        box_3_1 = GtkBox(:v)
        push!(box_3_1, GtkLabel("view from camera"))
        push!(box_3_1, canvas_3_1)
        push!(win_3_1, box_3_1)
        function draw_3_1(canvas)
            h = height(canvas)
            w = width(canvas)
            ctx = getgc(canvas)
            rectangle(ctx, 0, 0, w, h)
            set_source_rgb(ctx, 1, 1, 1)
            fill(ctx)
            set_line_width(ctx, 2)
            move_to(ctx, 0, h/2)
            line_to(ctx, w, h/2)
            move_to(ctx, w/2, 0)
            line_to(ctx, w/2, h)
            set_source_rgb(ctx, 0, 0, 0)
            stroke(ctx)
            for p in points
                pc=A*[p;1]
                x=5000*f*pc[1]/pc[3]
                y=5000*f*pc[2]/pc[3]
                circle(ctx, x+w/2, y+h/2, 2)
            end
            set_source_rgb(ctx, 0.75,0,0)
            stroke(ctx)
        end
        showall(win_3_1)
    end
    function ex_3_2()
        win_3_2 = GtkWindow("lab4.3.2")
        canvas_3_2 = @GtkCanvas(500,500)
        @guarded draw(canvas_3_2) do widget
            draw_3_2(canvas_3_2)
        end
        show(canvas_3_2)
        box_3_2 = GtkBox(:v)
        push!(box_3_2, GtkLabel("view 3d scene"))
        push!(box_3_2, canvas_3_2)
        push!(win_3_2, box_3_2)
        function draw_3_2(canvas)
            h = height(canvas)
            w = width(canvas)
            ctx = getgc(canvas)
            rectangle(ctx, 0, 0, w, h)
            set_source_rgb(ctx, 1, 1, 1)
            fill(ctx)
            set_line_width(ctx, 2)
            move_to(ctx, 0, h/2)
            line_to(ctx, w, h/2)
            move_to(ctx, w/2, 0)
            line_to(ctx, w/2, h)
            set_source_rgb(ctx, 0, 0, 0)
            stroke(ctx)
            for p in points
                pc=p
                x=30*pc[1]
                y=30*pc[2]
                circle(ctx, x+w/2, y+h/2, 2)
            end
            set_source_rgb(ctx, 0,0.75,0)
            stroke(ctx)
            cx=30*camera[1]
            cy=30*camera[2]
            cam=[cx+w/2;cy+h/2]
            circle(ctx, cam[1], cam[2], 5)
            set_source_rgb(ctx, 0.9,0.9,0)
            fill(ctx)
        end
        showall(win_3_2)
    end
    ex_3_1()
    ex_3_2()
end

function ex4()
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
end

println("\n----------ex1----------")
ex1()
println("\n----------ex2----------")
ex2()
println("\n----------ex3----------")
ex3()
println("\n----------ex4----------")
ex4()
println("\n----------finished----------")
