#Isaac Digón Donaire

using LinearAlgebra

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


test_u = [0.2672612; 0.5345225; 0.8017837]
test_θ = 1.5040802
test_m = [0.1333333 -0.6666667 0.7333333; 0.9333333 0.3333333 0.1333333; -0.3333333 0.6666667 0.6666667]
test_q = [0.1825742 0.3651484 0.5477226 0.7302967]

println("\n axis_angle_to_mat =\n", axis_angle_to_mat(test_u, test_θ))
println("\n axis_angle_to_quat =\n", axis_angle_to_quat(test_u, test_θ))
println("\n mat_to_axis_angle =\n", mat_to_axis_angle(test_m))
println("\n mat_to_quat =\n", mat_to_quat(test_m))
println("\n quat_to_axis_angle =\n", quat_to_axis_angle(test_q))
println("\n quat_to_mat =\n", quat_to_mat(test_q))
