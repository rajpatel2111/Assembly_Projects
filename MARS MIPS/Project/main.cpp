
#include "FormatWords.h"

int main() {
	WordFormatter *formatter;
	formatter = new WordFormatter("4.txt");
	
	formatter->format();

	return 0;
}

