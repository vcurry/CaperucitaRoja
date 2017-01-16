//
//  Pieza.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 18/3/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Pieza.h"

@implementation Pieza
@synthesize num=num, nombreImagen=nombreImagen, posInicial=posInicial, posCorrecta=posCorrecta;

-(id) init{
    self=[super init];
    if(self){
        self.num=num;
        self.nombreImagen=nombreImagen;
        self.posCorrecta=posCorrecta;
        self.posInicial=posInicial;
    }
    return self;
}




@end
