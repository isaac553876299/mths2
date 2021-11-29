
function to_2d()

end

function rotate_phi_z(vector,phi)
    R=[cos(phi) -sin(phi) 0; sin(phi) cos(phi) 0; 0 0 1]
    show(stdout,"text/plain",R)
    println()
    show(stdout,"text/plain",vector*R)
end

rotate_phi_z([1 0 0],3.14)
