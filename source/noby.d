module noby;

// [Noby Script]

void main() {
    log(Level.info, "Hello noby!");
    version (Windows) {
        cmd("cmd.exe", "/c", "dir");
    } else {
        cmd("ls");
    }
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

bool cmd(IStr[] args...) {
    import std.stdio;
    import std.process;

    writeln("[CMD] ", args);
    return spawnProcess(args).wait() != 0;
}
