#!/bin/env -S dmd -run

module noby;

// [Noby Script]

void main() {
    log(Level.info, "Hello noby!");
    version (Windows) cmd("cmd.exe", "/c", "dir");
    else cmd("ls");
}

// [Noby Library]

Level minLogLevel = Level.none;

alias Sz      = size_t;         /// The result of sizeof, ...
alias Str     = char[];         /// A string slice of chars.
alias IStr    = const(char)[];  /// A string slice of constant chars.

enum Level : ubyte {
    none,
    info,
    warning,
    error,
}

void log(Level level, IStr text) {
    import std.stdio;
    if (level < minLogLevel) return;
    with (Level) final switch (level) {
        case none:    break;
        case info:    writeln("[INFO] ", text); break;
        case warning: writeln("[WARNING] ", text); break;
        case error:   writeln("[ERROR] ", text); break;
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
    return spawnProcess(args).wait();
}

void touch(IStr path) {
    import std.file;
    write(path, "");
}

void paste(IStr path, IStr content) {
    import std.file;
    write(path, content);
}

void cp(IStr source, IStr target) {
    import std.file;
    copy(source, target);
}

void rm(IStr path) {
    import std.file;
    remove(path);
}

void mkdir(IStr path) {
    import std.file;
    mkdirRecurse(path);
}

void rmdir(IStr path) {
    import std.file;
    rmdirRecurse(path);
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
