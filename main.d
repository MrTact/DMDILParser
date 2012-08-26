
import std.array;
import std.conv;
import std.regex;
import std.stdio;
import std.string;

void main() 
{
	auto p = new Parser();
	p.Parse("Interop.InDesign.il");
}


class Parser
{
	alias bool delegate(string) state_func_t;
	protected state_func_t mState;

	protected string mClass;
	protected string mMethod;
	protected string mReturnType;

	protected auto mClassRx = regex(`^\s*\.class.* ([\w\.]+)\s*$`d);
	protected auto mMethodRx = regex(`^\s*\.method`d);
	protected auto mMethodNameRx = regex(`^\s*Duplicate`d);
	protected auto mReturnTypeRx = regex(`^\s*instance class ([\w\.]+)`d);
	protected auto mEndBraceRx = regex(`\}`d);


	dchar[][] mOutBuf;
	protected File mOutFile;

	this()
	{

	}

	void Parse(string path)
	{
		writeln("Starting parsing");
		//mState = &NullState;
		auto f = File(path, "r");
		mOutFile = File(path ~ ".out", "w");

		dchar[] buf;
		auto n = 10;
		while (f.readln(buf))
		{
			mOutBuf ~= buf;

			writeln(buf);
			writeln(mOutBuf);
			writeln("=".replicate(80));
			--n;
			if (!n)
			{
				return;
			}

			//if (!mState(to!string(buf)))
			//{
			//	break;
			//}
		}
	}

/+
	void DumpBuffer()
	{
		foreach (line; mOutBuf)
		{
			writeln(line);
			//mOutFile.write(line);
		}

		mOutBuf = [];
	}

	bool NullState(string input)
	{
		auto m = match(input, mClassRx);
		if (!m.empty)
		{
			mClass = m.captures[1];
			mState = &ClassState;
		}
		
		return true;
	}

	bool ClassState(string input)
	{
		auto m = match(input, mMethodRx);
		if (!m.empty)
		{
			mState = &MethodState;
			mReturnType = "";
		}

		m = match(input, mEndBraceRx);
		if (!m.empty)
		{
			//DumpBuffer();
			mState = &NullState;
		}

		return true;
	}

	bool MethodState(string input)
	{
		auto m = match(input, mReturnTypeRx);
		//if (mClass == "InDesign.MixedInk")
		//{
		//	writefln("%s: method match: %s", input, m);
		//}
		
		if (!m.empty)
		{
			mReturnType = m.captures[1];
			return true;
		}

		m = match(input, mMethodNameRx);
		if (!m.empty)
		{
			if (mClass != mReturnType)
			{
				//writeln("=".replicate(80));
				//writeln(mOutBuf);
				//ReplaceReturnType();
				//writefln("%s::Duplicate returns %s", mClass, mReturnType);
			}
			return true;
		}
		
		m = match(input, mEndBraceRx);
		if (!m.empty)
		{
			// Dump buffer to outfile
			mOutBuf = [];
			mState = &ClassState;
		}

		return true;
	}

	void ReplaceReturnType()
	{
		//writeln("=".replicate(80));
		//writeln("Replacing return type, buffer length=", mOutBuf.length);
		auto rx = regex(`[\w\.]+\s*$`);
		foreach (n, line; mOutBuf)
		{
			writeln(n, line);
			auto m = match(line, mReturnTypeRx);
			if (!m.empty)
			{
				//writeln(mOutBuf[n]);
				//mOutBuf[n] = replace(line, rx, mClass.dup);
				//writeln(mOutBuf[n]);
				writeln("*** MATCH");
				break;
			}
		}
	}
+/


}