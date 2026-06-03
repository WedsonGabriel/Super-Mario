.data
    # importa arquivo com os cenários
	.include "cenarios/1-Hell.asm"
	.include "cenarios/2-Earth.asm"
	.include "cenarios/3-Sky.asm" 

.text
main:
	la $4, cenario_1
	jal render
	jal timer
	la $4, cenario_2
	jal render
	jal timer
	la $4, cenario_3
	jal render
	jal timer
	addi $2, $0, 10
	syscall
	
# alterados: $5, $6, $7
# entrada: $4 (cenario)
# saida: void	
render:
	lui $5, 0x1001 # serve para resetar o ponteiro
	addi $6, $0, 8192
forRender:
	beq $6, 0, endRender
	lw $7, 0($4)
	sw $7, 0($5)
	addi $4, $4, 4
	addi $5, $5, 4
	sub $6, $6, 1
	j forRender
endRender:
	jr $31

timer:
	addi $6, $0, 900000
forTimer:
	beq $6, $0, endTimer
	sub $6, $6, 1
	j forTimer
endTimer:
	jr $31