import std.array : empty;
import std.stdio;
import std.conv : to;
import std.getopt;
import std.file : readText;
import std.format : format;
import std.experimental.logger;

import html;

import output;
import options;

int main(string[] args) {
	Options options;
	auto ops = getopt(args, 
			"i", "Specify an input intrinsics XML file (default: \"data-3.4.4.xml\")", 
				&options.inputXML,
			"o", "Specify an output D file (default: stdout)",
				&options.outputPath,
			"n|name", "Specify a particular intrinsic name (default: unused)",
				&options.selectedNames,
			"t|tech", "Specify a tech selector (default: none)" ~
				" Available techs: ALL MMX SSE SSE2 SSE3 SSSE3 SSE4.1 SSE4.2...",
				&options.selectedTech,
			"b|body", "generate D bodies converted from Intel pseudo-code " ~
				" (default: no).",
				&options.generateBodies
		);
	if(ops.helpWanted) {
		defaultGetoptPrinter(
				"Usage: intrinsicripper [-i data-X.Y.Z.xml] [-o output.d] " ~ 
				"[-t MMX] [-h] [-b]", ops.options
			);
		return 0;
	}

	try {
		if(options.selectedTech.length == 0 && options.selectedNames.length == 0) {
			writeln("error: use --tech or --name to select intrinsics to generate");
			return 1;
		}

		bool isSelectedIntrinsic(string name, string tech) {
			foreach(n; options.selectedNames) {
				if(n == name) {
					return true;
				}
			}
			foreach(sel; options.selectedTech) {
				if(sel == "ALL" || sel == tech) {
					return true;
				}
			}
			return false;
		}

		Func[] funcs;

		auto output = !options.outputPath.empty 
			? File(options.outputPath, "w") 
			: stdout;
		auto ltw = output.lockingTextWriter();

		auto doc = createDocument(readText(options.inputXML));

		int numIntrinsics = 0;

		foreach(it; doc.querySelectorAll("intrinsic")) {
			Func cur;
			cur.name = to!string(it.attr("name"));
			cur.tech = to!string(it.attr("tech"));

			// parse description
			if(auto descNode = doc.querySelector("description", it))
			{
				cur.desc = to!string(descNode.html());
			}

			// Should this intrinsic be accounted for?
			if(!isSelectedIntrinsic(cur.name, cur.tech))
				continue;

			cur.ret = Param("", to!string(it.attr("rettype")));
			auto t = doc.querySelector("operation", it);
			if(t !is null && options.generateBodies) {
				cur.operation = to!string(t.html());
				foreach(p; doc.querySelectorAll("parameter", it)) {
					cur.params ~= Param(
										to!string(p.attr("varname")),
										to!string(p.attr("type"))
										);
				}
				printIntrinsicAsDBody(ltw, cur);
			}
			else
			{
				printIntrinsicAsDSignature(ltw, cur);
			}
			funcs ~= cur;
			numIntrinsics++;
		}
		writefln("\n*** Seen %s intrinsics.\n\n", numIntrinsics);
		return 0;
	}
	catch(Exception e)
	{
		import std.stdio;
		writefln("error: %s", e.msg);
		return 1;
	}
}
