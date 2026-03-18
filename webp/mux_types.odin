// Copyright 2012 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
// Data-types common to the mux and demux libraries.
//
// Author: Urvang (urvang@google.com)
package webp

import "core:c"

_ :: c

foreign import lib { LIB, LIBDEMUX, LIBMUX }

// VP8X Feature Flags.
WebPFeatureFlags :: enum c.int {
	ANIMATION_FLAG  = 2,
	XMP_FLAG        = 4,
	EXIF_FLAG       = 8,
	ALPHA_FLAG      = 16,
	ICCP_FLAG       = 32,
	ALL_VALID_FLAGS = 62,
}

// Dispose method (animation only). Indicates how the area used by the current
// frame is to be treated before rendering the next frame on the canvas.
WebPMuxAnimDispose :: enum c.int {
	NONE,       // Do not dispose.
	BACKGROUND, // Dispose to background color.
}

// Blend operation (animation only). Indicates how transparent pixels of the
// current frame are blended with those of the previous canvas.
WebPMuxAnimBlend :: enum c.int {
	BLEND,    // Blend.
	NO_BLEND, // Do not blend.
}

// Data type used to describe 'raw' data, e.g., chunk data
// (ICC profile, metadata) and WebP compressed image data.
// 'bytes' memory must be allocated using WebPMalloc() and such.
WebPData :: struct {
	bytes: ^u8,
	size:  uint,
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	// Initializes the contents of the 'webp_data' object with default values.
	WebPDataInit :: proc(webp_data: ^WebPData) ---

	// Clears the contents of the 'webp_data' object by calling WebPFree().
	// Does not deallocate the object itself.
	WebPDataClear :: proc(webp_data: ^WebPData) ---

	// Allocates necessary storage for 'dst' and copies the contents of 'src'.
	// Returns true on success.
	WebPDataCopy :: proc(src: ^WebPData, dst: ^WebPData) -> i32 ---
}
