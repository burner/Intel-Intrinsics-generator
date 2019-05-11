import std.format;
import std.file;

import visitor;
import ast;

void iformat(Out,Args...)(ref Out o, size_t ident, string f, Args args) {
	foreach(it; 0 .. ident) {
		formattedWrite!"\t"(o);
	}
	formattedWrite(o, f, args);
}

class DWriter(Out) : Visitor {
	alias accept = Visitor.accept;

	private Out* o;
	size_t indent = 1;

	this(ref Out o) {
		this.o = &o;
	}

	override void accept(const(Block) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case BlockEnum.I:
				obj.i.visit(this);
				break;
			case BlockEnum.F:
				obj.f.visit(this);
				break;
			case BlockEnum.A:
				obj.a.visit(this);
				break;
			case BlockEnum.FUN:
				iformat(*this.o, this.indent, "auto ");
				obj.name.visit(this);
				formattedWrite!"("(*this.o);
				obj.para.visit(this);
				formattedWrite!") {\n"(*this.o);
				this.indent++;
				obj.block.visit(this);
				this.indent--;
				iformat(*this.o, this.indent, "}\n\n");
				break;
			case BlockEnum.RET:
				iformat(*this.o, this.indent, "return ");
				obj.expr.visit(this);
				formattedWrite!";\n"(*this.o);
				break;
			case BlockEnum.S:
				obj.sw.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(For) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ForEnum.To:
				iformat(*this.o, this.indent, "foreach(");
				obj.tok.visit(this);
				formattedWrite(*this.o, "; ");
				formattedWrite!"%s"(*this.o, obj.start.value);
				formattedWrite(*this.o, " .. ");
				formattedWrite!"%s"(*this.o, obj.end.value);
				formattedWrite(*this.o, ") {\n");
				this.indent++;
				obj.block.visit(this);
				this.indent--;
				iformat(*this.o, this.indent, "}\n");
				break;
		}
		exit(obj);
	}

	override void accept(const(Assign) obj) {
		enter(obj);
		iformat(*this.o, this.indent, "");
		final switch(obj.ruleSelection) {
			case AssignEnum.As:
				obj.left.visit(this);
				formattedWrite(*this.o, " = ");
				obj.right.visit(this);
				break;
			case AssignEnum.Ter:
				obj.left.visit(this);
				formattedWrite(*this.o, " = ");
				obj.right.visit(this);
				formattedWrite(*this.o, " ? ");
				obj.t.visit(this);
				formattedWrite(*this.o, " : ");
				obj.f.visit(this);
				break;
		}
		formattedWrite(*this.o, ";\n");
		exit(obj);
	}

	override void accept(const(UnaryExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case UnaryExprEnum.M:
				formattedWrite(*this.o, " -");
				obj.post.visit(this);
				break;
			case UnaryExprEnum.P:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(Identifier) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case IdentifierEnum.Ident:
				formattedWrite!"%s"(*this.o, obj.value.value);
		}
		exit(obj);
	}

	override void accept(const(PrimaryExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Integer:
				formattedWrite!"%s"(*this.o, obj.value.value);
				break;
			case PrimaryExprEnum.Parenthesis:
				formattedWrite!"("(*this.o);
				obj.expr.visit(this);
				formattedWrite!")"(*this.o);
				break;
		}
		exit(obj);
	}

	override void accept(const(PostfixFollow) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PostfixFollowEnum.Dot:
				formattedWrite!"."(*this.o);
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.Array:
				formattedWrite!"["(*this.o);
				obj.array.visit(this);
				formattedWrite!"]"(*this.o);
				break;
			case PostfixFollowEnum.ArrayDot:
				formattedWrite!"["(*this.o);
				obj.array.visit(this);
				formattedWrite!"]."(*this.o);
				obj.postfix.visit(this);
				break;
			case PostfixFollowEnum.Call:
				formattedWrite!"("(*this.o);
				obj.call.visit(this);
				formattedWrite!")"(*this.o);
				break;
			case PostfixFollowEnum.CallFollow:
				formattedWrite!"("(*this.o);
				obj.call.visit(this);
				formattedWrite!")"(*this.o);
				obj.pffollow.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(Array) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArrayEnum.Empty:
				break;
			case ArrayEnum.Index:
				obj.expr.visit(this);
				break;
			case ArrayEnum.Slice:
				obj.expr.visit(this);
				formattedWrite!" .. "(this.o);
				obj.expr2.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(ArgList obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArgListEnum.Arg:
				obj.arg.visit(this);
				break;
			case ArgListEnum.Args:
				obj.arg.visit(this);
				formattedWrite!", "(this.o);
				obj.next.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(AddExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case AddExprEnum.Plus:
				obj.post.visit(this);
				formattedWrite!" + "(this.o);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Minus:
				obj.post.visit(this);
				formattedWrite!" - "(this.o);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Post:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(MulExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case MulExprEnum.Star:
				obj.add.visit(this);
				formattedWrite!" * "(this.o);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Div:
				obj.add.visit(this);
				formattedWrite!" / "(this.o);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Mod:
				obj.add.visit(this);
				formattedWrite!" %% "(this.o);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Add:
				obj.add.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(CmpExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CmpExprEnum.EQ:
				obj.me.visit(this);
				formattedWrite!" == "(this.o);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.NEQ:
				obj.me.visit(this);
				formattedWrite!" != "(this.o);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.Mul:
				obj.me.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(RelExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case RelExprEnum.EE:
				obj.ce.visit(this);
				break;
			case RelExprEnum.L:
				obj.ce.visit(this);
				formattedWrite!" < "(this.o);
				obj.follow.visit(this);
				break;
			case RelExprEnum.G:
				obj.ce.visit(this);
				formattedWrite!" > "(this.o);
				obj.follow.visit(this);
				break;
			case RelExprEnum.LE:
				obj.ce.visit(this);
				formattedWrite!" <= "(this.o);
				obj.follow.visit(this);
				break;
			case RelExprEnum.GE:
				obj.ce.visit(this);
				formattedWrite!" >= "(this.o);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(Switch) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case SwitchEnum.S:
				iformat(this.o, this.indent, "switch(");
				obj.sel.visit(this);
				formattedWrite!") {\n"(this.o);
				this.indent++;
				obj.cases.visit(this);
				this.indent--;
				iformat(this.o, this.indent, "}\n");
				break;
		}
		exit(obj);
	}

	override void accept(const(Cases) obj) {
		enter(obj);
		iformat(this.o, this.indent, "case ");
		final switch(obj.ruleSelection) {
			case CasesEnum.One:
				obj.val.visit(this);
				formattedWrite!":\n"(this.o);
				this.indent++;
				obj.b.visit(this);
				iformat(this.o, this.indent, "break;\n");
				this.indent--;
				break;
			case CasesEnum.Many:
				obj.val.visit(this);
				formattedWrite!":\n"(this.o);
				this.indent++;
				obj.b.visit(this);
				iformat(this.o, this.indent, "break;\n");
				this.indent--;
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	override void accept(const(ArgList) obj) {
		enter(obj);
		formattedWrite!"auto "(this.o);
		final switch(obj.ruleSelection) {
			case ArgListEnum.Arg:
				obj.arg.visit(this);
				break;
			case ArgListEnum.Args:
				obj.arg.visit(this);
				formattedWrite!", "(this.o);
				obj.next.visit(this);
				break;
		}
		exit(obj);
	}

}
