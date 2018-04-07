.text
jal setPontuacao
li $t0,10
sw $t0,pontuacao
jal getPontuacao

li $v0,10
syscall

.include "Pontuacao.asm"


.include "GameArt.asm"


.include "PrintLine.asm"


.include "Contador.asm"
.include "PrintNumbers.asm"

