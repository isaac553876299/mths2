using LinearAlgebra

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
oAb=Bb-Ba
oBa=Ba-Bb
qB=[3;1]
qA=R*Bb-(Ba-Bb)
println("oAb = $oAb")
println("oBa = $oBa")
println("qA = $qA")

# 2.
oBa=[3;1;-2]
oCb=[-3;1;-2]

# 3.

# 4.
a=[0.9115;1.9397;3.3304]
b=[3.7207;2.8794;4.4372]
c=[1.9659;1.0000;3.2588]
d=[2.6663;3.8191;4.5087]
m=[a b c d]
show(stdout, "text/plain", m)
oG=[4.665;3.735;-0.5395]
a=-150*pi/180
u=[0.01;-0.2;1]
