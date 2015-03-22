#ifndef __UTILS_H__
#define __UTILS_H__

// ignore warning 4530 for xlocale in windows
#ifdef _WIN32
#pragma warning( push )
#pragma warning( disable : 4530 )
#endif // _WIN32

// include cocos2d headers
#include "cocos2d.h"

// restore warning ignore in windows
#ifdef _WIN32
#pragma warning( pop )
#endif // _WIN32

// usign cocos2d namespace
USING_NS_CC;

// log a line with the format <class::function> : <data to be loged> -> <file>(<line number>)
#define UTILS_LOG(s, ...) \
CCLOG("%s : %s -> %s (%d)",__FUNCTION__, CCString::createWithFormat(s, ##__VA_ARGS__)->getCString(),__FILE__,__LINE__)

// Replace for CC_BREAK_IF that logs when condintion is true
#define UTILS_BREAK_IF(cond) \
if(cond) \
{ \
UTILS_LOG("(%s)",""#cond""); \
break; \
}

// subtract color2 from color 1
#define COLORS3_SUB(color1,color2) ccc3(color1.r-color2.r,color1.g-color2.g,color1.b-color2.b)

// add color 2 to color 1
#define COLORS3_ADD(color1,color2) ccc3(color1.r+color2.r,color1.g+color2.g,color1.b+color2.b)

// multiplies color components by a factor
#define COLORS3_MUL(color,factor) ccc3(color.r*factor,color.g*factor,color.b*factor)

// interpolate two colors by a factor
#define COLORS3_INTERPOLATE(color1,color2,factor) \
ccc3( \
color1.r + ( color2.r - color1.r )  * colorScale , \
color1.g + ( color2.g - color1.g )  * colorScale , \
color1.b + ( color2.b - color1.b )  * colorScale \
)

#endif  // __UTILS_H__