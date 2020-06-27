//
//  HoloTargetMacro.h
//  HoloTarget
//
//  Created by 与佳期 on 2020/6/26.
//

#ifndef HoloTargetMacro_h
#define HoloTargetMacro_h

#ifdef DEBUG
#define HoloLog(...) NSLog(__VA_ARGS__)
#else
#define HoloLog(...)
#endif

#endif /* HoloTargetMacro_h */
