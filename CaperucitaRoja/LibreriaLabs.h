//
//  LibreriaLabs.h
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 4/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Capucha.h"
#import "Puzzle.h"
#import "Memory.h"
@class LibreriaLabs;

@protocol LibreriaDelegate <NSObject>

-(void) libreriaLabsCargada:(LibreriaLabs *) libreria;

@end

@interface LibreriaLabs : NSObject <NSXMLParserDelegate>{
//@private Laberinto * laberinto;
@private Capucha *capucha;
//@private Bloque3series *bloqueSeries;
@private Puzzle *puzzle;
@private Memory *memory;
}

//@property (strong,readonly,nonatomic) NSArray *laberintos;
@property (strong,readonly,nonatomic) NSArray *capuchas;
//@property (strong,readonly,nonatomic) NSArray *bloquesSeries;
@property (strong,readonly,nonatomic) NSArray *puzzles;
@property (strong,readonly,nonatomic) NSArray *memories;
@property (strong,nonatomic) id<LibreriaDelegate> delegado;

+(LibreriaLabs *) instancia;
//-(void) anadirLaberinto:(Laberinto *) laberinto;
-(void) anadirCapucha:(Capucha *) capucha;
//-(void) anadirBloque3Series:(Bloque3series *) bloqueSeries;
-(void) anadirPuzzle:(Puzzle *) puzzle;
-(void) anadirMemory:(Memory *) memory;
-(void) cargarXML:(NSString *) ruta;

@end
