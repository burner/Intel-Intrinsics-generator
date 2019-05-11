import lexer;
import parser;

unittest {
	string s = `
DEFINE ReduceArgumentPD(src1[63:0], imm8[7:0])
{
	m := imm8[7:4] // number of fraction bits after the binary point to be preserved
	rc := imm8[1:0] // round control
	rc_src := imm8[2] // round ccontrol source
	spe := 0
	tmp[63:0] := pow(2, -m) * ROUND(pow(2, m) * src1[63:0], spe, rc_source, rc)
	tmp[63:0] := src1[63:0] - tmp[63:0]
	RETURN tmp[63:0]
}

IF k[0]
	dst[63:0] := ReduceArgumentPD(a[63:0], imm8[7:0])
ELSE
	dst[63:0] := 0
FI
dst[127:64] := b[127:64]
dst[MAX:128] := 0
	`;

	auto l = Lexer(s);
	auto p = Parser(l);
	auto d = p.parseStart();
}

unittest {
	string s = `
tmp_dst[63:0] := (imm8[0] == 0) ? a[63:0] : a[127:64]
tmp_dst[127:64] := (imm8[1] == 0) ? b[63:0] : b[127:64]

FOR j := 0 to 1
	i := j*64
	IF k[j]
		dst[i+63:i] := tmp_dst[i+63:i]
	ELSE
		dst[i+63:i] := 0
	FI
ENDFOR
dst[MAX:128] := 0
	`;

	auto l = Lexer(s);
	auto p = Parser(l);
	auto d = p.parseStart();
}

unittest {
	string s = `
FOR j := 0 to 7
	i := j*8
	dst[i+7:i] := a[i+7:i] + b[i+7:i]
ENDFOR
	`;

	auto l = Lexer(s);
	auto p = Parser(l);
	auto d = p.parseStart();
}

