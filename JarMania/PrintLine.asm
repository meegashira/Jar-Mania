#################################################################
# CONTEM 2 FUNCOES PARA IMPRIMIR LETRAS NA TELA DE BITMAP 	#
#---------------------------------------------------------------#
#	CallSmallChar						#
# Os registradores sao:					   	#
#	$a0 : contem a letra q sera imprimida		   	#
#		varia de A-Z nao tem tratamento para 	   	#
#		valores fora da faixa. 			   	#
#	$a1 : contem a cor que sera utilizada		   	#
#		0x00000000-0x00ffffff			   	#
#	$a2: contem a posicao de memoria em que a funcao   	#
#		sera aplicada				   	#
#	$t0,$t1,$t2: para uso interno da funcao		   	#
#								#
#	PrintLine:						#
# Uma linha de um lado ao outro da tela contem 21 caracteres	#
# Os registradores sao:					   	#
#	$a0 : contem o endereco do texto que sera impresso	#
#		varia de A-Z e space, nao tem tratamento para 	#
#		valores fora da faixa. 			   	#
#	!!!!	use variaveis asciiz !!!!			#
#	$a1 : contem a cor que sera utilizada		   	#
#		0x00000000-0x00ffffff			   	#
#	$a2: contem a posicao de memoria em que a funcao   	#
#		sera aplicada				   	#
#	$t0,$t1,$t2,$t3: para uso interno da funcao	   	#
#---------------------------------------------------------------#
#    E IMPRESINDIVEL MANTER A ORDEM DOS DADOS DA FUNCAO    	#
#---------------------------------------------------------------#
# uso de memoria: 638 bytes				   	#
#################################################################

		# Contem um alfabeto implementado
		# a Funcao que imprime linhas usa caracteres maiusculos da tabela asc
		# que estao em variaes asciiz
.kdata
	argsPC:		.word	0,0
	argsPL: 	.word 	0,0
	small_a:	.byte	0,1,1,0,0
				1,0,0,1,0
				1,1,1,1,0
				1,0,0,1,0
				1,0,0,2,0
				
	small_b:   .byte	1,1,1,0,0
				1,0,0,1,0
				1,1,1,0,0
				1,0,0,1,0
				1,1,2,0,0
					
					
	small_c:   .byte	1,1,1,1,0
				1,0,0,0,0
				1,0,0,0,0
				1,0,0,0,0
				1,1,1,2,0
				
	small_d:   .byte	1,1,1,0,0
				1,0,0,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,1,2,0,0
				
	small_e:   .byte	1,1,1,1,0
				1,0,0,0,0
				1,1,1,1,0
				1,0,0,0,0
				1,1,1,2,0
				
	small_f:   .byte	1,1,1,1,0
				1,0,0,0,0
				1,1,1,1,0
				1,0,0,0,0
				2,0,0,0,0
				
	small_g:   .byte	1,1,1,1,0
				1,0,0,0,0
				1,0,1,1,0
				1,0,0,1,0
				1,1,1,2,0

	small_h:   .byte	1,0,0,1,0
				1,0,0,1,0
				1,1,1,1,0
				1,0,0,1,0
				1,0,0,2,0
				
	small_i:   .byte	0,1,1,1,0
				0,0,1,0,0
				0,0,1,0,0
				0,0,1,0,0
				0,1,1,2,0
				
	small_j:   .byte	0,1,1,1,0
				0,0,1,0,0
				0,0,1,0,0
				1,0,1,0,0
				0,2,0,0,0
				
	small_k:   .byte	1,0,0,1,0
				1,0,1,0,0
				1,1,0,0,0
				1,0,1,0,0
				1,0,0,2,0
				
	small_l:   .byte	1,0,0,0,0
				1,0,0,0,0
				1,0,0,0,0
				1,0,0,0,0
				1,1,1,2,0
				
	small_m:   .byte	1,0,0,0,1
				1,1,0,1,1
				1,0,1,0,1
				1,0,0,0,1
				1,0,0,0,2
				
	small_n:   .byte	1,0,0,0,1
				1,1,0,0,1
				1,0,1,0,1
				1,0,0,1,1
				1,0,0,0,2

	small_o:   .byte	1,1,1,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,1,1,2,0
				
				
	small_p:   .byte	1,1,1,1,0
				1,0,0,1,0
				1,1,1,1,0
				1,0,0,0,0
				2,0,0,0,0
			
	small_q:   .byte	1,1,1,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,0,1,1,0
				1,1,1,1,2
				
	small_r:   .byte	1,1,1,1,0
				1,0,0,1,0
				1,1,1,1,0
				1,0,1,0,0
				1,0,0,2,0
				
	small_s:   .byte	1,1,1,1,0
				1,0,0,0,0
				1,1,1,1,0
				0,0,0,1,0
				1,1,1,2,0
				
	small_t:   .byte	1,1,1,1,1
				0,0,1,0,0
				0,0,1,0,0
				0,0,1,0,0
				0,0,2,0,0

	small_u:   .byte	1,0,0,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,0,0,1,0
				1,1,1,2,0

	small_v:   .byte	1,0,0,0,1
				1,0,0,0,1
				0,1,0,1,0
				0,1,0,1,0
				0,0,2,0,0
	
	small_w:   .byte	1,0,0,0,1
				1,0,0,0,1
				1,0,0,0,1
				1,0,1,0,1
				0,1,0,2,0
				
	small_x:   .byte	1,0,0,0,1
				0,1,0,1,0
				0,0,1,0,0
				0,1,0,1,0
				1,0,0,0,2
	
	small_y:   .byte	1,0,0,0,1
				1,0,0,0,1
				0,1,0,1,0
				0,0,1,0,0
				0,0,2,0,0
				
	small_z:   .byte	1,1,1,1,1
				0,0,0,1,0
				0,0,1,0,0
				0,1,0,0,0
				1,1,1,1,2
				
	small_twodots:	.byte	0,0,0,0,0
				1,0,0,0,0
				0,0,0,0,0
				2,0,0,0,0
				0,0,0,0,0
	
	small_plus:	.byte	0,0,0,0,0
				0,0,1,0,0
				0,1,1,1,0
				0,0,2,0,0
				0,0,0,0,0
				
	small_exclamation:.byte	0,0,1,0,0
				0,0,1,0,0
				0,0,1,0,0
				0,0,0,0,0
				0,0,2,0,0
				
	small_questionm:.byte	0,1,1,1,0
				0,0,0,0,1
				0,0,1,1,0
				0,0,1,0,0
				0,0,0,0,0
				0,0,2,0,0

.text

callSmallLetter:
	sw $a0,argsPC
	sw $a2,argsPC+4
	mul $t0,$a0,25
	la $t0,small_a+-1($t0)
	li $t1,-1
	printSL:
		addi $t0,$t0,1
		lb $a0,0($t0)
		addi $t1,$t1,1
		bne $t1,5,tagSL
		add $a2,$a2,512
		li $t1,0
	tagSL:	beq $a0,$zero,printSL
		add $t2,$t1,$t1
		add $t2,$t2,$t2
		add $t2,$a2,$t2
		sw  $a1,0($t2)
		beq $a0,1,printSL
	lw $a0,argsPC
	lw $a2,argsPC+4
	jr $ra

callSmallChar:
	sw $a0,argsPC
	sw $a2,argsPC+4
	addi $a0,$a0,-65	# subrai o valor de A em asc para ser a posicao 0 do vetor de alfabeto
	mul $t0,$a0,25
	la $t0,small_a+-1($t0)
	li $t1,-1
	printSC:
		addi $t0,$t0,1
		lb $a0,0($t0)
		addi $t1,$t1,1
		bne $t1,5,tagSC
		add $a2,$a2,512
		li $t1,0
	tagSC:	beq $a0,$zero,printSC
		add $t2,$t1,$t1
		add $t2,$t2,$t2
		add $t2,$a2,$t2
		sw  $a1,0($t2)
		beq $a0,1,printSC
	lw $a0,argsPC
	lw $a2,argsPC+4
	jr $ra

	
printLine:
	sw $ra,argsPL
	sw $a0,argsPL+4
	addi $t3,$a0,0
	loopPL:
		lb $a0,0($t3)	# carrega letra da variavel asciiz
		beq $a0,32,tagPL # em ascii 32 eh o caractere de espaco
		beq $a0,0,endPL
		jal callSmallChar
	tagPL:	addi $t3,$t3,1
		addi $a2,$a2,24
		j loopPL
endPL:	lw $a0,argsPL+4
	lw $ra,argsPL
	jr $ra

