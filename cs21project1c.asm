# CS21 MP1 -- S2 AY 2022 - 2023
# Timothy Javier -- 05/19/2023
# cs21project1c.asm -- assembly code for the project

.eqv GRID_COLS 7
.eqv GRID_ROWS 10
.eqv PIECE_COLS 5

.text

main_b:
	# Line 25
	addi	$a0, $0, 70			#allocate 70 bytes
	li	$v0, 9				#preparing for sbrk
	syscall 
	move	$s0, $v0			#set $s0 to be start_grid
	
	# Line 26
	addi	$a0, $0, 70			#allocate 70 bytes
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$s1, $v0			#set $s1 to be final_grid
	
	# Line 27
	addi	$a0, $0, 20			#allocate 20 bytes
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$s2, $v0			#set $s2 to be pieceAscii

	addi	$t0, $0, 0			# $t0: row = 0
			
fill_rows_b:
	bge	$t0, 4, fill_rows_e		# branch to end if row >= 4
	
	addi	$t1, $0, 0			# $t1: col = 0
	
fill_cols_b:
	bge	$t1, 6, fill_cols_e		#branch to end if col >= 6
	
	addi	$t2, $0, GRID_COLS		# $t2 = GRID_COLS
	mult	$t0, $t2			# multiplying row with GRID_COLS
	mflo	$t2				# $t2 = GRID_COLS * row
	add	$t2, $t2, $t1			# $t2 = (GRID_COLS * row) + col
	add	$t2, $t2, $s0			# $t2 = start_grid + (GRID_COLS * row) + col
	
	li	$t3, '.'			# load '.' to $t3
	sb	$t3, 0($t2)			# start_grid[(GRID_COLS * row) + col] = '.'
	
	addi	$t2, $0, GRID_COLS		#setting $t2 to GRID_COLS
	mult	$t0, $t2			#multiplying row with GRID_COLS
	mflo	$t2				#get product of row and GRID_COLS
	add	$t2, $t2, $t1			#add the product by col
	add	$t2, $t2, $s1			#add offset and address of final_grid
	
	li	$t3, '.'			#load '.' to $t3
	sb	$t3, 0($t2)			#set final_grid[(GRID_COLS * row) + col] = '.'
		
	addi	$t1, $t1, 1			#increment col by 1
	j	fill_cols_b			#jump to the start of the loop
	
fill_cols_e:
	#marks the end of the fill_cols loop

fill_rows_m:
	addi	$t2, $0, GRID_COLS		#setting $t2 to GRID_COLS
	mult	$t0, $t2			#multiplying row with GRID_COLS
	mflo	$t2				#get product of row and GRID_COLS
	addi	$t2, $t2, 6			#add the product by 6
	add	$t2, $t2, $s0			#add offset and address of start_grid
	
	li	$t3, '\0'			#set $t3 to 0
	sb	$t3, 0($t2)			#set start_grid[(GRID_COLS * row) + 6] = 0
	
	addi	$t2, $0, GRID_COLS		#setting $t2 to GRID_COLS
	mult	$t0, $t2			#multiplying row with GRID_COLS
	mflo	$t2				#get product of row and GRID_COLS
	addi	$t2, $t2, 6			#add the product by 6
	add	$t2, $t2, $s1			#add offset and address of final_grid
	
	li 	$t3, '\0'			#load "\0" to $t3
	sh	$t3, 0($t2)			#set final_grid[(GRID_COLS * row) + 6] = '\0'
	
	addi	$t0, $t0, 1			#increment row by 1
	j	fill_rows_b			#jump to the start of the loop

fill_rows_e:
	#marks the end of fill_rows loop

	addi	$t0, $0, 4			# $t0: row = 4
	
read_start_input_b:
	bge	$t0, 10, read_start_input_e	#branch to end if row >= 10
	
	addi	$a1, $0, GRID_COLS		# $a1 = GRID_COLS
	mult	$t0, $a1			#multiplying row with GRID_COLS
	mflo	$t1				# $t1 = GRID_COLS * row
	add	$a0, $t1, $s0			# $a0 = start_grid + GRID_COLS * row
	
	li	$v0, 8				#preparing for string read 
	syscall					
	
	li	$v0, 12				#preparing for character read
	syscall
	
	addi	$t0, $t0, 1			#row += 1
	j	read_start_input_b		#jump to the start of the loop

read_start_input_e:
	#marks the end of the read_start_input loop 

	addi	$t0, $0, 4			# $t0: row = 4

read_final_input_b:
	bge	$t0, 10, read_final_input_e	#branch to end if row >= 10
	
	addi	$a1, $0, GRID_COLS		# $a1 = GRID_COLS
	mult	$t0, $a1			#multiplying row with GRID_COLS
	mflo	$t1				# $t1 = GRID_COLS * row
	add	$a0, $t1, $s1			# $a0 = final_grid + GRID_COLS * row
	
	li	$v0, 8				#preparing for string read 
	syscall					
	
	li	$v0, 12				#preparing for character read
	syscall
	
	addi	$t0, $t0, 1			#row += 1
	j	read_final_input_b		#jump to the start of the loop

read_final_input_e:
	#marks the end of the read_final_input loop
	
	addi	$t0, $0, 4			# $t0: row = 4			

cross_row_b:
	bge	$t0, 10, cross_row_e		#branch to end if row >= 10
	
	addi	$t1, $0, 0			# $t1: col = 0

cross_col_b:
	bge	$t1, 6, cross_col_e		#branch to end if col >= 6
	
	addi	$t2, $0, GRID_COLS		# $t2 = GRID_COLS
	mult 	$t0, $t2			#multiplying row with GRID_COLS
	mflo	$t2				# $t2 = GRID_COLS * row
	add	$t2, $t1, $t2			# $t2 = GRID_COLS * row + col
	add	$t2, $s0, $t2			# $t2 = start_grid + GRID_COLS * row + col
	
	lb	$t4, 0($t2)			# $t4 = start_grid[GRID_COLS * row + col]
	li	$t3, '#'			# $t3 = '#'
	bne	$t3, $t4, cross_col_b_final	# branch if start_grid[GRID_COLS * row + col] not == '#'
	
	li	$t3, 'X'			# $t3 = 'X'
	sb	$t3, 0($t2)			# start_grid[GRID_COLS * row + col] = 'X'
	
cross_col_b_final:
	addi	$t2, $0, GRID_COLS		# $t2 = GRID_COLS
	mult 	$t0, $t2			#multiplying row with GRID_COLS
	mflo	$t2				# $t2 = GRID_COLS * row
	add	$t2, $t1, $t2			# $t2 = GRID_COLS * row + col
	add	$t2, $s1, $t2			# $t2 = final_grid + GRID_COLS * row + col
	
	lb	$t4, 0($t2)			# $t2 = final_grid[GRID_COLS * row + col]
	li	$t3, '#'			# $t3 = '#'
	bne	$t3, $t4, cross_col_b_inc	# branch if final_grid[GRID_COLS * row + col] not == '#'
	
	li	$t3, 'X'			# $t3 = 'X'
	sb	$t3, 0($t2)			# final_grid[GRID_COLS * row + col] = 'X'

cross_col_b_inc:
	addi	$t1, $t1, 1			# col += 1
	j	cross_col_b			#jump to the start of the loop

cross_col_e:
	#marks the end of the cross_col loop

cross_row_m:
	addi	$t0, $t0, 1			# row += 1

cross_row_e:
	#marks the end of the cross_row loop

read_numpieces_inp:
	li	$v0, 5				#preparing for integer read
	syscall	
	move	$s3, $v0			# $s3: numPieces
	
malloc_pieces:
	move	$a0, $s3			# $a0 = numPieces	
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$s4, $v0			# $s4: chosen
	
	li	$t0, 8				# $t0 = 8
	mult	$t0, $s3			#multiplying numPieces by 8
	mflo	$a0				# $a0 = numPieces * 8
	li	$v0, 9				#preparing for sbrk
	syscall					
	move	$s5, $v0			# $s5: converted_pieces
	
	addi	$t0, $0, 0			# $t0: i
	
convert_pieces_b:
	bge	$t0, $s3, convert_pieces_e	#branch to end if i >= numPieces
	
	addi	$t1, $0, 0			# $t1: row

convert_row_b:
	bge	$t1, 4, convert_row_e		#branch to end if row >= 4
	
	addi	$a1, $0, PIECE_COLS		# $a1 = PIECE_COLS
	mult	$t1, $a1 			#multiplying row with PIECE_COLS
	mflo	$a0				# $a0: row * PIECE_COLS
	add	$a0, $a0, $s2			# $a0: pieceAscii + row * PIECE_COLS
	
	li	$v0, 8				#preparing for string read
	syscall
	
	li	$v0, 12				#preparing for character read
	syscall
	
	addi	$t1, $t1, 1			# row += 1
	j	convert_row_b			#jump to the start of the loop

convert_row_e:
	#marks the end of the convert_row loop

convert_pieces_m:
	move	$a0, $s2			# $a2 = pieceAscii
	
	li	$a1, 8				# $a1 = 8
	mult 	$t0, $a1			#multiplying i by 8
	mflo	$a1				# $a1 = i * 8
	add	$a1, $a1, $s5			# $a1 = converted_pieces + i * 8
	
	jal	convert_piece_to_pairs		#call convert_piece_to_pairs

	addi	$t0, $t0, 1			# i += 1
	j	convert_pieces_b		#jump to the start of the loop

convert_pieces_e:
	#marks the end of the convert_pieces loop

answer:
	move	$a0, $s0			# a0 = start_grid
	move	$a1, $s4			# a1 = chosen
	move	$a2, $s5			# a2 = converted_pieces
	move	$a3, $s3			# a3 = numPieces
	jal	backtrack			# call backtrack
	
	li	$t0, 1				# $t0 = 1
	bne	$v0, $t0			#branch to print_no if result != 1
	
print_yes:
	la	$a0, yes			#load yes (from .data) and print
	li	$v0, 4				#preparing to print string
	syscall
	j	main_e				#jump to end
	
print_no:
	la	$a0, no				#load no (from .data) and print
	li	$v0, 4				#preparing to print string
	syscall

main_e:
	# exit syscall
	li	$v0, 10
	syscall

copy: 
	# $a0 = src
	# $a1 = dst
	# $a2 = n
	
	#preamble
	subu	$sp, $sp, 8			#make stack frame
	sw	$ra, 4($sp)			#store $ra
	sw 	$s0, 0($sp)			#store $s0
	#preamble
	
	addi	$s0, $0, 0			#set i to 0 
	
copy_loop_b:
	bge 	$s0, $a2, copy_loop_e		#branch to end if i >= n
	
	add	$t1, $a0, $s0			# $t1 = src + i
	lb	$t0, 0($t1)			# $t0 = src[i]
	add	$t1, $a1, $s0			# $t1 = dst + i
	sb	$t0, 0($t1)			# dst[i] = $t0
	
	addi	$s0, $s0, 1			#increment i by 1
	j	copy_loop_b			#jump to the start of the loop
	
copy_loop_e:
	#marks the end of the copy_loop

copy_e:
	#end
	lw	$ra, 4($sp)			#load values from respective stack frame
	lw	$s0, 0($sp)		
	addu	$sp, $sp, 8			#deallocate stack frame	
	#end
	
	jr	$ra 				#return

is_equal_grids:
	# $a0 = gridOne[70]
	# $a1 = gridTwo[70]
	
	#preamble
	subu	$sp, $sp, 8			#make stack frame
	sw	$ra, 4($sp)			#store $ra
	sw 	$s0, 0($sp)			#store $s0
	#preamble
	
	li	$s0, 1				# $s0: result = 1
	li	$t0, 0				# $t0: i = 0
	
ieg_rows_loop_b:
	bge	$t0, 10, ieg_rows_loop_e	#branch to end if i >= 10
	
	li	$t1, 0				# $t1: j = 0
	
ieg_cols_loop_b:
	bge	$t1, 6, ieg_cols_loop_e		#branch to end if j >= 6

	li	$t2, GRID_COLS			# $t2 = GRID_COLS
	mult	$t0, $t2			#multiplying i by GRID_COLS
	mflo	$t2				# $t2 = i * GRID_COLS
	add	$t2, $t1, $t2			# $t2 = i * GRID_COLS + j
	add	$t2, $a0, $t2			# $t2 = gridOne + i * GRID_COLS + j
	lb	$t2, 0($t2)			# $t2 = gridOne[i * GRID_COLS + j]
	
	li	$t3, GRID_COLS			# $t3 = GRID_COLS
	mult	$t0, $t3			#multiplying i by GRID_COLS
	mflo 	$t3				# $t3 = i * GRID_COLS
	add	$t3, $t1, $t3			# $t3 = i * GRID_COLS + j
	add	$t3, $a1, $t3			# $t3 = gridTwo + i * GRID_COLS + j
	lb	$t3, 0($t3)			# $t3 = gridTwo[i * GRID_COLS + j]
	
	beq	$t2, $t3, ieg_cols_loop_m	#branch if $t2 == $t3
	andi	$s0, $s0, 0			# result = result AND 0 
	j 	ieg_cols_loop_inc		#jump to counter increment 

ieg_cols_loop_m:
	andi	$s0, $s0, 1			# result = result AND 1

ieg_cols_loop_inc:
	addi	$t1, $t1, 1			# j += 1
	j	ieg_cols_loop_b			#jump back to the start of the loop
	
ieg_cols_loop_e:
	#marks the end of the ieg_cols_loop 

ieg_rows_loop_m:
	addi	$t0, $t0, 1			# i += 1
	j	ieg_rows_loop_b			#jump back to the start of the loop
						
ieg_rows_loop_e:
	#marks the end of the ieg_rows_loop
	
	move $v0, $s0				# $v0: result

is_equal_grids_e:
	#end
	lw	$ra, 4($sp)			#load values from respective stack frame
	lw	$s0, 0($sp)		
	addu	$sp, $sp, 8			#deallocate stack frame	
	#end
	
	jr	$ra				#return 

print_grid:
	# $a0 = grid[70]
	
	#preamble
	subu	$sp, $sp, 8			#make stack frame
	sw	$ra, 4($sp)			#store $ra
	sw	$s0, 0($sp)			#store $s0
	#preamble
	
	move	$s0, $a0			# $s0 = grid[70]
	li	$t0, 0				# $t0: i = 0

print_grid_loop_b:
	bge	$t0, 10, print_grid_loop_e	#branch to end if i >= 10
	
	li	$t1, GRID_COLS			# $t1 = GRID_COLS
	mult	$t0, $t1			#multiplying i by GRID_COLS
	mflo 	$a0				# $a0 = i * GRID_COLS
	add	$a0, $s0, $a0			# $a0 = grid + i * GRID_COLS	
	
	li	$v0, 4				#preparing string print 
	syscall
	
	la	$a0, newline			# $a0 = "\n"
	li	$v0, 4				#preparing string print
	syscall	 
	
	addi	$t0, $t0, 1			# i += 1
	j	print_grid_loop_b		#jump to the start of the loop
	
print_grid_loop_e:
	#marks the end of print_grid_loop

print_grid_e:
	#end
	lw	$ra, 4($sp)			#load values from respective stack frame
	lw	$s0, 0($sp)		
	addu	$sp, $sp, 8			#deallocate stack frame	
	#end
	
	jr	$ra				#return 

freeze_blocks:
	# $a0 = grid[70]
	
	#preamble
	subu	$sp, $sp, 4			#make stack frame
	sw	$ra, 0($sp)			#store $ra
	#preamble
	
	li	$t0, 0				# $t0: i = 0
	
fb_rows_loop_b:
	bge	$t0, 10, fb_rows_loop_e		#branch if i >= 10
	
	li	$t1, 0				# $t1: j = 0
	
fb_cols_loop_b:
	bge	$t1, 6, fb_cols_loop_e		#branch if j >= 6
	
	li	$t2, GRID_COLS			# $t2 = GRID_COLS
	mult	$t0, $t2			#multiplying i by GRID_COLS
	mflo	$t2				# $t2 = i * GRID_COLS
	add	$t2, $t1, $t2			# $t2 = i * GRID_COLS + j
	add	$t2, $a0, $t2			# $t2 = grid + i * GRID_COLS + j
	lb	$t3, 0($t2)			# $t3 = grid[i * GRID_COLS + j]

	li	$t4, '#'			# $t4 = '#'
	bne	$t3, $t4, fb_cols_loop_inc	#branch to loop increment
	
	li	$t4, 'X'			# $t4 = 'X'
	sb	$t4, 0($t2)			# grid[i * GRID_COLS + j] = 'X'
	
fb_cols_loop_inc:
	addi	$t1, $t1, 1			# j += 1
	j	fb_cols_loop_b			#jump to the start of the loop
	
fb_cols_loop_e:
	#marks the end of fb_cols_loop

fb_rows_loop_m:	
	addi	$t0, $t0, 1			# i += 1
	j	fb_rows_loop_b			#jump to the start of the loop
	
fb_rows_loop_e:
	#marks the end of fb_rows_loop
	
freeze_blocks_e:
	move	$v0, $a0			# $v0 = grid
	
	#end
	lw	$ra, 0($sp)			#load values from respective stack frame
	addu	$sp, $sp, 4			#deallocate stack frame
	#end
	
	jr	$ra				#return

get_max_x_of_piece:
	# $a0 = piece[8]
	
	#preamble
	subu	$sp, $sp, 8			#make stack frame
	sw	$ra, 4($sp)			#store $ra
	sw 	$s0, 0($sp)			#store $s0
	#preamble

	li	$s0, -1				# $s0: max_x = -1
	li	$t0, 1				# $t0: i = 1
	
gmop_loop_b:
	bge	$t0, 8, gmop_loop_e		#branch to end if i >= 8
	
	add	$t1, $a0, $t0			# $t1 = piece + i
	lb	$t1, 0($t1)			# $t1 = piece[i]
	
	bge	$s0, $t1, gmop_loop_inc		#branch to loop inc if max_x >= piece[i]
	move	$s0, $t1			# max_x = piece[i]

gmop_loop_inc:
	addi	$t0, $t0, 2			# i += 2
	j 	gmop_loop_b			#jump to the start of the loop

gmop_loop_e:
	#marks the end of gmop_loop

get_max_x_of_piece_e:
	move	$v0, $s0			# $v0 = max_x

	#end
	lw	$ra, 4($sp)			#load values from respective stack frame
	lw	$s0, 0($sp)		
	addu	$sp, $sp, 8			#deallocate stack frame	
	#end
	
	jr	$ra				#return 

convert_piece_to_pairs:
	# $a0 = pieceGrid[20]
	# $a1 = pieceCoords[8]
	
	#preamble
	subu	$sp, $sp, 4			#make stack frame
	sw	$ra, 0($sp)			#store $ra
	#preamble

	li	$t0, 0				# $t0: k = 0
	li	$t1, 0				# $t1: i = 0

cptp_rows_loop_b:
	bge	$t1, 4, cptp_rows_loop_e	#branch to end if i >= 4
	li	$t2, 0				# $t2: j = 0
	
cptp_cols_loop_b:
	bge	$t2, 4, cptp_cols_loop_e	#branch to end if j >= 4

	li	$t3, PIECE_COLS			# $t3 = PIECE_COLS
	mult	$t1, $t3			#multiplying i by PIECE_COLS
	mflo	$t3				# $t3 = i * PIECE_COLS
	add	$t3, $t2, $t3			# $t3 = i * PIECE_COLS + j
	
	move	$t4, $a0			# $t4 = pieceGrid
	add	$t4, $t3, $t4			# $t4 = pieceGrid + i * PIECE_COLS + j	
	lb	$t4, 0($t4)			# $t4 = pieceGrid[i * PIECE_COLS + j]
	
	li	$t3, '#'			# $t3 = '#'
	bne	$t3, $t4, cptp_cols_loop_inc	#branch if pieceGrid[i * PIECE_COLS + j] != '#'
	
	move	$t3, $a1			# $t3 = pieceCoords
	add	$t3, $t0, $t3			# $t3 = pieceCoords + k
	sb	$t1, 0($t3)			# pieceCoords[k] = i
	addi	$t3, $t3, 1			# $t3 = pieceCoords + k + 1
	sb	$t2, 0($t3)			# pieceCoords[k+1] = j
	addi	$t0, $t0, 2			# k += 2

cptp_cols_loop_inc:
	addi	$t2, $t2, 1			# j += 1
	j	cptp_cols_loop_b		#jump to the start of the loop

cptp_cols_loop_e:
	#marks the end of cptp_cols_loop
	
cptp_rows_loop_inc:
	addi	$t1, $t1, 1			# i += 1
	j	cptp_rows_loop_b		#jump to the start of the loop
	
cptp_rows_loop_e:
	#marks the end of cptp_rows_loop

convert_piece_to_pairs_e:
	#end
	lw	$ra, 0($sp)			#load values from respective stack frame
	addu	$sp, $sp, 4			#deallocate stack frame
	#end
	
	jr	$ra				#return

backtrack:
	# $a0 = currGrid[70]
	# $a1 = chosen
	# $a2 = pieces
	# $a3 = numPieces 

	#preamble
	subu	$sp, $sp, 36			#make stack frame
	sw	$ra, 32($sp)			#store $ra
	sw	$s0, 28($sp)			#store $s0
	sw	$s1, 24($sp)			#store $s1
	sw	$s2, 20($sp)			#store $s2
	sw	$s3, 16($sp)			#store $s3
	sw	$s4, 12($sp)			#store $s4
	sw	$s5, 8($sp)			#store $s5
	sw	$s6, 4($sp)			#store $s6
	sw	$s7, 0($sp)			#store $s7
	#preamble

	move	$s2, $a0			# $s2 = currGrid[70]
	move	$s3, $a1			# $s3 = chosen
	move	$s4, $a2			# $s4 = pieces
	move	$s5, $a3			# $s5 = numPieces

	lw	$a1, 16($sp)			# $a1 = $s1 = final_grid?
	jal	is_equal_grids			#call is_equal_grids(currGrid, final_grid)
	move	$t0, $v0			# $t0: result of call
	li	$t1, 1				# $t1 = 1
	bne	$t0, $t1, skip_if_backtrack	#branch if $t0 != 1
	
	li	$v0, 1				# result = 1
	j	backtrack_e			#jump to end
	
skip_if_backtrack:
	li	$s0, 0				# $s0: i = 0
	
bt_outer_loop_b:
	bge	$s0, $s5, bt_outer_loop_e		
	
	add	$t1, $s0, $s3			# $t1 = chosen + i
	lb	$t1, 0($t1)			# $t1 = chosen[i]
	beq	$t1, 1, bt_outer_loop_inc	#continue if chosen[i] == 1

bt_max_offset:
	li	$t1, 8				# $t1 = 8
	mult	$s0, $t1			#multiplying i by 8
	mflo	$a0				# $a0 = i * 8
	add	$a0, $a0, $s4			# $a0 = pieces + i * 8
	
	jal	get_max_x_of_piece		#call get_max_x_of_piece
	li	$t1, 6				# $t1 = 6
	sub	$s7, $t1, $v0			# $s7: max_offset = 6 - result of get_max_x_of_piece
	
bt_copy:
	li	$a0, 8				# $a0 = 8
	mult	$a0, $s5			#multiplying numPieces by 8
	mflo	$a0				# $a0 = numPieces * 8
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$s6, $v0			# $s6 = chosenCopy

	move 	$a0, $s3			# $a0 = chosen
	move	$a1, $s6			# $a1 = chosenCopy

	li	$t0, 8				# $t0 = 8
	mult	$t0, $s5			#multiplying numPieces by 8
	mflo	$a2				# $a2 = numPieces * 8

	jal	copy				#call copy 

	li	$s1, 0				# $s1: offset = 0
	
bt_inner_loop_b:
	bge	$s1, $s7, bt_inner_loop_e	#branch to end if offset >= max_offset
	
	li	$a0, 1				#allocate 1 byte
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$a3, $v0			# $a3 = &success
	
	move	$a0, $s2			# $a0 = currGrid
	
	li	$t0, 8				# $t0 = 8
	mult	$t0, $s0			#multiplying i by 8
	mflo	$a1				# $a1 = i * 8
	add	$a1, $a1, $s4			# $a1 = pieces + i * 8

	move	$a2, $s1			# $a2 = offset
	
	jal	drop_piece_in_grid 		#call drop_piece_in_grid

bt_outer_if:
	#is $a3 still preserved?
	lb	$t0, 0($a3)			# $t0: success
	bne	$t0, 1, bt_inner_loop_inc	#branch if $t0 != 1
	
	add	$t0, $s0, $s6			# $t0: chosenCopy + i
	li	$t1, 1				# $t1 = 1
	sb	$t1, 0($t0)			# chosenCopy[i] = 1
	
bt_inner_if:
	move	$a0, $v0			# $a0: nextGrid
	move	$a1, $s6			# $a1: chosenCopy
	move	$a2, $s4			# $a2: pieces
	move	$a3, $s5			# $a3: numPieces
	
	jal	backtrack			#call backtrack
	bne	$v0, 1, bt_inner_loop_inc	#branch if backtrack result is not 1	
	j	backtrack_e			#return 1, and jump to end	
	
bt_inner_loop_inc:
	addi	$s1, $s1, 1			# offset += 1
	j	bt_inner_loop_b			#jump to the start of the loop

bt_inner_loop_e:
	#marks the end of bt_inner_loop

bt_outer_loop_inc:
	addi	$s0, $s0, 1			# i += 1
	j	bt_outer_loop_b			#jump to the start of the loop

bt_outer_loop_e:
	#marks the end of bt_outer_loop
	
	li	$v0, 0				# $v0 = result

backtrack_e:
	#end
	lw	$ra, 32($sp)			#load values from respective stack frame
	lw	$s0, 28($sp)			
	lw	$s1, 24($sp)			
	lw	$s2, 20($sp)			
	lw	$s3, 16($sp)			
	lw	$s4, 12($sp)			
	lw	$s5, 8($sp)
	lw	$s6, 4($sp)
	lw	$s7, 0($sp)			
	addu	$sp, $sp, 36			#deallocate stack frame
	#end	

	jr	$ra				#return

drop_piece_in_grid:
	# $a0 = grid[70]
	# $a1 = piece[8]
	# $a2 = yOffset
	# $a3 = isSuccess
	
	#preamble
	subu	$sp, $sp, 24			#make stack frame
	sw	$ra, 20($sp)			#storing registers
	sw 	$s0, 16($sp)			
	sw	$s1, 12($sp)			
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$s4, 0($sp)
	#preamble
	
	move	$s0, $a0			# $s0: grid
	move	$s1, $a1			# $s1: piece
	move	$s2, $a2			# $s2: yOffset
	move	$s3, $a3			# $s3: isSuccess
	
	li	$a0, 70				#allocate 70 bytes
	li	$v0, 9				#preparing for sbrk
	syscall
	move	$s4, $v0			# $s4: gridCopy
	
	move	$a0, $s0			# $a0 = grid
	move	$a1, $s4			# $a1 = gridCopy
	li	$a2, 70				# $a2 = 70
	
	jal	copy				#call copy
	
	li	$t0, 100			# $t0: maxY = 100
	li	$t1, 0				# $t1: i = 0
	
dpig_1st_loop_b:
	bge	$t1, 8, dpig_1st_loop_e		#branch to end if i >= 8
	
	add	$t2, $t1, $s1			# $t2 = piece + i
	lb	$t3, 0($t2)			# $t3: piece[i]
	li	$t4, GRID_COLS			# $t4 = GRID_COLS
	mult	$t3, $t4			#multiplying piece[i] by GRID_COLS
	mflo	$t3				# $t3: piece[i] * GRID_COLS
	
	addi	$t2, $t2, 1			# $t2 = piece + i + 1
	lb	$t2, 0($t2)			# $t2: piece[i + 1]
	
	add	$t2, $t2, $t3			# $t2 = piece[i + 1] + piece[i] * GRID_COLS
	add	$t2, $t2, $s2			# $t2 = piece[i + 1] + piece[i] * GRID_COLS + yOffset
	
	add	$t2, $t2, $s4			# $t2 = gridCopy + piece[i + 1] + piece[i] * GRID_COLS + yOffset
	li	$t3, '#'			# $t3 = '#'
	sb	$t3, 0($t2)			# gridCopy[piece[i + 1] + piece[i] * GRID_COLS + yOffset] = '#'
	
	addi	$t1, $t1, 2			# i += 2
	j	dpig_1st_loop_b			#jump to the start of the loop
	
dpig_1st_loop_e:
	#marks the end of dpig_1st_loop			
	
dpig_while_b:
	li	$t1, 1				# $t1: canStillGoDown
	li	$t2, 0				# $t2: i = 0
	
dpig_while_outer_b:
	bge	$t2, 10, dpig_while_outer_e	#branch if i >= 10
	li	$t3, 0				# $t3: j = 0
	
dpig_while_inner_b:
	bge	$t3, 6, dpig_while_inner_e	#branch if j >= 6
	
	li	$t4, GRID_COLS			# $t4 = GRID_COLS
	mult	$t2, $t4			#multiplying i by GRID_COLS
	mflo	$t5				# $t5 = i * GRID_COLS
	add	$t5, $t3, $t5			# $t5 = i * GRID_COLS + j
	add	$t5, $t5, $s4			# $t5 = gridCopy + i * GRID_COLS + j
	lb	$t5, 0($t5)			# $t5 = gridCopy[i * GRID_COLS + j]
	li	$t6, '#'			# $t6 = '#'

	beq	$t5, $t6, dpig_while_inner_if	#branch if gridCopy[i * GRID_COLS + j] = '#'
	j	dpig_while_inner_inc		#continue for loop

dpig_while_inner_if:
	beq	$t2, 9, update_csgd		#branch if or statement passed

	addi	$t5, $t2, 1			# $t5 = i + 1
	mult	$t4, $t5			#multiplying (i + 1) by GRID_COLS
	mflo	$t5				# $t5 = (i + 1) * GRID_COLS
	add	$t5, $t3, $t5			# $t5 = (i + 1) * GRID_COLS + j
	add	$t5, $s4, $t5			# $t5 = gridCopy + (i + 1) * GRID_COLS + j
	lb	$t5, 0($t5)			# $t5 = gridCopy[(i + 1) * GRID_COLS + j]
	
	li	$t6, 'X'			# $t6 = 'X'
	bne	$t5, $t6, dpig_while_inner_inc	#continue if gridCopy[(i + 1) * GRID_COLS + j] != 'X'
						
update_csgd:
	li	$t1, 0				# $t1: canStillGoDown = 0

dpig_while_inner_inc:
	addi	$t3, $t3, 1			# j += 1
	j	dpig_while_inner_b		#jump to the start of the loop

dpig_while_inner_e:
	#marks the end of dpig_while_inner loop
	
dpig_while_outer_inc:
	addi	$t2, $t2, 1			# i += 1
	j	dpig_while_outer_b		#jump to the start of the loop

dpig_while_outer_e:
	#marks the end of dpig_while_outer loop

dpig_while_if:
	bne	$t1, 1, dpig_while_e		#break while loop if csgd != 1
	li	$t2, 8				# $t2: i = 8
	
dpig_while_if_outer_b:
	ble	$t2, -1, dpig_while_if_outer_e	#branch if i <= -1
	li	$t3, 0				# $t3: j = 0

dpig_while_if_inner_b:
	bge	$t3, 6, dpig_while_if_inner_e	#branch if j >= 6
	

dpig_while_if_inner_inc:
	addi	$t3, $t3, 1			# i += 1
	j	dpig_while_if_inner_b		#jump to the start of the loop

dpig_while_if_inner_e:
	#marks the end of dpig_while_if_inner loop

dpig_while_if_outer_dec:
	subi	$t2, $t2, 1			# i -= 1
	j	dpig_while_if_outer_b		#jump to the start of the loop

dpig_while_if_outer_e:
	#marks the end of dpig_while_if_outer loop
	
dpig_while_m:
	j	dpig_while_b			#jump to the start of while

dpig_while_e:
	#marks the end of dpig_while loop

drop_piece_in_grid_e:
	#end
	lw	$ra, 20($sp)			#loading from respective stack frame
	lw 	$s0, 16($sp)			
	lw	$s1, 12($sp)			
	lw	$s2, 8($sp)
	lw	$s3, 4($sp)
	lw	$s4, 0($sp)
	addu	$sp, $sp, 24			#deallocate stack frame	
	#end
	
	jr	$ra				#return


.data
yes:		.asciiz "YES\n"
no:		.asciiz "NO\n"
newline: 	.asciiz "\n"

