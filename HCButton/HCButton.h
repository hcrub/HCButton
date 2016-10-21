//
//  HCButton.h
//  HCButton
//
//  Created by Neil Burchfield on 10/20/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -
#pragma mark - HCButton -

/**
 HCButton
 
 @discussion Button with loading support.
 */

@interface HCButton : UIButton

#pragma mark -
#pragma mark Properties

// Shows the loader while the command is executing. Defaults to YES.
@property (readwrite, assign, nonatomic) BOOL loadsWhileExecuting;

@end

#pragma mark -
#pragma mark - HCButton+Subclass -

@interface HCButton (Subclass)

/**
 Container of subviews that animate while loading.
 
 @discussion Defaults to the button's title and image views.
 @return Views that animate in and out with the loader.
 */
- (nonnull NSArray<UIView *> *)animateableSubviews;

@end

#pragma mark -
#pragma mark - HCSocialButton -

/**
 HCSocialButton
 
 @discussion Button specifically designed for social-based vendors.
 */

// Social Type
typedef NS_ENUM (NSInteger, HCSocialType) {
    HCSocialTypeFacebook,
    HCSocialTypeTwitter
};

@interface HCSocialButton : HCButton

// Social type
@property (readwrite, assign, nonatomic) HCSocialType socialType;

@end

NS_ASSUME_NONNULL_END
