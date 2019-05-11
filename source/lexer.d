module lexer;

import tokenmodule;

import std.experimental.logger;

@safe:

struct Lexer {
	string input;
	long stringPos;

	int line;
	int column;

	Token cur;

	this(string input) {
		this.input = input;
		this.stringPos = 0;
		this.line = 1;
		this.column = 1;
		this.buildToken();
	}

	private bool isTokenStop() const {
		return this.stringPos >= this.input.length 
			|| this.isTokenStop(this.input[this.stringPos]);
	}

	private bool isTokenStop(const(char) c) const {
		return 
			c == ' ' || c == '\t' || c == '\n' || c == ';' || c == '(' 
			|| c == ')' || c == '{' || c == '}' || c == '&' || c == '!'
			|| c == '=' || c == '|' || c == '.' || c == '*' || c == '/'
			|| c == '%' || c == '[' || c == ']' || c == ',';
	}

	private void eatWhitespace() {
		import std.ascii : isWhite;
		while(this.stringPos < this.input.length) {
			this.eatComment();
			if(this.input[this.stringPos] == ' ') {
				++this.column;
			} else if(this.input[this.stringPos] == '\t') {
				++this.column;
			} else if(this.input[this.stringPos] == '\n') {
				this.column = 1;
				++this.line;
			} else {
				break;
			}
			++this.stringPos;
		}
	}

	private void eatComment() {
		if(this.stringPos + 1 < this.input.length 
				&& this.input[this.stringPos .. this.stringPos + 2] == "//") 
		{
			while(this.stringPos < this.input.length
					&& this.input[this.stringPos] != '\n') 
			{
				++this.stringPos;
			}
			this.column = 1;
			++this.line;
		}
	}

	private void buildToken() {
		this.eatWhitespace();

		if(this.stringPos >= this.input.length) {
			this.cur = Token(TokenType.undefined);
			return;
		}

		if(this.input[this.stringPos] == ')') {
			this.cur = Token(TokenType.rparen);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '(') {
			this.cur = Token(TokenType.lparen);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '?') {
			this.cur = Token(TokenType.question);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '*') {
			this.cur = Token(TokenType.star);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '+') {
			this.cur = Token(TokenType.plus);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '-') {
			this.cur = Token(TokenType.minus);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == ']') {
			this.cur = Token(TokenType.rbrack);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '[') {
			this.cur = Token(TokenType.lbrack);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '}') {
			this.cur = Token(TokenType.rcurly);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '{') {
			this.cur = Token(TokenType.lcurly);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '.') {
			this.cur = Token(TokenType.dot);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == ',') {
			this.cur = Token(TokenType.comma);
			++this.column;
			++this.stringPos;
		} else if(this.input[this.stringPos] == '!') {
			if(this.input[this.stringPos] == '=') {
				++this.column;
				++this.stringPos;
				if(this.isTokenStop()) {
					this.cur = Token(TokenType.notequal);
					return;
				}
			}
			assert(false);
		} else if(this.input[this.stringPos] == '=') {
			++this.column;
			++this.stringPos;
			if(this.input[this.stringPos] == '=') {
				++this.column;
				++this.stringPos;
				this.cur = Token(TokenType.equal);
				return;
			}
			this.cur = Token(TokenType.assign);
			return;
		} else if(this.input[this.stringPos] == '<') {
			++this.column;
			++this.stringPos;
			if(this.input[this.stringPos] == '=') {
				++this.column;
				++this.stringPos;
				if(this.isTokenStop()) {
					this.cur = Token(TokenType.lessequal);
				}
			} else if(this.isTokenStop()) {
				this.cur = Token(TokenType.less);
				return;
			} else {
				assert(false);
			}
		} else if(this.input[this.stringPos] == '>') {
			++this.column;
			++this.stringPos;
			if(this.input[this.stringPos] == '=') {
				++this.column;
				++this.stringPos;
				if(this.isTokenStop()) {
					this.cur = Token(TokenType.greaterequal);
				}
			} else if(this.isTokenStop()) {
				this.cur = Token(TokenType.greater);
				return;
			} else {
				assert(false);
			}
		} else {
			ulong b = this.stringPos;	
			ulong e = this.stringPos;
			switch(this.input[this.stringPos]) {
				case ':':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('=', e)) {
						this.cur = Token(TokenType.assign);
					} else {
						this.cur = Token(TokenType.colon);
					}
					return;
				case 'O':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('F', e)) {
						this.cur = Token(TokenType.of);
						return;
					}
					goto default;
				case 'C':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testStrAndInc!"ASE"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.caseKeyword);
							return;
						}
					}
					goto default;
				case 'R':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testStrAndInc!"ETURN"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.returnKeyword);
							return;
						}
					}
					goto default;
				case 'D':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testStrAndInc!"EFINE"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.define);
							return;
						}
					}
					goto default;
				case 'I':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('F', e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.ifKeyword);
							return;
						}
					}
					goto default;
				case 't':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('o', e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.to);
							return;
						}
					}
					goto default;
				case 'T':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testCharAndInc('O', e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.to);
							return;
						}
					}
					goto default;
				case 'E':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testStrAndInc!"LSE"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.elseKeyword);
							return;
						}
						goto default;
					} else if(this.testStrAndInc!"NDFOR"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.endfor);
							return;
						}
						goto default;
					} else if(this.testStrAndInc!"SAC"(e)) {
						if(this.isTokenStop()) {
							this.cur = Token(TokenType.esacKeyword);
							return;
						}
					}
					goto default;
				case 'F':
					++this.stringPos;
					++this.column;
					++e;
					if(this.testStrAndInc!"OR"(e)) {
						if(this.testStrAndInc!"EACH"(e)) {
							if(this.isTokenStop()) {
								this.cur = Token(TokenType.forKeyword);
								return;
							}
						} else if(this.isTokenStop()) {
							this.cur = Token(TokenType.forKeyword);
							return;
						}
					}
					goto default;
				case '0': .. case '9':
					do {
						++this.stringPos;
						++this.column;
						++e;
					} while(this.stringPos < this.input.length 
							&& this.input[this.stringPos] >= '0'
							&& this.input[this.stringPos] <= '9');
					
					if(this.stringPos >= this.input.length
							|| this.input[this.stringPos] != '.') 
					{
						this.cur = Token(TokenType.intValue, this.input[b .. e]);
						return;
					} else {
						assert(false);
					}
				default:
					do {
						++this.stringPos;
						++this.column;
						++e;
					} while(!this.isTokenStop());
					this.cur = Token(TokenType.identifier, this.input[b .. e]);
					break;
			}
		}
	}

	bool testStrAndInc(string s)(ref size_t e) @safe {
		for(size_t i = 0; i < s.length; ++i) {
			if(this.stringPos < this.input.length
					&& this.input[this.stringPos] == s[i])
			{
				++this.column;
				++this.stringPos;
				++e;
			} else {
				return false;
			}
		}
		return true;
	}

	bool testCharAndInc(const(char) c, ref ulong e) {
		if(this.stringPos < this.input.length 
				&& this.input[this.stringPos] == c)
		{
			++this.column;
			++this.stringPos;
			++e;
			return true;
		} else {
			return false;
		}
	}

	@property bool empty() const @nogc pure {
		return this.stringPos >= this.input.length
			&& this.cur.type == TokenType.undefined;
	}

	@property ref Token front() @nogc pure {
		return this.cur;
	}

	@property Token front() @nogc pure const {
		return this.cur;
	}

	void popFront() {
		this.buildToken();		
	}
}

void test(ref Lexer l, TokenType[] tts) {
	import std.format;
	import std.stdio;

	foreach(t; tts) {
		assert(!l.empty);
		assert(l.front.type == t, format("%s != %s", t, l.front));
		l.popFront();
	}
}

unittest {
	string s = "(imm8[0] == 0)";
	auto l = Lexer(s);
	test(l, [
		TokenType.lparen, 
		TokenType.identifier, 
		TokenType.lbrack, 
		TokenType.intValue, 
		TokenType.rbrack, 
		TokenType.equal, 
		TokenType.intValue, 
		TokenType.rparen]);
	assert(l.empty);
}

unittest {
	string s = "IF (src2 == NaN)";
	auto l = Lexer(s);
	test(l, [
		TokenType.ifKeyword, 
		TokenType.lparen, 
		TokenType.identifier, 
		TokenType.equal, 
		TokenType.identifier, 
		TokenType.rparen, 
	]);
	assert(l.empty);
}
