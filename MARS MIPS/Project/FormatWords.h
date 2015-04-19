
#ifndef FORMATWORDS_H
#define FORMATWORDS_H

#include <iostream>
#include <fstream>
#include <string>

using namespace std;

class WordFormatter {
	public:
		WordFormatter();
		WordFormatter(string);
		~WordFormatter();
		void format();
	private:
		string filename, line;
		void readFile();
		void writeFile();
};

inline WordFormatter::WordFormatter() {
	filename = "";
}

inline WordFormatter::WordFormatter(string file) {
	filename = file;
}

inline WordFormatter::~WordFormatter() {}

#endif

