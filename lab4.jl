using LinearAlgebra

# 1.
pA=[3;4]
pB=[-2.5;0.5]
Ba=[pA;1]
Bb=[pB;1]
angle=-60*pi/180
t1=0
t2=0
C=[cos(angle) -sin(angle) t1; sin(angle) cos(angle) t2; 0 0 1]*[-2.5; 0.5; 1]
println(C)
