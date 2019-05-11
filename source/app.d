import std.stdio;
import std.conv : to;
import std.file : readText;
import std.format : format;
import std.experimental.logger;

import html;

import output;

void main() {
	Func[] funcs;

	auto output = File("testoutput.d", "w");
	auto ltw = output.lockingTextWriter();

	auto doc = createDocument(readText("data-3.4.4.xml"));
	//writeln(doc);
	foreach(it; doc.querySelectorAll("intrinsic")) {
		Func cur;
		cur.name = to!string(it.attr("name"));
		cur.ret = Param("", to!string(it.attr("rettype")));
		cur.tech = to!string(it.attr("tech"));
		auto t = doc.querySelector("operation", it);
		if(t is null) {
			continue;
		}
		cur.operation = to!string(t.html());
		foreach(p; doc.querySelectorAll("parameter", it)) {
			cur.params ~= Param(
					to!string(p.attr("varname")),
					to!string(p.attr("type"))
				);
		}
		toD(ltw, cur);
		//writeln("\n", toD(cur));
		funcs ~= cur;
	}
	//writefln("%(%s\n%)", funcs);
}
