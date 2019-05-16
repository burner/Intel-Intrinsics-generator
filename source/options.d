module options;

struct Options {
	string inputXML = "data-3.4.4.xml";
	string outputPath = "";

	// selected sets is the union of selected instruction sets and selected names
	string[] selectedTech = [];
	string[] selectedNames = [];
	bool generateBodies = false;
}
