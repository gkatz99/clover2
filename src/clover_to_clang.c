 #include "common.h"
#include <wchar.h>

ALLOC wchar_t* string_object_to_wchar_array(CLObject string_object)
{
    sCLObject* string_object_data = CLOBJECT(string_object);
    CLObject wstr_array = string_object_data->mFields[0].mObjectValue;
    sCLObject* wstr_array_data = CLOBJECT(wstr_array);

    int len = wstr_array_data->mArrayNum;

    wchar_t* wstr = MCALLOC(1, sizeof(wchar_t)*(len+1));

    int i;
    for(i=0; i<len; i++) {
        wstr[i] = wstr_array_data->mFields[i].mCharValue;
    }
    wstr[i] = '\0';

    return wstr;
}

ALLOC char* string_object_to_char_array(CLObject string_object)
{
    wchar_t* wstr = ALLOC string_object_to_wchar_array(string_object);
    int len = wcslen(wstr);

    int size = sizeof(char)* MB_LEN_MAX * (len + 1);
    char* result = MCALLOC(1, size);

    (void)wcstombs(result, wstr, size);

    MFREE(wstr);

    return result;
}

NULLABLE CLVALUE* get_element_from_array(CLObject array, int index)
{
    sCLObject* array_data = CLOBJECT(array);

    if(index < array_data->mArrayNum) {
        CLVALUE* result = array_data->mFields + index;
        return result;
    }
    else {
        return NULL;
    }
}

NULLABLE CLVALUE* get_element_from_Array(CLObject array, int index)
{
    sCLObject* array_data = CLOBJECT(array);

    CLObject items = array_data->mFields[0].mObjectValue;

    CLVALUE* result = get_element_from_array(items, index);
    
    return result;
}

int get_element_number_from_Array(CLObject array)
{
    sCLObject* array_data = CLOBJECT(array);

    CLObject items = array_data->mFields[0].mObjectValue;

    sCLObject* items_data = CLOBJECT(items);

    int result =  items_data->mArrayNum;

    return result;
}

char get_value_from_Byte(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    char result = object_data->mFields[0].mByteValue;
    return result;
}

unsigned char get_value_from_UByte(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    unsigned char result = object_data->mFields[0].mUByteValue;

    return result;
}

short get_value_from_Short(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    short result = object_data->mFields[0].mShortValue;

    return result;
}

unsigned short get_value_from_UShort(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    unsigned short result = object_data->mFields[0].mUShortValue;

    return result;
}

int get_value_from_Integer(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    int result = object_data->mFields[0].mIntValue;

    return result;
}

unsigned int get_value_from_UInteger(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    unsigned int result = object_data->mFields[0].mUIntValue;

    return result;
}

clint64 get_value_from_Long(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    clint64 result =  object_data->mFields[0].mLongValue;

    return result;
}

unsigned clint64 get_value_from_ULong(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    unsigned clint64 result = object_data->mFields[0].mULongValue;

    return result;
}

wchar_t get_value_from_Char(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    wchar_t result = object_data->mFields[0].mCharValue;

    return result;
}

float get_value_from_Float(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    float result = object_data->mFields[0].mFloatValue;

    return result;
}

double get_value_from_Double(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    double result = object_data->mFields[0].mDoubleValue;

    return result;
}

BOOL get_value_from_Bool(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    BOOL result = object_data->mFields[0].mBoolValue;

    return result;
}

char* get_value_from_Pointer(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    char* result = object_data->mFields[0].mPointerValue;

    return result;
}

sCLClass* get_class_from_object(CLObject object)
{
    sCLObject* object_data = CLOBJECT(object);
    sCLClass* result = object_data->mClass;

    return result;
}

void* get_pointer_from_buffer_object(CLObject buffer)
{
    sCLObject* obj_data = CLOBJECT(buffer);
    void* result = obj_data->mFields[0].mPointerValue;

    return result;
}

size_t get_size_from_buffer_object(CLObject buffer)
{
    sCLObject* obj_data = CLOBJECT(buffer);
    size_t result =  obj_data->mFields[2].mULongValue;

    return result;
}

ALLOC CLObject* list_to_array(CLObject list, int* num_elements)
{
    sCLObject* object_data = CLOBJECT(list);

    *num_elements = object_data->mFields[2].mIntValue;          // number

    CLObject* result = MCALLOC(1, sizeof(CLObject)*(*num_elements));

    int n = 0;
    CLObject it = object_data->mFields[0].mObjectValue;         // head

    while(it) {
        sCLObject* object_data = CLOBJECT(it);

        result[n] = object_data->mFields[0].mObjectValue;   // item
        n++;

        it = object_data->mFields[1].mObjectValue;          // next
    }

    return result;
}

void clover_termios_to_c_termios(CLObject terminfo_object, struct termios* terminfo_value)
{
    sCLObject* object_data = CLOBJECT(terminfo_object);

    terminfo_value->c_iflag = object_data->mFields[0].mIntValue;
    terminfo_value->c_oflag = object_data->mFields[1].mIntValue;
    terminfo_value->c_cflag = object_data->mFields[2].mIntValue;
    terminfo_value->c_lflag = object_data->mFields[3].mIntValue;

    CLObject array = object_data->mFields[4].mObjectValue;

    sCLObject* object_data2 = CLOBJECT(array);

    int i;
    for(i=0; i<32; i++) {
        terminfo_value->c_cc[i] = object_data2->mFields[i].mByteValue;
    }
}

void c_termios_to_clover_termios(struct termios* terminfo_value, CLObject terminfo_object)
{
    /// C to Clover object ///
    sCLObject* object_data = CLOBJECT(terminfo_object);
    object_data->mFields[0].mIntValue = terminfo_value->c_iflag;
    object_data->mFields[1].mIntValue = terminfo_value->c_oflag;
    object_data->mFields[2].mIntValue = terminfo_value->c_cflag;
    object_data->mFields[3].mIntValue = terminfo_value->c_lflag;

    CLObject array = object_data->mFields[4].mObjectValue;

    sCLObject* object_data2 = CLOBJECT(array);

    int i;
    for(i=0; i<32; i++) {
        object_data2->mFields[i].mByteValue = terminfo_value->c_cc[i];
    }
}

BOOL create_termios_object(CLObject* result, CLVALUE** stack_ptr, CLVALUE* lvar, sVMInfo* info)
{
    sCLClass* termios_class = get_class_with_load_and_initialize("termios", FALSE);

    if(termios_class == NULL) {
        entry_exception_object_with_class_name(stack_ptr, info->current_stack, info->current_var_num, info, "Exception", "class not found");
        return FALSE;
    }

    *result = create_object(termios_class, "termios", info);

    CLVALUE cl_value;
    cl_value.mObjectValue = *result;
    push_value_to_global_stack(cl_value, info);

    sCLObject* object_data = CLOBJECT(*result);

    sCLClass* cc_t_class = get_class("byte", FALSE);

    CLObject prev_obj = object_data->mFields[4].mObjectValue;

    object_data->mFields[4].mObjectValue = create_array_object(cc_t_class, 32, info);
    inc_refference_count(object_data->mFields[4].mObjectValue, prev_obj, TRUE);

    pop_global_stack(info);

    return TRUE;
}