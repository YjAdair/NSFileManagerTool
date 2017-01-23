//
//  NSFileManager+YJExpand.m
//
//  Created by yankezhi on 16/6/22.
//  Copyright © 2016年 YjAdair. All rights reserved.
//

#import "NSFileManager+YJExpand.h"

@implementation NSFileManager (YJExpand)

- (NSURL *)documentsURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSDocumentDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)documentsPath {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)cachesURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSCachesDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)cachesPath {
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSURL *)libraryURL {
    return [[[NSFileManager defaultManager]
             URLsForDirectory:NSLibraryDirectory
             inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)libraryPath {
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
}

- (NSString *)createDirectoryAtSystemPath:(SystemPathType)type WithFileName:(NSString *)fileName isSuccess:(BOOL *)isSuccess{
    BOOL temp = *isSuccess;
    temp = NO;
    if (!type) return nil;
    
    NSString *directoryPath  = nil;
    
    switch (type) {
        case SystemPathTypeDocuments:
    
            directoryPath = [[self documentsPath] stringByAppendingPathComponent:fileName];
            
            break;
        case SystemPathTypeCaches:
            
            directoryPath = [[self cachesPath] stringByAppendingPathComponent:fileName];
            break;
        case SystemPathTypeLibrary:
            directoryPath = [[self libraryPath] stringByAppendingPathComponent:fileName];
            break;
    }
    
    BOOL directory;
    BOOL exist = [self fileExistsAtPath:directoryPath isDirectory:&directory];
    if (!exist || !directory) {
        
        [self createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
        temp = YES;
        return directoryPath;
    }else{
        temp = YES;
        return directoryPath;
    }

}

#pragma mark ---计算缓存大小---
+ (void)getCasheFileSizeWithFileName:(NSString *)fileName Completion:(void(^)(NSString *size))completion{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *cachPath;
        if (fileName == nil) {
            
            cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        }else{
            cachPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];
        }
        
        CGFloat size = [[NSFileManager defaultManager] fileSize:cachPath];
        
        NSString *sizeText = nil;
        if (size >= pow(10, 9)) { // size >= 1GB
            sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
        } else if (size >= pow(10, 6)) { // 1GB > size >= 1MB
            sizeText = [NSString stringWithFormat:@"%.2fMB", size / pow(10, 6)];
        } else if (size >= pow(10, 3)) { // 1MB > size >= 1KB
            sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
        } else { // 1KB > size
            sizeText = [NSString stringWithFormat:@"%zdB", size];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(sizeText);
            }
        });
        
    });
}

/** 计算缓存 */
- (CGFloat)fileSize:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //是否为文件夹
    BOOL isDirectory = NO;
    //路径是否存在
    BOOL exist = [manager fileExistsAtPath:path isDirectory:&isDirectory];
    if (exist == NO) return 0;
    
    if (isDirectory) {
        CGFloat size = 0;
        
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:path];
        
        for (NSString *subpath in enumerator) {
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            
            NSDictionary *fileAttrs = [manager attributesOfItemAtPath:fullSubpath error:nil];
            
            size += fileAttrs.fileSize;
        }
        return size;
    } else {
        
        NSDictionary *fileAttrs = [manager attributesOfItemAtPath:path error:nil];
        return fileAttrs.fileSize;
    }
}

#pragma mark ---清除缓存---
+ (void)clearCasheWithFileName:(NSString *)fileName Completion:(void(^)())completion{
    
    // 删除自定义的缓存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *cachPath;
        if (fileName == nil) {
            
            cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        }else{
            cachPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:fileName];
        }
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        for (NSString *p in files) {
            NSError *error;
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        
        // 所有的缓存都清除完毕
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion();
            }
        });
    });
}
@end
