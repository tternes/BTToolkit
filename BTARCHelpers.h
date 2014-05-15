//
//  BTARCHelpers.h
//  BTToolkit
//
//  Created by Thaddeus on 3/10/14.
//  Copyright (c) 2014 Bluetoo. All rights reserved.
//

#ifndef BTToolkit_BTARCHelpers_h
#define BTToolkit_BTARCHelpers_h

#if __has_feature(objc_arc)
#define BT_SUPER_DEALLOC
#define BT_RELEASE_SELF
#else
#define BT_SUPER_DEALLOC [super dealloc]
#define BT_RELEASE_SELF [self release]
#endif

#endif
