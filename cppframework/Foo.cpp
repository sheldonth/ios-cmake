#include "Foo.hh"
#include <string>
#include <iostream>

int Foo::PrintFoo()
{
#if __cplusplus
    std::cout << "C++ environment detected." << std::endl;
#endif
    std::cout << "Foo::PrintFoo() called." << std::endl;
    return 1;
} 

