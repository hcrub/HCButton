//
//  HCButton.m
//  HCButton
//
//  Created by Neil Burchfield on 10/20/16.
//  Copyright © 2016 Neil Burchfield. All rights reserved.
//

#import "HCButton.h"

// Category
#import <HCComponents/UIFont+HCComponents.h>
#import <HCComponents/NSBundle+HCComponents.h>

// Reactive
#import <ReactiveCocoa.h>

#pragma mark -
#pragma mark - HCButton -

@interface HCButton ()
// Private
@property (readwrite, strong, nonatomic) UIActivityIndicatorView *indicator;
// Public
@property (readwrite, assign, getter=isLoading, nonatomic) BOOL loading;
@end

@implementation HCButton

#pragma mark -
#pragma mark - Initilizer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;

    [self setupDefaults];
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self setupDefaults];
    
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

#pragma mark -
#pragma mark - Defaults

- (void)setupDefaults {
    _loadsWhileExecuting = YES;
    
    [self setupView];
    [self setupBindings];
}

#pragma mark -
#pragma mark - Setup

- (void)setupView {
    self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.indicator.hidesWhenStopped = YES;
    RAC(self, indicator.color) = [[[[RACObserve(self, titleLabel.textColor) ignore:nil] distinctUntilChanged] startWith:[UIColor whiteColor]] deliverOnMainThread];
    [self addSubview:self.indicator];
}

#pragma mark -
#pragma mark - Bindings

- (void)setupBindings {
    @weakify(self)
    
    RAC(self, loading) = [[[[[RACObserve(self, loadsWhileExecuting)
                              distinctUntilChanged]
                             map:^id(NSNumber *loadsWhileExecuting) {
                                 return [RACSignal
                                         if:[RACSignal return:loadsWhileExecuting]
                                         then:[RACSignal
                                               defer:^RACSignal *{
                                                   @strongify(self)
                                                   
                                                   return [[[RACObserve(self, rac_command)
                                                             distinctUntilChanged]
                                                            map:^id(RACCommand *command) {
                                                                return command.executing;
                                                            }]
                                                           switchToLatest];
                                               }]
                                         else:[RACSignal
                                               defer:^RACSignal *{
                                                   return [RACSignal never];
                                               }]];
                             }]
                            switchToLatest]
                           deliverOnMainThread]
                          takeUntil:self.rac_willDeallocSignal];
}

#pragma mark -
#pragma mark - Properties

- (void)setLoading:(BOOL)loading {
    if (_loading == loading) return;
    
    _loading = loading;
    
    self.indicator.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f, CGRectGetHeight(self.bounds) / 2.f);
    
    @weakify(self)
    
    [UIView animateWithDuration:.5f
                          delay:0.f
                        options:_loading ? UIViewAnimationOptionCurveEaseOut : UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         @strongify(self)
                         
                         for (UIView *view in [self animateableSubviews]) {
                             view.layer.opacity = loading ? 0.f : 1.f;
                         }
                         if (loading) {
                             [self.indicator startAnimating];
                         } else {
                             [self.indicator stopAnimating];
                         }
                     } completion:NULL];
}


#pragma mark -
#pragma mark - Subclass

- (NSArray<UIView *> *)animateableSubviews {
    return @[self.titleLabel, self.imageView];
}

@end

#pragma mark -
#pragma mark - HCSocialButton -

@interface HCSocialButton ()
// Private
@property (readwrite, strong, nonatomic) UIView *separatorView;
@property (readonly) CGFloat titleWidth;
@end

@implementation HCSocialButton

#pragma mark -
#pragma mark - Setup

- (void)setupView {
    [super setupView];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:13.5f];

    /**
     *  Separator
     */
    self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
    self.separatorView.translatesAutoresizingMaskIntoConstraints = NO;
    self.separatorView.backgroundColor = [UIColor whiteColor];
    self.separatorView.alpha = .85f;
    [self addSubview:self.separatorView];
    
    NSLayoutConstraint *separatorViewHeightConstraint = [NSLayoutConstraint
                                                         constraintWithItem:self.separatorView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         multiplier:.6f
                                                         constant:0.f];
    NSLayoutConstraint *separatorViewCenterYConstraint = [NSLayoutConstraint
                                                          constraintWithItem:self.separatorView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                          toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.f
                                                          constant:0.f];
    NSLayoutConstraint *separatorViewWidthConstraint = [NSLayoutConstraint
                                                        constraintWithItem:self.separatorView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.f
                                                        constant:.35f];
    NSLayoutConstraint *separatorViewLeftConstraint = [NSLayoutConstraint
                                                       constraintWithItem:self.separatorView
                                                       attribute:NSLayoutAttributeLeft
                                                       relatedBy:NSLayoutRelationEqual
                                                       toItem:self.imageView
                                                       attribute:NSLayoutAttributeRight
                                                       multiplier:1.f
                                                       constant:-8.f];
    [self addConstraints:@[separatorViewHeightConstraint,
                           separatorViewCenterYConstraint,
                           separatorViewWidthConstraint,
                           separatorViewLeftConstraint]];
}

#pragma mark -
#pragma mark - Subclass

- (NSArray<UIView *> *)animateableSubviews {
    return [[super animateableSubviews] arrayByAddingObject:self.separatorView];
}

#pragma mark -
#pragma mark - Properties

- (void)setSocialType:(HCSocialType)socialType {
    if (_socialType != socialType) {
        _socialType = socialType;
    }
    NSBundle *const bundle = [NSBundle hc_bundleWithName:@"HCButton"];
    
    NSString *title, *imageName;
    if (_socialType == HCSocialTypeFacebook) {
        title = @"Login with Facebook";
        imageName = @"hc_button_facebook";
    }
    else {
        title = @"Login with Twitter";
        imageName = @"hc_button_twitter";
    }
    
    NSString *const imagePath = [bundle pathForResource:imageName ofType:@"png" inDirectory:@"images"];
    [self setImage:[UIImage imageWithContentsOfFile:imagePath] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    
}

#pragma mark -
#pragma mark - Overrides

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat width = CGRectGetHeight(self.bounds) + 10.f;
    CGFloat x = CGRectGetMinX([self titleRectForContentRect:contentRect]) - width;
    return CGRectMake(x, 0.f, width, CGRectGetHeight(self.bounds));
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(CGRectGetWidth(self.frame) / 2.f - self.titleWidth / 2.f + 10.f, 0.f, self.titleWidth, CGRectGetHeight(self.bounds));
}

#pragma mark -
#pragma mark - Private

- (CGFloat)titleWidth {
    NSString *title = [self titleForState:UIControlStateNormal];
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIFont *font = self.font;
#pragma GCC diagnostic pop
    if (title && font) {
        return [title boundingRectWithSize:self.frame.size
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                attributes:@{NSFontAttributeName:font}
                                   context:nil].size.width;
    }
    return 0.f;
}

@end
