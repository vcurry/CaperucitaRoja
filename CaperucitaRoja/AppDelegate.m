//
//  AppDelegate.m
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 23/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize num=num, subnum = subnum, libreria=libreria, capucha=capucha, puzzles=puzzles, memories=memories, language=language, modoJuego=modoJuego;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    libreria=[[LibreriaLabs alloc] init];
    libreria.delegado=self;
    [libreria cargarXML:@"positions.xml"];
    
    //language 0 is the default language of the device. 1 is English, 2 is Spanish and 3 is German
    language=0;
    modoJuego=0;
    
    //we initialize the arrays with the game data
  //  self->laberintos=[NSMutableArray array];
 //   laberintos=libreria.laberintos;
    self->puzzles=[NSMutableArray array];
    puzzles=libreria.puzzles;
    self->memories=[NSMutableArray array];
    memories=libreria.memories;
//    self->bloquesSeries=[NSMutableArray array];
//    bloquesSeries=libreria.bloquesSeries;
   // NSLog(@"piezas %lu",(unsigned long)pu.count);
    capucha = [libreria.capuchas objectAtIndex:0];
    
    //num sets the game pack to be played each time. If it's bigger or equal to 3 it goes back to pack nr. 0
 /**   if (num<4) {
        NSLog(@"cargado juego %d",num);
    }else{
        num=1;
        NSLog(@"cargado juego 0 por defecto");
    }*/
    num = 1;
    subnum = 1;
    return YES;
}

//we check that the data was correctly loaded
-(void) libreriaLabsCargada:(LibreriaLabs *)_libreria{
    NSLog(@"Libreria cargada");
    self->libreriaLabs=_libreria;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
