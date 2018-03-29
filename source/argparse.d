import std.string;
import std.container : Array;
import std.stdio;
import std.regex;
import core.exception : AssertError;


struct Arg {
private:
    bool isOption;
    bool hasDesc;
    bool existValue;
    bool hasDefault;
    string help;
    string[] shortname;
    string[] longname;
    string desc;
public:
    this(string shortname, string longname, string help, bool isOption, bool hasDesc, bool hasDefault, string desc) {
        this.shortname = split(shortname, regex("\\s+"));
        this.longname = split(longname, regex("\\s+"));
        this.help = help;
        this.desc = desc;
        this.isOption = isOption;
        this.hasDesc = hasDesc;
        this.hasDefault = hasDefault;
        this.existValue = false;
    }

    bool cmpName(string name) {
        foreach (ref sname; shortname) {
            if (sname == name) {
                return true;
            }
        }
        foreach (ref lname; longname) {
            if (lname == name) {
                return true;
            }
        }
        return false;
    }

    void setDesc(string value) { this.desc = value; }

    void setIsOption(bool option) { this.isOption = option; }
    bool getIsOption() { return isOption; }

    void setHasDesc(bool option) { this.hasDesc = option; }
    bool getHasDesc() { return hasDesc; }

    void setExistValue(bool option) { this.existValue = option; }
    bool getExistValue() { return existValue; }

    void setHasDefault(bool option) { this.hasDefault = option; }
    bool getHasDefault() { return hasDefault; }

    bool isSet() { return hasDefault || existValue; }

    void writeOpt() {
        write(shortname.join(", "));
        write("\t\t");
        writeln(longname.join(", "));
    }

    void writeHelp () {
        write('\t');
        writeln(help);
    }
}


class ArgParse {
private:
    Arg help_arg;
    Array!Arg args;
    Array!string nams;
    string desc;
    // Array!constrain cons;
public:
    void parse_args(string[] str) {
        // pass the first 
        outer: for (auto i = 1; i < str.length; i++) {
            foreach (elem; args) {
                if (elem.cmpName(str[i])) {
                    elem.setExistValue(true);
                    if (elem.getHasDesc()) {
                        elem.setDesc(str[i+1]);
                        i++;
                    }
                    continue outer;
                }
            } // end foreach
            
        }
        // checking all necess;
            foreach (elem; args) {
                assert(elem.getIsOption() || elem.isSet());
            }
        if (args[0].isSet()) {
            usage();
        }
    }

    auto add_argument(string shortname, string longname, string help="",  bool isOption=true, bool hasDesc=false, bool hasDefault=false, string desc="") {
        auto argue = Arg(shortname, longname, help, isOption, hasDesc, hasDefault, desc);
        args.insertBack(argue);
        return argue;
    }

    this() {
        auto argue = Arg("-h", "--help", "output this message", true, false, false, "");
        args.insertBack(argue);
    }

    void setDesc(string desc) {
        this.desc = desc;
    }

    void usage() {
        writeln(desc);
        writeln("optional:");
        foreach (elem; args) {
            if (elem.getIsOption()) {
                elem.writeOpt();
                // output default value; 
                elem.writeHelp();
            }
        }
        writeln("must have:");
        foreach (elem; args) {
            if (! elem.getIsOption()) {
                elem.writeOpt();
                elem.writeHelp();
            }
        }
    }
}
