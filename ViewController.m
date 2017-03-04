#import "ViewController.h"
#import "CppInterface.h"

@interface ViewController ()
{
    CppInterface* i;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    i = [[CppInterface alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
