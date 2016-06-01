libbasm
=======

A standard library for x64 assembly language programming.

This is really just for my own goofing around / learning, it shouldn't be used
for real stuff. Calling out to C libraries is probably the "right thing" and if
not that, I'm sure there are much better libraries out there written in
assembly.

Usage
=====

This is meant for small executable size, so the idea is to build the library
including only the functions needed for a project and statically link to that.
The `build.py` script is included to help with this.

Build with just `str_len` and `str_cpy` support:

```bash
./build.py str_len str_cpy
```

Build with all functions available:

```bash
./build.py
```

In both cases, the final library will be located at `bin/libbasm.a`.
