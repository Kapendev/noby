import std.file;

void main() {
    version (Windows) auto target = getcwd() ~ "\\noby.d";
    else auto target = getcwd() ~ "/noby.d";
    if (!target.exists) write(target, import("noby.d"));
}
