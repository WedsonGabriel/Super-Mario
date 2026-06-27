.data
    .space 32768 # reserva a área de memória da tela (8192 pixels * 4 bytes)
    
    # Variáveis de Estado Global: 0 = bg_hell, 1 = bg_earth, 2 = Vitória
    current_phase: .word 0 
    
    # Estado do Jogo: 0 = Jogando, 1 = Game Over, 2 = Home, 3 = Créditos, 4 = You Win
    game_state: .word 2 # Começa valendo 2 para iniciar direto na Home Screen
    
    # Controle de Tempo do Passo do Mario
    step_timer: .word 0
    
.text
main:

# ====================================================================
# GERENCIADOR CENTRAL DO JOGO (MÁQUINA DE ESTADOS)
# ====================================================================
game_manager:
    lw $8, game_state
    
    # telas (menús, vitórias e game Over)
    beq $8, 1, state_game_over   
    beq $8, 2, state_home_screen 
    beq $8, 3, state_credits     
    beq $8, 4, state_you_win

    # se game_state for 0, o jogo roda normalmente:
    jal check_keyboard   
    jal check_boundaries 
    
    lw $8, current_phase 
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
    addi $4, $0, 60 # velocidade do jogo (em milissegundos)
    addi $2, $0, 32
    syscall
    j game_manager

# ====================================================================
# ESTADO: HOME SCREEN (J = JOGAR, C = CRÉDITOS, L = SAIR)
# ====================================================================
state_home_screen:
    la $4, home_screen
    jal render
    jal check_home_keyboard
    
    addi $4, $0, 60 
    addi $2, $0, 32
    syscall
    j game_manager

check_home_keyboard:
    lui $9, 0xffff
    lw $10, 0($9)
    andi $10, $10, 1
    beq $10, $0, end_check_menu
    
    lw $10, 4($9)
    
    # 'j' = 106, 'J' = 74 (JOGAR)
    beq $10, 106, restart_game 
    beq $10, 74, restart_game
    # 'c' = 99, 'C' = 67 (CRÉDITOS)
    beq $10, 99, go_to_credits
    beq $10, 67, go_to_credits
    # 'l' = 108, 'L' = 76 (SAIR DA HOME = ENCERRA O JOGO)
    beq $10, 108, quit_game
    beq $10, 76, quit_game

end_check_menu:
    jr $31

# ====================================================================
# ESTADO: CRÉDITOS (L = VOLTAR PARA A HOME)
# ====================================================================
state_credits:
    la $4, credits
    jal render
    jal check_credits_keyboard
    
    addi $4, $0, 60 
    addi $2, $0, 32
    syscall
    j game_manager

check_credits_keyboard:
    lui $9, 0xffff
    lw $10, 0($9)
    andi $10, $10, 1
    beq $10, $0, end_check_menu
    
    lw $10, 4($9)
    
    # 'l' = 108, 'L' = 76
    beq $10, 108, go_to_home
    beq $10, 76, go_to_home
    jr $31

go_to_credits:
    addi $10, $0, 3
    sw $10, game_state
    jr $31

go_to_home:
    addi $10, $0, 2
    sw $10, game_state
    jr $31

# ====================================================================
# ESTADO: YOU WIN
# ====================================================================
state_you_win:
    # desenha a tela de vitória
    la $4, sc_you_win
    jal render
    
    # pausa para a tela de vitória ficar um pouco na tela antes de ir para os créditos
    addi $4, $0, 3000 
    addi $2, $0, 32
    syscall
    
    # créditos
    jal go_to_credits
    j game_manager

# ====================================================================
# TELA DE PAUSA / GAME OVER (L = MENU OU R = RETRY)
# ====================================================================
state_game_over:
    la $4, sc_game_over
    jal render
    jal check_game_over_keyboard
    
    addi $4, $0, 60 
    addi $2, $0, 32
    syscall
    j game_manager

check_game_over_keyboard:
    lui $9, 0xffff
    lw $10, 0($9)
    andi $10, $10, 1
    beq $10, $0, end_check_menu
    
    lw $10, 4($9)
    
    # 'r' = 114, 'R' = 82 | 'l' = 108, 'L' = 76
    beq $10, 114, restart_game
    beq $10, 82, restart_game
    
    # 'l' ou 'L'
    beq $10, 108, go_to_home
    beq $10, 76, go_to_home
    jr $31

# ====================================================================
# FUNÇÕES GLOBAIS DE FLUXO E REINÍCIO
# ====================================================================
restart_game:
    sw $0, game_state # volta o estado para "jogando" (0)
    sw $0, current_phase # volta para a fase 0 (inferno)
    
    # --- RESET DO PLAYER ---
    addi $10, $0, 2
    sw $10, pos_player_column # coluna inicial
    addi $10, $0, 1
    sw $10, mario_direction # volta o Mario a olhar para a direita
    sw $0, mario_is_moving # remove a animação de andar
    sw $0, step_timer # zera o timer da perna
    
    # --- RESET DOS FANTASMAS ---
    addi $10, $0, 4
    sw $10, ptr_ghost_mid # reseta a posição do fantasma do meio
    addi $10, $0, 108
    sw $10, ptr_ghost_side # reseta a posição dos fantasmas da ponta
    addi $10, $0, 4
    sw $10, step_forward # reseta a direção do movimento (direita)
    addi $10, $0, -4
    sw $10, step_backward # reseta a direção do movimento (esquerda)

    jr $31
    
quit_game:
    lui $5, 0x1001
    li $25, 0x00000000
    addi $6, $0, 8192
    
for_quit:
    beq $6, $0, end
    sw $25, 0($5)
    addi $5, $5, 4
    sub $6, $6, 1
    j for_quit
        
end:
    addi $2, $0, 10 # encerra o programa 
    syscall

# ====================================================================
# LEITOR DE TECLADO DO JOGO VIVO (MMIO)
# ====================================================================
check_keyboard:
    lui $9, 0xffff 
    lw $10, 0($9) 
    
    andi $10, $10, 1 
    beq $10, $0, no_key
    
    lw $10, 4($9)             
    lw $11, pos_player_column 
    
    # 'a' = 97, 'A' = 65  |  'd' = 100, 'D' = 68
    beq $10, 97, pressed_a
    beq $10, 65, pressed_a
    beq $10, 100, pressed_d
    beq $10, 68, pressed_d
    
    j no_key                
    
pressed_a:
    addi $12, $0, 0
    sw $12, mario_direction   
    addi $12, $0, 1
    sw $12, mario_is_moving   
    
    addi $12, $0, 4          
    sw $12, step_timer
    
    subi $11, $11, 4          
    sw $11, pos_player_column
    jr $31                    

pressed_d:
    addi $12, $0, 1
    sw $12, mario_direction   
    addi $12, $0, 1
    sw $12, mario_is_moving   
    
    addi $12, $0, 4          
    sw $12, step_timer
    
    addi $11, $11, 4         
    sw $11, pos_player_column
    jr $31                    

no_key:
    lw $12, step_timer
    
    slti $13, $12, 1          
    beq $13, 1, set_idle      
    
    subi $12, $12, 1          
    sw $12, step_timer
    jr $31
    
set_idle:
    sw $0, mario_is_moving    
    jr $31


# ====================================================================
# COLISÃO NATIVAS: LIMITES DA TELA E TRANSIÇÃO DE CENÁRIOS
# ====================================================================
check_boundaries:
    lw $10, pos_player_column
    lw $11, current_phase
    
    slti $13, $10, 1
    beq $13, 1, check_out_left 
    
    addi $12, $0, 113 
    slt $13, $10, $12         
    beq $13, 0, check_out_right 
    
    jr $31 

check_out_left: 
    sw $0, pos_player_column  
    jr $31 
    
check_out_right:
    beq $11, 0, go_to_earth_from_hell 
    addi $12, $0, 113
    sw $12, pos_player_column         
    jr $31
    
go_to_earth_from_hell:
    addi $12, $0, 1
    sw $12, current_phase     
    addi $10, $0, 5           
    sw $10, pos_player_column
    jr $31

# ====================================================================
# MOTOR DE RENDERIZAÇÃO (renderiza os cenários)
# ====================================================================
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

# ====================================================================
# INCLUSÕES DOS COMPONENTES (.ASM EXTERNOS)
# ====================================================================
.include "backgrounds/bg_hell.asm"
.include "backgrounds/bg_earth.asm"
.include "screens/you_win.asm"
.include "screens/game_over.asm"
.include "screens/credits.asm"
.include "screens/home_screen.asm"
.include "sprites/ghost/enemy_ghost.asm"
.include "sprites/braulio/ally_braulio.asm"
.include "sprites/player/player_mario.asm"
