//
//  LibreriaLabs.m
//  LittleRedRidingHood
//
//  Created by Verónica Cordobés on 4/2/15.
//  Copyright (c) 2015 Verónica Cordobés. All rights reserved.
//

#import "LibreriaLabs.h"

@implementation LibreriaLabs
@synthesize delegado=delegado,capuchas=capuchas, puzzles=puzzles, memories=memories;

+(LibreriaLabs *) instancia{
    static LibreriaLabs * libreriaLabs = nil;
    if(libreriaLabs==nil){
        libreriaLabs=[[LibreriaLabs alloc] init];
    }
    return libreriaLabs;
}

-(id) init{
    self=[super init];
    if(self){
   //     self->laberintos=[NSMutableArray array];
        self->capuchas=[NSMutableArray array];
     //   self->bloquesSeries=[NSMutableArray array];
        self->puzzles=[NSMutableArray array];
        self->memories=[NSMutableArray array];
    }
    return self;
}

/**
-(void) anadirLaberinto:(Laberinto *)_laberinto{
    [(NSMutableArray *)self->laberintos addObject:_laberinto];
//    NSLog(@"Pasa por anadirLaberinto de LibreriaLabs");
}
*/
-(void) anadirCapucha:(Capucha *)_capucha{
    [(NSMutableArray *)self->capuchas addObject:_capucha];
    //    NSLog(@"Pasa por anadirLaberinto de LibreriaLabs");
}

/**
-(void) anadirBloque3Series:(Bloque3series *)_bloqueSeries{
    [(NSMutableArray *)self->bloquesSeries addObject:_bloqueSeries];
}
*/
-(void) anadirPuzzle:(Puzzle *)_puzzle{
    [(NSMutableArray *)self->puzzles addObject:_puzzle];
}

-(void) anadirMemory:(Memory *)_memory{
    [(NSMutableArray *)self->memories addObject:_memory];
}


-(void) cargarXML:(NSString *)ruta{
    NSString *rutaCompleta = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:ruta];
    NSURL *URL = [NSURL fileURLWithPath:rutaCompleta];
    NSXMLParser *parser;
    parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    parser.delegate=self;
    [parser parse];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
 //   self->laberintos=[NSMutableArray array];
    self->capuchas=[NSMutableArray array];
 //   self->bloquesSeries=[NSMutableArray array];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [delegado libreriaLabsCargada:self];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqual:@"capucha"]){
        self->capucha=[[Capucha alloc] init];
        self->capucha.num=[attributeDict valueForKey:@"num"];
        NSString *imagen=[attributeDict valueForKey:@"imagen"];
        self->capucha.imagen=imagen;
        [self anadirCapucha:capucha];
    }else if([elementName isEqual:@"posicionC"]){
        Posicion *posicion = [[Posicion alloc] init];
        posicion.num=[attributeDict valueForKey:@"num"];
        NSString *ubiX=[attributeDict valueForKey:@"x"];
        NSString *ubiY=[attributeDict valueForKey:@"y"];
        posicion.ubicacion=CGPointMake([ubiX floatValue], [ubiY floatValue]);
        if(posicion!=nil){
            [self->capucha anadirPosicion:posicion];
        }
    }else if([elementName isEqual:@"linea"]){
        NSString *imagen=[attributeDict valueForKey:@"imagen"];
        SKSpriteNode *line=[SKSpriteNode spriteNodeWithImageNamed:imagen];
        NSString *ubiX=[attributeDict valueForKey:@"posx"];
        NSString *ubiY=[attributeDict valueForKey:@"posy"];
        line.position=CGPointMake([ubiX floatValue], [ubiY floatValue]);
        line.hidden=YES;
        if (line!=nil) {
            [self->capucha anadirLinea:line];
        }
    }else if([elementName isEqual:@"puzzle"]){
        self->puzzle=[[Puzzle alloc] init];
        self->puzzle.num=[attributeDict valueForKey:@"num"];
        [self anadirPuzzle:puzzle];
    }else if([elementName isEqual:@"pieza"]){
        Piece *pieza = [[Piece alloc] init];
        pieza.num=[attributeDict valueForKey:@"num"];
        NSString *xcorrect=[attributeDict valueForKey:@"xcorrect"];
        NSString *ycorrect=[attributeDict valueForKey:@"ycorrect"];
        pieza.posFinal=CGPointMake([xcorrect floatValue], [ycorrect floatValue]);
        if(pieza!=nil){
            [self->puzzle anadirPieza:pieza];
        }
    }else if([elementName isEqualToString:@"memory"]){
        self->memory=[[Memory alloc]init];
        self->memory.num=[attributeDict valueForKey:@"num"];
        [self anadirMemory:memory];
      //  NSLog(@"Pasa1");
    }else if([elementName isEqual:@"piezaM"]){
      //  NSLog(@"pasa2");
        Pieza *pieza=[[Pieza alloc] init];
        pieza.num=[attributeDict valueForKey:@"num"];
        pieza.nombreImagen=[attributeDict valueForKey:@"nombre"];
        if(pieza!=nil){
           // NSLog(@"pasa3");
            [self->memory anadirPieza:pieza];
        }
    }


}


@end
