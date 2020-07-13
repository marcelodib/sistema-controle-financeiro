.data
array1: .space 3200 #$t2
categorias: .space 1600 #$t5 array para definir as categorias
valor: .space 160
id: .space 4 #$t3
pos: .space 4 #t4
pos2: .space 4#usada pra tanto print quanto excluir
pos3: .space 4
pos4: .space 4
tam: .space 4 #tamanho do array
meses: .space 48

msgMesAno: .asciiz "\n\nAno a ser verificado?\n"
msgMes0: .asciiz "\n\nJaneiro"
msgMes1: .asciiz "\n\nFevereiro"
msgMes2: .asciiz "\n\nMarco"
msgMes3: .asciiz "\n\nAbril"
msgMes4: .asciiz "\n\nMaio"
msgMes5: .asciiz "\n\nJunho"
msgMes6: .asciiz "\n\nJulho"
msgMes7: .asciiz "\n\nAgosto"
msgMes8: .asciiz "\n\nSetembro"
msgMes9: .asciiz "\n\nOutubro"
msgMes10: .asciiz "\n\nNovembro"
msgMes11: .asciiz "\n\nDezembro"
msgMesVal: .asciiz "\nValor: R$ "

msg0: .asciiz "\tControle de Gastos\n"
msg1: .ascii "\t\t1) Registrar Despesas\n\t\t2) Excluir Despesas\n\t\t3) Listar Despesas\n\t\t4) Exibir Gasto Mensal\n\t\t"
msg11:.asciiz"5) Exibir gastos por Categoria\n\t\t6) Exibir Ranking por Despesas\n\t\t7) Sair\n\n"
msg2: .asciiz "\nInsira o dia:"
msg3: .asciiz "\nInsira o mes:"
msg4: .asciiz "\nInsira o ano:"
msg5: .asciiz "\nInsira o valor gasto:"
msg6: .asciiz "\nInsira o tipo de gasto:"
msg7: .asciiz "\nInsira o ID a excluir:"
msg8: .asciiz "\nID nao cadastrado\n"
msg9: .asciiz "/"
msg10: .asciiz "\n"
msg12: .asciiz "\nCategoria:"
msg13: .asciiz "\nGasto: R$"
#id(0-2), dia(2-4), mes(4-6), ano(6-8), soma(8-12) = 12
#salario(12-16)  = 4
#string(16-32) = 16
#total: 32 bytes por despesa ou 8 words

.text
.globl main

	la $t2, array1
	sh $zero, 0($t2)

	la $t3, id #zera o ID no comeco do programa
	sw $zero, 0($t3)

	la $t4, pos #zera a Posicao no comeco do programa
	sw $zero, 0($t4)

	la $t4, pos2 #zera a Posicao2 no comeco do programa
	sw $zero, 0($t4)


main:

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg0  #Passa a msg para o parametro a0
	syscall

	li $v0, 4	 # Codigo SysCall p/ escrever strings
	la $a0, msg1 #Passa a msg para o parametro a0
	syscall

	li $v0, 5	 # Codigo SysCall p/ ler inteiros
	syscall

#---------------Verifica qual a opcao escolhida pelo usuario e desvia o programa para o label certo--
	addi $t0, $zero,1
	beq $t0,$v0,RegistrarDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,2
	beq $t0,$v0,ExcluirDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,3
	beq $t0,$v0,ListarDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,4
	beq $t0,$v0,ExibirGastoMensal #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,5
	beq $t0,$v0,ExibirgastosPorCategoria #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,6
	beq $t0,$v0,ExibirRankingPorDespesas #caso t0 e v0 sejam iguais da um jump

	addi $t0, $zero,7
	beq $t0,$v0,Sair #caso t0 e v0 sejam iguais da um jump

	j main
#------------------------------------------------------------------------------------------------------
# dentro dos labels so tem uma funcao teste para saber se entro no label certo

RegistrarDespesas:
#----------Procura Posição-----------
la $t2, array1

addi $s0, $zero, 0 #pega o primeiro ID
lh $s2, 0($t2)

la $t4, pos #
sw $zero, 0($t4)

ContinuaBuscaRD:
beq $s2, $zero, ContinuaRD #compara se eh zero

la $t4, pos #recupera a posicao atual do array
lw $s0, 0($t4)

la $t2, array1 # se for diferente de zero, anda para a proxima despesa
addi $s0, $s0, 32 #Atualiza a posicao do array em 32(nova conta)
add $t2, $t2, $s0
lh $s2, 0($t2)

la $t4, pos #salva a posicao atual do array
sw $s0, 0($t4)

j ContinuaBuscaRD

ContinuaRD: #acho o id zero

#----------Coloca ID----------------
	 la $t4, tam
	 lw $s0, 0($t4)

	 addi $s0, $s0, 1

	 sw $s0, 0($t4)

	 la $t3, id #pega endereco de ID
	 lw $s3, 0($t3)

	 addi $s3, $s3, 1 #incrementa 1 no ID

	 la $t3, id #salva novo ID
	 sw $s3, 0($t3)

	 la $t4, pos #pega a posicao do array
	 lw $s0, 0($t4)

	 la $t2, array1 # salva o ID na posicao correta do array
	 add $t2, $t2, $s0
	 sh $s3, 0($t2)

#----------Recebe dia---------------

	 li $v0, 4     # Codigo SysCall p/ escrever strings
	 la $a0, msg2  #Passa a msg para o parametro a0
	 syscall

	 li $v0, 5 #pega dia
	 syscall
	 add $s0, $zero, $v0

	 la $t4, pos #pega posicao correta do array
	 lw $s2, 0($t4)

	 la $t2, array1

	 addi $s2, $s2, 2 #ajusta o endereco do array
	 add $t2, $t2, $s2

	 sh $s0, 0($t2)

#-------Recebe mes------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg3  #Passa a msg para o parametro a0
	syscall

	li $v0, 5 #pega mes
	syscall
	add $s2, $zero, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 4 #ajusta posicao atual, salva ela novamente e salva o mes
	add $t2, $t2, $s0
	sh $s2, 0($t2)

#--------Recebe ano---------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg4  #Passa a msg para o parametro a0
	syscall

	li $v0, 5 #pega o ano
	syscall
	add $s2, $zero, $v0

	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1

	addi $s0, $s0, 6 #ajusta posicao atual, salva ela novamente, e salva o ano
	add $t2, $t2, $s0
	sh $s2, 0($t2)


	la $t4, pos #pega posicao atual
	lw $s0, 0($t4)

	la $t2, array1
	add $t2, $t2, $s0

 	lh $s3, 2($t2) #dia
	lh $s4, 4($t2) #mes
	lh $s5, 6($t2) #ano

	addi $t0, $zero, 365
	mul $t0, $t0, $s5 #ano * 365

	addi $t1, $zero, 30
	mul $t1, $t1, $s4 #mes*30

	add $t0, $t0, $t1
	add $t0, $t0, $s3 #t0 contem a data formatada: soma de dia + mes + ano

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1
	addi $s0, $s0, 8
	add $t2, $t2, $s0

	sw $t0, 0($t2) #data formatada salva

#---------------PEGANDO FLOAT--------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg5  #Passa a msg para o parametro a0
	syscall

	li $v0, 6 #pega o salario
	syscall
	mov.s $f4, $f0 #.s eh o comando para mexer com floats

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1
	addi $s0, $s0, 12
	add $t2, $t2, $s0

	s.s $f4, 0($t2)

#--------------PEGANDO STRING------------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg6  #Passa a msg para o parametro a0
	syscall

	la $t4, pos
	lw $s0, 0($t4)

	la $t2, array1

	li $v0, 8
	add $t2,$t2,$s0
	add $a0, $zero, $t2# passa o endereco de array pra a0
	addi $a0, $a0, 16 #salva na posicao de memoria passada para a0 + 16 bytes
	add $a1, $zero, 16#limita pra 16 bytes o tamanho da string
	syscall

	jal listarCategorias

	j main # retorna para a main
#-----------------------------------------------------------------------------Exclui Despesas---------------------------------------------
ExcluirDespesas:

	la $t4, pos2 #zera o ID no comeco do programa
	sw $zero, 0($t4)

	la $t2, array1
	lh $s2, 0($t2)

	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg7  #Passa a msg para o parametro a0
	syscall

	li $v0,5 #pega ID
	syscall

	add $s0,$zero,$v0 #Passa id pra s0
ProcuraID:
	beq $s0,$s2,ExcluidID # compara se o id digitado e o mesmo que o registrado

	la $t4,pos2
	lw $s1,0($t4)

	la $t2, array1
	addi $s1, $s1, 32 #atualiza a pos2
	add $t2,$t2,$s1
	lh $s2, 0($t2) #pega o id da proxima posicao

	la $t4, pos2
	sw $s1,0($t4) #salva a pos2 atualizada

	la $t4, pos
	lw $s5,0($t4) #pega o valor da pos

	addi $s5, $s5, 32

	beq $s5, $s1, SaiMain #compara se a pos2 e a mesma que a pos, logo chego no fim do cadastro e nao achou o id

	j ProcuraID

ExcluidID:

	la $t4,pos2
	lw $s1,0($t4) #pega a posicao salva em pos2

	la $t2, array1
	add $t2, $t2, $s1 # vai pra posicao do array indicada por pos2
	addi $s3, $zero, 0
	sh $s3, 0($t2)# coloca -1 no ID

	addi $t2, $t2, 8
	addi $s3, $zero, 365
	mul $s3, $s3, 3000
	sh $s3, 0($t2)# coloca -1 no ID
	addi $t2, $t2, -8

	jal BubbleSort

	la $t0, tam
	lw $t1, 0($t0)
	addi $t1, $t1, -1
	sw $t1, 0($t0)

	j main # retorna para a main

SaiMain:
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg8  #Passa a msg para o parametro a0
	syscall

	j main
#-----------------------------------------------------------------------------ListaDespesas---------------------------------------------
ListarDespesas:
	jal BubbleSort
	#print para testes
	la $t4, pos2 #zera o ID no comeco do programa
	sw $zero, 0($t4)

	la $t2, array1
	lh $s2, 0($t2)

ContinuaBuscaLD:
#addi $s5, $zero, -1
bne $s2, $zero, ContinuaLD #compara se eh zero

j main

ContinuaLD:

	la $t2, array1 # passa o endereco de array1 para t2

	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s2, 0($t2) # pega o id

	li $v0, 1
	add $a0, $zero, $s2 #Print ID
	syscall
#--------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#-----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 2($t2) # pega o dia

	li $v0, 1
	add $a0, $zero, $s3 # printa dia
	syscall
#-----------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#-----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 4($t2)# pega o mes

	li $v0, 1
  add $a0, $zero, $s3 #Print mes
	syscall
#-----------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg9  #Passa a msg para o parametro a0
	syscall
#---------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	lh $s3, 6($t2)# pega o ano

	li $v0, 1
  add $a0, $zero, $s3 #Printa ano
	syscall
#-----------------------------
li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg9  #Passa a msg para o parametro a0
syscall
#----------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	l.s $f5, 12($t2) #pega o valor gasto

	li $v0, 2
	mov.s $f12, $f5
	syscall
#---------------------------
li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg9  #Passa a msg para o parametro a0
syscall
#---------------------------
	la $t2, array1
	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)
	add $t2, $t2, $s0

	li $v0,4
	la $a0, 16($t2)#passa a string salva no byte 16 pra a0 e printa
	syscall
#---------------------------
	li $v0, 4     # Codigo SysCall p/ escrever strings
	la $a0, msg10  #Passa a msg para o parametro a0
	syscall

	la $t4, pos2 #recupera a posicao atual do array
	lw $s0, 0($t4)

	la $t2, array1 # se for diferente de zero, anda para a proxima despesa
	addi $s0, $s0, 32
	add $t2, $t2, $s0
	lh $s2, 0($t2)

	la $t4, pos2 #salva a posicao atual do array
	sw $s0, 0($t4)

	j ContinuaBuscaLD #

ExibirGastoMensal:
la $s2, array1 #Load addres do vetor
addi $s2, $s2, -32

li $v0, 4
la $a0, msgMesAno
syscall

li $v0, 5	 # Codigo SysCall p/ ler inteiros
syscall
add $a0, $zero, $v0

LoopDespesasMes:
addi $s2, $s2, 32
#condicao de parada
lh $t0, 0($s2)
beq $t0, $zero, EndLoopDespesaMes
#else
addi $s2, $s2, 6 # posicao do ano
lh $t0, 0($s2)
addi $s2, $s2, -6 #pos inicial
bne $t0, $a0, LoopDespesasMes

addi $s2, $s2, 4
lh $t0, 0($s2) #recebe o mes
addi $s2, $s2, -4

addi $t0, $t0, -1
#Loop para encontrar a posicao certa do vetor meses
la $s1, meses
LoopRegistrarDespesaMes:
beq $t0, $zero, FimLoopRegistrarDespesas #condicao de parada
addi $s1, $s1, 4
addi $t0, $t0, -1
j LoopRegistrarDespesaMes
FimLoopRegistrarDespesas:

# mes encontrado
addi $s2, $s2, 12
l.s $f0, 0($s2) #valor da despesa
addi $s2, $s2, -12

l.s $f1, 0($s1) #valor da soma do mes

add.s $f0, $f0, $f1 # f0 = despesa + soma das despesas anteriores

s.s $f0, 0($s1)

j LoopDespesasMes
EndLoopDespesaMes:

#Listagem das Despesas

la $s1, meses

#janeiro
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes0
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#fevereiro
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes1
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#marco
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes2
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#abril
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes3
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#maio
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes4
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#junho
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes5
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#julho
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes6
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#agosto
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes7
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#setembro
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes8
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#outubro
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes9
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#novembro
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes10
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

#dezembro
addi $s1, $s1, 4
l.s $f12, 0($s1)

addi $v0, $zero, 4
la $a0, msgMes11
syscall

addi $v0, $zero, 4
la $a0, msgMesVal
syscall

addi $v0, $zero, 2
syscall

addi $v0, $zero, 4
la $a0, msg10
syscall

#limpar vetor meses
addi $t1, $zero, 12
la $s1, meses
sub.s $f3, $f3, $f3
LoopZerarVetor:
beq $t1, $zero, FimLoopZeraVetor
s.s $f3, 0($s1)
addi $s1, $s1, 4
addi $t1, $t1, -1
j LoopZerarVetor
FimLoopZeraVetor:

	j main # retorna para a main
ExibirgastosPorCategoria:
la $t0,categorias
la $t1,valor

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 0($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 16($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 16($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 32($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 32($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 48($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 48($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 64($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 64($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall


li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 80($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 80($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 96($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 96($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 112($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 112($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 128($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 128($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 144($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 144($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall


li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 160($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, 160($t0)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

li $v0, 2     # Codigo SysCall p/ escrever strings
l.s $f12, 176($t1)  #Passa a msg para o parametro a0
syscall

li $v0, 4     # Codigo SysCall p/ escrever strings
la $a0, msg10 #Passa a msg para o parametro a0
syscall

j main

ExibirRankingPorDespesas:
	add $t0, $zero,$v0
	li $v0, 1
	addi $a0, $zero, 6
	syscall
	j main # retorna para a main
Sair:
	li $v0, 10 # comando de exit, nao sei se vamos usar mais por via das duvidas deixei comentado
	syscall
	#---------------Bubble Sort-------------------------------------------------------------------------
BubbleSort:
	la $a0, array1
	la $s3, tam
	lw $a1, 0($s3)

bubble: move $s0, $zero      # (s0) i = 0
	move $t6, $zero

eloop:
  bge $s0, $a1, endBubble    # break if i >= tam
	move  $s1, $zero

iloop:  bge $s1, $a1 endiloop   # break if j >= tam (tam >= j)

	sll $t1, $s0, 5         # t1 = i * 32 (para indexar o vetor)
	sll $t2, $s1, 5         # t2 = j * 32 (para indexar o vetor)

	add $t1, $a0, $t1       # endereço de vec[i] => t1 = vec + i * 4
	add $t2, $a0, $t2       # endereço de vec[j] => t2 = vec + j * 4

	lw $t3, 0($t1)          # t3 = vec[i] id
	lw $t4, 0($t2)          # t4 = vec[j] id


	addi $t1, $t1, 8
	addi $t2, $t2, 8

	lw $t3, ($t1)
	lw $t4, ($t2)

	addi $t1, $t1, -8
	addi $t2, $t2, -8

	blt $t3, $t4, swap

	addi $s1, $s1, 1 # j++
	j iloop


swap:

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)           #id e dia swap
	sw $t4, ($t1)

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)          #mes e ano swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)           #data formatada swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)           #salario swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	l.s $f3, ($t1)
	l.s $f4, ($t2)

	s.s $f3, ($t2)
	s.s $f4, ($t1)           #part1 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)           #part2 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)           #part3 string swap

	addi $t1,$t1, 4
	addi $t2,$t2, 4

	lw $t3, ($t1)
	lw $t4, ($t2)

	sw $t3, ($t2)
	sw $t4, ($t1)           #part4 string swap

	addi $s1, $s1, 1        # j++
	j iloop

endiloop:
	addi $s0, $s0, 1        # i++
	j eloop

endBubble:
	jr $ra

#--------------------------------------------------------------------------
listarCategorias:
  la $t4,pos
  lw $s5,0($t4)
	addi $s5, $s5, 32

	la $t4, pos
	lw $s7, 0($t4)
	addi $s7, $s7, 16

	la $t5,pos3
	lw $s3,0($t5)

	addi $s3, $s3, 16

	la $t5,pos3
	lw $s6,0($t5)

	la $t0,pos4
	addi $s2, $zero, 0
	sw $s2, 0($t0)

	beq $s6, $zero, insere
	j compara
comparacat:
	beq $s2, $s3,insere

	la $t4, pos
	lw $s7, 0($t4)
	addi $s7, $s7, 16

	addi $s2,$s2,4
compara:
	la $t2, array1
	add $t2, $t2, $s7
	lw $s6, 0($t2)

	beq $s7,$s5,somaValor

	la $t6,categorias
	add $t6,$t6,$s2
	lw $s1,0($t6)

	bne $s1, $s6,comparacat

	addi $s7,$s7,4
	addi $s2,$s2,4

j compara

insere:
	la $t4,pos
	lw $s5,0($t4)
	addi $s5, $s5,32

	la $t4, pos
	lw $s7, 0($t4)
	addi $s7, $s7, 16

	la $t5,pos3
	lw $s0, 0($t5)

loopcat:
	la $t2, array1
	add $t2, $t2, $s7
	lw $s6, 0($t2)

	beq $s7,$s5,somaValorp

	la $t6,categorias
	add $t6,$t6,$s0
	sw $s6,0($t6)

	addi $s7,$s7,4
	addi $s0,$s0,4
	j loopcat
somaValorp:
	la $t5,pos3
	sw $s0, 0($t5)
somaValor:
	la $t4, pos
	lw $s7, 0($t4)
	addi $s7, $s7, 12

	la $t2, array1
	add $t2, $t2, $s7
	l.s $f0, 0($t2)

	la $t4, pos3
	lw $s0,0($t4)

	la $t3, valor
	add $t3,$t3,$s0
	l.s $f1,0($t3)
	add.s $f0,$f0,$f1
	s.s $f0,0($t3)
	j fimcat
fimcatinsere:
 la $t5,pos3
 sw $s0, 0($t5)
fimcat:
 jr $ra

	#---------------STRCMP------------------------------------------------------------------------------
# STRCMP: #$a0 String 1, $a1 String 2, $v0 = 0 se igual, $v0 = 1 se diferente
#     add $t0, $zero, $zero # i = 0
# STRCMPL1:
#     add $t1, $a0, $t0 # $t1 = &str1[i]
#     lbu $t1, 0($t1) # $t
