Walle can monitor the core data of iOS application performance.

# Features

Real-time monitoring of the following data

- Memory
- FPS
- CPU
- launch time
- UIViewController appear time

#Environment
IOS 8 or later , XCode 7 or later

#How To Use
```Objc
#import "XYPerformanceMonitor.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    [[XYPerformanceMonitor sharedInstance] startMonitorWithBar:YES];
}
```

#Installation

pod 'Walle'




