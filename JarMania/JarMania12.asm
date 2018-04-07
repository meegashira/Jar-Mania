.kdata
# Entrada do teclado que executara as acoes no jogo
	action:		.word	0	
# Selecionador de Jarros	
	selection:	.word	0:3		# endereco do parametro do segmento(endereco do segmento),
						# endereco do primeiro segmento(endereco do jarro),
						# valor da possicao do jarro na tela(deve ser somado a GP)
						

	background:	.word	0xfceaa0 		
	jarcolor:	.word	0x6d2924	
	
		#parametros dos jarros de modelar(1seg,2seg,3seg...)
		#o 1seg eh o segmento mais acima na tela
	jar1:		.word	0:7	
	jar2:		.word	0:7
	jar3:		.word	0:7
	
	
		#Buffer que armazena o endereco do inicio dos parametros que devem ser comparados
		#o primeiro compara com jar1
		#o segundo com jar2
		#e o terceiro com jar3
	checkBox:	.word	0:3
	
# Modelos de Jarros
	jModel1:	.word	6,4,6,8,10,10,8
	jModel2:	.word	16,12,16,16,16,14,12
	jModel3:	.word	8,6,8,8,8,8,6
	jModel4:	.word	10,8,6,12,14,14,12
	jModel5:	.word	6,4,4,8,14,16,14
	jModel6:	.word	12,14,12,8,4,8,12
	jModel7:	.word	4,6,4,8,10,10,8
	jModel8:	.word	14,12,14,14,12,10,8
	jModel9:	.word	8,10,16,16,14,12,8
# Bloco para apagar todo o espaco de um jarro
	jDEATH:		.word	16:7
	
	EasterEggTXT:	.asciiz	"JAR GOD"
.text
GameStart: #limpa registradores
	li $v0, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
        li $s5, 0
        li $s6, 0


paintBackGround: #Imprime o BackGround
jal DrawBackground
jal setPontuacao
jal setVita
la $a0,pergaminho
add $a1,$gp,19460
jal DrawObject

		#Testa se o som esta mutado
lw $t0,volume		#carrega valor do volume
bnez $t0,tagJM		#se volume nao eh zero continua a carregar outras informacoes
la $a0 noSoundOBJ	#carrega simbolo de mute
add $a1,$gp,9656	# posicao do simbolo
jal DrawObject		# desenha simbolo
tagJM:
		#Carregamento da musica
la $t0,faixa_melodia		#carrega faixa1
la $t1,faixa_solo		#carrega faixa2
la $t2,faixa_acompanhamento	#carrega faixa3
li $t3,1			#carrega 1 para reiniciar temporizador de notas
sw $t0,enderecoFaixa		#salva faixa1
sw $t1,enderecoFaixa+4		#salva faixa2
sw $t2,enderecoFaixa+8		#salva faixa3
sw $zero,enderecoFaixa+12	#Atribui 0 a ultima faixa como condição de parada
sb $t3,noteTemp			# Reinicia temporizadores das notas
sb $t3,noteTemp+1
sb $t3,noteTemp+2
li $s7,40			# carrega tempo de uma semifusa em $s7
			# !!!!!!! $s7 reservado para compasso musical  !!!!!!!!

		#iniciando selecionador de Jarros
la $t0,jar1		#endereco do primeiro segmento do primeiro jarro
sw $t0,selection	#armazena esse endereco na memoria
add $t1,$t0,$zero	#copia para $t1		
sw $t0,selection+4	#o primeiro segmento de todo jarro tem o mesmo endereco dele
li $t3,42604		#posicao na tela sem $gp
sw $t3,selection+8	#armazena posicao na memoria

		#pinta indicador
sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
			#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
			# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
			# vez que cada segmento tem 4 linhas
mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
add $s0,$s0,$t3		#soma a posicao do jarro
add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
add $s0,$s0,-68		#posiciona no local do indicador
lw $a0,color+80
jal printIndicador


randomJarGen: #Logica para gerar um turno Aleatorio

		#Liberando area para pintar jarros
	lw $a0,background#cor dos jarros
      	li $s0,42604	#posicao do 1o jarro
      	la $s1,jDEATH	#bloco de reset
      	jal printJars
      	li $s0,42752	#posicao do 2o jarro
      	la $s1,jDEATH	#bloco de reset
      	jal printJars
      	li $s0,42900	#posicao do 3o jarro
      	la $s1,jDEATH	#bloco de reset
      	jal printJars
      	
      	lw $a0,color+128#cor dos jarros
      	li $s0,22636	#posicao do jarro modelo
      	la $s1,jDEATH	#parametros do 1o jarro modelo
      	jal printJars
      	li $s0,22784	#posicao do jarro modelo
      	la $s1,jDEATH	#parametros do 2o jarro modelo
      	jal printJars
      	li $s0,22932	#posicao do jarro modelo
      	la $s1,jDEATH	#parametros do 3o jarro modelo
      	jal printJars
		
		#Logica para gerar parametros aleatorios nos jarros que sao modificaveis
	li $v0,30	#system time
	add $t2,$a0,$zero#t0 <- low order 32 bits of system time
	li $v0,40	#set seed para randomizacao
	li $a0,1	#seed corresponde a tag 1
	move $a1,$t2	#valor da seed
	syscall		#syscall para seed
	li $v0,42	#random int range
	li $a0,1	#tag da seed
	li $a1,8	#tamanho maximo da metade de cada uma das extremidades do vaso
	li $t3,2	#usado em multiplicacao para o tamanho do jarro
	la $t0,jar1	#endereco do primeiro parametro de jarro <-
	la $t1,jar3+28	#endereco do ultimo parametro de jarro <--
	rjgLoop:
		syscall			#chama numero randomico entre 1 e 8
		beqz $a0,rjgLoop	#se o numero aleatorio for igual a zero retorna ao loop
		mul $a0,$a0,$t3		#alinha o tamanho do segmento
        	sw $a0,0($t0)		#guarda parametro <-
        	addi $t0,$t0,4		#proximo endereco de parametro
        	blt $t0,$t1,rjgLoop	#Testa se os parametros acabaram <--
        	
        	#aleatoriza qual jarro sera o modelo
        li $a1,9		#Numero de jarros modelo
        la $t2,jModel1		# primeiro endereco do primeiro jarro modelo
        la $t0,checkBox		# primeiro endereco da check box
        la $t1,checkBox+12	# endereco para checagem de final de loop
        rcbLoop:
        	syscall			#gera um numero
        	mul $a0,$a0,28		#multiplica pelo numero de palavras de um jarro modelo
        	add $a0,$a0,$t2,	#soma com o endereço base
        	sw $a0,0($t0)		# armazena na checkBox
        	addi $t0,$t0,4		# proxima posicao da checkBox
        	blt $t0,$t1,rcbLoop	#Testa se as posicoes da checkBox acabaram
			    
			    # Desenhando os jarros na tela de bitmap
        lw $a0,jarcolor#cor dos jarros
      	li $s0,42604	#posicao do 1o jarro
      	la $s1,jar1	#parametros do 1o jarro
      	jal printJars
      	li $s0,42752	#posicao do 2o jarro
      	la $s1,jar2	#parametros do 2o jarro
      	jal printJars
      	li $s0,42900	#posicao do 3o jarro
      	la $s1,jar3	#parametros do 3o jarro
      	jal printJars
      	
      	lw $a0,color+80#cor dos jarros
      	li $s0,22636	#posicao do jarro modelo
      	lw $s1,checkBox	#parametros do 1o jarro modelo
      	jal printJars
      	li $s0,22784	#posicao do jarro modelo
      	lw $s1,checkBox+4#parametros do 2o jarro modelo
      	jal printJars
      	li $s0,22932	#posicao do jarro modelo
      	lw $s1,checkBox+8#parametros do 3o jarro modelo
      	jal printJars
		
		# Inicia um contador para controlar o tempo do turno
		# funcoes do arquivo contador.asm
lw $a0,timeCountDown	#tempo da contagem em segundosdos
jal setTime		#seta o tempo de contagem		
	
	# Carregando parametros para funcao getTime
	# essa funcao retorna algarismos do contador na tela de bitmap
lw $a0,background	#Cor de fundo dos numeros
lw $a1,color+80		#cor dos numeros
li $a2,4016		#Posicao dos numeros
add $a2,$a2,$gp		#soma posicao com $gp para colocalo no display
jal getTime		#geta o tempo em forma de imagem

li $v0,30		# system time
syscall
add $s6,$a0,$zero	#armazena os numeros de baixa ordem em $s6 para testes de tempo
		# !!!!!!!!!!! $s6 reservado para contagem !!!!!!!!!!!!!!!!!
     	
InputCheck: #Logica da entrada do teclado 
        li $a1,0
        li $t0,0
	li $t0, 0xffff0000
	lw $t1, ($t0)
	andi $t1, $t1, 0x0001
	beqz $t1,timeTag
	lw $a1, 4($t0) 
#########################################
#                COMANDOS 		#
# 119 - w				#
# 115 - s				#
# 97 - a				#
# 100 - d				#
# 32 -Space				#
# 9 - TAB				#
# 109 - m				#
#########################################
	sw $a1, action
	lw $t0, action
	
	beq $t0,100,increasejar
	beq $t0,97,decreasejar
	beq $t0,119,nextsectionup
	beq $t0,115,nextsectiondown
	beq $t0,32,changejar
	beq $t0,9,checkjar
	beq $t0,109,muteSoundGame
	
timeTag:li $v0,30		#system time
	syscall
	sub $t3,$a0,$s6		#subtrai o tempo atual do armazenado
	jal playSong		# Logica para tocar a musica do jogo
	bne $v1,0,timeTag2	# teste para fazer com q a musica toque em loop
			# reinicia musica
	la $t0,faixa_melodia		#carrega faixa1
	la $t1,faixa_solo		#carrega faixa2
	la $t2,faixa_acompanhamento	#carrega faixa3
	li $t3,1			#carrega 1 para reiniciar temporizador de notas
	sw $t0,enderecoFaixa		#salva faixa1
	sw $t1,enderecoFaixa+4		#salva faixa2
	sw $t2,enderecoFaixa+8		#salva faixa3
	sw $zero,enderecoFaixa+12	#Atribui 0 a ultima faixa como condição de parada
	sb $t3,noteTemp			# Reinicia temporizadores das notas
	sb $t3,noteTemp+1
	sb $t3,noteTemp+2
	
timeTag2:blt $t3,999,InputCheck	#se for menor que 999 milesimos volta para o loop de leitura do teclado
	
	li $v0,30		#system time
	syscall
	add $s6,$a0,$zero	#armazena o novo tempo atual para contagem
	
	lw $a0,background	#cor de fundo
	lw $a1,color+80	#cor dos numeros
	li $a2,4016		#posicao dos nuemros
	add $a2,$a2,$gp		#posicao no display
	jal getTime		#get time em forma de imagem
	
	beq $v0,1,InputCheck	# se a contagem nao acabou volta para o loop de leitura do teclado
	j checkjar

      	# Comandos posiveis do jogo
muteSoundGame:
	lw $t0,volume
	beqz $t0,tagMSG
	li $t0,0
	sw $t0,volume
	la $a0 noSoundOBJ
	add $a1,$gp,9656
	jal DrawObject
	j InputCheck
tagMSG:	li $t0,90
	sw $t0,volume
	la $a0 sky11x11block3
	add $a1,$gp,9656
	jal DrawObject
	j InputCheck
	
increasejar:		#comando D
	lw $t0,selection	#carrega endereco do parametro do segmento
	lw $t1,0($t0)		#carrega o parametro do segmento
	beq $t1,16,InputCheck	#checa se o parametro esta no limite superior
	addi $t1,$t1,2		#aumenta parametro
	sw $t1,0($t0)		#armazena o novo valor	
	
	lw $s0,selection	#endereco segmento
	lw $s1,selection+4	#endereco jarro
	lw $s2,selection+8	#posicao do jarro
	sub $s0,$s0,$s1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$s2		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	addi $t0,$s0,4		#adiciona uma palavra para alinhar a busca com a borda direita do menor parametro possivel
	lw $t1,jarcolor		#carrega cor do jarro
	increaseSegmentFoward:		#busca a borda direita do segmento para aumentala
		addi $t0,$t0,4		#proxima pixel da tela
		lw $t2,0($t0)		#carrega cor desse pixel
		beq $t2,$t1,increaseSegmentFoward #se a cor do pixel eh igual a do jarro busca denovo
		sw $t1,0($t0)		#pinta uma coluna
		sw $t1,512($t0)
		sw $t1,1024($t0)
		sw $t1,1536($t0)
		sw $t1,4($t0)		#pinta outra coluna
		sw $t1,516($t0)
		sw $t1,1028($t0)
		sw $t1,1540($t0)
	addi $t0,$s0,-8		#subtrai duas palavra para alinhar a busca com a borda esquerda do menor parametro possivel	
	increaseSegmentBackward:	#busca a borda esquerda para aumentala
		addi $t0,$t0,-4		#proximo pixel da tela
		lw $t2,0($t0)		#carrega cor desse pixel
		beq $t2,$t1,increaseSegmentBackward#se a cor eh igual a do jarro busca denovo
		sw $t1,0($t0)		#pinta uma coluna
		sw $t1,512($t0)
		sw $t1,1024($t0)
		sw $t1,1536($t0)
		sw $t1,-4($t0)		#pinta outra coluna
		sw $t1,508($t0)
		sw $t1,1020($t0)
		sw $t1,1532($t0)	
	j InputCheck
decreasejar:		#comando A
      	
	lw $t0,selection	#carrega endereco do parametro do segmento
	lw $t1,0($t0)		#carrega o parametro do segmento
	beq $t1,2,InputCheck		#checa se o paramerto esta no limite inferior
	addi $t1,$t1,-2		#diminui parametro
	sw $t1,0($t0)		#armazena novo valor
	
	lw $s0,selection	#endereco segmento
	lw $s1,selection+4	#endereco jarro
	lw $s2,selection+8	#posicao do jarro
	
			#Todos os procedimentos semelhantes aos de increasejar
	sub $s0,$s0,$s1
	mul $s0,$s0,512
	add $s0,$s0,$s2
	add $s0,$s0,$gp
	addi $t0,$s0,4
	lw $t1,jarcolor
	decreaseSegmentFoward:	#busca a borda da direita para reduzila
		addi $t0,$t0,4
		lw $t2,0($t0)
		beq $t2,$t1,decreaseSegmentFoward#loop de busca
		lw $t2,background	#carrega cor de background
		sw $t2,-4($t0)		#pintando os pixels
		sw $t2,508($t0)
		sw $t2,1020($t0)
		sw $t2,1532($t0)
		sw $t2,-8($t0)		#
		sw $t2,504($t0)		
		sw $t2,1016($t0)	
		sw $t2,1528($t0)
	addi $t0,$s0,-8
	decreaseSegmentBackward:#busca a borda da esquerda para reduzila
		addi $t0,$t0,-4
		lw $t2,0($t0)
		beq $t2,$t1,decreaseSegmentBackward#loop de busca
		lw $t2,background	#carrega cor de background
		sw $t2,4($t0)		#pinando os pixels
		sw $t2,516($t0)
		sw $t2,1028($t0)
		sw $t2,1540($t0)
		sw $t2,8($t0)		#
		sw $t2,520($t0)
		sw $t2,1032($t0)
		sw $t2,1544($t0)	
	j InputCheck
nextsectionup:		#comando W
	lw $t0,selection	#carrega o endereco do segmento selecionado
	lw $t1,selection+4	#carrega o endereco do jarro selecionado
		#apaga indicador
	lw $s2,selection+8	#posicao do jarro
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$s2		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,background
	jal printIndicador
	
	addi $t0,$t0,-4		#sobe um segmento		
	
	bge $t0,$t1,tagNSU	#testa se nao subiu alem dos limites
	addi $t0,$t0,28		#pula para o ultimo segmento
	
tagNSU:	sw $t0,selection	#armazena o novo endereco
		#pinta indicador
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$s2		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,color+80
	jal printIndicador
	
	j InputCheck
nextsectiondown:	#comando S
	lw $t0,selection	#carrega o endereco do segmento selecionado
	lw $t1,selection+4	#carrega o endereco do jarro selecionado
	
		#apaga indicador
	lw $s2,selection+8	#posicao do jarro
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$s2		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,background
	jal printIndicador
	
	addi $t0,$t0,4		#desce um segmento
	addi $t2,$t1,24		#t2 contem o endereco do final do jarro
	ble $t0,$t2,tagNSD	#testa se nao desceu alem dos limites
	addi $t0,$t0,-28
	
tagNSD:	sw $t0,selection	#armazena o novo endereco

		#pinta indicador
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$s2		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,color+80
	jal printIndicador

	j InputCheck
changejar:		#comando Space
	lw $t0,selection	#carrega o endereco do segmento selecionado
	lw $t1,selection+4	#carrega o endereco do jarro selecionado
	lw $t3,selection+8	#carrega a posicao na tela do jarro selecionado
			#Apaga indicador
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$t3		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,background
	jal printIndicador
	
	addi $t0,$t0,28		#passa para o mesmo segmento do jarro seguinte
	addi $t1,$t1,28		#passa para o jarro seguinte
	addi $t3,$t3,148	#passa para a posicao na tela do jarro seguinte
	la $t2,jar3+28		#carrega o endereco do ultimo parametro do jarro
	blt $t1,$t2,tagCJ	#se o novo endereco do jarro for menor entao sem problemas
	addi $t0,$t0,-84	#pula para o mesmo segmento no primeiro jarro
	addi $t1,$t1,-84	#pula para o primeiro jarro
	addi $t3,$t3,-444	#pula para a posicao na tela do primeiro jarro
tagCJ:	sw $t0,selection	#guarda o segmento selecionado
	sw $t1,selection+4	#guarda o jarro selecionado
	sw $t3,selection+8	#guarda a posicao na tela do jarro selecionado
			#pinta indicador
	sub $s0,$t0,$t1		#subtrai endereco do jarro do endereco do segmento
				#como cada palavra tem 4 posicoes de endereco fazendo essa diferenca obtemos
				# a diferenca entre o topo do jarro e o segmento que estamos manipulando uma
				# vez que cada segmento tem 4 linhas
	mul $s0,$s0,512		#multiplica a diferenca por 512(posicoes de memoria correspondetes entre um pixel e seu inferior imediato
	add $s0,$s0,$t3		#soma a posicao do jarro
	add $s0,$s0,$gp		#soma a $gp para posicionalo na tela
	add $s0,$s0,-68		#posiciona no local do indicador
	lw $a0,color+80
	jal printIndicador
	
	j InputCheck
	
checkjar:	#Compara jarro modelado com jarro modelo
	la $s0,jar1		#Endereco dos parametros do primeiro jarro
	la $s2,jar1+28		#fim dos parametros do primeiro jarro
	la $s1,checkBox		#primeiro endereco da checkBox
	la $s3,checkBox+12	#fim da checkBox
	li $s4,0
	checkloop:
		lw $t3,0($s1)		#endereco dos parametros do jarro modelo
		li $t4,50		#Contador de pontos
performCL:	lw $t0,0($s0)		# carrega parametro do jarro
		lw $t1,0($t3)		# carrega parametro do modelo
		addi $s0,$s0,4		# proximo parametro do jarro
		addi $t3,$t3,4		# proximo parametro do modelo
		beq $t0,$t1,tagCL	# se os parametros do jarro e modelos forem iguais nao desconta pontos
		addi $t4,$t4,-10		# desconta pontos se os parametros forem diferentes
	tagCL:	blt $s0,$s2,performCL	# se nao chegou ao final dos parametros do jarro testa denovo
		addi $s2,$s2,28		# proximo fim de parametros de jarro
		
		bgtz $t4,moreThanZero	# Teste de pontuacao que controla a vida do jogador
		li $t4,0		# se errar muitos segmentos perde vidas
		addi $s4,$s4,1
		moreThanZero:
			add $a0,$t4,$zero
			jal sumPontuacao
		sw $t4,0($s1)		# grava os pontos na checkBox
		addi $s1,$s1,4		#proxima posicao da checkBox
		blt $s1,$s3,checkloop	# se checkBox nao acabou testa devono
		checkErrors:
		lw $t0,erros
		sub $t0,$t0,$s4
		bgtz $t0,NonNegativeError # para caso hajam valores negativos de pontos
		li $t0,0
		NonNegativeError:
		sw $t0,erros
		
	# Logica para imprimir as gemas com base nos pontos
getGems1:	
	li $v0,30
	syscall
	sub $t3,$a0,$s6
	jal playSong
	blt $t3,1000,getGems1
	lw $a1,color+8
	la $a2,42540($gp)
	la $s0,checkBox	
	la $s1,checkBox+8
	la $s2,42984($gp)
	startGetRewards:
	lw $t0,($s0)
	breakGem:
		bnez $t0,RewardJar
		lw $a1,color+8
		jal breakJarEffect
		j endGetRewards
	RewardJar:
		li $t1,10
		div $t0,$t1
		mflo $t0
		subi $a0,$t0,1
		la $a1,1580($a2)
		jal DrawGem
		la $a1,7704($a2)
		jal DrawGem
		la $a1,7748($a2)
		jal DrawGem
	endGetRewards:
	addi $s0,$s0,4
	addi $a2,$a2,148
	bne $a2,$s2,startGetRewards
	
	# Imprime a Pontuacao e Vidas atuais
lw $a1,color+80	
jal getPontuacao
jal getVita
tagCL2:
li $v0,30
syscall
sub $t3,$a0,$s6
jal playSong
blt $t3,2000,tagCL2
	
	# quanto mais pontos o jogador tiver seu turnos vao ficando mais curtos
	# dando a ele menos tempo para montar os jarros
getNewTimeCountdown:
#########################################
# 60 seg -> 0 pts			#
# 54 seg -> 450 pts -> +1 vida 		#
# 48 seg -> 900 pts -> +1 vida		#
# 45 seg -> 1350 pts -> +1 vida		#
# 40 seg -> 1700 pts -> +1 vida		#
# 35 seg -> 2050 pts -> +2 vida		#
# 32 seg -> 2400 pts -> +2 vida		#
# 30 seg -> 2750 pts -> +3 vida		#
# 27 seg -> 5000 pts -> +5 vida		#
#########################################
		# essa logica se baiseia em um contador que eh aumentado de acordo com os limiares de pontos alcancados
		# com base no seu valor os branchs sao acessados
		# dando ao jogador bonus de vidas quando ultrapassa algum limiar
lw $t0,pontuacao
	li $t1,60
pt1:	blt $t0,450,endpt
	li $t1,54
	lw $t3,walkThrough
	bgt $t3,0,pt2
	lw $t2,erros
	addi $t2,$t2,1
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt2:	blt $t0,900,endpt
	li $t1,48
	lw $t3,walkThrough
	bgt $t3,1,pt3
	lw $t2,erros
	addi $t2,$t2,1
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt3:	blt $t0,1350,endpt
	li $t1,45
	lw $t3,walkThrough
	bgt $t3,2,pt4
	lw $t2,erros
	addi $t2,$t2,1
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt4:	blt $t0,1700,endpt
	li $t1,40
	lw $t3,walkThrough
	bgt $t3,3,pt5
	lw $t2,erros
	addi $t2,$t2,1
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt5:	blt $t0,2050,endpt
	li $t1,35
	lw $t3,walkThrough
	bgt $t3,4,pt6
	lw $t2,erros
	addi $t2,$t2,2
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt6:	blt $t0,2400,endpt
	li $t1,32
	lw $t3,walkThrough
	bgt $t3,5,pt7
	lw $t2,erros
	addi $t2,$t2,2
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt7:	blt $t0,2750,endpt
	li $t1,30
	lw $t3,walkThrough
	bgt $t3,6,pt8
	lw $t2,erros
	addi $t2,$t2,3
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt8:	blt $t0,5000,endpt
	li $t1,27
	lw $t3,walkThrough
	bgt $t3,7,pt9
	lw $t2,erros
	addi $t2,$t2,5
	sw $t2 erros
	addi $t3,$t3,1
	sw $t3,walkThrough
pt9:	li $t1,27
	lw $a1,color+32		#Carrega cor preto
	la $a0,EasterEggTXT	#Carrega texto
	addi $a2,$gp,5300	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
endpt:	sw $t1,timeCountDown

lw $t0,erros		# erros sao as vidas do jogador
bnez $t0,continue	# se ela eh zero deu game over

j callGameOver		# chama fucao gameOver

continue:
jal randomJarGen

printJars: #imprime os jarros
	# fucao que imprime os jarros
#########################################
#		ATENCAO			#
#---------------------------------------#
# $a0 deve ser carregado previamente	#
#	com a cor dos jarros		#
# $s0 deve ser carregado previamente	#
#	com o valor da posicao dos 	#
#	jarros(Sem $gp)			#
# $s1 deve ser carregado previamente	#
#	com o endereco dos parametros 	#
#	do jarro			#
#---------------------------------------#
# $t0, $t1, $t2, $t3, $s2 sao usados	#
# na funcao				#
#########################################
	add $s0,$s0,$gp
	li $t1,0	#reseta indice de linhas
	addi $s2,$s1,28	#endereco do ultimo parametro dos jarro
	printJ:
		li $t2,0			#reseta indice de colunas
		lw $t0,0($s1)			#carrega o primeiro parametro em t0
		jarColumsPos:
			add $t3,$t2,$t2		#calculo da posicao que os pixels serao pintados
			add $t3,$t3,$t3
			add $t3,$t3,$s0
			sw $a0,0($t3)		#pinta 4 pixels de uma coluna em um segmento
			sw $a0,512($t3)
			sw $a0,1024($t3)
			sw $a0,1536($t3)
			addi $t2,$t2,1		#proximo indice
			blt $t2,$t0,jarColumsPos#se ainda não chegou ao fim do segmento volta para o inicio
		addi $s0,$s0,-4	#posicao para pintar o outro lado do jarro
		mul $t0,$t0,-1	#limitador negativo para o outro lado
		li $t2,0	#reseta o indice de colunas
		jarColumsNeg:
			add $t3,$t2,$t2		#calculo da posicao que os pixels serao pintados
			add $t3,$t3,$t3
			add $t3,$t3,$s0
			sw $a0,0($t3)		#pinta 4 pixels de uma coluna em um segmento
			sw $a0,512($t3)
			sw $a0,1024($t3)
			sw $a0,1536($t3)
			addi $t2,$t2,-1		#proximo indice
			bgt $t2,$t0,jarColumsNeg#se ainda não chegou ao fim do segmento volta para o inicio
        	addi $s1,$s1,4		#passa para o proximo parametro do jarro
        	addi $s0,$s0,2052	#posicao para pintar o proximo segmento
        	addi $t1,$t1,1		#contagem de segmentos
        	blt $t1,7,printJ	# testa se os segmentos acabaram
        jr $ra

