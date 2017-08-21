#include "Foo.hh"
#include <string>
#include <iostream>

#define EXPORT __attribute__((visibility("default")))

EXPORT
int Foo::PrintFoo()
{
#if __cplusplus
    std::cout << "C++ environment detected." << std::endl;
#endif
    std::cout << "Foo::PrintFoo() called." << std::endl;
    return 1;
} 

