#import "CppInterface.h"
#include <FooBar/Foo.hh>

@interface CppInterface () 
{
    Foo* myFoo;
}
@end

@implementation CppInterface

-(instancetype)init
{
    self = [super init];
    if (self) {
        myFoo = new Foo();
        myFoo->PrintFoo();
        delete myFoo;
        myFoo = nullptr;
    }
    return self;
}

@end
