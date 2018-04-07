#########################################################
# CONTEM 2 FUNCOES PARA IMPRIMIR UM CONTADOR		#
# REGRESSIVO EM NUMEROS DE TAMANHO M			#
#-------------------------------------------------------#
# setTime:						#
#	inicia timeReferenceValue e timeCounDown	#
#		$a0: tempo da contagem em segundos	#
#			valores de 0-99			#
#		$v0,$a1: para uso interno		#
# getTime:						#
#	imprime 2 digitos de contador			#
#		$a0: cor de fundo			#
#			0x00000000-0x00ffffff		#
#		$a1: cor dos digitos			#
#			0x00000000-0x00ffffff		#
#		$a2: posicao dos digitos		#
#		$v0,$t0,$t1: para uso interno		#
#	retorna 1 em $v0 se a contagem nao acabou	#
#	retorna 0 em $v0 se a contagem acabou		#
#-------------------------------------------------------#
# E IMPRESCINDIVEL IMPORTAR PRINTCHARACTERS.ASM PARA	#
# EXECUTAR ESSAS FUNCOES				#
#-------------------------------------------------------#
# uso de memoria: 17 bytes				#
#########################################################
.kdata
	timeReferenceValue:	.word	0
	stackGT:		.word	0:3
	timeCountDown:		.byte	60
.text

setTime:
	sw $a0,timeCountDown
	li $v0,30
	syscall
	sw $a0,timeReferenceValue
	jr $ra

getTime:
	sw $a1,stackGT
	sw $a0,stackGT+4
	li $v0,30
	syscall
	li $v0,1
	
	lw $t0,timeReferenceValue
	sub $t0,$a0,$t0
	div $t0,$t0,1000
	lw $a1,timeCountDown
	blt $t0,$a1,tagGT
	sw $a0,timeReferenceValue
	li $v0,0
	
tagGT:	sub $t0,$a1,$t0
	addi $a0,$zero,10
	div $t0,$a0
	mfhi $t0
	
	lw $a0,stackGT+4
	lw $a1,stackGT
	sw $a2,stackGT
	sw $ra,stackGT+4
	sw $t0,stackGT+8
	
	add $t0,$a2,52
	add $t1,$a2,5120
	resetGT:
		sw $a0,0($a2)
		add $a2,$a2,4
		bne $a2,$t0,resetGT
		add $t0,$t0,512
		add $a2,$a2,460
		bne $a2,$t1,resetGT
		
	lw $a2,stackGT
	
	mflo $a0
	jal callMidNumber
	add $a2,$a2,28
	lw $a0,stackGT+8
	jal callMidNumber
	
	lw $ra,stackGT+4
	lw $a2,stackGT
endGT:	jr $ra
