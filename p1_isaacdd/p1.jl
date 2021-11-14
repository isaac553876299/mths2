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
Generates a random non-singular square matrix, A, of integers between -10 and 10
such that the inverse is formed by integers and a vector of the same kind and dimension.
=#

println("\nGeneration--------------------------------------------------")

using LinearAlgebra
using Random
#= a continuació es genera una matriu cuadrada aleatoria de dimensió arbitrària (n)
amb valors entre 10 i -10. i a més a més un vector de la mateixa dimensió per formar l'ampliada.
=#
n = 3 # Set the dimension of your matrix
A = rand(-10:10, (n,n))
A = UnitUpperTriangular(A)
A = A[shuffle(1:end), :]
A = A[:, shuffle(1:end)]

println("\nYour random ",n," x ",n," matrix is")
show(stdout, "text/plain", A)

b=rand(-10:10, n)
println("\n\nYour random vector is\n",b)

original=[A b]
M=original
println("\nYour ampliated matrix is")
show(stdout, "text/plain", M)

# read matrix from file

using DelimitedFiles
#= per tal de llegir de fitxers de text fem servir la llibreria DelimitedFiles i les funcions
readdlm i writedlm
=#
read_from_file = false
if read_from_file==true
    println("\n\nRead matrix from file")
    M=readdlm("m.txt")
    show(stdout, "text/plain", M)
end

# guardem el tamany de la matriu per a emprar-lo als bucles posteriors
n=size(M)
#println("\n n[1] = ",n[1]," n[2] = ",n[2])

# calibration

#= en aquest pas facilitem la feina i assegurem la matriu reordenant les seves files en funció
de la cantitat de zeros que contenen i comparant amb les següents, de manera que a priori ja
s'assembli a una triangulada.
=#
print("\n\nCalibration--------------------------------------------------\n\n")
for i=1:n[1]
    for i=1:n[1]-1
        count_a=0
        count_b=0
        for j=1:n[1]
            if M[i,j]==0 count_a+=1
            else break
            end
        end
        for j=1:n[1]
            if M[i+1,j]==0 count_b+=1
            else break
            end
        end
        if count_a>count_b
            tmp=M[i,:]
            M[i,:]=M[i+1,:]
            M[i+1,:]=tmp
        end
    end
end
show(stdout, "text/plain", M)

# triangulate

#= per triangular la matriu fent servir el procediment del pivot s'empra un doble bucle que recórre
un per un els pivots de la diagonal i realitza el càlcul necessari per transformar les files.
=#
print("\n\nTriangulation--------------------------------------------------")
for i=1:n[2]
    for j=i+1:n[1]
        if M[i,i]!=0
            println("\n\nFila$j = ", M[i,i], " * Fila$j - ", M[j,i], " * Fila$i\n")
            M[j,:]=M[i,i]*M[j,:]-M[j,i]*M[i,:]
            show(stdout, "text/plain", M)
        end
    end
end
println("\n\nYour triangulated matrix is")
show(stdout, "text/plain", M)

# backtracking

print("\n\nCalibration-----------------------(again)---------------------------\n\n")
for k=1:n[1]
    for i=1:n[1]-1
        count_a=0
        count_b=0
        for j=1:n[1]
            if M[i,j]==0 count_a+=1
            else break
            end
        end
        for j=1:n[1]
            if M[i+1,j]==0 count_b+=1
            else break
            end
        end
        if count_a>count_b
            tmp=M[i,:]
            M[i,:]=M[i+1,:]
            M[i+1,:]=tmp
        end
    end
end
show(stdout, "text/plain", M)

#= per a trobar la solució al sistema s'empra un doble bucle similar a l'anterior que desfà
fila per fila el valor que ha de tenir una variable en funció dels valors ja coneguts començant
per l'última fila, el càlcul de la qual es realitza en primer lloc per la seva simplicitat.
=#
println("\n\nBacktracking--------------------------------------------------\n")
amp=M[:,n[2]]
len=length(amp)
result=zeros(len)
print("result[$len] = ", M[len,len+1], " / ", M[len,len])
result[len]=M[len,len+1]/M[len,len]
println(" = ", result[len])
for i=len-1:-1:1
    print("result[$i] = (", amp[i])
    for j=len:-1:i
        print(" - (", M[i,j], " * ", result[j], ")")
        amp[i]-=M[i,j]*result[j]
    end
    result[i]=amp[i]/M[i,i]
    println(") / ",M[i,i]," = ", result[i])
end
println("\nresult ", result)

newr=A\b
println("\nx=A\\b = ",newr," (using julia)")

# print result and save to file

writedlm("result.txt", original)
writedlm("result.txt", M)
writedlm("result.txt", result)

# Isaac Digón Donaire
