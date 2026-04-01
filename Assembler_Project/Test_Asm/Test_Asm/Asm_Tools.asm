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
Draw_Line_Vertical proc
; extern "C" void Draw_Line_Vertical(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; Параметры
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; Возврат: нет
	
	push rax
	push rcx
	push rdi
	push r11

	; 1. Вычисляем адрес вывода
	call Get_Pos_Address ; RDI = позиция символа в буфере screen_buffer в позиции pos

	; 2. Вычисление коррекции позиции вывода
	mov r11, rdx     ; R11 = pos
	shr r11, 32
	movzx r11, r11w  ; R11 = R11W = pos.Screen_Width
	dec r11
	shl r11, 2       ; R11 = R11 * 4 = ширина экрана в байтах

	; 3. Готовим счётчик цикла
	mov rcx, rdx
	shr rcx, 48      ; RCX = CX = pos.Len

	mov eax, r8d     ; EAX = symbol

_1:
	stosd            ; Выводим символ
	add rdi, r11

	loop _1

	
	pop r11
	pop rdi
	pop rcx
	pop rax

	ret

Draw_Line_Vertical endp

;-----------------------------------------------------------------------------------------------------------------------

Show_Colors proc
; extern "C" void Show_Colors(CHAR_INFO *screen_buffer, SPos pos, CHAR_INFO symbol);
; Параметры
; RCX - screen_buffer
; RDX - pos
; R8 - symbol
; Возврат: нет

	push rax
	push rbx
	push rcx
	push rdi
	push r10
	push r11

	; 1. Вычисляем адрес вывода
	call Get_Pos_Address ; RDI = позиция символа в буфере screen_buffer в позиции pos

	mov r10, rdi

	; 2. Вычисление коррекции позиции вывода
	mov r11, rdx     ; R11 = pos
	shr r11, 32
	movzx r11, r11w  ; R11 = R11W = pos.Screen_Width
	shl r11, 2       ; R11 = R11 * 4 = ширина экрана в байтах

	; 3. Готовим циклы
	mov rax, r8

	and rax, 0ffffh
	mov rbx, 16

	xor rcx, rcx

_0:
	mov cl, 16

_1:
	stosd
	add rax, 010000h ; Инкрементируем часть регистра, в котором хранится цвет(атрибут) символа

	loop _1

	add r10, r11
	mov rdi, r10

	dec rbx
	jnz _0

	pop r11
	pop r10
	pop rdi
	pop rcx
	pop rbx
	pop rax

	ret

Show_Colors endp
;-----------------------------------------------------------------------------------------------------------------------


end