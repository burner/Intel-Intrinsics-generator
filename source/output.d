import std.algorithm : map;
import std.format : format, formattedWrite;

import lexer;
import parser;
import dwriter;
import ast;

struct Param {
	string name;
	string type;

	string toString() const {
		return format!"Param(%s, %s)"(name, type);
	}
}

struct Func {
	string name;
	string tech;
	Param ret;
	Param[] params;
	string desc;
	string operation;

	string toString() const {
		return format!"Func(%s, %s, %s, [%(%s, %)])"(tech, name, ret, params);
	}
}

string toD(Func f) {
	import std.array : appender;
	auto app = appender!string();
	toD(app, f);
	return app.data;
}

void toD(Out)(ref Out o, Func f) {
	formattedWrite!"/*%s*/\n"(o, f.operation);
	formattedWrite!"%s %s(%-(%s, %)) {\n"(o, f.ret.type, f.name,
			f.params.map!(a => format("%s %s", a.type, a.name)));
	auto l = Lexer(f.operation);
	auto parser = Parser(l);
	try {
		auto d = parser.parseStart();
		DWriter!Out vis = new DWriter!Out(o);
		vis.accept(cast(const(Start))d);
	} catch(Throwable e) {
		formattedWrite!"/+\n%s+/\n"(o, e.msg);
		formattedWrite!"\tassert(false, \"Failed to parse\");\n"(o);
	} finally {
		formattedWrite!"}\n\n"(o);
	}
}
