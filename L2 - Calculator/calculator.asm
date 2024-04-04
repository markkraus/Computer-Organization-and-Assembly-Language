# preserves a0, v0
.macro print_str %str
	.data
	print_str_message: .asciiz %str
	.text
	push a0
	push v0
	la a0, print_str_message
	li v0, 4
	syscall
	pop v0
	pop a0
.end_macro

# display = 0 , operation = 0;
.data
	display: .word 0
	operation: .word 0
.text
.global main
main:
	#System.out.print("Hello! Welcome!\n");
	print_str "Hello! Welcome!\n"



	# while(true) {
	_loop:
		# System.out.print(display);
		lw a0, display
		li v0, 1
		syscall

		# System.out.print("\nOperations (=,+,-,*,/,c,q): ");
		print_str "\nOperations (=,+,-,*,/,c,q): "

		# operation = read_char();
		li v0, 12
		syscall

		# v0 = operation
		sw v0, operation

		# System.out.print("\n");
		li a0, '\n'
		li v0, 11
		syscall


		# switch (operation) {
		lw t0, operation
		beq t0, 'q', _quit
		beq t0, 'c', _clear
		beq t0, '+', _get_operand
		beq t0, '-', _get_operand
		beq t0, '*', _get_operand
		beq t0, '/', _get_operand
		beq t0, '=', _get_operand
		j _default

			# case 'q':
			_quit:
				#System.exit(0);
				li v0, 10
				syscall
				j _break

			# case 'c':
			_clear:
				# display = 0;
				sw zero, display
				j _break

		# case '+': case '-': case '*': case '/': case '=':
		_get_operand:
			# System.out.print("Value: ");
			print_str "Value: "

			# scanner.nextInt();
			li v0, 5
			syscall

				# switch(operation) {
				lw t0, operation
				beq t0, '+', _add
				beq t0, '-', _subtract
				beq t0, '*', _multiply
				beq t0, '/', _divide
				beq t0, '=', _equals

				# default:
				_equals:
					sw v0, display
					j _break
				# case '+':
				_add:
					# display += value
					lw t0, display
					add t0, v0, t0
					sw t0, display
					j _break

				# case '-':
				_subtract:
					# display -= value
					lw t0, display
					sub t0, t0, v0
					sw t0, display
					j _break

				# case '*':
				_multiply:
					# display += value
					lw t0, display
					mul t0, v0, t0
					sw t0, display
					j _break

				# case'/':
				_divide:
					# if(value == 0)
					bne v0, 0, _else

						# System.out.print("Attempting to divide by 0!\n");
						print_str "Attempting to divide by 0!\n"
						j _break
					_else:
						# display /= value;
						lw t0, display
						div t0, t0, v0
						sw t0, display
					j _break





		# default:
		_default:
			print_str "Huh?\n"

		_break:
		# }
		j _loop
	# }
