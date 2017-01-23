//
//  NSFileManager+YJExpand.h
//
//  Created by yankezhi on 16/6/22.
//  Copyright © 2016年 YjAdair. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    SystemPathTypeDocuments = 1,
    SystemPathTypeCaches,
    SystemPathTypeLibrary
} SystemPathType;
@interface NSFileManager (YJExpand)

/** Documents文件夹路径**/
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/** Caches文件夹路径**/
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/** Library文件夹路径**/
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/** 计算缓存大小**/
+ (void)getCasheFileSizeWithFileName:(NSString *)fileName Completion:(void(^)(NSString *size))completion;

/** 清除缓存**/
+ (void)clearCasheWithFileName:(NSString *)fileName Completion:(void(^)())completion;

/** 文件夹**/
- (NSString *)createDirectoryAtSystemPath:(SystemPathType)type WithFileName:(NSString *)fileName isSuccess:(BOOL *)isSuccess;
@end
