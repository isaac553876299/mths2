# les columnes de la matriu són les imatges de la base
# q=[cos(θ);sin(θ)*u]
# _q=[0;v]
# matriu afí: [[v1; v2; origen]; 0 0 1]*[x; y; 1]
    # rang 3 -> invertible -> B0*p0=B1*p1 -> inv(B1)*B0*p0=p1
#= MA:
[1 0 0 0]
[0 cos -sin 4]
[0 sin cos 1]
[0 0 0 1]
**041 is origin
**left is rotation x
** 0001 is afinee

**multiply by column vector of coordinates points
=#
angle=30*pi/180
M=[1 0 0; 0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)]
show(stdout, "text/plain", M)
println()
M=hcat(M,[0; 4; 1])
show(stdout, "text/plain", M)
