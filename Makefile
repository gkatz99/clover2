#######################################################
# installed directories
#######################################################
prefix=/home/ab25cq
exec_prefix=${prefix}
bindir=${exec_prefix}/bin
datadir=${datarootdir}
mandir=${datarootdir}/man
libdir=${exec_prefix}/lib
sharedstatedir=${prefix}/com
sysconfdir=${prefix}/etc/clover2
includedir=${prefix}/include/clover2
datarootdir=${prefix}/share/clover2
docdir=${datarootdir}/doc

##########################################################
# environmnet variables
##########################################################
CC=clang
INSTALL=/usr/bin/install -c
CFLAGS=-Isrc/ -I. -L . -I/home/ab25cq/include -L/home/ab25cq/lib -fPIC -DSYSCONFDIR="\"${sysconfdir}/\"" -DDOCDIR="\"${docdir}/\"" -DDATAROOTDIR="\"${datarootdir}/\"" -I/usr/local/include -L /usr/local/lib -g -DMDEBUG -Werror -Qunused-arguments
LIBS= -lutil -ldl -lm
DESTDIR=
SO_VERSION=1.0.0
LIBSONAME=libclover2.so
LIBSO2NAME=libclover2.so.1.0.0
OS=LINUX
OBJS=src/main.o src/vm.o src/object.o src/array.o src/string.o src/integer.o src/byte.o src/type.o src/stack.o src/heap.o src/exception.o src/native_method.o src/class_system.o src/class_clover.o
COMPILER_OBJS=src/compiler.o src/parser.o src/node_type.o src/node.o src/vtable.o src/script.o src/node_block.o src/node_block_type.o src/class_compiler.o src/klass_compile_time.o src/method_compiler.o src/module.o
LIB_OBJS=src/buffer.o src/debug.o src/xfunc.o src/klass.o src/constant.o src/code.o

##########################################################
# main
##########################################################
all: lib cclover2 clover2
	if test $(OS) = DARWIN; then ctags src/*.c > /dev/null 2>&1; else ctags -R; fi

cclover2: config.h $(COMPILER_OBJS)
	clang -o cclover2 $(COMPILER_OBJS) $(CFLAGS) -lclover2 $(LIBS)

clover2: config.h $(OBJS)
	clang -o clover2 $(OBJS) $(CFLAGS) -lclover2 $(LIBS)

lib: $(LIBSONAME)
#	rm -f install

########################################################
# clover2 libraries
########################################################
libclover2.so.$(SO_VERSION): $(LIB_OBJS)
	clang -shared -o libclover2.so.$(SO_VERSION) $(LIB_OBJS) -lc $(LIBS) $(CFLAGS)

libclover2.so: libclover2.so.$(SO_VERSION)
	ln -s -f libclover2.so.$(SO_VERSION) libclover2.so.1
	ln -s -f libclover2.so.$(SO_VERSION) libclover2.so

########################################################
# clover2 libraries on Darwin
########################################################
libclover2.$(SO_VERSION).dylib: $(OBJ)
	clang -dynamiclib -o libclover2.$(SO_VERSION).dylib $(OBJ) -lc $(LIBS) $(CFLAGS)

libclover2.dylib: libclover2.$(SO_VERSION).dylib
	cp libclover2.$(SO_VERSION).dylib libclover2.1.dylib
	cp libclover2.$(SO_VERSION).dylib libclover2.dylib

#########################################################
# Object files
#########################################################
$(OBJ): src/*.h Makefile configure

#########################################################
# install
#########################################################
install:
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class Fundamental.clc
	mkdir -p ~/.clover2
	$(INSTALL) -m 644 System.clcl ~/.clover2
	$(INSTALL) -m 644 Clover.clcl ~/.clover2
	$(INSTALL) -m 644 String.clcl ~/.clover2
	$(INSTALL) -m 644 Exception.clcl ~/.clover2
	$(INSTALL) -m 644 SystemException.clcl ~/.clover2
	$(INSTALL) -m 644 Object.clcl ~/.clover2
	$(INSTALL) -m 644 Byte.clcl ~/.clover2
	$(INSTALL) -m 644 UByte.clcl ~/.clover2
	$(INSTALL) -m 644 Integer.clcl ~/.clover2
	$(INSTALL) -m 644 UInteger.clcl ~/.clover2
	mkdir -p "$(libdir)"
	$(INSTALL) -m 755 clover2 "$(bindir)"
	$(INSTALL) -m 755 cclover2 "$(bindir)"
	$(INSTALL) -m 755 libclover2.so "$(libdir)"
	$(INSTALL) -m 755 libclover2.so.1 "$(libdir)"
	$(INSTALL) -m 755 libclover2.so.1.0.0 "$(libdir)"

#########################################################
# uninstall
#########################################################
uninstall:
	rm -Rf ~/.clover2
	rm -f "$(bindir)"/clover2
	rm -f "$(bindir)"/cclover2
	rm -f "$(libdir)"/libclover2.so
	rm -f "$(libdir)"/libclover2.so.1
	rm -f "$(libdir)"/libclover2.so.1.0.0

#########################################################
# permission
#########################################################
permission:
	chmod 644 *
	chmod 755 .git man src configure
	chmod 644 src/*.c
	chmod 644 src/*.h
	chmod 755 update_clover.sh

########################################################
# clean
########################################################
clean:
	rm -fR clover2 clover2.dSYM cclover2 cclover2.dSYM src/*.o libclover* config.log config.status *.stackdump autom4te.cache .DS_Store core.* a.out *.clcl *.clo code/*.clo *.clm

distclean: clean
	rm -fR  config.h Makefile autom4te.cache

########################################################
# test
########################################################
test:
	@echo "Compile to test code..."
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/block_var_test.cl && ./clover2 code/block_var_test.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/user_object.clc code/user_object.cl && ./clover2 code/user_object.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/pointer.cl && ./clover2 code/pointer.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/increment.clc && ./cclover2 code/increment.cl && ./clover2 code/increment.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/initialize_test.clc && ./cclover2 code/initialize_test.cl && ./clover2 code/initialize_test.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/stack.clc && ./cclover2 code/stack.cl && ./clover2 code/stack.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/array.cl && ./clover2 code/array.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); export LANG="ja_JP.utf8"; export LC_ALL="ja_JP.utf8"; ./cclover2 code/char.cl && ./clover2 code/char.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/hello_world.cl && ./clover2 code/hello_world.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/cast.cl && ./clover2 code/cast.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/string.cl && ./clover2 code/string.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/try.clc code/try.cl && ./clover2 code/try.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/interface.clc code/interface.cl && ./clover2 code/interface.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/null.cl && ./clover2 code/null.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/special_field.cl && ./clover2 code/special_field.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/self_class.clc code/self_class.cl && ./clover2 code/self_class.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/module.clc code/module.cl && ./clover2 code/module.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 -class code/generics.clc code/generics.cl && ./clover2 code/generics.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/integer.cl && ./clover2 code/integer.clo
	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/block.cl && ./clover2 code/block.clo
#	export LD_LIBRARY_PATH=.$(LD_LIBRARY_PATH); ./cclover2 code/hash.cl && ./clover2 code/hash.clo

