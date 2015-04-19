
#include <iostream>
#include <fstream>
#include <string>

#include "FormatWords.h"

using namespace std;

void WordFormatter::format() {
	// readFile();
	
	ifstream fileIn;
	fileIn.open(filename.c_str(), ios_base::in);

	// string outfilename = filename[0] + "_MOD" + filename.substr(1);
	string outfilename = filename.insert(1,"_MOD");

	ofstream fileOut;
	fileOut.open(outfilename.c_str(), ios_base::out);

	if(fileIn.is_open()) {
		if(fileIn.eof()) {
			cout << "End of file." << endl;
		}
		while(!fileIn.eof()) {
			while(getline(fileIn, line, " ")) {
				cout << "Line : " << line << endl;
				// cout << "Word : " << word << endl;
			}
		}
	}

	fileIn.close();


	// writeFile();
	
	cout << "\n\n\nInput Line : \n\n\n" << line << endl;

	fileOut << line << endl;

	if(fileOut.is_open()) {
		fileOut << line << endl;
	}

	fileOut.close();


}

void WordFormatter::readFile() {	
	ifstream fileIn;
	fileIn.open(filename.c_str(), ios_base::in);

	if(fileIn.is_open()) {
		if(fileIn.eof()) {
			cout << "End of file." << endl;
		}
		while(!fileIn.eof()) {
			while(getline(fileIn, line)) {
				cout << "Line : " << line << endl;
			}
		}
	}

	fileIn.close();
};

void WordFormatter::writeFile() {
	string outfilename = filename.substr(0,1) + "_MOD" + filename.substr(1);

	ofstream fileOut;
	fileOut.open(outfilename.c_str(), ios_base::out);

	cout << "\n\n\nInput Line : \n\n\n" << line << endl;

	fileOut << line << endl;

	if(fileOut.is_open()) {
		fileOut << line << endl;
	}

	fileOut.close();
}

