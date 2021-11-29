
using LinearAlgebra

function r2d(x)
    return x*pi/180
end

v=[0.5;1;1]
M=[
v[1]*sin(r2d(-132)) v[2]*sin(r2d(97)) 0;
v[1]*cos(r2d(-132)) v[2]*cos(r2d(97)) 1
]

function to_2d(vector3d)
    return M*vector3d
end

I=[1 0 0; 0 1 0; 0 0 1]
function rotate_phi_z(v,phi)
    K=[
    0 -v[3] v[2];
    v[3] 0 -v[1];
    -v[2] v[1] 0
    ]
    vr=I+sin(phi)*K+(1-cos(phi))*K^2
    return vr
end

println(rotate_phi_z([1;0;0],3.14))
println(to_2d([1;2;3]))


x=[1;0;0]
y=[0;1;0]
z=[0;0;1]
#B=[x,y,z]
phi=3.14
x=rotate_phi_z(x,phi)
y=rotate_phi_z(y,phi)
z=rotate_phi_z(z,phi)
x=to_2d(x)
y=to_2d(y)
z=to_2d(z)
