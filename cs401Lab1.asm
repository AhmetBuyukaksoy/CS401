.data

array: .word 2,3, 0 # final 0 indicates the end of the array; 0 is excluded; it should return TRUE for this array
sum: .word 3

true: .asciiz "TRUE\n"
false: .asciiz "FALSE\n"
default: .asciiz "This is just a template. It always returns "

.text

main:
      la $a0, array 	# $a0 has the address of the array "arr"
      lw $a1, sum   	# $a1 has the "sum"
      
      jal lenArray  	# Find the lenght of the array
      
      move $a2, $v0  	# $a2 has the length of the array, "n"
        
      jal subsetSum

      bne $v0, 0,  yes
      
      la  $a0, false
      li $v0, 4
      syscall 
      j exit

yes:  la    $a0, true
      li $v0, 4
      syscall

exit:
      li $v0, 10
      syscall


subsetSum:
###############################################
#   Your code goes here
###############################################
 	addi $sp, $sp, -16
 	sw $ra, 0($sp) 
 	sw $s0, 4($sp)  # return value of 1st recursion
 	sw $s1, 8($sp)  # sum
 	sw $s2, 12($sp) # n
 	move $s1, $a1   # store $a1 for next calls
 	move $s2, $a2   # store $a2 for next calls
 	
 	bne $s1, 0, L2 # if sum != 0 then go to L2
 	j subsetFound  # else sum==0, and subset is found
 	
 	L2:

 	bne $s2, 0, L3 # if num != 0 and a2 != 0 then recurse
 	j subsetNotFound # else num==0 there is no subset
 	

	L3: #recursive calls here
 	addi $s2, $s2, -1 # n = n - 1
 	move $a1, $s1
 	move $a2, $s2 
	jal subsetSum # call with arr, sum, n-1
 	
 	move $s0, $v0 #store the result of the 1st recursive call
 	
 	li $t1, 4         
 	mult $t1, $s2     # 4 * (n - 1)
 	mflo $t1
 	add $t1, $t1, $a0      # Calculate the memory address offset
	lw $t2, 0($t1)
 	sub $s1, $s1, $t2     # sum - array[n-1]
 	move $a1, $s1
 	move $a2, $s2
 	jal subsetSum  # call with arr, sum-array[n-1], n-1
 	or $v0, $v0,$s0
 	j subsetSumEnd
 		
 	subsetFound:
 	li $v0, 1
 	j subsetSumEnd
 	
 	subsetNotFound:
 	li $v0, 0
 	j subsetSumEnd
 	
 	subsetSumEnd:
 	lw $ra, 0($sp) # restore registers
 	lw $s0, 4($sp)
 	lw $s1, 8($sp)
 	lw $s2, 12($sp)
 	addi $sp, $sp, 16 # restore stack pointer
 		 
 		     		
###############################################
# Everything in between should be deleted
###############################################
      jr $ra	

lenArray:       #Fn returns the number of elements in an array
      addi $sp, $sp, -8
      sw $ra,0($sp)
      sw $a0,4($sp)
      li $t1, 0

laWhile:       
      lw $t2, 0($a0)
      beq $t2, $0, endLaWh
      addi $t1,$t1,1
      addi $a0, $a0, 4
      j laWhile

endLaWh:
      move $v0, $t1
      lw $ra, 0($sp)
      lw $a0, 4($sp)
      addi $sp, $sp, 8
      jr $ra
