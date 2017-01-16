//
//  Memory.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 22/4/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pieza.h"

@interface Memory : NSObject

@property(strong,nonatomic) NSString *num;
@property(strong,nonatomic) NSArray *piezas;

-(void) anadirPieza:(Pieza *) pieza;
-(id) init;

@end
