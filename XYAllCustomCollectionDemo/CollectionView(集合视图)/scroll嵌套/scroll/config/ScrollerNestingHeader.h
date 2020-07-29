//
//  ScrollerNestingHeader.h
//  XYAllCustomCollectionDemo
//
//  Created by 4AM_XIAO on 2020/7/29.
//  Copyright © 2020 4AM_XIAO. All rights reserved.
//

#ifndef ScrollerNestingHeader_h
#define ScrollerNestingHeader_h

#import "XYFont.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

/*
 极细 纤细 细 常规 中粗 中黑
    PingFangSC-Ultralight,
    PingFangSC-Thin,
    PingFangSC-Light,
    PingFangSC-Regular,
    PingFangSC-Semibold,
    PingFangSC-Medium
*/

#define kFontUltralightName @"PingFangSC-Ultralight"
#define kFontThinName @"PingFangSC-Thin"
#define kFontLightName @"PingFangSC-Light"
#define kFontRegularName @"PingFangSC-Regular"
#define kFontMediumName @"PingFangSC-Medium"
#define kFontSemiboldName @"PingFangSC-Semibold"
#define kFontBoldName kFontSemiboldName

#define kFontHelvetica @"Helvetica"

#define kFontNormal(fontSize) [XYFont fontWithName:kFontRegularName size:fontSize]
#define kFontMedium(fontSize) [XYFont fontWithName:kFontMediumName size:fontSize]
#define kFontBold(fontSize) [XYFont fontWithName:kFontBoldName size:fontSize]
#define kFontCustom(fontName,fontSize) [XYFont fontWithName:fontName size:fontSize]

/*颜色*/
#define kColorClear [UIColor clearColor]
#define kColorWhite [UIColor whiteColor]
#define kColorBlack [UIColor blaceColor]
#define kColorDarkGray [UIColor darkGrayColor]
#define kColorLightGray [UIColor lightGrayColor]
#define kColorOrange [UIColor orangeColor]

#endif /* ScrollerNestingHeader_h */
