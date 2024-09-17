    addi x12, x0, 6
    addi x5, x0, 2
    addi x6, x0, 1
    blt x12, x5, end1
    add x28, x12, x0 
    j check1

end1:
	addi x28, x0, 1
    j end

check1:
	bge x12, x5, loop1
    j end

loop1:
	sub x7, x12, x6 
    addi x10, x0, 0
    j check2

check2:
    bge x7, x6, loop2
    j load

loop2:
	add x10, x10, x28
    sub x7, x7, x6
    j check2
    
load:
	add x28, x0, x10
    sub x12, x12, x6
    j check1
end:  
	sw x28, 0(x0)
    lw x1, 0(x0)
    j end
 
