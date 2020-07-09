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

#ifndef HOLO_LOCK
#define HOLO_LOCK(lock) dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
#endif

#ifndef HOLO_UNLOCK
#define HOLO_UNLOCK(lock) dispatch_semaphore_signal(lock);
#endif

#endif /* HoloTargetMacro_h */
