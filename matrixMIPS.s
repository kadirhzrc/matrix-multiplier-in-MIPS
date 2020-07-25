.data

# Matrix arrays for question 2
matrix1Text:	.space	100
matrix2Text:	.space 	100
firstMatrix:	.space  200
secondMatrix:	.space	200
resultMatrix:	.space  200

# For menu
main_menu: .asciiz "\n\nMain Menu:\n1. Square Root Approximate\n2. Matrix Multiplication\n3. Palindrome\n4. Exit\nPlease select an option: "
menu_greeting:	.asciiz "\n\nWelcome to our MIPS project!"
exit_message:	.asciiz "\nProgram ends. Bye :)"

# For 1st question
promptIter:	.asciiz "Enter the number of iteration for the series: "
printA:		.asciiz "a: 1 "
printB:		.asciiz "b: 1 "
space:		.asciiz " "
nextLine:	.asciiz "\n"

# For 2nd question
prompt1:	.asciiz "Enter the first matrix: "
prompt2:	.asciiz "Enter the second matrix: "
prompt3:	.asciiz "Enter the first dimension of first matrix: "
prompt4:	.asciiz "Enter the second dimension of first matrix: "
prompt5:	.asciiz "Multiplication matrix:"

# For 3rd question
question3_message: .asciiz "Enter an input string: "
question3_palindrome: .asciiz " is a palindrome."
question3_notpalindrome: .asciiz " is not a palindrome."
input_string: .space 100
.text


main:
	li $v0, 4		# Print greeting message
	la $a0, menu_greeting
	syscall
	
	li $v0, 4		# Print main menu
	la $a0, main_menu
	syscall			# Take option input from the user
	li $v0, 5
	syscall
	add $s0, $zero, $v0	# Write selected option to s0
	beq $s0, 1, question1
	beq $s0, 2, question2
	beq $s0, 3, question3
	beq $s0, 4, exit
	j clear_registers	# Clear all registers then jump back to main
	
question1:
	li $v0, 4 # Set to print string
	la $a0, promptIter # Ask user for input
	syscall
	
	# Go to nextline
	li $v0, 4
	la $a0, nextLine
	syscall
	
	# Set input to v0
	li $v0, 5
	syscall
	
	# Move input to a3
	move $a3, $v0
	
	# Set loop control register s2 to 1 (not 0 because initial values (1) are not calculated)
	addi $s2, $zero, 1
	
	# Set a and b
	addi $a1, $zero, 1  # a=1
	addi $a2, $zero, 1  # b=1
	
	# Print a = 1
	li $v0, 4 # Set to print string
	la $a0, printA # Print iteration text
	syscall
	j getA

# Calculation of a and printing is implemented here
getA:	
	slt $t1,$s2,$a3      # t1=1 if s2 < a3, else t1=0
	beq $t1, $zero, resetValues
	
	# Copy a to a temp variable
	move $t2, $a1
	
	add $t0, $a2, $a2  # assign 2*b to t0
	add $a1, $t0, $a1  # a=2b+a
	add $a2, $t2, $a2 # b=a+b
	
	# Print a's value
	move $a0, $a1
	li $v0, 1
	syscall
	
	# Print space
	li $v0, 4 
	la $a0, space 
	syscall
	
	# Increment iterator variable
	addi $s2, $s2, 1
	j getA
	
resetValues:	# Reset to initial values
	addi $a1, $zero, 1  # a=1
	addi $a2, $zero, 1  # b=1
	addi $s2, $zero, 1  # iterator=0
	
	# Go to nextline
	li $v0, 4
	la $a0, nextLine
	syscall
	
	li $v0, 4 
	la $a0, printB 
	syscall
	j getB

# Calculation of b and printing is implemented here
getB:	
	slt $t1,$s2,$a3      # t1=1 if s2 < a3, else t1=0
	beq $t1, $zero, clear_registers
	
	# Copy a to a temp variable
	move $t2, $a1
	
	add $t0, $a2, $a2  # assign 2*b to t0
	add $a1, $t0, $a1  # a=2b+a
	add $a2, $t2, $a2 # b=a+b
	
	# Print b's value
	move $a0, $a2
	li $v0, 1
	syscall
	
	# Print space
	li $v0, 4
	la $a0, space 
	syscall
	
	# Increment iterator variable
	addi $s2, $s2, 1
	j getB

question2:
	li $v0, 4 # Set to print string
	la $a0, prompt1 # Ask for first matrix
	syscall

	li $v0, 8 # Set to read string
	la $a0, matrix1Text # Get string
	li $a1, 100
	syscall
	
	move $t2, $a0	# t2 points to the matrix1 string
	move $s5, $t2
	add $t1, $zero, $zero
	
	li $v0, 4 # Set to print string
	la $a0, prompt2 # Print prompt2
	syscall

	li $v0, 8 # Set to read string
	la $a0, matrix2Text # Ask for second matrix
	li $a1, 100
	syscall
	
	add $t2, $a0, $zero	
	move $s6, $t2	# s6 points to the 2nd matrix string
	
	li $v0, 4 # Set to print string
	la $a0, prompt3 # Ask for 1st matrix row
	syscall
	
	li $v0, 5 # Set to read int
	syscall
	
	move $s2, $v0	# Move 1st dimension of 1st array to s2
	
	li $v0, 4 # Set to print string
	la $a0, prompt4 # Ask for 1st matrix column
	syscall
	
	li $v0, 5 # Set to read int
	syscall
	
	move $s3, $v0	# move 2nd dimension of 1st array to s3
	
	mul $s4, $s2, $s3	# Calculate total number of elements in 1st matrix
	move $t2, $s5
	
	
	move $t7, $zero
	j countChr
	
# Counts how many chars are there in first matrix string
countChr:  
  	lb $t0, 0($s5)  # Load the first byte from address in $t0  
   	beqz $t0, rest   # if $t0 == 0 then go to label
    	add $s5, $s5, 1      # else increment the address  
   	add $t7, $t7, 1 # increment counter
   	j countChr      # Loop back 
    
rest:	
	sub $t7, $t7, 1	# Subtract end of line character
	
	la $s0, firstMatrix # Set matrix array address to s0
	move $s1, $s0	# s1 for iterating in the array
	
	move $t4, $zero
	addi $t5, $zero, 1
	j LoopString
	
LoopString:
	
	lb $t0, 0($t2)	# grabbed a char to t0
	# check if space
	j checkSpace
	
checkSpace:
	# if it is space, skip to next iteration of char by incrementing char iterator and jump to beginning of the loop
	# if it is not space, modify char and go back
	
	# check if at the limit
	beq $t1, $t7, moveOn
	
	li $t3, ' '
    	beq $t0, $t3, isSpace
    	# if it isn't space
    	
    	# Multiply previous sum by 10
    	mul $t4, $t4, 10
    	
    	andi $t0, $t0, 0x0F	# Convert to int by subtracting 0x0F
    	add $t4, $t4, $t0	# Sum current value with previous value
    	
    	# Increment t2
    	addi $t2, $t2, 1
    	addi $t1, $t1, 1
    	j LoopString
    	
# If the character is a space
isSpace:
	# Save current value in t4 to matrix
	addi $t5, $t5, 1
	
	li $v0, 4 # Set to print string
	la $a0, space # Print space
	syscall
	
	sw $t4, 0($s1)
    	addi $s1, $s1, 4	# increment by 4 as it's an integer array
    	move $t4, $zero		# Reset current value register
    	
	# Increment loop register
	addi $t2, $t2, 1
	addi $t1, $t1, 1
	j LoopString

# 1st matrix integer conversion is successful. Proceed to 2nd matrix
moveOn:
	# Store last value from 1st matrix
	sw $t4, 0($s1)
	
	# Reset registers
	move $t3, $s6
	move $t4, $s6
	move $t7, $zero
	move $t6, $zero
	li $t5, ' '	# t5 is now space 
	j countChr2

# Counts number of characters in 2nd matrix string
countChr2:  
  	lb $t0, 0($t3)  # Load the first byte from address in $t0  
   	beqz $t0, spaceCalc   # if $t0 == 0 then go to label end  
    	add $t3, $t3, 1      # else increment the address  
   	add $t7, $t7, 1 # and increment the counter
   	j countChr2      # Loop back

# Counts number of space characters as well to calculate 2nd matrix's dimensions	
spaceCalc:	# count spaces in 2nd matrix
	lb $t0, 0($t4)  # Load the first byte from address in $t0 
	beqz $t0, calcMatrix2Column
	beq $t0, $t5, increment
	
	addi $t4, $t4, 1
	j spaceCalc
	

increment:
	addi $t6, $t6, 1
	addi $t4, $t4, 1
	j spaceCalc
	
# Calculates matrix 2 column number
calcMatrix2Column:
	addi $t6, $t6, 1
	move $s1, $t6
	div $s1, $s1, $s3	# get column number for 2nd matrix
	j setMatrix2
	
# Configures integer array for 2nd matrix	
setMatrix2:
	sub $t7, $t7, 1
	
	la $a3, secondMatrix #initial address at s0
	move $a1, $a3	#s1 for iterating in the array
	
	move $t4, $zero
	addi $t5, $zero, 1
	
	# Reset registers to default values
	move $t2, $s6
	move $t1, $zero
	move $t4, $zero
	j LoopString2

# Convert 2nd matrix string to integer array
LoopString2:
	lb $t0, 0($t2)	# grabbed a char to t0
	# check if space
	j checkSpace2
	
checkSpace2:
	# if it is space, skip to next iteration of char by incrementing char iterator and jump to beginning of the loop
	# if it is not space, modify char and go back
	
	# check if at the limit
	beq $t1, $t7, moveOn2
	
	li $t3, ' '
    	beq $t0, $t3, isSpace2
    	# if it isn't space
    	
    	# multiply previous sum by 10
    	mul $t4, $t4, 10
    	
    	andi $t0, $t0, 0x0F	# convert to int
    	add $t4, $t4, $t0	# Sum prev and current
    	
    	# check if its the last matrix element, if yes, move to another section
    	# if not, increment text iterator and continue the loop
    	
    	# Increment t2
    	addi $t2, $t2, 1
    	addi $t1, $t1, 1
    	j LoopString2
    	
    	
isSpace2:
	# Push value of t4 to array
	addi $t5, $t5, 1
	
	sw $t4, 0($a1)
    	addi $a1, $a1, 4	# increment by 4 as its int
    	move $t4, $zero		# Reset matrix value
    	
	# Increment loop reg
	addi $t2, $t2, 1
	addi $t1, $t1, 1
	j LoopString2
	
# Completed conversion of string to array for 2nd matrix. Move onto multiplication.
moveOn2:
	sw $t4, 0($a1)
		
	la $a2, resultMatrix # Initial address at a2
	
	# Reset registers
	move $t0, $zero
	move $t1, $zero
	move $t2, $s0
	move $t3, $a3
	move $t4, $a2
	move $t7, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
	move $t8, $zero
	move $v0, $zero

# Where the skeleton multiplication process happens
multiply:
	move $s5, $zero
	beq $s3, $t0, nextColumn	# When enough columns are iterated, change address of t3 to 2nd matrix's next column
	
	lw $t5, 0($t2)	# t2 for first matrix
	lw $t6, 0($t3)	# t3 for second matrix
	
	mul $t7, $t5, $t6	# Multiply elements
	add $s4, $s4, $t7	# Sum with previous value
	
	j nextIter
	
nextIter:
	addi $t2, $t2, 4	# Increment first matrix address
	
	addi $t0, $t0, 1	# When enough columns are iterated, change address of t3 to 2nd matrix's next column
	j nextIterPart2

nextIterPart2:	# Move 2nd matrix's address forward to 1 column size further
	beq $s1, $s5, multiply
	addi $t3, $t3, 4
	addi $s5, $s5, 1
	
	j nextIterPart2
	
nextColumn:
	addi $t1, $t1, 1
	move $s6, $zero
	move $t9, $zero
	
	sw $s4, 0($t4)
	addi $t4, $t4, 4
	
	# check if there is more column
	beq $t1, $s1, nextRow
	# if not, prepare for next column
	move $t3, $a3
	j updatRow
	
updatRow:	# When 2nd matrix address is adjusted, 1st matrix address also need to be adjusted back to its first row element
	move $t2, $s0
	move $t9, $zero
	move $v0, $zero
	
	j upRow3
	
upRow:
	beq $t8, $t9, continue
	move $v0, $zero
	j setRow
setRow:
	beq $s3, $v0, upRow
	addi $t2, $t2, 4
	addi $v0, $v0, 1
	
	
continue:	
	move $s4, $zero # Set some register values to 0
	move $t0, $zero	
	
	# and move it as much as t1, columns iterated
	j iterColumn
iterColumn:
	beq $s6, $t1, multiply
	addi $t3, $t3, 4
	addi $s6, $s6, 1
	j iterColumn
	
nextRow:
	addi $t8, $t8, 1
	beq $s2, $t8, q2_exit	# Go to exit when 1st matrix rows are completed
	
	# Revert some registers back to their default values
	move $t3, $a3
	move $t2, $s0
	move $t9, $zero
	move $v0, $zero
	move $t0, $zero
	move $t1, $zero
	move $s4, $zero
	j upRow2
	
upRow2:
	beq $t8, $t9, continue2
	move $v0, $zero
	j setRow2
	
setRow2:
	beq $s3, $v0, inc2
	addi $t2, $t2, 4
	addi $v0, $v0, 1
	j setRow2
	
inc2:
	addi $t9, $t9, 1
	j upRow2
	
continue2:
	j multiply
	
# Used for 1st matrix row update when 2nd matrix's column changes
upRow3:
	beq $t8, $t9, continue3
	move $v0, $zero
	j setRow3
	
setRow3:
	beq $s3, $v0, inc3
	addi $t2, $t2, 4
	addi $v0, $v0, 1
	j setRow3
	
inc3:
	addi $t9, $t9, 1
	j upRow3
	
continue3:
	j upRow
	
q2_exit:	
	move $t0, $zero
	move $t1, $zero
	move $t2, $zero
	mul $t1, $s2, $s1
	
	li $v0, 4 # Set to print string
	la $a0, nextLine # Print nextline
	syscall
	
	li $v0, 4 # Set to print string
	la $a0, nextLine # Print nextline
	syscall
	
	li $v0, 4 # Set to print string
	la $a0, prompt5 # Print result matrix
	syscall
	
	li $v0, 4 # Set to print string
	la $a0, nextLine # Print nextline
	syscall
	
	j printResult
	
# Prints result matrix
printResult:
	beq $t1, $t0, clear_registers
	
	# Access to result matrix register
	lw $t4, 0($a2)
	li $v0, 1
	move $a0, $t4
	syscall
	
	li $v0, 4 # Set to print string
	la $a0, space # Print space
	syscall
	
	addi $a2, $a2, 4
	addi $t0, $t0, 1
	
	addi $t2, $t2, 1
	beq $s1, $t2, printNewline

	j printResult

printNewline:
	move $t2, $zero
	
	li $v0, 4 # Set to print string
	la $a0, nextLine # Print nextline
	syscall
	
	j printResult
	

question3:
	
	la $s1 input_string
	
	
	li $v0, 4					# print input message
	la $a0, question3_message
	syscall

	li $v0, 8					# take input string from user
	la $a0, input_string
	li $a1, 100
	syscall
	

	add $a0, $s1, $zero
	jal lowercase			# Lowercase all letters in the input screen
	addi $s0, $v0, 0
	
	add $a0, $s1, $zero
	add $a1, $s0, $zero	
	jal checkPalindrome		# check the input string palindrome or not
	
	la $a0, input_string
	add $a1, $s0, $zero
	jal clearString			# clear the input string
	
	
	j clear_registers
	
checkPalindrome:
	# start to compare first char and last char of input
	add $t0, $a1, $a0
	sb $zero, 0($t0)
	addi $t0, $t0, -1
	palindromeLoop:
		lb $t1, 0($a0)		# load first char to t1
		lb $t2, 0($t0)		# load last char to t2
		
		bne $t1, $t2, notPalindrome		# if  char's is not equel so input string is not palindrome
		
		addi $a0, $a0, 1	# next char
		addi $t0, $t0, -1	# previous char
		
		slt $t3, $t0, $a0
		beq $t3, $zero, palindromeLoop		# if first_count is bigger than last_count so, input string is palindrome
		li $v0, 4
		la $a0, input_string
		syscall
		li $v0, 4
		la $a0, question3_palindrome
		syscall
		jr $ra
		
notPalindrome:
	li $v0, 4
	la $a0, input_string
	syscall
	li $v0, 4
	la $a0, question3_notpalindrome
	syscall
	jr $ra
			

lowercase:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	add $s0, $zero, $zero
	add $t1, $zero, $zero		# return input length
	lowercaseLoop:
		lb $s0, 0($a0)
		
		# if the character's ascii code is not between 65 and 91 ( 65 - 90  is lowercase letters )  do not process the char
		slti $t0, $s0, 65	
		bne $t0, $zero, conditionLetter
		slti $t0, $s0, 91
		beq $t0, $zero, conditionLetter
		addi $s0, $s0, 32		# if char is uppercase increase 32 
		sb $s0, 0($a0)
		conditionLetter:
			addi $a0, $a0, 1
			addi $t1, $t1, 1
			bne $s0, 10, lowercaseLoop		# at the end of the input string finish loop
			addi $t1, $t1, -1
			lw $s0, 0($sp)
			addi $sp, $sp, 4
			addi $v0, $t1, 0
			jr $ra			# return
			
clearString:				# clearString(String, length)
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	add $s0, $zero, $zero
	
	clear_loop:
		add $t0, $s0, $a0
		sb $zero, 0($t0)
		
		addi $s0, $s0, 1
		bne $s0, $a1, clear_loop
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra


clear_registers:
	move $v0, $zero
	move $v1, $zero
	move $a0, $zero
	move $a1, $zero
	move $a2, $zero
	move $a3, $zero
	move $t0, $zero
	move $t1, $zero
	move $t2, $zero
	move $t3, $zero
	move $t4, $zero
	move $t5, $zero
	move $t6, $zero
	move $t7, $zero
	move $t8, $zero
	move $t9, $zero
	move $s0, $zero
	move $s1, $zero
	move $s2, $zero
	move $s3, $zero
	move $s4, $zero
	move $s5, $zero
	move $s6, $zero
	move $s7, $zero
	j main


exit:
	li $v0, 4		# print exit message
	la $a0, exit_message
	syscall

	li $v0, 10
	syscall
