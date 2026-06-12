.data
	.space 32768 # reserva a área de memória da tela (8192 pixels * 4 bytes)
	
.text
main:
	la $4, bg_hell
	jal render
	jal ghost_hell
	#jal timer
	
	#la $4, bg_earth
	#jal render
	#jal timer
	
	#la $4, bg_heaven
	#jal render
	#jal timer
	
	addi $2, $0, 10
	syscall
	
# alterados: $5, $6, $7
# entrada: $4 (cenario)
# saida: void	
render:
	lui $5, 0x1001 # serve para resetar o ponteiro (base do Bitmap Display)
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
	addi $6, $0, 50000
forTimer:
	beq $6, $0, endTimer
	sub $6, $6, 1
	j forTimer
endTimer:
	jr $31

ghost_hell:
    add $25, $0, $31 # salva endereço de retorno original do jogo
    
    la $15, line_ghost_values # endereço base do array
    addi $15, $15, 4 # pula o primeiro '-1' -> Aponta para o valor 10 (Início)
    addi $16, $15, 100 # avança 15 elementos (25 * 4 = 100) -> Aponta para o valor 30 (Fim)
    
    # inicializa os passos (direção) de iteração na memória
    li $19, 4 # ponteiro $15 vai andar para a frente (+4 bytes)
    li $20, -4 # ponteiro $16 vai andar para trás (-4 bytes)

for_hell:
    lw $4, 0($15) # linha para o fantasma do meio
    lw $5, 0($16) # linha para os fantasmas das pontas (usando $5 temporariamente)
    
    # se qualquer um for -1, bateu na borda do array, então inverte o sinal
    beq $4, -1, inverter_signal
    beq $5, -1, inverter_signal

    # desenha os fantasmas
    raw_ghost_left:
        lw $7, column_ghost_left
        add $4, $0, $5
        jal draw_ghost

    draw_ghost_mid:
        lw $7, column_ghost_mid
        lw $4, 0($15)
        jal draw_ghost

    draw_ghost_right:
        lw $7, column_ghost_right
        add $4, $0, $5
        jal draw_ghost
        
    # atualiza os ponteiros para o próximo frame
    add $15, $15, $19
    add $16, $16, $20
    
    addi $4, $0, 50
    addi $2, $0, 32
    syscall
    
    la $4, bg_hell
    jal render
    
    j for_hell
	
end_ghost_hell:
    jr $25
    
inverter_signal:
    # inverte o sinal dos passos multiplicando por -1
    mul $19, $19 -1
    mul $20, $20, -1
    
    add $15, $15, $19
    add $16, $16, $20
    
    j for_hell

 # importa arquivo com os cenários
.include "backgrounds\bg_hell.asm"
.include "backgrounds\bg_earth.asm"
.include "backgrounds\bg_heaven.asm"
.include "sprites\ghost\enemy_ghost.asm"
