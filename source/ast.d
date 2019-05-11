module ast;

import tokenmodule;

import visitor;

enum StartEnum {
	B,
}

class Start {
	StartEnum ruleSelection;
	Block block;

	this(StartEnum ruleSelection, Block block) {
		this.ruleSelection = ruleSelection;
		this.block = block;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum IfEnum {
	If,
	IfElse,
}

class If {
	IfEnum ruleSelection;
	Blocks block;
	Expr expr;
	Blocks block2;

	this(IfEnum ruleSelection, Expr expr, Blocks block) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
		this.block = block;
	}

	this(IfEnum ruleSelection, Expr expr, Blocks block, Blocks block2) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
		this.block = block;
		this.block2 = block2;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum ForEnum {
	To,
}

class For {
	ForEnum ruleSelection;
	Identifier tok;
	Blocks block;
	Token end;
	Token start;

	this(ForEnum ruleSelection, Identifier tok, Token start, Token end, Blocks block) {
		this.ruleSelection = ruleSelection;
		this.tok = tok;
		this.start = start;
		this.end = end;
		this.block = block;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum BlocksEnum {
	One,
	Follow,
}

class Blocks {
	BlocksEnum ruleSelection;
	Block block;
	Blocks follow;

	this(BlocksEnum ruleSelection, Block block) {
		this.ruleSelection = ruleSelection;
		this.block = block;
	}

	this(BlocksEnum ruleSelection, Block block, Blocks follow) {
		this.ruleSelection = ruleSelection;
		this.block = block;
		this.follow = follow;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum BlockEnum {
	I,
	F,
	A,
	FUN,
	RET,
	S,
}

class Block {
	BlockEnum ruleSelection;
	Expr expr;
	If i;
	Call para;
	Identifier name;
	Assign a;
	Blocks block;
	Switch sw;
	For f;

	this(BlockEnum ruleSelection, If i) {
		this.ruleSelection = ruleSelection;
		this.i = i;
	}

	this(BlockEnum ruleSelection, For f) {
		this.ruleSelection = ruleSelection;
		this.f = f;
	}

	this(BlockEnum ruleSelection, Assign a) {
		this.ruleSelection = ruleSelection;
		this.a = a;
	}

	this(BlockEnum ruleSelection, Identifier name, Call para, Blocks block) {
		this.ruleSelection = ruleSelection;
		this.name = name;
		this.para = para;
		this.block = block;
	}

	this(BlockEnum ruleSelection, Expr expr) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
	}

	this(BlockEnum ruleSelection, Switch sw) {
		this.ruleSelection = ruleSelection;
		this.sw = sw;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum SwitchEnum {
	S,
}

class Switch {
	SwitchEnum ruleSelection;
	Expr sel;
	Cases cases;

	this(SwitchEnum ruleSelection, Expr sel, Cases cases) {
		this.ruleSelection = ruleSelection;
		this.sel = sel;
		this.cases = cases;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum CasesEnum {
	One,
	Many,
}

class Cases {
	CasesEnum ruleSelection;
	Token val;
	Block b;
	Cases follow;

	this(CasesEnum ruleSelection, Token val, Block b) {
		this.ruleSelection = ruleSelection;
		this.val = val;
		this.b = b;
	}

	this(CasesEnum ruleSelection, Token val, Block b, Cases follow) {
		this.ruleSelection = ruleSelection;
		this.val = val;
		this.b = b;
		this.follow = follow;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum AssignEnum {
	As,
	Ter,
}

class Assign {
	AssignEnum ruleSelection;
	Expr left;
	Expr right;
	Expr t;
	Expr f;

	this(AssignEnum ruleSelection, Expr left, Expr right) {
		this.ruleSelection = ruleSelection;
		this.left = left;
		this.right = right;
	}

	this(AssignEnum ruleSelection, Expr left, Expr right, Expr t, Expr f) {
		this.ruleSelection = ruleSelection;
		this.left = left;
		this.right = right;
		this.t = t;
		this.f = f;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum ExprEnum {
	E,
}

class Expr {
	ExprEnum ruleSelection;
	RelExpr post;

	this(ExprEnum ruleSelection, RelExpr post) {
		this.ruleSelection = ruleSelection;
		this.post = post;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum RelExprEnum {
	EE,
	L,
	G,
	LE,
	GE,
}

class RelExpr {
	RelExprEnum ruleSelection;
	CmpExpr ce;
	RelExpr follow;

	this(RelExprEnum ruleSelection, CmpExpr ce) {
		this.ruleSelection = ruleSelection;
		this.ce = ce;
	}

	this(RelExprEnum ruleSelection, CmpExpr ce, RelExpr follow) {
		this.ruleSelection = ruleSelection;
		this.ce = ce;
		this.follow = follow;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum CmpExprEnum {
	EQ,
	NEQ,
	Mul,
}

class CmpExpr {
	CmpExprEnum ruleSelection;
	CmpExpr follow;
	MulExpr me;

	this(CmpExprEnum ruleSelection, MulExpr me, CmpExpr follow) {
		this.ruleSelection = ruleSelection;
		this.me = me;
		this.follow = follow;
	}

	this(CmpExprEnum ruleSelection, MulExpr me) {
		this.ruleSelection = ruleSelection;
		this.me = me;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum MulExprEnum {
	Star,
	Div,
	Mod,
	Add,
}

class MulExpr {
	MulExprEnum ruleSelection;
	AddExpr add;
	MulExpr follow;

	this(MulExprEnum ruleSelection, AddExpr add, MulExpr follow) {
		this.ruleSelection = ruleSelection;
		this.add = add;
		this.follow = follow;
	}

	this(MulExprEnum ruleSelection, AddExpr add) {
		this.ruleSelection = ruleSelection;
		this.add = add;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum AddExprEnum {
	Plus,
	Minus,
	Post,
}

class AddExpr {
	AddExprEnum ruleSelection;
	UnaryExpr post;
	AddExpr follow;

	this(AddExprEnum ruleSelection, UnaryExpr post, AddExpr follow) {
		this.ruleSelection = ruleSelection;
		this.post = post;
		this.follow = follow;
	}

	this(AddExprEnum ruleSelection, UnaryExpr post) {
		this.ruleSelection = ruleSelection;
		this.post = post;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum UnaryExprEnum {
	M,
	P,
}

class UnaryExpr {
	UnaryExprEnum ruleSelection;
	PostfixExpr post;

	this(UnaryExprEnum ruleSelection, PostfixExpr post) {
		this.ruleSelection = ruleSelection;
		this.post = post;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PostfixExprEnum {
	Ident,
	Array,
	Primary,
}

class PostfixExpr {
	PostfixExprEnum ruleSelection;
	Identifier ident;
	PostfixFollow follow;
	PrimaryExpr prim;

	this(PostfixExprEnum ruleSelection, Identifier ident) {
		this.ruleSelection = ruleSelection;
		this.ident = ident;
	}

	this(PostfixExprEnum ruleSelection, Identifier ident, PostfixFollow follow) {
		this.ruleSelection = ruleSelection;
		this.ident = ident;
		this.follow = follow;
	}

	this(PostfixExprEnum ruleSelection, PrimaryExpr prim) {
		this.ruleSelection = ruleSelection;
		this.prim = prim;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PostfixFollowEnum {
	Dot,
	Array,
	ArrayDot,
	Call,
	CallFollow,
}

class PostfixFollow {
	PostfixFollowEnum ruleSelection;
	Call call;
	Array array;
	PostfixExpr follow;
	PostfixExpr postfix;
	PostfixFollow pffollow;

	this(PostfixFollowEnum ruleSelection, PostfixExpr follow) {
		this.ruleSelection = ruleSelection;
		this.follow = follow;
	}

	this(PostfixFollowEnum ruleSelection, Array array) {
		this.ruleSelection = ruleSelection;
		this.array = array;
	}

	this(PostfixFollowEnum ruleSelection, Array array, PostfixExpr postfix) {
		this.ruleSelection = ruleSelection;
		this.array = array;
		this.postfix = postfix;
	}

	this(PostfixFollowEnum ruleSelection, Call call) {
		this.ruleSelection = ruleSelection;
		this.call = call;
	}

	this(PostfixFollowEnum ruleSelection, Call call, PostfixFollow pffollow) {
		this.ruleSelection = ruleSelection;
		this.call = call;
		this.pffollow = pffollow;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum ArrayEnum {
	Empty,
	Index,
	Slice,
}

class Array {
	ArrayEnum ruleSelection;
	Expr expr2;
	Expr expr;

	this(ArrayEnum ruleSelection) {
		this.ruleSelection = ruleSelection;
	}

	this(ArrayEnum ruleSelection, Expr expr) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
	}

	this(ArrayEnum ruleSelection, Expr expr, Expr expr2) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
		this.expr2 = expr2;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum CallEnum {
	Empty,
	Args,
}

class Call {
	CallEnum ruleSelection;
	ArgList args;

	this(CallEnum ruleSelection) {
		this.ruleSelection = ruleSelection;
	}

	this(CallEnum ruleSelection, ArgList args) {
		this.ruleSelection = ruleSelection;
		this.args = args;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum ArgListEnum {
	Arg,
	Args,
}

class ArgList {
	ArgListEnum ruleSelection;
	Expr arg;
	ArgList next;

	this(ArgListEnum ruleSelection, Expr arg) {
		this.ruleSelection = ruleSelection;
		this.arg = arg;
	}

	this(ArgListEnum ruleSelection, Expr arg, ArgList next) {
		this.ruleSelection = ruleSelection;
		this.arg = arg;
		this.next = next;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum PrimaryExprEnum {
	Integer,
	Parenthesis,
}

class PrimaryExpr {
	PrimaryExprEnum ruleSelection;
	Token value;
	Expr expr;

	this(PrimaryExprEnum ruleSelection, Token value) {
		this.ruleSelection = ruleSelection;
		this.value = value;
	}

	this(PrimaryExprEnum ruleSelection, Expr expr) {
		this.ruleSelection = ruleSelection;
		this.expr = expr;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

enum IdentifierEnum {
	Ident,
}

class Identifier {
	IdentifierEnum ruleSelection;
	Token value;

	this(IdentifierEnum ruleSelection, Token value) {
		this.ruleSelection = ruleSelection;
		this.value = value;
	}

	void visit(Visitor vis) {
		vis.accept(this);
	}

	void visit(Visitor vis) const {
		vis.accept(this);
	}
}

