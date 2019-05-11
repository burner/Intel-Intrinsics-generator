module treevisitor;

import std.traits : Unqual;
import ast;
import visitor;
import tokenmodule;

class TreeVisitor : Visitor {
	import std.stdio : write, writeln;

	alias accept = Visitor.accept;

	int depth;

	this(int d) {
		this.depth = d;
	}

	void genIndent() {
		foreach(i; 0 .. this.depth) {
			write("    ");
		}
	}

	override void accept(const(Start) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(If) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(For) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Blocks) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Block) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Switch) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Cases) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Assign) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Expr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(RelExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(CmpExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(MulExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(AddExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(UnaryExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(PostfixExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(PostfixFollow) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Array) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Call) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(ArgList) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(PrimaryExpr) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}

	override void accept(const(Identifier) obj) {
		this.genIndent();
		writeln(Unqual!(typeof(obj)).stringof,":", obj.ruleSelection);
		++this.depth;
		super.accept(obj);
		--this.depth;
	}
}
