.kdata
	# Variaveis de texto
	TextoP:		.asciiz "PRODUTORES"
	NomeDp:		.asciiz "DANIELLE PEREIRA"
	NomeC:		.asciiz "CONTIERI"
	NomeGar:	.asciiz "GASPAR AFONSO ROCHA"
	NomeMee:	.asciiz "MIKAELA EMI EGASHIRA"
	NomeVo:		.asciiz "VICTOR DE OLIVEIRA"
	NomeO:		.asciiz "OGATA"
	Greetings1:	.asciiz "ORIENTADORES"
	Greetings2:	.asciiz "FABIO AUGUSTO MENOCCI"
	Greetings3:	.asciiz "CAPPABIANCO"
	Greetings4:	.asciiz "SERGIO RONALDO BARROS"
	Greetings5:	.asciiz "DOS SANTOS"
	TextoM:		.asciiz "MUSICAS"
	TextoM1_1:	.asciiz "MUSICA TEMA"
	TextoM1_2:	.asciiz "EM UM MERCADO PERSA"
	TextoM1_3:	.asciiz "ALBERT KETELBEY"
	TextoM2_1:	.asciiz "MUSICA DO MENU"
	TextoM2_2:	.asciiz "AERIALS"
	TextoM2_3:	.asciiz "SYSTEM OF A DOWN"
	TextoM3_1:	.asciiz "MUSICA DOS CREDITOS"
	TextoM3_2:	.asciiz "POISEH POISEH"
	TextoM3_3:	.asciiz "ICT UNIFESP"
	
	screenTop:	.word	0x10008000	# primeiro pixel da tela
	screenBotom:	.word	0x10018000	# ultimo pixel da tela

.text
callCredits: # carregamento da musica dos creditos
	la $t0,PoisehPoiseh
	li $t1,1
	sw $t0,enderecoFaixa
	sw $zero,enderecoFaixa+4
	sb $t1,noteTemp
	li $s7,32
			# Apagando a Tela
	lw $t0,screenTop	#endereço do inicio da tela
	lw $t1,screenBotom	#endereço do final da tela
	add $t2,$zero,$zero	#cor preto
	paint:
		sw $t2,0($t0)		#pinta pixel
		addi $t0,$t0,4
		blt $t0,$t1,paint	#chegou no fim da tel
		
		# desenha Logo da Unifesp com a mesma funcao que desenha o icone de somMudo
	la $a0,Unifesp		#Carrega endereco do simbolo
	addi $a1,$gp,100	#Carrega posicao na tela de bitmap
	jal DrawObject		#Desenha Simbolo

		# Imprimindo os textos da primeira tela
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoP		#Carrga texto
	addi $a2,$gp,21648	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto

	la $a0,NomeDp		#Carrga texto
	addi $a2,$gp,27708	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,NomeC		#Carrga texto
	addi $a2,$gp,30888	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto

	la $a0,NomeGar		#Carrga texto
	addi $a2,$gp,38948	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto

	la $a0,NomeMee		#Carrga texto
	addi $a2,$gp,47124	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto

	la $a0,NomeVo		#Carrga texto
	addi $a2,$gp,55852	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto	
	la $a0,NomeO		#Carrga texto
	addi $a2,$gp,59068	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto

	
	li $v0,30
	syscall
	sw $a0,timebuffer
	add $s6,$a0,$zero
loopCred1:			# Nesse loop enquanto o programa espera passar o tempo vai tocando a musica
	li $v0,30
	syscall
	sub $t3,$a0,$s6
	jal playSong
	blt $t3,6000,loopCred1
	
			#apaga nomes da tela para imprimir outros
	addi $t0,$gp,19972	#endereço da primeira palavra na tela
	lw $t1,screenBotom	#endereço do final da tela
	add $t2,$zero,$zero		#cor preto
	paint2:
		sw $t2,0($t0)		#pinta pixel
		addi $t0,$t0,4
		blt $t0,$t1,paint2	#chegou no fim da tel

	lw $a1,color+84		#Carrega cor branco
	la $a0,Greetings1	#Carrga texto
	addi $a2,$gp,21620	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	la $a0,Greetings2		#Carrga texto
	addi $a2,$gp,33800	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Greetings3	#Carrga texto
	addi $a2,$gp,36988	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	la $a0,Greetings4	#Carrga texto
	addi $a2,$gp,47112	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Greetings5	#Carrga texto
	addi $a2,$gp,50316	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	li $v0,30
	syscall
	add $s6,$a0,$zero
loopCred2:			# a mesma coisa se repete aqui
	li $v0,30
	syscall
	sub $t3,$a0,$s6
	jal playSong
	blt $t3,6000,loopCred2

		#apaga nomes
	addi $t0,$gp,19972	#endereço da area dos nomes
	lw $t1,screenBotom	#endereço do final da tela
	add $t2,$zero,$zero		#cor preto
	paint3:
		sw $t2,0($t0)		#pinta pixel
		addi $t0,$t0,4
		blt $t0,$t1,paint3	#chegou no fim da tela

	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM		#Carrga texto
	addi $a2,$gp,21680	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM1_1	#Carrga texto
	addi $a2,$gp,27772	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM1_2	#Carrga texto
	addi $a2,$gp,31780	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM1_3	#Carrga texto
	addi $a2,$gp,34892	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM2_1	#Carrga texto
	addi $a2,$gp,41052	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM2_2	#Carrga texto
	addi $a2,$gp,45228	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM2_3	#Carrga texto
	addi $a2,$gp,48196	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM3_1	#Carrga texto
	addi $a2,$gp,54308	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM3_2	#Carrga texto
	addi $a2,$gp,58468	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,TextoM3_3	#Carrga texto
	addi $a2,$gp,61564	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	li $v0,30
	syscall
	add $s6,$a0,$zero
loopCred3:			# e aqui tambem esta esperando o tempo passar
	li $v0,30
	syscall
	sub $t3,$a0,$s6
	jal playSong
	blt $t3,6000,loopCred3

j main		# Volta para o menu


