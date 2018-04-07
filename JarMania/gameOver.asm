.kdata
	#Textos da tela de game over
	
	Texto_GameOver:	.asciiz	"GAME OVER"
	Texto_Sc500:	.asciiz "SERIO ^"
	Texto_Sc1000:	.asciiz "TENTE OUTRA VEZ"
	Texto_Sc1500:	.asciiz "VOCE FAZ MELHOR ^"
	Texto_Sc2000:	.asciiz "BOA TENTATIVA ]"
	Texto_Sc3000:	.asciiz "WASTED"
	Texto_Sc5000:	.asciiz "LEVANDO A SERIO"
	Texto_Sc10000:	.asciiz	"]HARD TRY]"
	Texto_Sc25000:	.asciiz	"]]INSANO]]"
	Texto_Sc50000:	.asciiz	"]]]JAR GOD]]]"
	
.text
callGameOver:
		# apaga uma parte da tela para imprimir os textos
	li $t0,34456
	sw $t0,pontuacao
	addi $t0,$gp,19456
	addi $t1,$gp,40448
	lw $t2,color+20
	GOloop:
		sw $t2,0($t0)
		addi $t0,$t0,4
		blt $t0,$t1,GOloop
		
		# Imprime GameOver
	la $a0,Texto_GameOver
	lw $a1,color+32
	addi $a2,$gp,24732
	jal printLine
	lw $a1,color+84
	addi $a2,$gp,24216
	jal printLine
	
		# De acordo com a quantidade de pontos adiquirida uma mensagem eh selecionada
	lb $t0,walkThrough
	la $a0,Texto_Sc500
	blt $t0,1,tagGO
	la $a0,Texto_Sc1000
	blt $t0,2,tagGO
	la $a0,Texto_Sc1500
	blt $t0,3,tagGO
	la $a0,Texto_Sc2000
	blt $t0,4,tagGO
	la $a0,Texto_Sc3000
	blt $t0,5,tagGO
	la $a0,Texto_Sc5000
	blt $t0,6,tagGO
	la $a0,Texto_Sc10000
	blt $t0,7,tagGO
	la $a0,Texto_Sc25000
	blt $t0,8,tagGO
	la $a0,Texto_Sc50000
			
			# Imprime a mensagem
tagGO:	lw $a1,color+32
	addi $a2,$gp,32356
	jal printLine
	lw $a1,color+84
	addi $a2,$gp,31840
	jal printLine

	li $v0,30
	syscall
	add $s6,$a0,$zero
loopGO:
	li $v0,30
	syscall
	sub $t3,$a0,$s6		# Continua tocando a musica do jogo enquanto espera para retornar ao Menu
	jal playSong
	blt $t3,3000,loopGO
j main
