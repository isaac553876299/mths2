
using LinearAlgebra

function axis_angle_to_mat(u,θ)
    #R=I+sin(θ)*u+(1-cos(θ))*(u^2)
    #return #= R= =#(1-cos(θ))*I+sin(θ)*u+(1-cos(θ))*((u^2)+I)
    #Rodrigues'?
    #cos(θ)*I+sin(θ)*u+(1-cos(θ))*(uXu)
    R = cos(θ)*I+#=(1-cos(θ))*(cross(u,u))+=#sin(θ)*[0 -u[3] u[2]; u[3] 0 -u[1]; -u[2] u[1] 0]
    return R
end
u=[1; 0; 0]
θ=1/2
print("axis_angle_to_mat($u, $θ) = ")
println(axis_angle_to_mat(u, θ))

function axis_angle_to_quat(u,θ)
    q = [cos(θ); sin(θ)*u]
    return q
end
u=[1; 0; 0]
θ=1/2
print("axis_angle_to_quat($u, $θ) = ")
println(axis_angle_to_quat(u, θ))

function mat_to_axis_angle(m)
    θ = acos((tr(m)-1)/2)
    #u = ((m-m')/2)*sin(θ)
    u = (m-m')
    #sm=[m[3,2]-m[2,3]; m[1,3]-m[3,1]; m[2,1]-m[1,2]]
    #s=sqrt(magnitude(sm))
    #u=sm/s
    return θ,u
end
m=[1 0 0; 0 0.88 -0.48; 0 0.48 0.88]
print("mat_to_axis_angle($m) = ")
println(mat_to_axis_angle(m))

function mat_to_quat(m)
    m00 = m[1, 1]
    m11 = m[2, 2]
    m22 = m[3, 3]
    #absQ2 = det(m)^(1/3)
    #https://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/christian.htm
    q = [0; 0; 0; 0]
    q[1] = sqrt(max(0, 1+m00+m11+m22))/2;
    #q[2] = sqrt(max(0, 1+m00-m11-m22))/2;
    #q[3] = sqrt(max(0, 1-m00+m11-m22))/2;
    #q[4] = sqrt(max(0, 1-m00-m11+m22))/2;
    return q
end
m=[1 0 0; 0 0.88 -0.48; 0 0.48 0.88]
print("mat_to_quat($m) = ")
println(mat_to_quat(m))

function quat_to_axis_angle(q)
    qw = q[1]
    θ = 2*acos(qw)
    u = [q[2]/sqrt(1-qw^2), q[3]/sqrt(1-qw^2), q[4]/sqrt(1-qw^2)]
    return u,θ
end
q=[1;2;3;4]
print("quat_to_axis_angle($q) = ")
println(quat_to_axis_angle(q))

function quat_to_mat(q)
    q0 = q[1]#01ww
    q1 = q[2]#12ix
    q2 = q[3]#23jy
    q3 = q[4]#34kz

    r1 = 2 * [((q0^2)+(q1^2)), (q1*q2-q0*q3), (q1*q3+q0*q2)]
    r1[1] -= 1
    r2 = 2 * [(q1*q2+q0*q3), ((q0^2)+(q2^2)), (q2*q3-q0*q1)]
    r2[2] -= 1
    r3 = 2 * [(q1*q3-q0*q2), (q2*q3+q0*q1), ((q0^2)+(q3^2))]
    r3[3] -= 1

    R = [r1, r2, r3]
    #R = [[r00, r01, r02], [r10, r11, r12], [r20, r21, r22]]
    return R
end
q=[1; 0.5; 0.3; 0.2]
print("quat_to_mat($q) = ")
println(quat_to_mat(q))
