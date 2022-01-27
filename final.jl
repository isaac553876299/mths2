#Isaac Digón Donaire

using LinearAlgebra, Quaternions

function axis_angle_to_mat(u,θ)
    R = cos(θ)*I + (1-cos(θ))*(u*u') + sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
    return R
end

function angle_segments(a, b)
    return acos(dot(a,b)/(norm(a)*norm(b)))
end

function axis_angle_to_quat(u,θ)
    q = [sin(θ/2)*u; cos(θ/2)]
    return q
end

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

function mat_to_axis_angle(m)
    θ = acos((tr(m)-1)/2)
    sm=[m[3,2]-m[2,3]; m[1,3]-m[3,1]; m[2,1]-m[1,2]]
    u=sm/norm(sm)
    return u,θ
end

function quat_to_axis_angle(q)
    qw = q[4]
    θ = 2*acos(qw)
    b = sqrt(1-qw^2)
    u = (0.0001 > b) ? [1 0 0] : [q[1]/b q[2]/b q[3]/b]
    return u,θ
end

oG=[0;0;0]
oA=[2.5003;-3.667;20]
oB=[4.053;5.250;20]

println("\n\n(a)")
R=axis_angle_to_mat([1;0;0],-30*pi/180)
A=[R oA; 0 0 0 1]
show(stdout, "text/plain", A)
println("\n\n(b)")
y_angle=angle_segments([oB,oG],[oB,oA])
R=axis_angle_to_mat([0;1;0],y_angle)
A=[R oB; 0 0 0 1]
show(stdout, "text/plain", A)
println("\n\n(c)")
kB=normalize([2;-1;-10])*200#normalize¿
println(kB)
println("\n\n(d)")
kG=oB+kB
println(kG)
println("\n\n(e)")
kA=kG-oA
println(kA)
println("\n\n(f)")
xyoG=[oG[1];oG[2]]
xyoA=[oA[1];oA[2]]
xykG=[kG[1];kG[2]]
α=angle_segments([xyoA,xyoG],[xyoA,xykG])
println(α)
println("\n\n(g)")
xzoG=[oG[1];oG[3]]
xzoA=[oA[1];oA[3]]
xzkG=[kG[1];kG[3]]
β=angle_segments([xzoA,xzoG],[xzoA,xzkG])
println(β)
println("\n\n(h)")
qα=axis_angle_to_quat([0;0;1],α)
qβ=axis_angle_to_quat([0;1;0],β)
q=Quaternion(qα[4],qα[1],qα[2],qα[3])*Quaternion(qβ[4],qβ[1],qβ[2],qβ[3])
R=quat_to_mat([q.v1;q.v2;q.v3;q.s])
A=[R kB; 0 0 0 1]
show(stdout, "text/plain", A)
println("\n\n(i)")
#=
The tandem teleportation can only be achieved
if invoked while both casters are no more
than 10 units away. Will complete the spell?
=#
distance=norm(oA-oB)
println(distance)



aa=[-1;2;4;-120*pi/180]
A=[
-0.428571 -0.613072 -0.663679;
0.898786 -0.214286 -0.382446;
0.0922502 -0.760411 0.642857]
println("\n\n b", mat_to_axis_angle(A))
q=Quaternion(1/2,0.18898,0.37796,0.75593)
q=[q.s;q.v1;q.v2;q.v3]
println("\n\n c", quat_to_axis_angle(q))
aa=[1;-2;-4;240*pi/180]



Robird=[1500;20;150]
q1=Quaternion(1/sqrt(2),0,0,1/sqrt(2))
PlaneDir=[1;4;1/4]
planeG=Robird+normalize(PlaneDir)*1150#normalize¿
println("\n\nplaneG: ", planeG)
println()
f=1/10
imagev=Quaternions.imag(q1*Quaternion(planeG)*conj(q1))
x=imagev[1]*f/imagev[3]
y=imagev[2]*f/imagev[3]
println("\n\nairplane image ", [x;y])
