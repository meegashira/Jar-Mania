.kdata

	Texto_Jogar:	.asciiz "JOGAR"
	Texto_Com:	.asciiz "COMANDOS"
	Texto_Cred:	.asciiz "CREDITOS"

.text
.globl main
#########################################################
#	JAR MANIA LAUCHER eh...				#
# O Bloco de Programa que interliga todos os arquivos	#
# Nele esta a programacao do menu que direciona o	#
# programa para o arquivo da opção selecionada		#
#########################################################
main:
			#Inicio do carregamento da musica do Menu
	la $t0,aerials_sitar
	la $t1,aerials_muteGuitar
	li $t2,1
	sw $t0,enderecoFaixa
	sw $t1,enderecoFaixa+4
	sw $zero,enderecoFaixa+8
	sb $t2,noteTemp
	sb $t2,noteTemp+1 
	li $s7,32	# !!!! REGISTRADOR S7 RESERVADO PARA COMPASSO MUSICAL !!!!
			#termino do carregamento da musica do Menu
	
	jal DrawMenu	# Esta funcao esta contida no arquivo gameArt.asm
			# ela eh responsavel por desenhar o plano de fundo do menu
	
	lw $t0,volume
	bnez $t0,tagMainMenu	# condicao para exibir icone de som mudo
	la $a0 noSoundOBJ
	add $a1,$gp,464
	jal DrawObject		# outra funcao de gameArt.asm
				# desenha objetos
	
tagMainMenu:	
		#A Escrita dos Textos do menu eh feita pela funcao printLine
		# do arquivo PrintLine.asm
		
	lw $a1,color+20		#Carrega cor preto
	la $a0,Texto_Jogar	#Carrga texto
	addi $a2,$gp,53260	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_Cred	#Carrga texto
	addi $a2,$gp,53560	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_Com	#Carrga texto
	addi $a2,$gp,57472	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+84		#Carrega cor branco
	la $a0,Texto_Jogar	#Carrga texto
	addi $a2,$gp,52744	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	lw $a1,color+28		#Carrega cor marron
	la $a0,Texto_Cred	#Carrga texto
	addi $a2,$gp,53044	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	la $a0,Texto_Com	#Carrga texto
	addi $a2,$gp,56956	#Carrega posicao na tela de bitmap
	jal printLine		#escreve texto
	
	la $t0,Texto_Jogar	# carregando informaçoes do selecionador
	li $t1,52744
	la $t2,GameStart
	sw $t0,selection
	sw $t1,selection+4
	sw $t2,selection+8	# No menu o selecionador tem:
			# O endereco na memoria do Texto selecionado
			# A posicao relativa na tela do texto
			# e o endereco da funcao em outro arquivo para o qual o programa sera
			# conduzido se a selecao for confirmada
	
	li $a3,90	#iniciando um buffer de tempo para tocar as musicas
	li $v0,30
	syscall
	sw $a0,timebuffer
	add $s6,$a0,$zero
InputMenu: # Logica da entrada do teclado
        li $a1,0
        li $t0,0
	li $t0, 0xffff0000
	lw $t1, ($t0)
	andi $t1, $t1, 0x0001
	beqz $t1,MenuTag
	lw $a1, 4($t0) 
#########################################
#                COMANDOS 		#
# 32 -Space				#
# 9 - TAB				#
# 109 - m				#
#########################################
	sw $a1, action
	lw $t0, action

	beq $t0,32,changeOption
	beq $t0,9,checkOption
	beq $t0,109,muteSoundMenu
	
MenuTag:li $v0,30
	syscall
	jal playSong	#funcao que reproduz a musica carregada
			# esta no arquivo playSongFunctionsSS.asm
	bne $v1,0,MenuTag2
	la $t0,aerials_sitar
	la $t1,aerials_muteGuitar
	li $t2,1
	sw $t0,enderecoFaixa
	sw $t1,enderecoFaixa+4
	sb $t2,noteTemp
	sb $t2,noteTemp+1
MenuTag2:j InputMenu

muteSoundMenu: # Logica para mutar a musica
	# Se baseia em apenas zerar o volume do som
	lw $t0,volume
	beqz $t0,tagMS	# codicao para desenho do icone de som mudo
	li $t0,0
	sw $t0,volume
	la $a0 noSoundOBJ
	add $a1,$gp,464
	jal DrawObject
	j InputMenu
	jr $ra
tagMS:	li $t0,90
	sw $t0,volume
	la $a0 sky11x11block1
	add $a1,$gp,464
	jal DrawObject
	j InputMenu
	
changeOption:
		#Logica da troca de Opcao
		# Sao Varios branchs que respondem de acordo com o texto atual selecionado
		
	lw $a1,color+28		#Apaga selecao na tela de bitmap
	lw $a0,selection
	lw $a2,selection+4
	add $a2,$a2,$gp
	jal printLine
	
	la $t0,Texto_Jogar
	bne $a0,$t0,tagCO1		# Se a opcao selecionada eh jogar
		la $t0,Texto_Com	#Passa para Comandos
		li $t1,56956
		la $t2,callTutorial
		sw $t0,selection
		sw $t1,selection+4
		sw $t2,selection+8
		j tagCO3
		
tagCO1:	la $t0,Texto_Com		# Se a opcao selecionada eh comandos
	bne $a0,$t0,tagCO2		# Passa para creditos
		la $t0,Texto_Cred
		li $t1,53044
		la $t2,callCredits
		sw $t0,selection
		sw $t1,selection+4
		sw $t2,selection+8
		j tagCO3
					# Como creditos eh a ultima opcao
					# nao ha condicao de selecao basta apenas que nao seja as outras
					# retorna a selecao para Jogar
tagCO2:		la $t0,Texto_Jogar
		li $t1,52744
		la $t2,GameStart
		sw $t0,selection
		sw $t1,selection+4
		sw $t2,selection+8
		
tagCO3: add $a0,$t0,$zero  # Escreve a selecao na tela de BitMap
	lw $a1,color+84
	add $a2,$t1,$gp
	jal printLine
	
	j InputMenu

checkOption:
 		#Logica da Confirmacao de Selecao
 		# apenas se carrega o endereco destino
 		# e o programa eh conduzido para ele
	lw $ra,selection+8
	jr $ra

.include "JarMania12.asm"
.include "gameOver.asm"
.include "GameArt.asm"
.include "PlaySongFunctionsSS.asm"
.include "PrintLine.asm"
.include "Creditos.asm"
.include "Tutorial.asm"
.include "Contador.asm"
.include "Pontuacao.asm"
.include "PrintNumbers.asm"
.include "mercadoPersa.asm"
.include "PoisehPoiseh.asm"
.include "aerialsTrack.asm"

