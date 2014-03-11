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
#else
#define BT_SUPER_DEALLOC [super dealloc]
#endif

#endif
