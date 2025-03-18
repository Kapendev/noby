#!/bin/env -S dmd -run

module noby;

// [Noby Script]

void main() {
    log(Level.info, "Hello noby!");
    version (Windows) cmd("cmd.exe", "/c", "dir");
    else cmd("ls");
}

// [Noby Library]

enum cloneExt = "._cl";

Level minLogLevel = Level.info;

alias Sz      = size_t;         /// The result of sizeof, ...
alias Str     = char[];         /// A string slice of chars.
alias IStr    = const(char)[];  /// A string slice of constant chars.

enum Level : ubyte {
    none,
    info,
    warning,
    error,
}

bool isX(IStr path) {
    import std.file;
    return path.exists;
}

bool isF(IStr path) {
    import std.file;
    return path.exists;
}

bool isD(IStr path) {
    import std.file;
    return path.isDir;
}

void echo(A...)(A args) {
    import std.stdio;
    writeln(args);
}

void cp(IStr source, IStr target) {
    import std.file;
    copy(source, target);
}

void rm(IStr path) {
    import std.file;
    if (path.isX) remove(path);
}

void mkdir(IStr path, bool isRecursive = false) {
    import std.file;
    if (!path.isX) {
        if (isRecursive) mkdirRecurse(path);
        else std.file.mkdir(path);
    }
}

void rmdir(IStr path, bool isRecursive = false) {
    import std.file;
    if (!path.isX) {
        if (isRecursive) rmdirRecurse(path);
        else std.file.rmdir(path);
    }
}

IStr cat(IStr path) {
    import std.file;
    return path.isX ? readText(path) : "";
}

IStr[] ls(IStr path = ".", bool isRecursive = false) {
    import std.file;
    IStr[] result;
    foreach (dir; dirEntries(cast(string) path, isRecursive ? SpanMode.breadth : SpanMode.shallow)) {
        result ~= dir.name;
    }
    return result;
}

IStr basename(IStr path) {
    import std.path;
    return baseName(path);
}

IStr realpath(IStr path) {
    import std.path;
    return absolutePath(cast(string) path);
}

IStr read() {
    import std.stdio;
    import std.string;
    return readln().strip();
}

IStr join(IStr[] args...) {
    import std.path;
    return buildPath(args);
}

bool isYes(IStr arg) {
    return (arg.length == 1 && (arg[0] == 'Y' || arg[0] == 'y'));
}

bool isNo(IStr arg) {
    return (arg.length == 1 && (arg[0] == 'N' || arg[0] == 'n'));
}

bool isYesOrNo(IStr arg) {
    return arg.isYes || arg.isNo;
}

bool startsWith(IStr str, IStr start) {
    if (str.length < start.length) return false;
    return str[0 .. start.length] == start;
}

bool endsWith(IStr str, IStr end) {
    if (str.length < end.length) return false;
    return str[$ - end.length .. $] == end;
}

void paste(IStr path, IStr content) {
    import std.file;
    write(path, content);
}

void pasteIfNew(IStr path, IStr content) {
    if (!path.isX) paste(path, content);
}

void clone(IStr path) {
    if (path.isX) paste(path ~ cloneExt, cat(path));
}

void restore(IStr path) {
    auto clonePath = path ~ cloneExt;
    if (clonePath.isX) {
        paste(path, cat(clonePath));
        rm(clonePath);
    }
}

void log(Level level, IStr text) {
    if (minLogLevel == 0 || minLogLevel > level) return;
    with (Level) final switch (level) {
        case info:    echo("[INFO] ", text); break;
        case warning: echo("[WARNING] ", text); break;
        case error:   echo("[ERROR] ", text); break;
        case none:    break;
    }
}

void logf(A...)(Level level, IStr text, A args) {
    import std.format;
    log(level, text.format(args));
}

int cmd(IStr[] args...) {
    import std.stdio;
    import std.process;
    writeln("[CMD] ", args);
    try {
        return spawnProcess(args).wait();
    } catch (Exception e) {
        return 1;
    }
}
