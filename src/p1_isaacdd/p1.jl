#=
Escribir un código en JULIA capaz de resolver un sistema compatible determinado de n
ecuaciones con n incógnitas, A·x=b, mediante el método de Gauss usando la regla de los
pivotes.

La matriz cuadrada A y el vector b, de dimensión n arbitraria, deben ser introducidos
a través de un único fichero de texto.

Tras hacer 0 los elementos correspondientes en cada columna de la matriz ampliada,
el código debe imprimir por pantalla las operaciones por filas realizadas y la matriz
resultante de esas operaciones.

Finalmente, una vez triangulada la matriz, debe hacer backtracking para resolver el
sistema de ecuaciones.

El resultado final debe ser impreso por pantalla y escrito en otro fichero de texto.
El código debe estar comentado, de modo que en los comentarios se explique cada
paso seguido.

El código debe ser probado con problemas de dimensiones 2, 3 y 4 generados
aleatoriamente mediante el código generator.jl. Debe comprobarse que la solución
obtenida coincide con la que nos da Julia con la operación “x=A\b”.
=#


#= generator.jl
Generates a random non-singular sqaure matrix, A, of integers between -10 and 10
such that the inverse is formed by integers and a vector  of the same kind and dimension.
=#

using LinearAlgebra
using Random

n = 2 # Set the dimension of your matrix
A = rand(-10:10, (n,n))
A = UnitUpperTriangular(A)
A = A[shuffle(1:end), :]
A = A[:, shuffle(1:end)]

println("\n\nYour random ",n," x ",n," matrix is")
show(stdout, "text/plain", A)

b=rand(-10:10, n)
println("\n\nYour random vector is\n",b)

A=[A b]
println("\n\nYour ampliated matrix is")
show(stdout, "text/plain", A)


#= read matrix from file
=#

using DelimitedFiles

println("\n\nRead matrix from file")
A=readdlm("m.txt")
show(stdout, "text/plain", A)

#= triangulate
=#

n=size(A)
for i=1:n[2]
    for j=i+1:n[1]
        A[j,:]=A[i,i]*A[j,:]-A[j,i]*A[i,:]
        println("\n\nFila$j = ",A[i,i]," * Fila$j - ",A[j,i]," * Fila$i")
        show(stdout, "text/plain", A)
    end
end
println("\n\nYour triangulated matrix is")
show(stdout, "text/plain", A)


#= print result and save to file
=#

writedlm("result.txt",A)
