#include "common.h"
#include <locale.h>
#define _GNU_SOURCE
#include <stdio.h>

#ifdef HAVE_READLINE_H
#include <readline/readline.h>
#include <readline/history.h>
#endif

#include <signal.h>
#include <termios.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <time.h>
#include <limits.h>
#include <unistd.h>
#include <fcntl.h>
#include <dirent.h>
#include <libgen.h>

static void clover2_init()
{
    class_system_init();
    thread_init();
#ifdef ENABLE_JIT
    jit_init_on_runtime();
#endif
    native_method_init();
    class_init();
    heap_init(HEAP_INIT_SIZE, HEAP_HANDLE_INIT_SIZE);
    stack_init();
    (void)class_init_on_runtime();
}

static void clover2_final()
{
    thread_final();
    class_final_on_runtime();
    heap_final();
    stack_final();
    class_final();
    native_method_final();
#ifdef ENABLE_JIT
    jit_final_on_runtime();
#endif
}

static void compiler_init(BOOL no_load_fudamental_classes)
{
    init_nodes();
    module_init();
}

static void compiler_final()
{
    module_final();
    free_nodes();
}

static BOOL get_type(char* source, char* fname, sVarTable* lv_table, sNodeType** type_, sVarTable** result_lv_table)
{
    sParserInfo info;

    memset(&info, 0, sizeof(sParserInfo));

    info.p = source;
    info.source = source;
    info.sname = fname;
    info.sline = 1;
    info.lv_table = lv_table;
    info.parse_phase = 0;
    info.get_type_for_interpreter = TRUE;

    sCompileInfo cinfo;
    
    memset(&cinfo, 0, sizeof(sCompileInfo));

    sByteCode code;
    sByteCode_init(&code);
    cinfo.code = &code;

    sConst constant;
    sConst_init(&constant);
    cinfo.constant = &constant;

    cinfo.lv_table = lv_table;
    cinfo.no_output = TRUE;
    cinfo.pinfo = &info;

    info.cinfo = &cinfo;

    while(*info.p) {
        info.exist_block_object_err = FALSE;

        unsigned int node = 0;
        (void)expression(&node, &info);

        *result_lv_table = info.lv_table;

        if(node != 0) {
            (void)compile(node, &cinfo);

            *type_ = cinfo.type;

            if(*info.p == ';') {
                info.p++;
                skip_spaces_and_lf(&info);
            }
        }
    }

    sByteCode_free(&code);
    sConst_free(&constant);

    return TRUE;
}


static void tclover_get_type(char* source_value, char* fname_object_value, char* type_name, int type_name_size)
{
    sVarTable* lv_table = init_var_table();
    sVarTable* result_lv_table;
    sNodeType* type_ = NULL;

    (void)get_type(source_value, fname_object_value, lv_table, &type_, &result_lv_table);

    if(type_ == NULL || type_->mClass == NULL) {
        type_name[0] = '\0';
    }
    else {
        create_type_name_from_node_type(type_name, type_name_size, type_);
    }
}

int gARGC;
char** gARGV;
char* gVersion = "6.6.8";

char gScriptDirPath[PATH_MAX];
BOOL gRunningCompiler = FALSE;
BOOL gCompilingCore = FALSE;

static char gInitInputString[1024];
static int gInitInputCursorPosition;

int main(int argc, char** argv)
{
    init_vtable();
    init_node_types();
    init_node_block_types();
    clover2_init();
    parser_init();
    compiler_init(FALSE);

    sBuf buf;
    sBuf_init(&buf);

    while(!feof(stdin)) {
        char buf2[BUFSIZ];

        int result = fread(buf2, 1, BUFSIZ, stdin);
        
        if(result < 0) {
            fprintf(stderr, "invalid stdin\n");
            exit(1);
        }

        sBuf_append(&buf, buf2, result);
    }

    char type_name[1024];
    tclover_get_type(buf.mBuf, "tyclover2", type_name, 1024);

    printf("%s\n", type_name);

    compiler_final();
    parser_final();
    clover2_final();
    final_vtable();
    free_node_types();
    free_node_block_types();

    exit(0);
}
