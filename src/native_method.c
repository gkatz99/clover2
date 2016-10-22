#include "common.h"

#define NATIVE_METHOD_HASH_SIZE 256

struct sNativeMethodHashItem {
    char* mPath;
    fNativeMethod mFun;
};

static struct sNativeMethodHashItem gNativeMethodHash[NATIVE_METHOD_HASH_SIZE];

static unsigned int get_hash_key_for_native_method(char* path)
{
    unsigned int key;
    char* p;

    p = path;

    key = 0;

    while(*p) {
        key += *p++;
    }

    return key % NATIVE_METHOD_HASH_SIZE;
}

static void put_fun_to_hash_for_native_method(char* path, fNativeMethod fun)
{
    unsigned int key, key2;

    key = get_hash_key_for_native_method(path);

    key2 = key;

    while(1) {
        if(gNativeMethodHash[key2].mPath == NULL) {
            gNativeMethodHash[key2].mPath = MSTRDUP(path);
            gNativeMethodHash[key2].mFun = fun;
            break;
        }
        else {
            key2++;

            if(key2 >= NATIVE_METHOD_HASH_SIZE) {
                key2 = 0;
            }
            else if(key2 == key) {
                fprintf(stderr, "overflow native methods number");
                exit(1);
            }
        }
    }
}

fNativeMethod get_native_method(char* path)
{
    unsigned int key, key2;

    key = get_hash_key_for_native_method(path);

    key2 = key;

    while(1) {
        if(gNativeMethodHash[key2].mPath == NULL) {
            return NULL;
        }
        else if(strcmp(gNativeMethodHash[key2].mPath, path) == 0) {
            return gNativeMethodHash[key2].mFun;
        }
        else {
            key2++;

            if(key2 >= NATIVE_METHOD_HASH_SIZE) {
                key2 = 0;
            }
            else if(key2 == key) {
                return NULL;
            }
        }
    }
}

struct sNativeMethodStruct {
    const char* mPath;
    fNativeMethod mFun;
};

typedef struct sNativeMethodStruct sNativeMethod;

// manually sort is needed
static sNativeMethod gNativeMethods[] = {
    { "System.exit(int)", System_exit },
    { "System.assert(bool)", System_assert },
    { "System.malloc(int)", System_malloc },
    { "System.calloc(int,int)", System_calloc },
    { "System.free(pointer)", System_free },
    { "System.strlen(pointer)", System_strlen },
    { "System.strcpy(pointer,pointer)", System_strcpy },
    { "System.strncpy(pointer,pointer,int)", System_strncpy },
    { "System.strdup(pointer)", System_strdup },
    { "System.print(String)", System_print },
    { "System.println(String)", System_println },
    { "System.printToError(String)", System_printToError },
    { "System.printlnToError(String)", System_printlnToError },
    { "System.sleep(int)", System_sleep },
    { "System.pcre_exec(regex,String,int,PcreOVec)", System_pcre_exec },
    { "System.sprintf(String,Array)", System_sprintf },

    { "", 0 }  // sentinel
};


void native_method_init()
{
    sNativeMethod* p;

    memset(gNativeMethodHash, 0, sizeof(gNativeMethodHash));

    p = gNativeMethods;

    while(p->mPath[0] != 0) {
        put_fun_to_hash_for_native_method((char*)p->mPath, p->mFun);
        p++;
    }

    gGetNativeMethod = get_native_method;
}

void native_method_final()
{
    int i;
    for(i=0; i<NATIVE_METHOD_HASH_SIZE; i++) {
        if(gNativeMethodHash[i].mPath) {
            MFREE(gNativeMethodHash[i].mPath);
        }
    }
}

