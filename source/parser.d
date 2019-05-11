module parser;

import std.typecons : RefCounted, refCounted;
import std.format : format;
import ast;
import tokenmodule;

import lexer;

import exception;

struct Parser {
	import std.array : appender;

	import std.format : formattedWrite;

	Lexer lex;

	this(Lexer lex) {
		this.lex = lex;
	}

	bool firstStart() const pure @nogc @safe {
		return this.firstBlock();
	}

	Start parseStart() {
		try {
			return this.parseStartImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Start an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Start parseStartImpl() {
		string[] subRules;
		subRules = ["B"];
		if(this.firstBlock()) {
			Block block = this.parseBlock();

			return new Start(StartEnum.B
				, block
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["caseKeyword -> Switch","define","forKeyword -> For","identifier -> Assign","ifKeyword -> If","intValue -> Assign","lparen -> Assign","minus -> Assign","returnKeyword"]
		);

	}

	bool firstIf() const pure @nogc @safe {
		return this.lex.front.type == TokenType.ifKeyword;
	}

	If parseIf() {
		try {
			return this.parseIfImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a If an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	If parseIfImpl() {
		string[] subRules;
		subRules = ["If", "IfElse"];
		if(this.lex.front.type == TokenType.ifKeyword) {
			this.lex.popFront();
			subRules = ["If", "IfElse"];
			if(this.firstExpr()) {
				Expr expr = this.parseExpr();
				subRules = ["If", "IfElse"];
				if(this.firstBlocks()) {
					Blocks block = this.parseBlocks();
					subRules = ["If"];
					if(this.lex.front.type == TokenType.fi) {
						this.lex.popFront();

						return new If(IfEnum.If
							, expr
							, block
						);
					} else if(this.lex.front.type == TokenType.elseKeyword) {
						this.lex.popFront();
						subRules = ["IfElse"];
						if(this.firstBlocks()) {
							Blocks block2 = this.parseBlocks();
							subRules = ["IfElse"];
							if(this.lex.front.type == TokenType.fi) {
								this.lex.popFront();

								return new If(IfEnum.IfElse
									, expr
									, block
									, block2
								);
							}
							auto app = appender!string();
							formattedWrite(app, 
								"Found a '%s' while looking for", 
								this.lex.front
							);
							throw new ParseException(app.data,
								__FILE__, __LINE__,
								subRules,
								["fi"]
							);

						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["caseKeyword -> Block","define -> Block","forKeyword -> Block","identifier -> Block","ifKeyword -> Block","intValue -> Block","lparen -> Block","minus -> Block","returnKeyword -> Block"]
						);

					}
					auto app = appender!string();
					formattedWrite(app, 
						"Found a '%s' while looking for", 
						this.lex.front
					);
					throw new ParseException(app.data,
						__FILE__, __LINE__,
						subRules,
						["fi","elseKeyword"]
					);

				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["caseKeyword -> Block","define -> Block","forKeyword -> Block","identifier -> Block","ifKeyword -> Block","intValue -> Block","lparen -> Block","minus -> Block","returnKeyword -> Block"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["ifKeyword"]
		);

	}

	bool firstFor() const pure @nogc @safe {
		return this.lex.front.type == TokenType.forKeyword;
	}

	For parseFor() {
		try {
			return this.parseForImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a For an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	For parseForImpl() {
		string[] subRules;
		subRules = ["To"];
		if(this.lex.front.type == TokenType.forKeyword) {
			this.lex.popFront();
			subRules = ["To"];
			if(this.firstIdentifier()) {
				Identifier tok = this.parseIdentifier();
				subRules = ["To"];
				if(this.lex.front.type == TokenType.assign) {
					this.lex.popFront();
					subRules = ["To"];
					if(this.lex.front.type == TokenType.intValue) {
						Token start = this.lex.front;
						this.lex.popFront();
						subRules = ["To"];
						if(this.lex.front.type == TokenType.to) {
							this.lex.popFront();
							subRules = ["To"];
							if(this.lex.front.type == TokenType.intValue) {
								Token end = this.lex.front;
								this.lex.popFront();
								subRules = ["To"];
								if(this.firstBlocks()) {
									Blocks block = this.parseBlocks();
									subRules = ["To"];
									if(this.lex.front.type == TokenType.endfor) {
										this.lex.popFront();

										return new For(ForEnum.To
											, tok
											, start
											, end
											, block
										);
									}
									auto app = appender!string();
									formattedWrite(app, 
										"Found a '%s' while looking for", 
										this.lex.front
									);
									throw new ParseException(app.data,
										__FILE__, __LINE__,
										subRules,
										["endfor"]
									);

								}
								auto app = appender!string();
								formattedWrite(app, 
									"Found a '%s' while looking for", 
									this.lex.front
								);
								throw new ParseException(app.data,
									__FILE__, __LINE__,
									subRules,
									["caseKeyword -> Block","define -> Block","forKeyword -> Block","identifier -> Block","ifKeyword -> Block","intValue -> Block","lparen -> Block","minus -> Block","returnKeyword -> Block"]
								);

							}
							auto app = appender!string();
							formattedWrite(app, 
								"Found a '%s' while looking for", 
								this.lex.front
							);
							throw new ParseException(app.data,
								__FILE__, __LINE__,
								subRules,
								["intValue"]
							);

						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["to"]
						);

					}
					auto app = appender!string();
					formattedWrite(app, 
						"Found a '%s' while looking for", 
						this.lex.front
					);
					throw new ParseException(app.data,
						__FILE__, __LINE__,
						subRules,
						["intValue"]
					);

				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["assign"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["forKeyword"]
		);

	}

	bool firstBlocks() const pure @nogc @safe {
		return this.firstBlock();
	}

	Blocks parseBlocks() {
		try {
			return this.parseBlocksImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Blocks an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Blocks parseBlocksImpl() {
		string[] subRules;
		subRules = ["Follow", "One"];
		if(this.firstBlock()) {
			Block block = this.parseBlock();
			subRules = ["Follow"];
			if(this.firstBlocks()) {
				Blocks follow = this.parseBlocks();

				return new Blocks(BlocksEnum.Follow
					, block
					, follow
				);
			}
			return new Blocks(BlocksEnum.One
				, block
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["caseKeyword -> Switch","define","forKeyword -> For","identifier -> Assign","ifKeyword -> If","intValue -> Assign","lparen -> Assign","minus -> Assign","returnKeyword"]
		);

	}

	bool firstBlock() const pure @nogc @safe {
		return this.firstIf()
			 || this.firstFor()
			 || this.firstAssign()
			 || this.lex.front.type == TokenType.define
			 || this.lex.front.type == TokenType.returnKeyword
			 || this.firstSwitch();
	}

	Block parseBlock() {
		try {
			return this.parseBlockImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Block an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Block parseBlockImpl() {
		string[] subRules;
		subRules = ["I"];
		if(this.firstIf()) {
			If i = this.parseIf();

			return new Block(BlockEnum.I
				, i
			);
		} else if(this.firstFor()) {
			For f = this.parseFor();

			return new Block(BlockEnum.F
				, f
			);
		} else if(this.firstAssign()) {
			Assign a = this.parseAssign();

			return new Block(BlockEnum.A
				, a
			);
		} else if(this.lex.front.type == TokenType.define) {
			this.lex.popFront();
			subRules = ["FUN"];
			if(this.firstIdentifier()) {
				Identifier name = this.parseIdentifier();
				subRules = ["FUN"];
				if(this.firstCall()) {
					Call para = this.parseCall();
					subRules = ["FUN"];
					if(this.lex.front.type == TokenType.lcurly) {
						this.lex.popFront();
						subRules = ["FUN"];
						if(this.firstBlocks()) {
							Blocks block = this.parseBlocks();
							subRules = ["FUN"];
							if(this.lex.front.type == TokenType.rcurly) {
								this.lex.popFront();

								return new Block(BlockEnum.FUN
									, name
									, para
									, block
								);
							}
							auto app = appender!string();
							formattedWrite(app, 
								"Found a '%s' while looking for", 
								this.lex.front
							);
							throw new ParseException(app.data,
								__FILE__, __LINE__,
								subRules,
								["rcurly"]
							);

						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["caseKeyword -> Block","define -> Block","forKeyword -> Block","identifier -> Block","ifKeyword -> Block","intValue -> Block","lparen -> Block","minus -> Block","returnKeyword -> Block"]
						);

					}
					auto app = appender!string();
					formattedWrite(app, 
						"Found a '%s' while looking for", 
						this.lex.front
					);
					throw new ParseException(app.data,
						__FILE__, __LINE__,
						subRules,
						["lcurly"]
					);

				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["lparen"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier"]
			);

		} else if(this.lex.front.type == TokenType.returnKeyword) {
			this.lex.popFront();
			subRules = ["RET"];
			if(this.firstExpr()) {
				Expr expr = this.parseExpr();

				return new Block(BlockEnum.RET
					, expr
				);
			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
			);

		} else if(this.firstSwitch()) {
			Switch sw = this.parseSwitch();

			return new Block(BlockEnum.S
				, sw
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["ifKeyword","forKeyword","identifier -> Expr","intValue -> Expr","lparen -> Expr","minus -> Expr","define","returnKeyword","caseKeyword"]
		);

	}

	bool firstSwitch() const pure @nogc @safe {
		return this.lex.front.type == TokenType.caseKeyword;
	}

	Switch parseSwitch() {
		try {
			return this.parseSwitchImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Switch an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Switch parseSwitchImpl() {
		string[] subRules;
		subRules = ["S"];
		if(this.lex.front.type == TokenType.caseKeyword) {
			this.lex.popFront();
			subRules = ["S"];
			if(this.lex.front.type == TokenType.lparen) {
				this.lex.popFront();
				subRules = ["S"];
				if(this.firstExpr()) {
					Expr sel = this.parseExpr();
					subRules = ["S"];
					if(this.lex.front.type == TokenType.rparen) {
						this.lex.popFront();
						subRules = ["S"];
						if(this.lex.front.type == TokenType.of) {
							this.lex.popFront();
							subRules = ["S"];
							if(this.firstCases()) {
								Cases cases = this.parseCases();
								subRules = ["S"];
								if(this.lex.front.type == TokenType.esacKeyword) {
									this.lex.popFront();

									return new Switch(SwitchEnum.S
										, sel
										, cases
									);
								}
								auto app = appender!string();
								formattedWrite(app, 
									"Found a '%s' while looking for", 
									this.lex.front
								);
								throw new ParseException(app.data,
									__FILE__, __LINE__,
									subRules,
									["esacKeyword"]
								);

							}
							auto app = appender!string();
							formattedWrite(app, 
								"Found a '%s' while looking for", 
								this.lex.front
							);
							throw new ParseException(app.data,
								__FILE__, __LINE__,
								subRules,
								["intValue"]
							);

						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["of"]
						);

					}
					auto app = appender!string();
					formattedWrite(app, 
						"Found a '%s' while looking for", 
						this.lex.front
					);
					throw new ParseException(app.data,
						__FILE__, __LINE__,
						subRules,
						["rparen"]
					);

				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["lparen"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["caseKeyword"]
		);

	}

	bool firstCases() const pure @nogc @safe {
		return this.lex.front.type == TokenType.intValue;
	}

	Cases parseCases() {
		try {
			return this.parseCasesImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Cases an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Cases parseCasesImpl() {
		string[] subRules;
		subRules = ["Many", "One"];
		if(this.lex.front.type == TokenType.intValue) {
			Token val = this.lex.front;
			this.lex.popFront();
			subRules = ["Many", "One"];
			if(this.lex.front.type == TokenType.colon) {
				this.lex.popFront();
				subRules = ["Many", "One"];
				if(this.firstBlock()) {
					Block b = this.parseBlock();
					subRules = ["Many"];
					if(this.firstCases()) {
						Cases follow = this.parseCases();

						return new Cases(CasesEnum.Many
							, val
							, b
							, follow
						);
					}
					return new Cases(CasesEnum.One
						, val
						, b
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["caseKeyword -> Switch","define","forKeyword -> For","identifier -> Assign","ifKeyword -> If","intValue -> Assign","lparen -> Assign","minus -> Assign","returnKeyword"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["colon"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["intValue"]
		);

	}

	bool firstAssign() const pure @nogc @safe {
		return this.firstExpr();
	}

	Assign parseAssign() {
		try {
			return this.parseAssignImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Assign an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Assign parseAssignImpl() {
		string[] subRules;
		subRules = ["As", "Ter"];
		if(this.firstExpr()) {
			Expr left = this.parseExpr();
			subRules = ["As", "Ter"];
			if(this.lex.front.type == TokenType.assign) {
				this.lex.popFront();
				subRules = ["As", "Ter"];
				if(this.firstExpr()) {
					Expr right = this.parseExpr();
					subRules = ["Ter"];
					if(this.lex.front.type == TokenType.question) {
						this.lex.popFront();
						subRules = ["Ter"];
						if(this.firstExpr()) {
							Expr t = this.parseExpr();
							subRules = ["Ter"];
							if(this.lex.front.type == TokenType.colon) {
								this.lex.popFront();
								subRules = ["Ter"];
								if(this.firstExpr()) {
									Expr f = this.parseExpr();

									return new Assign(AssignEnum.Ter
										, left
										, right
										, t
										, f
									);
								}
								auto app = appender!string();
								formattedWrite(app, 
									"Found a '%s' while looking for", 
									this.lex.front
								);
								throw new ParseException(app.data,
									__FILE__, __LINE__,
									subRules,
									["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
								);

							}
							auto app = appender!string();
							formattedWrite(app, 
								"Found a '%s' while looking for", 
								this.lex.front
							);
							throw new ParseException(app.data,
								__FILE__, __LINE__,
								subRules,
								["colon"]
							);

						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
						);

					}
					return new Assign(AssignEnum.As
						, left
						, right
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["assign"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
		);

	}

	bool firstExpr() const pure @nogc @safe {
		return this.firstRelExpr();
	}

	Expr parseExpr() {
		try {
			return this.parseExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Expr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Expr parseExprImpl() {
		string[] subRules;
		subRules = ["E"];
		if(this.firstRelExpr()) {
			RelExpr post = this.parseRelExpr();

			return new Expr(ExprEnum.E
				, post
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> CmpExpr","intValue -> CmpExpr","lparen -> CmpExpr","minus -> CmpExpr"]
		);

	}

	bool firstRelExpr() const pure @nogc @safe {
		return this.firstCmpExpr();
	}

	RelExpr parseRelExpr() {
		try {
			return this.parseRelExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a RelExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	RelExpr parseRelExprImpl() {
		string[] subRules;
		subRules = ["EE", "G", "GE", "L", "LE"];
		if(this.firstCmpExpr()) {
			CmpExpr ce = this.parseCmpExpr();
			subRules = ["L"];
			if(this.lex.front.type == TokenType.less) {
				this.lex.popFront();
				subRules = ["L"];
				if(this.firstRelExpr()) {
					RelExpr follow = this.parseRelExpr();

					return new RelExpr(RelExprEnum.L
						, ce
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> CmpExpr","intValue -> CmpExpr","lparen -> CmpExpr","minus -> CmpExpr"]
				);

			} else if(this.lex.front.type == TokenType.greater) {
				this.lex.popFront();
				subRules = ["G"];
				if(this.firstRelExpr()) {
					RelExpr follow = this.parseRelExpr();

					return new RelExpr(RelExprEnum.G
						, ce
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> CmpExpr","intValue -> CmpExpr","lparen -> CmpExpr","minus -> CmpExpr"]
				);

			} else if(this.lex.front.type == TokenType.lessequal) {
				this.lex.popFront();
				subRules = ["LE"];
				if(this.firstRelExpr()) {
					RelExpr follow = this.parseRelExpr();

					return new RelExpr(RelExprEnum.LE
						, ce
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> CmpExpr","intValue -> CmpExpr","lparen -> CmpExpr","minus -> CmpExpr"]
				);

			} else if(this.lex.front.type == TokenType.greaterequal) {
				this.lex.popFront();
				subRules = ["GE"];
				if(this.firstRelExpr()) {
					RelExpr follow = this.parseRelExpr();

					return new RelExpr(RelExprEnum.GE
						, ce
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> CmpExpr","intValue -> CmpExpr","lparen -> CmpExpr","minus -> CmpExpr"]
				);

			}
			return new RelExpr(RelExprEnum.EE
				, ce
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> MulExpr","intValue -> MulExpr","lparen -> MulExpr","minus -> MulExpr"]
		);

	}

	bool firstCmpExpr() const pure @nogc @safe {
		return this.firstMulExpr();
	}

	CmpExpr parseCmpExpr() {
		try {
			return this.parseCmpExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a CmpExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	CmpExpr parseCmpExprImpl() {
		string[] subRules;
		subRules = ["EQ", "Mul", "NEQ"];
		if(this.firstMulExpr()) {
			MulExpr me = this.parseMulExpr();
			subRules = ["EQ", "NEQ"];
			if(this.lex.front.type == TokenType.equal) {
				this.lex.popFront();
				subRules = ["EQ", "NEQ"];
				if(this.firstCmpExpr()) {
					CmpExpr follow = this.parseCmpExpr();

					return new CmpExpr(CmpExprEnum.NEQ
						, me
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> MulExpr","intValue -> MulExpr","lparen -> MulExpr","minus -> MulExpr"]
				);

			}
			return new CmpExpr(CmpExprEnum.Mul
				, me
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> AddExpr","intValue -> AddExpr","lparen -> AddExpr","minus -> AddExpr"]
		);

	}

	bool firstMulExpr() const pure @nogc @safe {
		return this.firstAddExpr();
	}

	MulExpr parseMulExpr() {
		try {
			return this.parseMulExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a MulExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	MulExpr parseMulExprImpl() {
		string[] subRules;
		subRules = ["Add", "Div", "Mod", "Star"];
		if(this.firstAddExpr()) {
			AddExpr add = this.parseAddExpr();
			subRules = ["Star"];
			if(this.lex.front.type == TokenType.star) {
				this.lex.popFront();
				subRules = ["Star"];
				if(this.firstMulExpr()) {
					MulExpr follow = this.parseMulExpr();

					return new MulExpr(MulExprEnum.Star
						, add
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> AddExpr","intValue -> AddExpr","lparen -> AddExpr","minus -> AddExpr"]
				);

			} else if(this.lex.front.type == TokenType.div) {
				this.lex.popFront();
				subRules = ["Div"];
				if(this.firstMulExpr()) {
					MulExpr follow = this.parseMulExpr();

					return new MulExpr(MulExprEnum.Div
						, add
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> AddExpr","intValue -> AddExpr","lparen -> AddExpr","minus -> AddExpr"]
				);

			} else if(this.lex.front.type == TokenType.mod) {
				this.lex.popFront();
				subRules = ["Mod"];
				if(this.firstMulExpr()) {
					MulExpr follow = this.parseMulExpr();

					return new MulExpr(MulExprEnum.Mod
						, add
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> AddExpr","intValue -> AddExpr","lparen -> AddExpr","minus -> AddExpr"]
				);

			}
			return new MulExpr(MulExprEnum.Add
				, add
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> UnaryExpr","intValue -> UnaryExpr","lparen -> UnaryExpr","minus -> UnaryExpr"]
		);

	}

	bool firstAddExpr() const pure @nogc @safe {
		return this.firstUnaryExpr();
	}

	AddExpr parseAddExpr() {
		try {
			return this.parseAddExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a AddExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	AddExpr parseAddExprImpl() {
		string[] subRules;
		subRules = ["Minus", "Plus", "Post"];
		if(this.firstUnaryExpr()) {
			UnaryExpr post = this.parseUnaryExpr();
			subRules = ["Plus"];
			if(this.lex.front.type == TokenType.plus) {
				this.lex.popFront();
				subRules = ["Plus"];
				if(this.firstAddExpr()) {
					AddExpr follow = this.parseAddExpr();

					return new AddExpr(AddExprEnum.Plus
						, post
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> UnaryExpr","intValue -> UnaryExpr","lparen -> UnaryExpr","minus -> UnaryExpr"]
				);

			} else if(this.lex.front.type == TokenType.minus) {
				this.lex.popFront();
				subRules = ["Minus"];
				if(this.firstAddExpr()) {
					AddExpr follow = this.parseAddExpr();

					return new AddExpr(AddExprEnum.Minus
						, post
						, follow
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> UnaryExpr","intValue -> UnaryExpr","lparen -> UnaryExpr","minus -> UnaryExpr"]
				);

			}
			return new AddExpr(AddExprEnum.Post
				, post
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> PostfixExpr","intValue -> PostfixExpr","lparen -> PostfixExpr","minus"]
		);

	}

	bool firstUnaryExpr() const pure @nogc @safe {
		return this.lex.front.type == TokenType.minus
			 || this.firstPostfixExpr();
	}

	UnaryExpr parseUnaryExpr() {
		try {
			return this.parseUnaryExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a UnaryExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	UnaryExpr parseUnaryExprImpl() {
		string[] subRules;
		subRules = ["M"];
		if(this.lex.front.type == TokenType.minus) {
			this.lex.popFront();
			subRules = ["M"];
			if(this.firstPostfixExpr()) {
				PostfixExpr post = this.parsePostfixExpr();

				return new UnaryExpr(UnaryExprEnum.M
					, post
				);
			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier -> Identifier","intValue -> PrimaryExpr","lparen -> PrimaryExpr"]
			);

		} else if(this.firstPostfixExpr()) {
			PostfixExpr post = this.parsePostfixExpr();

			return new UnaryExpr(UnaryExprEnum.P
				, post
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["minus","identifier -> Identifier","intValue -> PrimaryExpr","lparen -> PrimaryExpr"]
		);

	}

	bool firstPostfixExpr() const pure @nogc @safe {
		return this.firstIdentifier()
			 || this.firstPrimaryExpr();
	}

	PostfixExpr parsePostfixExpr() {
		try {
			return this.parsePostfixExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a PostfixExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	PostfixExpr parsePostfixExprImpl() {
		string[] subRules;
		subRules = ["Array", "Ident"];
		if(this.firstIdentifier()) {
			Identifier ident = this.parseIdentifier();
			subRules = ["Array"];
			if(this.firstPostfixFollow()) {
				PostfixFollow follow = this.parsePostfixFollow();

				return new PostfixExpr(PostfixExprEnum.Array
					, ident
					, follow
				);
			}
			return new PostfixExpr(PostfixExprEnum.Ident
				, ident
			);
		} else if(this.firstPrimaryExpr()) {
			PrimaryExpr prim = this.parsePrimaryExpr();

			return new PostfixExpr(PostfixExprEnum.Primary
				, prim
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier","intValue","lparen"]
		);

	}

	bool firstPostfixFollow() const pure @nogc @safe {
		return this.lex.front.type == TokenType.dot
			 || this.firstArray()
			 || this.firstCall();
	}

	PostfixFollow parsePostfixFollow() {
		try {
			return this.parsePostfixFollowImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a PostfixFollow an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	PostfixFollow parsePostfixFollowImpl() {
		string[] subRules;
		subRules = ["Dot"];
		if(this.lex.front.type == TokenType.dot) {
			this.lex.popFront();
			subRules = ["Dot"];
			if(this.firstPostfixExpr()) {
				PostfixExpr follow = this.parsePostfixExpr();

				return new PostfixFollow(PostfixFollowEnum.Dot
					, follow
				);
			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier -> Identifier","intValue -> PrimaryExpr","lparen -> PrimaryExpr"]
			);

		} else if(this.firstArray()) {
			Array array = this.parseArray();
			subRules = ["ArrayDot"];
			if(this.lex.front.type == TokenType.dot) {
				this.lex.popFront();
				subRules = ["ArrayDot"];
				if(this.firstPostfixExpr()) {
					PostfixExpr postfix = this.parsePostfixExpr();

					return new PostfixFollow(PostfixFollowEnum.ArrayDot
						, array
						, postfix
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> Identifier","intValue -> PrimaryExpr","lparen -> PrimaryExpr"]
				);

			}
			return new PostfixFollow(PostfixFollowEnum.Array
				, array
			);
		} else if(this.firstCall()) {
			Call call = this.parseCall();
			subRules = ["CallFollow"];
			if(this.firstPostfixFollow()) {
				PostfixFollow pffollow = this.parsePostfixFollow();

				return new PostfixFollow(PostfixFollowEnum.CallFollow
					, call
					, pffollow
				);
			}
			return new PostfixFollow(PostfixFollowEnum.Call
				, call
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["dot","lbrack","lparen"]
		);

	}

	bool firstArray() const pure @nogc @safe {
		return this.lex.front.type == TokenType.lbrack;
	}

	Array parseArray() {
		try {
			return this.parseArrayImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Array an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Array parseArrayImpl() {
		string[] subRules;
		subRules = ["Empty", "Index", "Slice"];
		if(this.lex.front.type == TokenType.lbrack) {
			this.lex.popFront();
			subRules = ["Empty"];
			if(this.lex.front.type == TokenType.rbrack) {
				this.lex.popFront();

				return new Array(ArrayEnum.Empty
				);
			} else if(this.firstExpr()) {
				Expr expr = this.parseExpr();
				subRules = ["Index"];
				if(this.lex.front.type == TokenType.rbrack) {
					this.lex.popFront();

					return new Array(ArrayEnum.Index
						, expr
					);
				} else if(this.lex.front.type == TokenType.colon) {
					this.lex.popFront();
					subRules = ["Slice"];
					if(this.firstExpr()) {
						Expr expr2 = this.parseExpr();
						subRules = ["Slice"];
						if(this.lex.front.type == TokenType.rbrack) {
							this.lex.popFront();

							return new Array(ArrayEnum.Slice
								, expr
								, expr2
							);
						}
						auto app = appender!string();
						formattedWrite(app, 
							"Found a '%s' while looking for", 
							this.lex.front
						);
						throw new ParseException(app.data,
							__FILE__, __LINE__,
							subRules,
							["rbrack"]
						);

					}
					auto app = appender!string();
					formattedWrite(app, 
						"Found a '%s' while looking for", 
						this.lex.front
					);
					throw new ParseException(app.data,
						__FILE__, __LINE__,
						subRules,
						["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
					);

				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["rbrack","colon"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["rbrack","identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["lbrack"]
		);

	}

	bool firstCall() const pure @nogc @safe {
		return this.lex.front.type == TokenType.lparen;
	}

	Call parseCall() {
		try {
			return this.parseCallImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Call an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Call parseCallImpl() {
		string[] subRules;
		subRules = ["Args", "Empty"];
		if(this.lex.front.type == TokenType.lparen) {
			this.lex.popFront();
			subRules = ["Empty"];
			if(this.lex.front.type == TokenType.rparen) {
				this.lex.popFront();

				return new Call(CallEnum.Empty
				);
			} else if(this.firstArgList()) {
				ArgList args = this.parseArgList();
				subRules = ["Args"];
				if(this.lex.front.type == TokenType.rparen) {
					this.lex.popFront();

					return new Call(CallEnum.Args
						, args
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["rparen"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["rparen","identifier -> Expr","intValue -> Expr","lparen -> Expr","minus -> Expr"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["lparen"]
		);

	}

	bool firstArgList() const pure @nogc @safe {
		return this.firstExpr();
	}

	ArgList parseArgList() {
		try {
			return this.parseArgListImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a ArgList an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	ArgList parseArgListImpl() {
		string[] subRules;
		subRules = ["Arg", "Args"];
		if(this.firstExpr()) {
			Expr arg = this.parseExpr();
			subRules = ["Args"];
			if(this.lex.front.type == TokenType.comma) {
				this.lex.popFront();
				subRules = ["Args"];
				if(this.firstArgList()) {
					ArgList next = this.parseArgList();

					return new ArgList(ArgListEnum.Args
						, arg
						, next
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["identifier -> Expr","intValue -> Expr","lparen -> Expr","minus -> Expr"]
				);

			}
			return new ArgList(ArgListEnum.Arg
				, arg
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
		);

	}

	bool firstPrimaryExpr() const pure @nogc @safe {
		return this.lex.front.type == TokenType.intValue
			 || this.lex.front.type == TokenType.lparen;
	}

	PrimaryExpr parsePrimaryExpr() {
		try {
			return this.parsePrimaryExprImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a PrimaryExpr an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	PrimaryExpr parsePrimaryExprImpl() {
		string[] subRules;
		subRules = ["Integer"];
		if(this.lex.front.type == TokenType.intValue) {
			Token value = this.lex.front;
			this.lex.popFront();

			return new PrimaryExpr(PrimaryExprEnum.Integer
				, value
			);
		} else if(this.lex.front.type == TokenType.lparen) {
			this.lex.popFront();
			subRules = ["Parenthesis"];
			if(this.firstExpr()) {
				Expr expr = this.parseExpr();
				subRules = ["Parenthesis"];
				if(this.lex.front.type == TokenType.rparen) {
					this.lex.popFront();

					return new PrimaryExpr(PrimaryExprEnum.Parenthesis
						, expr
					);
				}
				auto app = appender!string();
				formattedWrite(app, 
					"Found a '%s' while looking for", 
					this.lex.front
				);
				throw new ParseException(app.data,
					__FILE__, __LINE__,
					subRules,
					["rparen"]
				);

			}
			auto app = appender!string();
			formattedWrite(app, 
				"Found a '%s' while looking for", 
				this.lex.front
			);
			throw new ParseException(app.data,
				__FILE__, __LINE__,
				subRules,
				["identifier -> RelExpr","intValue -> RelExpr","lparen -> RelExpr","minus -> RelExpr"]
			);

		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["intValue","lparen"]
		);

	}

	bool firstIdentifier() const pure @nogc @safe {
		return this.lex.front.type == TokenType.identifier;
	}

	Identifier parseIdentifier() {
		try {
			return this.parseIdentifierImpl();
		} catch(ParseException e) {
			throw new ParseException(
				"While parsing a Identifier an Exception was thrown.",
				e, __FILE__, __LINE__
			);
		}
	}

	Identifier parseIdentifierImpl() {
		string[] subRules;
		subRules = ["Ident"];
		if(this.lex.front.type == TokenType.identifier) {
			Token value = this.lex.front;
			this.lex.popFront();

			return new Identifier(IdentifierEnum.Ident
				, value
			);
		}
		auto app = appender!string();
		formattedWrite(app, 
			"Found a '%s' while looking for", 
			this.lex.front
		);
		throw new ParseException(app.data,
			__FILE__, __LINE__,
			subRules,
			["identifier"]
		);

	}

}
