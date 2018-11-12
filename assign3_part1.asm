;Code modified/updated by Ryan Sowers
;Submitted: 03/01/2018
;CS3140 Assignment 3 - Part 1
;Assemble: 	nasm -f elf64 -g assign3_part1.asm
;Link:		ld -o assign3_part1 -m elf_x86_64 assign3_part1.o
;Run:		./assign3_part1

bits 64

section .text				;section declaration 

global _start

_start:

loop_top:
	mov rdx, 1				;read size 1 byte
	mov rsi, input_buf		;move into buffer
	mov edi, 0				;input from stdin
	mov eax, 0				;read system call number
	syscall					;do system call

	cmp rax, 1				;compare return value to 1
	jne all_done			;if not 1, reading is complete

	xor rax, rax
	mov al, [input_buf]		;move value into rax
	
	xor rcx, rcx
	mov rcx, 16				;load base into rcx

	xor rbx, rbx
	mov rbx, 1				;index counter
div_loop:
	xor rdx, rdx			;clear rdx
	idiv rcx				;divide by base
	cmp dl, 9				;compare remainder to value greater than 9
	jbe char_adjust	
	add dl, 7				;if >9, must adjust to letter

char_adjust:
	add dl, byte 48
	mov [output + rbx], dl	;store it
	dec rbx					;decrement counter
	cmp rbx, 0				;check if quotient is zero
	jge div_loop			;if not, must divide again
	
	xor edi, edi
	xor eax, eax
out_loop:
	mov [output + 2], byte 0x20	;place 'space' in third byte
	mov rsi, output				;buf address
	mov rdx, 3					;length of buffer used
	mov edi, 1					;output to stdout
	mov eax, 1					;write system call number
	syscall						;do system call
	
	mov al, [output]	
	mov ah, [output+1]
	cmp ax, '0A'				;check for newline
	jne loop_top				;keep reading until no more bytes left 
								;(return value 0)
all_done:
	mov eax, 60					;exit system call number
	syscall						;do system call


section .bss

input_buf: resb 1
output: resb 3


