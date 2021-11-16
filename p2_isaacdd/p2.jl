

# eje-ángulo -> R -> eje-ángulo
k=rand(-10:10,3);
println(" k = ", k)
K=[0 -k[3] k[2]; k[3] 0 -k[1]; -k[2] k[1] 0]
show(stdout,"text/plain", K)
println("\n k' * K = ", k'*K)
using LinearAlgebra
phi=pi*(1/2)
R=I+K*sin(phi)+K*K*(1-cos(phi))
show(stdout,"text/plain", R)
# R'*R==I columnas base ortonormal
# det(R)==1 conserva orientación
println("\n R * k = ", R*k)
# R*k=I*k -> (R-I)*k=0 compatible indeterminado -> resulta vector !=0 en el eje solo si det(R-I)==0
# det(R-I)=det((R-I)')=det(R'-I')=det(R'-R'*R)=det(R'*(I-R))=det(R')*det(I-R)=det(R)*-det(R-I)
# -> 1*-det(R-I) -> det(R-I)=-det(R-I) -> det=0
println(" det(R) == det(R') = ", det(R))
k=zeros(3)\(R-I)
println("\n (R-I) * k = 0 -> k = ", k)
# sin(phi)=-(1/2)*tr(K*R) -> K=[0 -kz ky; kz 0 -kx; -ky kx 0]
K=[0 -k[3] k[2]; k[3] 0 -k[1]; -k[2] k[1] 0]
show(stdout,"text/plain", K)
phi=asin(-(1/2)*tr(K*R))
println("\n phi = asin(-(1/2) * tr(K * R)) = ", phi)

#=
quaterniones, números complejos en esteroides (a+bi -> i^2 == -1)
q = a + bi + cj + dk
i^2 = j^2 = k^2 = -1
ij = k = -ji }
jk = i = -kj  } ijk = -1
ki = j = -ik }
=#
