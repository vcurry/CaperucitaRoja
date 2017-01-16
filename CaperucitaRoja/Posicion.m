//
//  Posicion.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 4/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "Posicion.h"
#import <QuartzCore/QuartzCore.h>

@implementation Posicion
@synthesize num=num, ubicacion=ubicacion;

-(id)init{
    self=[super init];
    if(self){
        self.num=num;
        self.ubicacion=ubicacion;
    }
    return self;
}
@end
