
A=[1 2 3; 4 5 6; 7 8 9]

n=size(A)
println(n[1] == n[2] ? "square" : "non-square" , " matrix $n:")
for a=1:n[1]
    println(A[a,:])
end
#--------------------------------------------------
for i=1:n[2]
    for j=i+1:n[1]
        A[j,:]=A[i,i]*A[j,:]-A[j,i]*A[i,:]
    end
end
#--------------------------------------------------
println("triangulated:")
for a=1:n[1]
    println(A[a,:])
end
