//
//  Foursquare.h
//  drunkh
//
//  Created by Serena Simkus on 1/1/14.
//  Copyright (c) 2014 Serena Simkus. All rights reserved.
//

#import "JSONModel.h"

@protocol ItemsPhotos
@end

@interface ItemsPhotos : JSONModel

@property (strong, nonatomic) NSString* url;

@end

@implementation ItemsPhotos
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol GroupPhotos
@end

@interface GroupPhotos : JSONModel

@property (strong, nonatomic) NSArray<ItemsPhotos>* items;

@end

@implementation GroupPhotos
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Photos
@end

@interface Photos : JSONModel

@property (strong, nonatomic) NSArray<GroupPhotos>* groups;

@end

@implementation Photos
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Location
@end

@interface Location : JSONModel

@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lng;

@end

@implementation Location
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Venues
@end

@interface Venues : JSONModel

@property (strong, nonatomic) Location* location;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Photos* photos;

@end

@implementation Venues
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Items
@end

@interface Items : JSONModel

@property (strong, nonatomic) Venues* venue;

@end

@implementation Items
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Groups
@end

@interface Groups : JSONModel

@property (strong, nonatomic) NSArray<Items>* items;

@end

@implementation Groups
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



@protocol Response
@end

@interface Response : JSONModel

@property (strong, nonatomic) NSArray<Groups>* groups;
@property (strong, nonatomic) NSString* suggestedRadius;

@end

@implementation Response
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end



//@protocol Foursquare
//@end

@interface Foursquare : JSONModel

@property (strong, nonatomic) NSString* numResults;
@property (strong, nonatomic) Response* response;

@end

@implementation Foursquare
+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end
