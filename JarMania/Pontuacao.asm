#################################################
#  CONTEM AS FUNCOES QUE CONTROLAM E MOSTRAM	#
# A PONTUACAO DO JOGADOR			#
#################################################

.kdata

	pontuacao:	.word	0
	stackP:		.word	0:3
	stackV:		.word 	0:3
	stackNum:	.byte	0:10
	walkThrough:	.word	0
	erros:		.word	0
.text

# Inicia parametros da pontuacao do jogador
# e tambem a primeira representacao dos pontos na tela
setPontuacao:
	sw $ra,stackP
	
	li $a0,6
	lw $a1,color+80
	la $a2,3612($gp)
	jal callSmallLetter

	li $a0,26
	addi $a2,$a2,24
	jal callSmallLetter
	
	li $a0,0
	addi $a2,$a2,8
	jal callSmallNumber
	sw $zero,pontuacao
	
	sw $a2,stackP+4
	lw $ra,stackP
	
	sw $zero,walkThrough
	jr $ra
	
# Retorna os pontos na tela 
getPontuacao:
	sw $ra,stackP
	lw $a2,stackP+4
	lw $t0,pontuacao
	la $t1,stackNum
	li $t2,10
	li $t3,0
loopNum:
	beq $t0,0,loopP
	div $t0,$t2
	mfhi $t4
	mflo $t0
	sb $t4,0($t1)
	addi $t3,$t3,1
	addi $t1,$t1,1
	j loopNum
loopP:
	beq $t3,0,fimP
	subi $t1,$t1,1
	lb $a0,0($t1)
	
	sw $t1,stackP+8
	
	lw $t0,color+8
	sw $t0,0($a2)
	sw $t0,4($a2)
	sw $t0,8($a2)
	sw $t0,512($a2)
	sw $t0,516($a2)
	sw $t0,520($a2)
	sw $t0,1024($a2)
	sw $t0,1028($a2)
	sw $t0,1032($a2)
	sw $t0,1536($a2)
	sw $t0,1540($a2)
	sw $t0,1544($a2)
	sw $t0,2048($a2)
	sw $t0,2052($a2)
	sw $t0,2056($a2)
	
	jal callSmallNumber
	lw $t1,stackP+8
	addi $a2,$a2,16
	subi $t3,$t3,1
	j loopP
fimP:	lw $ra,stackP
	jr $ra
	
	# Faz a soma dos pontos
sumPontuacao:
	lw $t0,pontuacao
	add $t0,$t0,$a0
	sw $t0,pontuacao
	jr $ra
	
	# inicia Parametros que controlam as vidas do jogador
	# e tambem exibe a representacao inicial na tela
setVita:
	sw $ra,stackV
	
	li $a0,24
	lw $a1,color+80
	la $a2,7196($gp)
	jal callSmallLetter

	li $a0,26
	addi $a2,$a2,24
	jal callSmallLetter

	li $a0,1
	addi $a2,$a2,8
	jal callSmallNumber
	
	sw $a2,stackV+4
	
	li $a0,0
	addi $a2,$a2,16
	jal callSmallNumber
	
	li $t0,10
	sw $t0,erros
	
	lw $ra,stackV
	jr $ra
	
	# Exibe na tela o contador de vidas
getVita:
	sw $ra,stackV
	lw $a2,stackV+4
	lw $t0,erros
	la $t1,stackNum
	li $t2,10
	li $t3,0
	
	bnez $t0,loopNum2
	li $a0,0
	lw $s0,color+8
	sw $s0,0($a2)
	sw $s0,4($a2)
	sw $s0,8($a2)
	sw $s0,512($a2)
	sw $s0,516($a2)
	sw $s0,520($a2)
	sw $s0,1024($a2)
	sw $s0,1028($a2)
	sw $s0,1032($a2)
	sw $s0,1536($a2)
	sw $s0,1540($a2)
	sw $s0,1544($a2)
	sw $s0,2048($a2)
	sw $s0,2052($a2)
	sw $s0,2056($a2)
	jal callSmallNumber
	j fimV
loopNum2:
	beq $t0,0,loopV
	div $t0,$t2
	mfhi $t4
	mflo $t0
	sw $t4,0($t1)
	addi $t3,$t3,1
	addi $t1,$t1,4
	j loopNum2
loopV:
	beq $t3,0,fimV
	subi $t1,$t1,4
	lw $a0,0($t1)
	
	sw $t1,stackV+8
	
	lw $t0,color+8
	sw $t0,0($a2)
	sw $t0,4($a2)
	sw $t0,8($a2)
	sw $t0,512($a2)
	sw $t0,516($a2)
	sw $t0,520($a2)
	sw $t0,1024($a2)
	sw $t0,1028($a2)
	sw $t0,1032($a2)
	sw $t0,1536($a2)
	sw $t0,1540($a2)
	sw $t0,1544($a2)
	sw $t0,2048($a2)
	sw $t0,2052($a2)
	sw $t0,2056($a2)
	
	jal callSmallNumber
	lw $t1,stackV+8
	addi $a2,$a2,16
	lw $t0,color+8
	sw $t0,0($a2)
	sw $t0,4($a2)
	sw $t0,8($a2)
	sw $t0,512($a2)
	sw $t0,516($a2)
	sw $t0,520($a2)
	sw $t0,1024($a2)
	sw $t0,1028($a2)
	sw $t0,1032($a2)
	sw $t0,1536($a2)
	sw $t0,1540($a2)
	sw $t0,1544($a2)
	sw $t0,2048($a2)
	sw $t0,2052($a2)
	sw $t0,2056($a2)
	subi $t3,$t3,1
	j loopV
fimV:	lw $ra,stackV
	jr $ra
