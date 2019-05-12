import std.stdio;
import std.conv : to;
import std.file : readText;
import std.format : format;
import std.experimental.logger;

import html;

import output;

void usage()
{
    writeln;
    writeln("Usage: intrinsicripper [-i data-X.Y.Z.xml] [-o output.d] [-t MMX] [-h] [-b]");
    writeln();
    writeln("Params:");
    writeln("  -i          Specify an input intrinsics XML file (default: \"data-3.4.4.xml\")");
    writeln("  -o          Specify an output D file (default: stdout)");
    writeln("  -n, --name  Specify a particular intrinsic name (default: unused)");
    writeln("  -t, --tech  Specify a tech selector (default: none)");
    writeln("              Available techs: ALL MMX SSE SSE2 SSE3 SSSE3 SSE4.1 SSE4.2...");
    writeln("  -h, --help  Display this help");
    writeln("  -b, --body  generate D bodies converted from Intel pseudo-code (default: no).");
    writeln;
}

int main(string[] args) 
{
    try
    {
        string inputXML = "data-3.4.4.xml";
        string outputPath = null;

        // selected sets is the union of selected instruction sets and selected names
        string[] selectedTech = [];
        string[] selectedNames = [];
        bool help = false;
        bool generateBodies = false;

        for(int i = 1; i < args.length; ++i)
        {
            string arg = args[i];
            if (arg == "-i")
            {
                ++i;
                inputXML = args[i];
            }
            else if (arg == "-o")
            {
                ++i;
                outputPath = args[i];
            }    
            else if (arg == "-t" || arg == "--tech")
            {
                ++i;
                selectedTech ~= args[i];
            }
            else if (arg == "-n" || arg == "--name")
            {
                ++i;
                selectedNames ~= args[i];
            } 
            else if (arg == "-h" || arg == "--help")
            {
                help = true;
            }
            else if (arg == "-b" || arg == "--body")
            {
                generateBodies = true;
            }
            else
                throw new Exception("Unknown ");
        }

        if (help)
        {
            usage();
            return 0;
        }

        if (selectedTech.length == 0 && selectedNames.length == 0)
        {
            writeln("error: use --tech or --name to select intrinsics to generate");
            usage();
            return 1;
        }

        bool isSelectedIntrinsic(string name, string tech)
        {
            foreach(n; selectedNames)
            {
                if (n == name)
                    return true;
            }
            foreach(sel; selectedTech)
            {
                if (sel == "ALL" || sel == tech)
                    return true;
            }
            return false;
        }

        Func[] funcs;

        auto output = outputPath ? File(outputPath, "w") : stdout;
        auto ltw = output.lockingTextWriter();

        auto doc = createDocument(readText("data-3.4.4.xml"));

        int numIntrinsics = 0;

        foreach(it; doc.querySelectorAll("intrinsic")) {
            Func cur;
            cur.name = to!string(it.attr("name"));
            cur.tech = to!string(it.attr("tech"));

            // parse description
            if (auto descNode = doc.querySelector("description", it))
            {
                cur.desc = to!string(descNode.html());
            }

            // Should this intrinsic be accounted for?
            if (!isSelectedIntrinsic(cur.name, cur.tech))
                continue;

            cur.ret = Param("", to!string(it.attr("rettype")));
            auto t = doc.querySelector("operation", it);
            if(t !is null && generateBodies)
            {
                cur.operation = to!string(t.html());
                foreach(p; doc.querySelectorAll("parameter", it)) {
                    cur.params ~= Param(
                                        to!string(p.attr("varname")),
                                        to!string(p.attr("type"))
                                        );
                }
                printIntrinsicAsDBody(ltw, cur);
            }
            else
            {
                printIntrinsicAsDSignature(ltw, cur);
            }
            funcs ~= cur;
            numIntrinsics++;
        }
        writefln("\n*** Seen %s intrinsics.\n\n", numIntrinsics);
        return 0;
    }
    catch(Exception e)
    {
        import std.stdio;
        writefln("error: %s", e.msg);
        usage();
        return 1;
    }
}
