import std.stdio;

import argparse;

void main(string[] args)
{
	auto argparse = new ArgParse();
	argparse.setDesc("This is a example function for argparse in d.");
	argparse.add_argument("-v", "--verbose","more output");
	argparse.add_argument("-q", "", "quite");
	argparse.parse_args(["-h"]);
	argparse.usage();
	// writeln("Edit source/app.d to start your project.");
}
