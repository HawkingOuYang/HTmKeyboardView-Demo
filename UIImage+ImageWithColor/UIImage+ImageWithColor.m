//mxclmade

#import "UIImage+ImageWithColor.h"

/**
 注释代码 by OYXJ on 2016.08.24
 static NSCache *imageCache;
 */

/**
 code added by OYXJ on 2016.08.24 ， aiming at optimizing performance 。
 */
//! 图片缓存
static NSCache *imageCache;
//! App生命周期中，对imageCache只初始化一次
static dispatch_once_t onceTokenForImageCache;



@implementation UIImage (WithColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    dispatch_once(&onceTokenForImageCache, ^{   // code added by OYXJ on 2016.08.24
        imageCache = [[NSCache alloc] init];
    });
    
    UIImage *image = [imageCache objectForKey:color];
    if (image) {
        return image;
    }
    
    UIImage *newImage = [self imageWithColor:color size:CGSizeMake(1,1)];
    
    [imageCache setObject:newImage forKey:color];
    
    return newImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    dispatch_once(&onceTokenForImageCache, ^{   // code added by OYXJ on 2016.08.24
        imageCache = [[NSCache alloc] init];
    });
    
    // [begin] code added by OYXJ on 2016.08.24
    NSString *key = [[color description] stringByAppendingString: NSStringFromCGSize(size)];
    UIImage *image = [imageCache objectForKey:key];
    if (image) {
        return image;
    }
    // [end] code added by OYXJ on 2016.08.24

    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [imageCache setObject:newImage forKey:color];   // code added by OYXJ on 2016.08.24
    
    return newImage;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    dispatch_once(&onceTokenForImageCache, ^{   // code added by OYXJ on 2016.08.24
        imageCache = [[NSCache alloc] init];
    });
    
    // [begin] code added by OYXJ on 2016.08.24
    NSString *key = [[color description] stringByAppendingString: [@(cornerRadius) stringValue]];
    UIImage *image = [imageCache objectForKey:key];
    if (image) {
        return image;
    }
    // [end] code added by OYXJ on 2016.08.24

    
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage *newImage = [img resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
    
    [imageCache setObject:newImage forKey:color];   // code add by OYXJ on 2016.08.24
    
    return newImage;
}

@end
