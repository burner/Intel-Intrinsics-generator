module tokenmodule;

@safe @nogc:

enum TokenType {
	undefined,
	plus,
	minus,
	div,
	mod,
	star,
	to,
	fi,
	of,
	elseKeyword,
	endfor,
	colon,
	define,
	returnKeyword,
	caseKeyword,
	esacKeyword,
	assign,
	lbrack,
	rbrack,
	lparen,
	rparen,
	lcurly,
	rcurly,
	identifier,
	intValue,
	ifKeyword,
	forKeyword,
	dot,
	comma,
	less,
	greater,
	lessequal,
	greaterequal,
	equal,
	notequal,
	question,
}

struct Token {
	import visitor;

	//int line;
	//int column;
	string value;

	TokenType type;

	this(TokenType type) {
		this.type = type;
	}

	this(TokenType type, string value) {
		this(type);
		this.value = value;
	}

	void visit(Visitor v) {

	}
	
	void visit(Visitor v) const {

	}
}

