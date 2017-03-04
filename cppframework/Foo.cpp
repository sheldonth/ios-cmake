#include "Foo.hh"
#include <string>
#include <iostream>

int Foo::PrintFoo()
{
    std::cout << "This is in a C++ in a dynamically linked framework!";
    return 1;
} 

