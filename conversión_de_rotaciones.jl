

function axis_angle_to_mat(θ,u)
    return #= R= =#I+sin(θ)*u+(1-cos(θ))*(u^2)
    #return #= R= =#(1-cos(θ))*I+sin(θ)*u+(1-cos(θ))*((u^2)+I)
    #Rodrigues'?
    #cos(θ)*I+sin(θ)*u+(1-cos(θ))*(uXu)
end


function axis_angle_to_quat(θ,u)
    return #= q= =#[cos(θ);sin(θ)*u]
end


function mat_to_axis_angle(m)
    θ=acos((tr(m)-1)/2)
    u=((m-m')/2)*sin(θ)
end


function mat_to_quat(m)
    m00 = m[0][0]
    m11 = m[1][1]
    m22 = m[2][2]
    absQ2 = det(m)^(1/3)
    #https://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/christian.htm
    q.w = sqrt(max(0, 1 + m00 + m11 + m22)) / 2;
    q.x = sqrt(max(0, 1 + m00 - m11 - m22)) / 2;
    q.y = sqrt(max(0, 1 - m00 + m11 - m22)) / 2;
    q.z = sqrt(max(0, 1 - m00 - m11 + m22)) / 2;
end


function quat_to_axis_angle(q)
    qw=q.w
    θ = 2 * acos(q.w)
    u.x = q.x / sqrt(1-qw^2)
    u.y = q.y / sqrt(1-qw^2)
    u.z = q.z / sqrt(1-qw^2)
end


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

    r00 = 2 * (q0^2 + q1^2) - 1
    r01 = 2 * (q1 * q2 - q0 * q3)
    r02 = 2 * (q1 * q3 + q0 * q2)

    r10 = 2 * (q1 * q2 + q0 * q3)
    r11 = 2 * (q0^2 + q2^2) - 1
    r12 = 2 * (q2 * q3 - q0 * q1)

    r20 = 2 * (q1 * q3 - q0 * q2)
    r21 = 2 * (q2 * q3 + q0 * q1)
    r22 = 2 * (q0^2 + q3^2) - 1

    R = [[r00, r01, r02], [r10, r11, r12], [r20, r21, r22]]
end
