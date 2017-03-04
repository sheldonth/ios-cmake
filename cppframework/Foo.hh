#include <string>
#include <iostream>

class Foo
{
public:
    int PrintFoo();
    std::string foo;
    Foo() {std::cout << "Foo Created.";}
    ~Foo() {std::cout << "Foo Destroyed.";}
private:
};


