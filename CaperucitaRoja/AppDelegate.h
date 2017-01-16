//
//  AppDelegate.h
//  CaperucitaRoja
//
//  Created by Verónica Cordobés on 23/9/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "LibreriaLabs.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LibreriaDelegate>{
    LibreriaLabs *libreriaLabs;
    
}


@property (strong, nonatomic) UIWindow *window;

@property int num;
@property int subnum;
@property LibreriaLabs *libreria;

@property (strong, nonatomic) Capucha *capucha;
//@property (strong, nonatomic) NSArray *laberintos;
//@property (strong, nonatomic) NSArray *bloquesSeries;
@property (strong, nonatomic) NSArray *puzzles;
@property (strong, nonatomic) NSArray *memories;
@property int language;
@property int modoJuego;


@end

