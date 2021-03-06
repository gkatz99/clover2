VERSION1:="10.4.5"
VERSION2:="10.4.6"

{ "src/interpreter.c",
  "src/compiler.c",
  "src/get_type.c", 
  "debian/control",
  "debian/files",
  "src/jit_main.cpp",
  "README.md",
  "src/main.c" }
.each {
    tmpfile := "\{it}.result";
    cat(it).toString().sub(/\{VERSION1}/g, VERSION2).write(tmpfile)
    mv(tmpfile, it);
}
