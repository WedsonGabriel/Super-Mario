.data
	# COORDENADAS E PROPRIEDADES DO JOGADOR (vamos alterar para inserir o Mário)
	pos_player_column: .word 2 # posição X (coluna) do jogador
	pos_player_line: .word 41 # posição Y (linha) do jogador
	player_size: .word 10 # quadrado atual de 10x10 pixels
	player_color: .word 0x00FF1493 # cor rosa choque (teste)

.text

# entrada: nenhuma
# alterados: $9, $10, $11, $12, $13, $14
# saída: void
draw_player:
	lw $9, pos_player_line 
	lw $10, pos_player_column 
	lui $11, 0x1001 
	lw $12, player_size 
	lw $14, player_color 

	# CALCULAR POSIÇÃO INICIAL DA TELA
	sll $9, $9, 7          
	add $10, $10, $9       
	sll $10, $10, 2        
	add $10, $10, $11      
	
	line_player:	
		beq $12, $0, end_draw_player
		lw $13, player_size 

	column_player:	
		beq $13, $0, end_column_player
		sw $14, 0($10) # pinta o pixel
		add $10, $10, 4 # avança ponteiro da tela
		sub $13, $13, 1     
		j column_player
			
	end_column_player:
		addi $10, $10, 472  # (512 - 40 bytes)
		sub $12, $12, 1     
		j line_player 

end_draw_player:
	jr $31