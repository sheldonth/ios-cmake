#include <string>
#include <iostream>

class Foo
{
public:
    int PrintFoo();
    std::string foo;
    Foo() {std::cout << "Foo Created." << std::endl;}
    ~Foo() {std::cout << "Foo Destroyed." << std::endl;}
private:
};


