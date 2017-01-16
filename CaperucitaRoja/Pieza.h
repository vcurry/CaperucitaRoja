//
//  Pieza.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 18/3/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface Pieza : NSObject

@property(assign,nonatomic) CGPoint posInicial;
@property(assign,nonatomic) CGPoint posCorrecta;
@property(strong,nonatomic) NSString *num;
@property(strong,nonatomic) NSString *nombreImagen;

@end
