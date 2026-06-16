.data
	.space 32768 # reserva a área de memória da tela (8192 pixels * 4 bytes)
	
	# Variáveis de Estado Global: 0 = bg_hell, 1 = bg_earth
	current_phase: .word 0 # a fase atual começa no inferno
	
.text
main:

# ====================================================================
# GERENCIADOR CENTRAL DO JOGO (MÁQUINA DE ESTADOS)
# ====================================================================
game_manager:
	jal check_keyboard # checa a tecla pressionada
	jal check_boundaries # checa o limite da tela/progressão
	
	lw $8, current_phase # carrega a fase atual
	beq $8, 0, render_bg_hell
	beq $8, 1, render_bg_earth

render_bg_hell:
	la $4, bg_hell
	jal render
	jal hell
	j draw_player_layer

render_bg_earth:
	la $4, bg_earth
	jal render
	jal earth
	j draw_player_layer

draw_player_layer:
	jal draw_player
	addi $4, $0, 30 # timer em milissegundos
	addi $2, $0, 32
	syscall
	j game_manager

# ====================================================================
# LEITOR DE TECLADO (MMIO) - MOVE O JOGADOR
# ====================================================================
# entrada: nenhuma
# alterados: $9, $10, $11
# saída: void
check_keyboard:
	lui $9, 0xffff # endereço base do receiver control (keyboard)
	lw $10, 0($9) # lê o bit de controle
	
	andi $10, $10, 1 # testa se há tecla pressionada (se o bit 0 = 1)
	beq $10, $0, no_key
	
	lw $10, 4($9) # lê a tecla pressionada
	lw $11, pos_player_column # pega a posição X (coluna) atual do jogador
	
	# 'a' = 97, 'A' = 65  |  'd' = 100, 'D' = 68
	beq $10, 97, pressed_a
	beq $10, 65, pressed_a
	beq $10, 100, pressed_d
	beq $10, 68, pressed_d
	
	j no_key                
	
pressed_a:
	#j go_to_hell_from_earth # CASO BRAULIO PEÇA PARA TROCAR DE CENÁRIO APENAS
	subi $11, $11, 4 # move 4 pixels para a esquerda
	sw $11, pos_player_column
	j no_key

pressed_d:
	#j go_to_earth_from_hell # CASO BRAULIO PEÇA PARA TROCAR DE CENÁRIO APENAS
	addi $11, $11, 4 # move 4 pixels para a direita
	sw $11, pos_player_column
	j no_key

no_key:
	jr $31

# ====================================================================
# COLISÃO: LIMITES DA TELA E PROGRESSÃO
# ====================================================================
# entrada: nenhuma
# alterados: $10, $11, $12
# saída: void
check_boundaries:
	lw $10, pos_player_column
	lw $11, current_phase
	
	blez $10, check_out_left # colisão esquerda (eixo X <= 0)
	
	addi $12, $0, 118 # colisão direita (largura da tela é 128. "Quadrado = 10". Limite = 118) ALTERAR QUANDO INSERIR O MÁRIO
	bge $10, $12, check_out_right
	
	jr $31 # apenas volta para o game_manager

# entrada: nenhuma
# alterados: nenhuma
# saída: void
check_out_left: # bloqueio: jogador não pode mais voltar para trás
	sw $0, pos_player_column # fixa na posição 0 (eixo X)        
	jr $31 
	
# entrada: $11 (fase atual)
# alterados: $12
# saída: void
check_out_right:
	beq $11, 0, go_to_earth_from_hell # Se estiver no hell (fase 0), passa para o earth (fase 1)
	addi $12, $0, 118
	sw $12, pos_player_column # mantêm o player no limite direito (vamos trocar isso para a tela de finalização)         
	jr $31
	
# entrada: nenhuma
# alterados: $10, $12
# saída: void
go_to_earth_from_hell:
	addi $12, $0, 1
	sw $12, current_phase # muda fase para 1 (earth)
	addi $10, $0, 5 # o jogador inicia na posição 5 (eixo X)
	sw $10, pos_player_column
	jr $31
	
# entrada: nenhuma
# alterados: $10, $12
# saída: void
go_to_hell_from_earth: # OPCIONAL (PARA PODER ALTERAR ENTRE OS DOIS CENÁRIOS COM A e D NA HORA DA PROVA)
	addi $12, $0, 0
	sw $12, current_phase # muda fase para hell
	addi $10, $0, 5 # o jogador inicia na posição 5 (eixo X)
	sw $10, pos_player_column
	jr $31

# ====================================================================
# MOTOR DE RENDERIZAÇÃO (renderiza os cenários)
# ====================================================================
# entrada: $4 (endereço de memória do cenário base)
# alterados: $4, $5, $6, $7
# saída: void
render:
	lui $5, 0x1001 
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

# IMPORTS
.include "backgrounds\bg_hell.asm"
.include "backgrounds\bg_earth.asm"
.include "sprites\ghost\enemy_ghost.asm"
.include "sprites\braulio\ally_braulio.asm"
.include "sprites\player\player_rosa.asm"