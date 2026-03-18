// Copyright 2010 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
//  Common types + memory wrappers
//
// Author: Skal (pascal.massimino@gmail.com)
package webp

import "core:c"

_ :: c

foreign import lib { LIB, LIBDEMUX, LIBMUX }

// WEBP_INLINE :: inline

@(default_calling_convention="c", link_prefix="")
foreign lib {
	// Allocates 'size' bytes of memory. Returns NULL upon error. Memory
	// must be deallocated by calling WebPFree(). This function is made available
	// by the core 'libwebp' library.
	WebPMalloc :: proc(size: uint) -> rawptr ---

	// Releases memory returned by the WebPDecode*() functions (from decode.h).
	WebPFree :: proc(ptr: rawptr) ---
}
