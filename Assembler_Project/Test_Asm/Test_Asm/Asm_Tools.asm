.code

Make_Sum proc
; int Make_Sum(int one_value, int another_value)
; Параметры
; RCX - one_value
; RDX - another_value
; Возврат: RAX

	mov eax, ecx
	add eax, edx
	ret

Make_Sum endp

;-----------------------------------------------------------------------------------------------------------------------
Get_Pos_Address proc
; Параметры
; RCX - screen_buffer
; RDX - pos
; Возврат: RDI

	; 1. Вычисляем адрес вывода: addres_offset = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4
	; 1.1 Вычисляем pos.Y_Pos * pos.Screen_Width
	mov rax, rdx
	shr rax, 16   ; AX = pos.Y_Pos
	movzx rax, ax ; RAX = AX = pos.Y_Pos
	
	mov rbx, rdx
	shr rbx, 32   ; BX = pos.Screen_Width
	movzx rbx, bx ; RBX = BX = pos.Screen_Width

	imul rax, rbx ; RAX = RAX * RBX = pos.Y_Pos * pos.Screen_Width

	; 1.2 Добавим pos.X_Pos к RAX
	movzx rbx, dx ; RBX = DX = pos.X_Pos
	add rax, rbx  ; RAX = pos.Y_Pos * pos.Screen_Width + pos.X_Pos = смещение в символах

	; 1.3 
	shl rax, 2    ; RAX = RAX * 4 = RAX << 2 = RAX * 2 ** 2 = (pos.Y_Pos * pos.Screen_Width + pos.X_Pos) * 4

	mov rdi, rcx  ; RDI = screen_buffer
	add rdi, rax  ; RDI = screen_buffer + addres_offset

	ret

Get_Pos_Address endp
;-----------------------------------------------------------------------------------------------------------------------
Draw_Line_Horizontal proc
; extern "C" void Draw_Line_Horizontal(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; Параметры
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; Возврат: нет

	push rax
	push rbx
	push rcx
	push rdi
	
	; 1. Вычисляем адрес вывода
	call Get_Pos_Address ; RDI = позиция символа в буфере screen_buffer в позиции pos

	; 2. Выводим символы
	mov eax, r8d
	mov rcx, rdx
	shr rcx, 48   ; RCX = CX = pos.Len

	rep stosd

	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Draw_Line_Horizontal endp
;-----------------------------------------------------------------------------------------------------------------------

Show_Colors proc
; extern "C" void Show_Colors(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; Параметры
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; Возврат: нет

	; 1. Вычисляем адрес вывода
	call Get_Pos_Address ; RDI = позиция символа в буфере screen_buffer в позиции pos
	mov rax, r8

	and rax, 0ffffh

	stosd

	ret

Show_Colors endp
;-----------------------------------------------------------------------------------------------------------------------


end