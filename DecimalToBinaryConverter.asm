.data
    prompt:     .asciiz "Enter an integer: "
    array:      .space 0

.text
main:
    # prompt
    li $v0, 4            
    la $a0, prompt      
    syscall

    # Read an integer from the user
    li $v0, 5            
    syscall
    move $t0, $v0        # Move the entered integer to $t0

    # Calculate the number of bits needed
    li $t1, 0            # bit counter
    li $t2, 1            

find_bits_loop:
    bge $t0, $t2, bit_increment   # Exit loop if entered integer is less than or equal to the current power of 2
    j end_find_bits_loop

bit_increment:
    addi $t1, $t1, 1            # Increment the bit counter
    sll $t2, $t2, 1             # Double the current power of 2
    j find_bits_loop

end_find_bits_loop:
    
    # Calculate the size of the array (in bytes)
    sll $t1, $t1, 2     # Multiply the number of bits by 4 (shift left by 2)

    # Reserve space for the array based on the size calculated
    li $v0, 9            # System call code for sbrk (allocate memory)
    move $a0, $t1        # Move the size of the array to $a0
    syscall
    move $t4, $v0
    
    add $t5, $t4, $t1      # array pointer
    li $t6, 0         # Initialize $t6 to 0 for array index
    
loop_start:
    bge $t6, $t1, loop_end   # Exit loop if the array index is greater than or equal to the size

    div $t0, $t0, 2
    mflo $t7 
    mfhi $t8 
    sw $t8, 0($t5)

    #move $a0, $t8      # Move the concatenated number to $a0
    #li $v0, 1          # System call code for print integer
    #syscall
    
    add $t5, $t5, 4   # Go to the next index
    addi $t6, $t6, 1  # Increment array index
    bnez $t7, loop_start 

loop_end:
    
    move $t7, $t4    # reset array pointer to the beginning
    move $t8, $zero  # reset concatenated number to 0
    
sub $t9, $t1, 1
print_loop_start:
    bge $t6, $t9, print_loop_end   # Exit loop if the index is greater than or equal to the size

    lw $t5, 0($t7)   # Load the current element into $t5
    
    
    # Print the current bit
    li $v0, 1          # System call code for print integer
    move $a0, $t5      # Move the current bit to $a0
    syscall
    
    

    addi $t6, $t6, -1  # Increment array index
    add $t7, $t7, 4   # Increment the index

    # Print a delimiter (optional for better readability)
    #li $v0, 11         # System call code for print character
    #li $a0, 32         # ASCII code for space
    #syscall

    j print_loop_start

print_loop_end:
    
    #move $a0, $t8      # Move the concatenated number to $a0
    #li $v0, 1          # System call code for print integer
    #syscall

    # Exit the program
    li $v0, 10         # Exit system call code
    syscall
