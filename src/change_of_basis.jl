
#--------------------------------------------------
#u=P*u'=Q*u"
#P=B1'
#Q=B2'
#u'=(P^-1)*Q*u"
#u"=(Q^-1)*P*u'

#u'=inv(B1')*B2'*u"
#u"=inv(B2')*B1'*u'
#--------------------------------------------------
B1=[1 0 0 0; 1 1 0 0; 1 1 1 0; 1 1 1 1]
B2=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]
ub1=[0; -1; 0; 1]
ub2=[-1; 0; 1; 0]
#--------------------------------------------------
u_1=inv(B1')*B2'*ub2; println("\nu_1=$u_1")
u_2=inv(B1')*B2'*ub1; println("\nu_2=$u_2")
#--------------------------------------------------
