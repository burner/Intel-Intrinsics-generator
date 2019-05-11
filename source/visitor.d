module visitor;

import ast;
import tokenmodule;

class Visitor {

	void enter(Start obj) {}
	void exit(Start obj) {}

	void accept(Start obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case StartEnum.B:
				obj.block.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Start) obj) {}
	void exit(const(Start) obj) {}

	void accept(const(Start) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case StartEnum.B:
				obj.block.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(If obj) {}
	void exit(If obj) {}

	void accept(If obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case IfEnum.If:
				obj.expr.visit(this);
				obj.block.visit(this);
				break;
			case IfEnum.IfElse:
				obj.expr.visit(this);
				obj.block.visit(this);
				obj.block2.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(If) obj) {}
	void exit(const(If) obj) {}

	void accept(const(If) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case IfEnum.If:
				obj.expr.visit(this);
				obj.block.visit(this);
				break;
			case IfEnum.IfElse:
				obj.expr.visit(this);
				obj.block.visit(this);
				obj.block2.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(For obj) {}
	void exit(For obj) {}

	void accept(For obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ForEnum.To:
				obj.tok.visit(this);
				obj.start.visit(this);
				obj.end.visit(this);
				obj.block.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(For) obj) {}
	void exit(const(For) obj) {}

	void accept(const(For) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ForEnum.To:
				obj.tok.visit(this);
				obj.start.visit(this);
				obj.end.visit(this);
				obj.block.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Blocks obj) {}
	void exit(Blocks obj) {}

	void accept(Blocks obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case BlocksEnum.One:
				obj.block.visit(this);
				break;
			case BlocksEnum.Follow:
				obj.block.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Blocks) obj) {}
	void exit(const(Blocks) obj) {}

	void accept(const(Blocks) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case BlocksEnum.One:
				obj.block.visit(this);
				break;
			case BlocksEnum.Follow:
				obj.block.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Block obj) {}
	void exit(Block obj) {}

	void accept(Block obj) {
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
				obj.name.visit(this);
				obj.para.visit(this);
				obj.block.visit(this);
				break;
			case BlockEnum.RET:
				obj.expr.visit(this);
				break;
			case BlockEnum.S:
				obj.sw.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Block) obj) {}
	void exit(const(Block) obj) {}

	void accept(const(Block) obj) {
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
				obj.name.visit(this);
				obj.para.visit(this);
				obj.block.visit(this);
				break;
			case BlockEnum.RET:
				obj.expr.visit(this);
				break;
			case BlockEnum.S:
				obj.sw.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Switch obj) {}
	void exit(Switch obj) {}

	void accept(Switch obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case SwitchEnum.S:
				obj.sel.visit(this);
				obj.cases.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Switch) obj) {}
	void exit(const(Switch) obj) {}

	void accept(const(Switch) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case SwitchEnum.S:
				obj.sel.visit(this);
				obj.cases.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Cases obj) {}
	void exit(Cases obj) {}

	void accept(Cases obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CasesEnum.One:
				obj.val.visit(this);
				obj.b.visit(this);
				break;
			case CasesEnum.Many:
				obj.val.visit(this);
				obj.b.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Cases) obj) {}
	void exit(const(Cases) obj) {}

	void accept(const(Cases) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CasesEnum.One:
				obj.val.visit(this);
				obj.b.visit(this);
				break;
			case CasesEnum.Many:
				obj.val.visit(this);
				obj.b.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Assign obj) {}
	void exit(Assign obj) {}

	void accept(Assign obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case AssignEnum.As:
				obj.left.visit(this);
				obj.right.visit(this);
				break;
			case AssignEnum.Ter:
				obj.left.visit(this);
				obj.right.visit(this);
				obj.t.visit(this);
				obj.f.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Assign) obj) {}
	void exit(const(Assign) obj) {}

	void accept(const(Assign) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case AssignEnum.As:
				obj.left.visit(this);
				obj.right.visit(this);
				break;
			case AssignEnum.Ter:
				obj.left.visit(this);
				obj.right.visit(this);
				obj.t.visit(this);
				obj.f.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Expr obj) {}
	void exit(Expr obj) {}

	void accept(Expr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ExprEnum.E:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Expr) obj) {}
	void exit(const(Expr) obj) {}

	void accept(const(Expr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ExprEnum.E:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(RelExpr obj) {}
	void exit(RelExpr obj) {}

	void accept(RelExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case RelExprEnum.EE:
				obj.ce.visit(this);
				break;
			case RelExprEnum.L:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.G:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.LE:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.GE:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(RelExpr) obj) {}
	void exit(const(RelExpr) obj) {}

	void accept(const(RelExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case RelExprEnum.EE:
				obj.ce.visit(this);
				break;
			case RelExprEnum.L:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.G:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.LE:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
			case RelExprEnum.GE:
				obj.ce.visit(this);
				obj.follow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(CmpExpr obj) {}
	void exit(CmpExpr obj) {}

	void accept(CmpExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CmpExprEnum.EQ:
				obj.me.visit(this);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.NEQ:
				obj.me.visit(this);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.Mul:
				obj.me.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(CmpExpr) obj) {}
	void exit(const(CmpExpr) obj) {}

	void accept(const(CmpExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CmpExprEnum.EQ:
				obj.me.visit(this);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.NEQ:
				obj.me.visit(this);
				obj.follow.visit(this);
				break;
			case CmpExprEnum.Mul:
				obj.me.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(MulExpr obj) {}
	void exit(MulExpr obj) {}

	void accept(MulExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case MulExprEnum.Star:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Div:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Mod:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Add:
				obj.add.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(MulExpr) obj) {}
	void exit(const(MulExpr) obj) {}

	void accept(const(MulExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case MulExprEnum.Star:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Div:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Mod:
				obj.add.visit(this);
				obj.follow.visit(this);
				break;
			case MulExprEnum.Add:
				obj.add.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(AddExpr obj) {}
	void exit(AddExpr obj) {}

	void accept(AddExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case AddExprEnum.Plus:
				obj.post.visit(this);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Minus:
				obj.post.visit(this);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Post:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(AddExpr) obj) {}
	void exit(const(AddExpr) obj) {}

	void accept(const(AddExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case AddExprEnum.Plus:
				obj.post.visit(this);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Minus:
				obj.post.visit(this);
				obj.follow.visit(this);
				break;
			case AddExprEnum.Post:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(UnaryExpr obj) {}
	void exit(UnaryExpr obj) {}

	void accept(UnaryExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case UnaryExprEnum.M:
				obj.post.visit(this);
				break;
			case UnaryExprEnum.P:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(UnaryExpr) obj) {}
	void exit(const(UnaryExpr) obj) {}

	void accept(const(UnaryExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case UnaryExprEnum.M:
				obj.post.visit(this);
				break;
			case UnaryExprEnum.P:
				obj.post.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(PostfixExpr obj) {}
	void exit(PostfixExpr obj) {}

	void accept(PostfixExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PostfixExprEnum.Ident:
				obj.ident.visit(this);
				break;
			case PostfixExprEnum.Array:
				obj.ident.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixExprEnum.Primary:
				obj.prim.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(PostfixExpr) obj) {}
	void exit(const(PostfixExpr) obj) {}

	void accept(const(PostfixExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PostfixExprEnum.Ident:
				obj.ident.visit(this);
				break;
			case PostfixExprEnum.Array:
				obj.ident.visit(this);
				obj.follow.visit(this);
				break;
			case PostfixExprEnum.Primary:
				obj.prim.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(PostfixFollow obj) {}
	void exit(PostfixFollow obj) {}

	void accept(PostfixFollow obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PostfixFollowEnum.Dot:
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.Array:
				obj.array.visit(this);
				break;
			case PostfixFollowEnum.ArrayDot:
				obj.array.visit(this);
				obj.postfix.visit(this);
				break;
			case PostfixFollowEnum.Call:
				obj.call.visit(this);
				break;
			case PostfixFollowEnum.CallFollow:
				obj.call.visit(this);
				obj.pffollow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(PostfixFollow) obj) {}
	void exit(const(PostfixFollow) obj) {}

	void accept(const(PostfixFollow) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PostfixFollowEnum.Dot:
				obj.follow.visit(this);
				break;
			case PostfixFollowEnum.Array:
				obj.array.visit(this);
				break;
			case PostfixFollowEnum.ArrayDot:
				obj.array.visit(this);
				obj.postfix.visit(this);
				break;
			case PostfixFollowEnum.Call:
				obj.call.visit(this);
				break;
			case PostfixFollowEnum.CallFollow:
				obj.call.visit(this);
				obj.pffollow.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Array obj) {}
	void exit(Array obj) {}

	void accept(Array obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArrayEnum.Empty:
				break;
			case ArrayEnum.Index:
				obj.expr.visit(this);
				break;
			case ArrayEnum.Slice:
				obj.expr.visit(this);
				obj.expr2.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Array) obj) {}
	void exit(const(Array) obj) {}

	void accept(const(Array) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArrayEnum.Empty:
				break;
			case ArrayEnum.Index:
				obj.expr.visit(this);
				break;
			case ArrayEnum.Slice:
				obj.expr.visit(this);
				obj.expr2.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Call obj) {}
	void exit(Call obj) {}

	void accept(Call obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CallEnum.Empty:
				break;
			case CallEnum.Args:
				obj.args.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Call) obj) {}
	void exit(const(Call) obj) {}

	void accept(const(Call) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case CallEnum.Empty:
				break;
			case CallEnum.Args:
				obj.args.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(ArgList obj) {}
	void exit(ArgList obj) {}

	void accept(ArgList obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArgListEnum.Arg:
				obj.arg.visit(this);
				break;
			case ArgListEnum.Args:
				obj.arg.visit(this);
				obj.next.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(ArgList) obj) {}
	void exit(const(ArgList) obj) {}

	void accept(const(ArgList) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case ArgListEnum.Arg:
				obj.arg.visit(this);
				break;
			case ArgListEnum.Args:
				obj.arg.visit(this);
				obj.next.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(PrimaryExpr obj) {}
	void exit(PrimaryExpr obj) {}

	void accept(PrimaryExpr obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Integer:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(PrimaryExpr) obj) {}
	void exit(const(PrimaryExpr) obj) {}

	void accept(const(PrimaryExpr) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case PrimaryExprEnum.Integer:
				obj.value.visit(this);
				break;
			case PrimaryExprEnum.Parenthesis:
				obj.expr.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(Identifier obj) {}
	void exit(Identifier obj) {}

	void accept(Identifier obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case IdentifierEnum.Ident:
				obj.value.visit(this);
				break;
		}
		exit(obj);
	}

	void enter(const(Identifier) obj) {}
	void exit(const(Identifier) obj) {}

	void accept(const(Identifier) obj) {
		enter(obj);
		final switch(obj.ruleSelection) {
			case IdentifierEnum.Ident:
				obj.value.visit(this);
				break;
		}
		exit(obj);
	}
}
