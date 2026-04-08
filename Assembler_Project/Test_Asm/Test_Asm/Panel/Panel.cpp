#include "Panel.h"

//----------------------------------------------------------------------------------------------------------------------
APanel::APanel(unsigned short x_pos, unsigned short y_pos, unsigned short width, unsigned short height, CHAR_INFO* screen_buffer, unsigned short screen_width)
	: X_Pos(x_pos), Y_Pos(y_pos), Width(width), Height(height), Screen_Buffer(screen_buffer), Screen_Width(screen_width)
{
}
//----------------------------------------------------------------------------------------------------------------------
void APanel::Draw()
{
	CHAR_INFO symbol{};
	symbol.Attributes = 0x1b; // Цвет фона = 1, цвет символа = b. В 16 системе счисления

	SPos pos(0, 0, Screen_Width, 0);

	// 1. Вертикальные линии
	symbol.Char.UnicodeChar = L'║';
	pos.Y_Pos = 1;
	pos.Len = Height - 2;

	// 1.1 Левая линия
	pos.X_Pos = 0;
	Draw_Line_Vertical(Screen_Buffer, pos, symbol);

	// 1.2 Правая линия
	pos.X_Pos = Width - 1;
	Draw_Line_Vertical(Screen_Buffer, pos, symbol);

	// 1.3 Средняя линия
	pos.X_Pos = Width / 2;
	pos.Len -= 2;
	Draw_Line_Vertical(Screen_Buffer, pos, symbol);


	// 2. Горизонтальные линии
	symbol.Char.UnicodeChar = L'═';
	pos.X_Pos = 1;
	pos.Len = Width - 2;
	
	// 2.1 Верхняя линия
	pos.Y_Pos = 0;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	
	// 2.2 Нижняя линия
	pos.Y_Pos = Height - 1;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);

	// 2.3 Средняя линия
	symbol.Char.UnicodeChar = L'─';
	pos.Y_Pos = Height - 3;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);

	// 3. Соединители для строк
	pos.Len = 1;

	// 3.1 Соединитель для средней строки
	symbol.Char.UnicodeChar = L'╟';
	pos.X_Pos = 0;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	pos.X_Pos = Width - 1;
	symbol.Char.UnicodeChar = L'╢';
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);

	// 3.2 Соединитель для верхней строки
	symbol.Char.UnicodeChar = L'╗';
	pos.Y_Pos = 0;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	symbol.Char.UnicodeChar = L'╔';
	pos.X_Pos = 0;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);

	// 3.3 Соединитель для нижней строки
	symbol.Char.UnicodeChar = L'╚';
	pos.Y_Pos = Height - 1;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	symbol.Char.UnicodeChar = L'╝';
	pos.X_Pos = Width - 1;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);

	// 4 Соединитель для средней вертикальной линии
	pos.X_Pos = Width / 2;
	symbol.Char.UnicodeChar = L'╦';
	pos.Y_Pos = 0;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	symbol.Char.UnicodeChar = L'╨';
	pos.Y_Pos = Height - 3;
	Draw_Line_Horizontal(Screen_Buffer, pos, symbol);
	

	//symbol.Char.UnicodeChar = L'X';
	//pos = {50, 8, Screen_Width, 10};
	//Show_Colors(Screen_Buffer, pos, symbol);
}
//----------------------------------------------------------------------------------------------------------------------
