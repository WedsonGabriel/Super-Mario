.data
  spr_ghost:
  #     C01         C02         C03         C04         C05         C06         C07         C08         C09         C10         C11         C12         C13         C14         C15
  .word 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L01
  .word 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L02
  .word 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L03
  .word 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L04
  .word 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L05
  .word 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00 # L06
  .word 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x0000FF00, 0x0000FF00 # L07
  .word 0x0000FF00, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x0000FF00, 0x0000FF00 # L08
  .word 0x0000FF00, 0x00ffffff, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00 # L09
  .word 0x0000FF00, 0x00ffffff, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00 # L10
  .word 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ff1206, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00 # L11
  .word 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ff1206, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00 # L12
  .word 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L13
  .word 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x00ffffff, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L14
  .word 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00, 0x0000FF00 # L15

  width: .word 15
  height: .word 15
  
  column_ghost_left: .word 15
  column_ghost_mid: .word 55
  column_ghost_right: .word 95
  
  line_ghost_values: .word -1, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35 -1
  
.text

# entrada: $4, $7 (posição do fantasma [LINHA][COLUNA], respectivamente)
# alterados: $8 a $14
# saída:
draw_ghost:
	la $24, spr_ghost # endereço de memória do array do fantasma
	add $9, $0, $4 # carrega LINHA (Y) em $9
	add $10, $0, $7 # carrega COLUNA (X) em $10
	lui $11, 0x1001 # Base da Tela em $11
	lw $12, height # carrega a altura em $12 (Contador de Linhas)

	# CALCULAR POSIÇÃO INICIAL DA TELA (armazenada em $10)
	sll $9, $9, 7 # $9 = Y * 128
	add $10, $10, $9 # $10 = X + (Y * 128)
	sll $10, $10, 2 # $10 = normaliza o endereço de memória (multiplica por 4)
	add $10, $10, $11 # $10 = Base da Tela + Offset
	
	# LOOP EXTERNO (Linhas)
	line_ghost:	
		beq $12, $0, end_draw_ghost
		
		# Recarrega a largura (15) para o contador de colunas ($13)
		lw $13, width # carrega a largura em $13 (contador de colunas)

	# LOOP INTERNO (Colunas)
	column_ghost:	
		beq $13, $0, end_column_ghost
		
		lw $14, 0($24) # $14 pega a cor do pixel do fantasma
		beq $14, 0x0000FF00, drop_column # se for fundo VERDE, ignora
		
		sw $14, 0($10) # pinta o pixel na tela

		drop_column:
			add $24, $24, 4 # avança ponteiro de leitura (fantasma)
			add $10, $10, 4 # avança ponteiro de escrita (tela)
			sub $13, $13, 1 # diminui pixels restantes na coluna ($13)
			j column_ghost
			
	end_column_ghost:
		addi $10, $10, 452 # ajusta o ponteiro da tela para a próxima linha (512 - o que ja andou (largura do fantasma 15 * 4 = 60 bytes) = 452)
		sub $12, $12, 1 # diminui linhas restantes ($12)
		j line_ghost # volta para a próxima linha

end_draw_ghost:
	jr $31
