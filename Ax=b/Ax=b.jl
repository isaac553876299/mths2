
A=[1 2 3; 4 5 6; 7 8 9]

n=size(A)
show(stdout, "text/plain", A)
#--------------------------------------------------
for i=1:n[2]
    for j=i+1:n[1]
        A[j,:]=A[i,i]*A[j,:]-A[j,i]*A[i,:]
    end
end
#--------------------------------------------------
println("\ntriangulated:")
show(stdout, "text/plain", A)
