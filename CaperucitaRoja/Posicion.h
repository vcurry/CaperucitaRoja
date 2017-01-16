//
//  Posicion.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 4/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Posicion : NSObject

@property (copy,nonatomic) NSString * num;
@property (assign,nonatomic) CGPoint ubicacion;

-(id) init;

@end
