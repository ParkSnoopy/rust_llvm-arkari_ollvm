// RUN: %clang_analyze_cc1 -Wno-array-bounds -analyzer-output=text        \
// RUN:     -analyzer-checker=core,alpha.security.ArrayBoundV2,unix.Malloc,alpha.security.taint -verify %s

int array[10];

void arrayUnderflow(void) {
  array[-3] = 5;
  // expected-warning@-1 {{Out of bound access to memory preceding 'array'}}
  // expected-note@-2 {{Access of 'array' at negative byte offset -12}}
}

int underflowWithDeref(void) {
  int *p = array;
  --p;
  return *p;
  // expected-warning@-1 {{Out of bound access to memory preceding 'array'}}
  // expected-note@-2 {{Access of 'array' at negative byte offset -4}}
}

int scanf(const char *restrict fmt, ...);

void taintedIndex(void) {
  int index;
  scanf("%d", &index);
  // expected-note@-1 {{Taint originated here}}
  // expected-note@-2 {{Taint propagated to the 2nd argument}}
  array[index] = 5;
  // expected-warning@-1 {{Potential out of bound access to 'array' with tainted index}}
  // expected-note@-2 {{Access of 'array' with a tainted index that may be too large}}
}

int *taintedIndexAfterTheEndPtr(void) {
  // NOTE: Technically speaking, this testcase does not trigger any UB because
  // &array[10] is the after-the-end pointer which is well-defined; but this is
  // a bug-prone situation and far from the idiomatic use of `&array[size]`, so
  // it's better to report an error. This report can be easily silenced by
  // writing array+index instead of &array[index].
  int index;
  scanf("%d", &index);
  // expected-note@-1 {{Taint originated here}}
  // expected-note@-2 {{Taint propagated to the 2nd argument}}
  if (index < 0 || index > 10)
    return array;
  // expected-note@-2 {{Assuming 'index' is >= 0}}
  // expected-note@-3 {{Left side of '||' is false}}
  // expected-note@-4 {{Assuming 'index' is <= 10}}
  // expected-note@-5 {{Taking false branch}}
  return &array[index];
  // expected-warning@-1 {{Potential out of bound access to 'array' with tainted index}}
  // expected-note@-2 {{Access of 'array' with a tainted index that may be too large}}
}

void taintedOffset(void) {
  int index;
  scanf("%d", &index);
  // expected-note@-1 {{Taint originated here}}
  // expected-note@-2 {{Taint propagated to the 2nd argument}}
  int *p = array + index;
  p[0] = 5;
  // expected-warning@-1 {{Potential out of bound access to 'array' with tainted offset}}
  // expected-note@-2 {{Access of 'array' with a tainted offset that may be too large}}
}

void arrayOverflow(void) {
  array[12] = 5;
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at index 12, while it holds only 10 'int' elements}}
}

void flippedOverflow(void) {
  12[array] = 5;
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at index 12, while it holds only 10 'int' elements}}
}

int *afterTheEndPtr(void) {
  // This is an unusual but standard-compliant way of writing (array + 10).
  return &array[10]; // no-warning
}

int useAfterTheEndPtr(void) {
  // ... but dereferencing the after-the-end pointer is still invalid.
  return *afterTheEndPtr();
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at index 10, while it holds only 10 'int' elements}}
}

int *afterAfterTheEndPtr(void) {
  // This is UB, it's invalid to form an after-after-the-end pointer.
  return &array[11];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at index 11, while it holds only 10 'int' elements}}
}

int *potentialAfterTheEndPtr(int idx) {
  if (idx < 10) { /* ...do something... */ }
  // expected-note@-1 {{Assuming 'idx' is >= 10}}
  // expected-note@-2 {{Taking false branch}}
  return &array[idx];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at an overflowing index, while it holds only 10 'int' elements}}
  // NOTE: On the idx >= 10 branch the normal "optimistic" behavior would've
  // been continuing with the assumption that idx == 10 and the return value is
  // a legitimate after-the-end pointer. The checker deviates from this by
  // reporting an error because this situation is very suspicious and far from
  // the idiomatic `&array[size]` expressions. If the report is FP, the
  // developer can easily silence it by writing array+idx instead of
  // &array[idx].
}

int scalar;
int scalarOverflow(void) {
  return (&scalar)[1];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'scalar'}}
  // expected-note@-2 {{Access of 'scalar' at index 1, while it holds only a single 'int' element}}
}

int oneElementArray[1];
int oneElementArrayOverflow(void) {
  return oneElementArray[1];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'oneElementArray'}}
  // expected-note@-2 {{Access of 'oneElementArray' at index 1, while it holds only a single 'int' element}}
}

struct vec {
  int len;
  double elems[64];
} v;

double arrayInStruct(void) {
  return v.elems[64];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'v.elems'}}
  // expected-note@-2 {{Access of 'v.elems' at index 64, while it holds only 64 'double' elements}}
}

double arrayInStructPtr(struct vec *pv) {
  return pv->elems[64];
  // expected-warning@-1 {{Out of bound access to memory after the end of the field 'elems'}}
  // expected-note@-2 {{Access of the field 'elems' at index 64, while it holds only 64 'double' elements}}
}

struct item {
  int a, b;
} itemArray[20] = {0};

int arrayOfStructs(void) {
  return itemArray[35].a;
  // expected-warning@-1 {{Out of bound access to memory after the end of 'itemArray'}}
  // expected-note@-2 {{Access of 'itemArray' at index 35, while it holds only 20 'struct item' elements}}
}

int arrayOfStructsArrow(void) {
  return (itemArray + 35)->b;
  // expected-warning@-1 {{Out of bound access to memory after the end of 'itemArray'}}
  // expected-note@-2 {{Access of 'itemArray' at index 35, while it holds only 20 'struct item' elements}}
}

short convertedArray(void) {
  return ((short*)array)[47];
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at index 47, while it holds only 20 'short' elements}}
}

struct two_bytes {
  char lo, hi;
};

struct two_bytes convertedArray2(void) {
  // We report this with byte offsets because the offset is not divisible by the element size.
  struct two_bytes a = {0, 0};
  char *p = (char*)&a;
  return *((struct two_bytes*)(p + 7));
  // expected-warning@-1 {{Out of bound access to memory after the end of 'a'}}
  // expected-note@-2 {{Access of 'a' at byte offset 7, while it holds only 2 bytes}}
}

int intFromString(void) {
  // We report this with byte offsets because the extent is not divisible by the element size.
  return ((const int*)"this is a string of 33 characters")[20];
  // expected-warning@-1 {{Out of bound access to memory after the end of the string literal}}
  // expected-note@-2 {{Access of the string literal at byte offset 80, while it holds only 34 bytes}}
}

int intFromStringDivisible(void) {
  // However, this is reported with indices/elements, because the extent
  // (of the string that consists of 'a', 'b', 'c' and '\0') happens to be a
  // multiple of 4 bytes (= sizeof(int)).
  return ((const int*)"abc")[20];
  // expected-warning@-1 {{Out of bound access to memory after the end of the string literal}}
  // expected-note@-2 {{Access of the string literal at index 20, while it holds only a single 'int' element}}
}

typedef __typeof(sizeof(int)) size_t;
void *malloc(size_t size);

int *mallocRegion(void) {
  int *mem = (int*)malloc(2*sizeof(int));
  mem[3] = -2;
  // expected-warning@-1 {{Out of bound access to memory after the end of the heap area}}
  // expected-note@-2 {{Access of the heap area at index 3, while it holds only 2 'int' elements}}
  return mem;
}

void *alloca(size_t size);

int allocaRegion(void) {
  int *mem = (int*)alloca(2*sizeof(int));
  mem[3] = -2;
  // expected-warning@-1 {{Out of bound access to memory after the end of the memory returned by 'alloca'}}
  // expected-note@-2 {{Access of the memory returned by 'alloca' at index 3, while it holds only 2 'int' elements}}
  return *mem;
}

int *unknownExtent(int arg) {
  if (arg >= 2)
    return 0;
  int *mem = (int*)malloc(arg);
  mem[8] = -2;
  // FIXME: this should produce
  //   {{Out of bound access to memory after the end of the heap area}}
  //   {{Access of 'int' element in the heap area at index 8}}
  return mem;
}

void unknownIndex(int arg) {
  // expected-note@+2 {{Assuming 'arg' is >= 12}}
  // expected-note@+1 {{Taking true branch}}
  if (arg >= 12)
    array[arg] = -2;
  // expected-warning@-1 {{Out of bound access to memory after the end of 'array'}}
  // expected-note@-2 {{Access of 'array' at an overflowing index, while it holds only 10 'int' elements}}
}

int *nothingIsCertain(int x, int y) {
  if (x >= 2)
    return 0;
  int *mem = (int*)malloc(x);
  if (y >= 8)
    mem[y] = -2;
  // FIXME: this should produce
  //   {{Out of bound access to memory after the end of the heap area}}
  //   {{Access of 'int' element in the heap area at an overflowing index}}
  return mem;
}