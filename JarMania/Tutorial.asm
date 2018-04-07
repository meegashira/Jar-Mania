.kdata
	# Variaveis de texto do tutorial
	Texto_T0: .asciiz "COMANDOS["
	Texto_T1: .asciiz "W[ SELECIONA ACIMA"
	Texto_T3: .asciiz "S[ SELECIONA ABAIXO"
	Texto_T2: .asciiz "A[ DIMINUI SEGMENTO"
	Texto_T4: .asciiz "D[ AUMENTA SEGMENTO"
	Texto_T5: .asciiz "SPACO[ TROCA JARRO"
	Texto_T6: .asciiz "TAB[ TERMINA TURNO"
	Texto_T7: .asciiz "M[ MUTA A MUSICA"
	Texto_T8: .asciiz "DICA["
	Texto_T9: .asciiz "AO FIM DO TEMPO DE UM"
	Texto_T10: .asciiz "TURNO OS JARROS SAO"
	Texto_T11: .asciiz "TODOS TESTADOS"
.text
callTutorial:
		# codigo que nao quis apagar
#	lw $a1,color+20		#Carrega cor preto
#	la $a0,Texto_T0		#Carrga texto
#	addi $a2,$gp,1548	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T1		#Carrga texto
#	addi $a2,$gp,5644	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T2		#Carrga texto
#	addi $a2,$gp,8716	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T3		#Carrga texto
#	addi $a2,$gp,11788	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T4		#Carrga texto
#	addi $a2,$gp,14860	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T5		#Carrga texto
#	addi $a2,$gp,18444	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T6		#Carrga texto
#	addi $a2,$gp,21516	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T7		#Carrga texto
#	addi $a2,$gp,24588	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T8		#Carrga texto
#	addi $a2,$gp,29196	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T9		#Carrga texto
#	addi $a2,$gp,32780	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T10	#Carrga texto
#	addi $a2,$gp,35852	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
#	la $a0,Texto_T11	#Carrga texto
#	addi $a2,$gp,38924	#Carrega posicao na tela de bitmap
#	jal printLine		#escreve texto
	
	# logica eh apenas imprimir na tela o conteudo das variaveis de texto
	# e retornar para a Logica de entrada do teclado do menu
	
	lw $a1,color+20		#Carrega cor preto
	la $a0,Texto_T0		#Carrga texto
	addi $a2,$gp,1032	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T1		#Carrga texto
	addi $a2,$gp,5128	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T2		#Carrga texto
	addi $a2,$gp,8200	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T3		#Carrga texto
	addi $a2,$gp,11272	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T4		#Carrga texto
	addi $a2,$gp,14344	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T5		#Carrga texto
	addi $a2,$gp,17928	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T6		#Carrga texto
	addi $a2,$gp,21000	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T7		#Carrga texto
	addi $a2,$gp,24072	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T8		#Carrga texto
	addi $a2,$gp,28680	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T9		#Carrga texto
	addi $a2,$gp,32264	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T10	#Carrga texto
	addi $a2,$gp,35336	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_T11	#Carrga texto
	addi $a2,$gp,38408	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
j InputMenu
