# Generates a random non-singular sqaure matrix, A, of integers between -10 and 10
# such that the inverse is formed by integers and a vector  of the same kind and dimension.

using LinearAlgebra
using Random

n = 2 # Set the dimension of your matrix
A = rand(-10:10, (n,n))
A = UnitUpperTriangular(A)
A = A[shuffle(1:end), :]
A = A[:, shuffle(1:end)]

println("Your random ",n," x ",n," matrix is")
show(stdout, "text/plain", A)

b=rand(-10:10, n)
println("\n\nYour random vector is\n",b)
