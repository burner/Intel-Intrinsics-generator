import std.algorithm : map;
import std.format : format, formattedWrite;
import std.string;
import std.stdio;
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

struct Func 
{
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

string printIntrinsicAsDBody(Func f) {
	import std.array : appender;
	auto app = appender!string();
	printIntrinsicAsDBody(app, f);
	return app.data;
}

string indent(string s)
{
    return s.replace("\n", "\n    ");
}

void printIntrinsicAsDSignature(Out)(ref Out o, Func f) 
{ 
    formattedWrite!"%s %s(%-(%s, %)) pure nothrow @nogc @safe;\n"(o, f.ret.type, f.name,
                                                                f.params.map!(a => format("%s %s", a.type, a.name)));
}

void printIntrinsicAsDBody(Out)(ref Out o, Func f) 
{
    if (f.desc)
        formattedWrite!"/// %s\n"(o, f.desc);
	formattedWrite!"%s %s(%-(%s, %)) pure nothrow @nogc @safe\n{\n"(o, f.ret.type, f.name,
			f.params.map!(a => format("%s %s", a.type, a.name)));
    if (f.operation)
    {
	    auto l = Lexer(f.operation);
	    auto parser = Parser(l);
	    try {
		    auto d = parser.parseStart();
		    DWriter!Out vis = new DWriter!Out(o);
		    vis.accept(cast(const(Start))d);
	    } 
        catch(Throwable e) 
        {
            // didn't parse, put the operation body
            string operationContent = format("    /*%s*/\n", f.operation);
            formattedWrite!"%s"(o, operationContent.indent);

            string parseErrorMessage = format("//%s\n", e.msg);
            formattedWrite!"%s"(o, parseErrorMessage.indent);

            formattedWrite!"assert(false, \"Failed to parse\");\n"(o);
	    } 
        formattedWrite!"}\n\n"(o);
    }
    else
        throw new Exception("Intrinsic has no pseudo-code");
}
