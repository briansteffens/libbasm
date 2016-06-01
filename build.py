#!/usr/bin/env python3

import os
import sys
import json

os.chdir(os.path.dirname(os.path.realpath(__file__)))

with open("structure.json") as f:
    files = json.loads(f.read())["files"]

def get_file_by_function(function_name):
    for fi in files:
        if function_name in fi["functions"]:
            return fi

    raise Exception("Function {} not found".format(function_name))

included_files = []

# Include a file in the build, including any dependencies (recursive)
def include_file(file_info):
    if file_info["name"] in included_files:
        return

    if "dependencies" in file_info:
        for dependency in file_info["dependencies"]:
            include_file(get_file_by_function(dependency))

    included_files.append(file_info["name"])

# Include all functions if no command-line arguments were provided
if len(sys.argv) == 1:
    included_files = [f["name"] for f in files]

# Otherwise include only functions passed on the command-line
else:
    for function in sys.argv[1:]:
        include_file(get_file_by_function(function))

# Assemble included files
for included_file in included_files:
    command = "nasm -f elf64 -isrc/ src/{}.asm -o obj/{}.o" \
              .format(included_file, included_file)

    print(command)

    if os.system(command) != 0:
        print("Error assembling source file")
        sys.exit(1)

# Delete archive if exists
try:
    os.remove("bin/libbasm.a")
except:
    pass

# Archive assembled files
obj_files = " ".join(["obj/{}.o".format(f) for f in included_files])
command = "ar rcs bin/libbasm.a {}".format(obj_files)

print(command)

if os.system(command) != 0:
    print("Error archiving object files")
    sys.exit(1)
