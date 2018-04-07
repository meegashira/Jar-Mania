#################################################
# *Carregue o endereco das faixas nas primeiras	#
# posicoes de enderecoFaixa			#
# *Eh imprescindivel que a ultima posicao de	#
# enderecoFaixa seja 0				#
# *timebuffer deve ser iniciado			#
#-----------------------------------------------#
# FUNCAO playSong:				#
# 	$a0 deve conter um os bits menos signifi#
# cativos de systemtime				#
#	$s7 deve conter a duracao de uma	#
# semifusa					#
#	$v1 retorna 0 se a musica acabou e 1 se #
# o contrario					#
# $s0,$s1,$s2,$t0,$t1,$t2,$t7,$a1,$a2,$a3 e $v0 #
# para uso interno				#
#################################################

# As musicas sao vetores com as informacoes de que um som precisa para tocar
# cada som da for armazenado da seguinte forma:
# nota,multiplicador de tempo,timbre
# nota 0-127
# multiplicador de tempo: 64 semibreve, 32 minima, 16 seminina, 8 colcheia, 4 semicolcheia, 2 fusa, 1 semifusa
# timbre 0-127

.kdata
	enderecoFaixa:	.word	0,0,0,0,0
	noteTemp:	.byte	1,1,1,1
	pilhafs:	.word	0,0
	timebuffer:	.word	0
	volume:		.byte	90
.text

#==PLAY SONG==#
# $a0 deve conter um os bits menos significativos de systemtime
# $a3 com o volume do som
# $s7 com a duracao de uma semifusa
playSong:
	sw $ra,pilhafs		#guarda valor de $ra
	lw $a3,volume		#ajusta o volume
	li $v1,1		#supomos q a musica não acabou
	lw $t0,timebuffer	#acessa timbebuffer
	sub $s0,$a0,$t0		#faz a diferenca do tempo
	blt $s0,$s7,missTime	#se tempo eh menor que a duracao minima esta fora do tempo
	
	li $v0,31		#Carrega syscall de MIIDI
	li $s2,0		#Carrega contador de faixas
	loopps:
		jal playSound	#Toca o Som
		addi $s2,$s2,1	#Proxima Faixa
		bne $s2,-1,loopps#Se faixas acabaram termina o loop, $s2 eh modificado em playSound se enderecoFaixa eh 0x000000
		
	li $v0,30		#system time
	syscall
	sw $a0,timebuffer	#atualiza timebuffer
	
	missTime:
	lw $ra,pilhafs
	jr $ra

#==PLAY SOUND==#
# carrega endereço e contagem de tempo das notas
# Usa $s2 como parametro, retorna $s2 <- -1 se leitura de enderecoFaixa eh nula
playSound:
	add $t0,$s2,$s2
	add $t7,$t0,$t0
	lw $s0,enderecoFaixa($t7)#Carrega o endereco da nota na faixa
	beqz $s0,endSound	 #Se endero eh zero nao ha mais faixas
	la $s1,noteTemp($s2)	 #Carrega o endereco do temporizador
	lb $t0,0($s1)		 #Carrega o valor do temporizador
	addi $t0,$t0,-1		 #Desconta o temporizador
	bnez $t0,next		 #Se temporizador nao eh nulo nao toca nota
	sw $ra,pilhafs+4	 #Empilha endereco de retorno
	jal playNote		 #Toca nota
	lw $ra,pilhafs+4	 #Desempilha endereco de retorno
next:	sb $t0,0($s1)		 #Armazena valor do temporizador, pode ter sido modificado em playNote
	sw $s0,enderecoFaixa($t7)#Armazena o endereco da nota na Faixa, pode ter sido modificado em playNote
	jr $ra			 #Retorna
endSound: li $s2,-2		 #$s2 <- -1 para sair do loop externo
	  jr $ra		 #Retorna

#==PLAY NOTE==#
# Toca a nota efetivamente
# Usa $s0 como parametro do enderecoFaixa
#Retorna $t0 com valor de temporizador se exite nota
#Retorna $s0 com novo enderecoFaixa se esse mudar
#Retorna $v1 <- 1 se tocou nota ou $v1 <- 0 se a musica acabou
playNote:
	lb $a0,0($s0) 		#Nota
	beq $a0,1,endps		#Se nota eh 1 então a musica acabou
	lb $t1,1($s0)		#Carrega multiplicador de tempo
	add $t0,$t1,$zero	#Atualiza $t0 com o valor que ira para o temporizador
	beq $a0,$zero,endpn	#Se nota eh 0 então é uma pausa
	mul $a1,$t1,$s7		#Duração
	lb $a2,2($s0)		#Instrumento
	syscall			#Toca a nota
endpn:	addi $s0,$s0,3		#Atualiza enderecoFaixa
	li $v1,1
	jr $ra			#Retorna 1
endps:	li $v1,0
	jr $ra			#Retorna 0
