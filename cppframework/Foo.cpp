#include "Foo.hh"
#include <string>
#include <iostream>

#define EXPORT __attribute__((visibility("default")))

EXPORT
int Foo::PrintFoo()
{
    std::cout << "This is in a C++ in a dynamically linked framework!" << std::endl;
    return 1;
} 

