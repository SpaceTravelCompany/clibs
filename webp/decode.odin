// Copyright 2010 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
//  Main decoding functions for WebP images.
//
// Author: Skal (pascal.massimino@gmail.com)
package webp

import "core:c"

_ :: c

foreign import lib {LIB, LIBDEMUX, LIBMUX}


WebPIDecoder :: struct {}

WEBP_DECODER_ABI_VERSION :: 0x0210 // MAJOR(8b) + MINOR(8b)

// Colorspaces
// Note: the naming describes the byte-ordering of packed samples in memory.
// For instance, MODE_BGRA relates to samples ordered as B,G,R,A,B,G,R,A,...
// Non-capital names (e.g.:MODE_Argb) relates to pre-multiplied RGB channels.
// RGBA-4444 and RGB-565 colorspaces are represented by following byte-order:
// RGBA-4444: [r3 r2 r1 r0 g3 g2 g1 g0], [b3 b2 b1 b0 a3 a2 a1 a0], ...
// RGB-565: [r4 r3 r2 r1 r0 g5 g4 g3], [g2 g1 g0 b4 b3 b2 b1 b0], ...
// In the case WEBP_SWAP_16BITS_CSP is defined, the bytes are swapped for
// these two modes:
// RGBA-4444: [b3 b2 b1 b0 a3 a2 a1 a0], [r3 r2 r1 r0 g3 g2 g1 g0], ...
// RGB-565: [g2 g1 g0 b4 b3 b2 b1 b0], [r4 r3 r2 r1 r0 g5 g4 g3], ...
CSP_MODE :: enum c.int {
	RGB       = 0,
	RGBA      = 1,
	BGR       = 2,
	BGRA      = 3,
	ARGB      = 4,
	RGBA_4444 = 5,
	RGB_565   = 6,

	// RGB-premultiplied transparent modes (alpha value is preserved)
	rgbA      = 7,

	// RGB-premultiplied transparent modes (alpha value is preserved)
	bgrA      = 8,

	// RGB-premultiplied transparent modes (alpha value is preserved)
	Argb      = 9,

	// RGB-premultiplied transparent modes (alpha value is preserved)
	rgbA_4444 = 10,
	YUV       = 11, // yuv 4:2:0
	YUVA      = 12, // yuv 4:2:0
	LAST      = 13,
}

//------------------------------------------------------------------------------
// WebPDecBuffer: Generic structure for describing the output sample buffer.
WebPRGBABuffer :: struct {
	rgba:   ^u8, // pointer to RGBA samples
	stride: i32, // stride in bytes from one scanline to the next.
	size:   uint, // total size of the *rgba buffer.
}

WebPYUVABuffer :: struct {
	y, u, v, a:         ^u8, // pointer to luma, chroma U/V, alpha samples
	y_stride:           i32, // luma stride
	u_stride, v_stride: i32, // chroma strides
	a_stride:           i32, // alpha stride
	y_size:             uint, // luma plane size
	u_size, v_size:     uint, // chroma planes size
	a_size:             uint, // alpha-plane size
}

// Output buffer
WebPDecBuffer :: struct {
	colorspace:         CSP_MODE, // Colorspace.
	width, height:      i32, // Dimensions.
	is_external_memory: i32, // If non-zero, 'internal_memory' pointer is not
	// used. If value is '2' or more, the external
	// memory is considered 'slow' and multiple
	// read/write will be avoided.
	u:                  struct #raw_union {
		RGBA: WebPRGBABuffer,
		YUVA: WebPYUVABuffer,
	}, // Nameless union of buffer parameters.
	pad:                [4]u32, // padding for later use
	private_memory:     ^u8, // Internally allocated memory (only when
	// is_external_memory is 0). Should not be used
	// externally, but accessed via the buffer union.
}

//------------------------------------------------------------------------------
// Enumeration of the status codes
VP8StatusCode :: enum c.int {
	OK = 0,
	OUT_OF_MEMORY,
	INVALID_PARAM,
	BITSTREAM_ERROR,
	UNSUPPORTED_FEATURE,
	SUSPENDED,
	USER_ABORT,
	NOT_ENOUGH_DATA,
}

// Features gathered from the bitstream
WebPBitstreamFeatures :: struct {
	width:         i32, // Width in pixels, as read from the bitstream.
	height:        i32, // Height in pixels, as read from the bitstream.
	has_alpha:     b32, // True if the bitstream contains an alpha channel.
	has_animation: b32, // True if the bitstream is an animation.
	format:        i32, // 0 = undefined (/mixed), 1 = lossy, 2 = lossless
	pad:           [5]u32, // padding for later use
}

// Decoding options
WebPDecoderOptions :: struct {
	bypass_filtering:            b32, // if true, skip the in-loop filtering
	no_fancy_upsampling:         b32, // if true, use faster pointwise upsampler
	use_cropping:                b32, // if true, cropping is applied _first_
	crop_left, crop_top:         i32, // top-left position for cropping.
	// Will be snapped to even values.
	crop_width, crop_height:     i32, // dimension of the cropping area
	use_scaling:                 b32, // if true, scaling is applied _afterward_
	scaled_width, scaled_height: i32, // final resolution
	use_threads:                 b32, // if true, use multi-threaded decoding
	dithering_strength:          i32, // dithering strength (0=Off, 100=full)
	flip:                        b32, // if true, flip output vertically
	alpha_dithering_strength:    i32, // alpha dithering strength in [0..100]
	pad:                         [5]u32, // padding for later use
}

// Main object storing the configuration for advanced decoding.
WebPDecoderConfig :: struct {
	input:   WebPBitstreamFeatures, // Immutable bitstream features (optional)
	output:  WebPDecBuffer, // Output buffer (can point to external mem)
	options: WebPDecoderOptions, // Decoding options
}

@(default_calling_convention = "c")
foreign lib {
	// Return the decoder's version number, packed in hexadecimal using 8bits for
	// each of major/minor/revision. E.g: v2.5.7 is 0x020507.
	WebPGetDecoderVersion :: proc() -> i32 ---

	// Retrieve basic header information: width, height.
	// This function will also validate the header, returning true on success,
	// false otherwise. '*width' and '*height' are only valid on successful return.
	// Pointers 'width' and 'height' can be passed NULL if deemed irrelevant.
	// Note: The following chunk sequences (before the raw VP8/VP8L data) are
	// considered valid by this function:
	// RIFF + VP8(L)
	// RIFF + VP8X + (optional chunks) + VP8(L)
	// ALPH + VP8 <-- Not a valid WebP format: only allowed for internal purpose.
	// VP8(L)     <-- Not a valid WebP format: only allowed for internal purpose.
	WebPGetInfo :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> i32 ---

	// Decodes WebP images pointed to by 'data' and returns RGBA samples, along
	// with the dimensions in *width and *height. The ordering of samples in
	// memory is R, G, B, A, R, G, B, A... in scan order (endian-independent).
	// The returned pointer should be deleted calling WebPFree().
	// Returns NULL in case of error.
	WebPDecodeRGBA :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> ^u8 ---

	// Same as WebPDecodeRGBA, but returning A, R, G, B, A, R, G, B... ordered data.
	WebPDecodeARGB :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> ^u8 ---

	// Same as WebPDecodeRGBA, but returning B, G, R, A, B, G, R, A... ordered data.
	WebPDecodeBGRA :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> ^u8 ---

	// Same as WebPDecodeRGBA, but returning R, G, B, R, G, B... ordered data.
	// If the bitstream contains transparency, it is ignored.
	WebPDecodeRGB :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> ^u8 ---

	// Same as WebPDecodeRGB, but returning B, G, R, B, G, R... ordered data.
	WebPDecodeBGR :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32) -> ^u8 ---

	// Decode WebP images pointed to by 'data' to Y'UV format(*). The pointer
	// returned is the Y samples buffer. Upon return, *u and *v will point to
	// the U and V chroma data. These U and V buffers need NOT be passed to
	// WebPFree(), unlike the returned Y luma one. The dimension of the U and V
	// planes are both (*width + 1) / 2 and (*height + 1) / 2.
	// Upon return, the Y buffer has a stride returned as '*stride', while U and V
	// have a common stride returned as '*uv_stride'.
	// 'width' and 'height' may be NULL, the other pointers must not be.
	// Returns NULL in case of error.
	// (*) Also named Y'CbCr. See: https://en.wikipedia.org/wiki/YCbCr
	WebPDecodeYUV :: proc(data: ^u8, data_size: uint, width: ^i32, height: ^i32, u: ^^u8, v: ^^u8, stride: ^i32, uv_stride: ^i32) -> ^u8 ---

	// These five functions are variants of the above ones, that decode the image
	// directly into a pre-allocated buffer 'output_buffer'. The maximum storage
	// available in this buffer is indicated by 'output_buffer_size'. If this
	// storage is not sufficient (or an error occurred), NULL is returned.
	// Otherwise, output_buffer is returned, for convenience.
	// The parameter 'output_stride' specifies the distance (in bytes)
	// between scanlines. Hence, output_buffer_size is expected to be at least
	// output_stride x picture-height.
	WebPDecodeRGBAInto :: proc(data: ^u8, data_size: uint, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^u8 ---
	WebPDecodeARGBInto :: proc(data: ^u8, data_size: uint, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^u8 ---
	WebPDecodeBGRAInto :: proc(data: ^u8, data_size: uint, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^u8 ---

	// RGB and BGR variants. Here too the transparency information, if present,
	// will be dropped and ignored.
	WebPDecodeRGBInto :: proc(data: ^u8, data_size: uint, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^u8 ---
	WebPDecodeBGRInto :: proc(data: ^u8, data_size: uint, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^u8 ---

	// WebPDecodeYUVInto() is a variant of WebPDecodeYUV() that operates directly
	// into pre-allocated luma/chroma plane buffers. This function requires the
	// strides to be passed: one for the luma plane and one for each of the
	// chroma ones. The size of each plane buffer is passed as 'luma_size',
	// 'u_size' and 'v_size' respectively.
	// Pointer to the luma plane ('*luma') is returned or NULL if an error occurred
	// during decoding (or because some buffers were found to be too small).
	WebPDecodeYUVInto :: proc(data: ^u8, data_size: uint, luma: ^u8, luma_size: uint, luma_stride: i32, u: ^u8, u_size: uint, u_stride: i32, v: ^u8, v_size: uint, v_stride: i32) -> ^u8 ---

	WebPIsPremultipliedMode :: proc(mode: CSP_MODE) -> i32 ---
	WebPIsAlphaMode :: proc(mode: CSP_MODE) -> i32 ---
	WebPIsRGBMode :: proc(mode: CSP_MODE) -> i32 ---

	// Internal, version-checked, entry point
	WebPInitDecBufferInternal :: proc(buffer: ^WebPDecBuffer, version: i32) -> i32 ---


	// Free any memory associated with the buffer. Must always be called last.
	// Note: doesn't free the 'buffer' structure itself.
	WebPFreeDecBuffer :: proc(buffer: ^WebPDecBuffer) ---

	// Creates a new incremental decoder with the supplied buffer parameter.
	// This output_buffer can be passed NULL, in which case a default output buffer
	// is used (with MODE_RGB). Otherwise, an internal reference to 'output_buffer'
	// is kept, which means that the lifespan of 'output_buffer' must be larger than
	// that of the returned WebPIDecoder object.
	// The supplied 'output_buffer' content MUST NOT be changed between calls to
	// WebPIAppend() or WebPIUpdate() unless 'output_buffer.is_external_memory' is
	// not set to 0. In such a case, it is allowed to modify the pointers, size and
	// stride of output_buffer.u.RGBA or output_buffer.u.YUVA, provided they remain
	// within valid bounds.
	// All other fields of WebPDecBuffer MUST remain constant between calls.
	// Returns NULL if the allocation failed.
	WebPINewDecoder :: proc(output_buffer: ^WebPDecBuffer) -> ^WebPIDecoder ---

	// This function allocates and initializes an incremental-decoder object, which
	// will output the RGB/A samples specified by 'csp' into a preallocated
	// buffer 'output_buffer'. The size of this buffer is at least
	// 'output_buffer_size' and the stride (distance in bytes between two scanlines)
	// is specified by 'output_stride'.
	// Additionally, output_buffer can be passed NULL in which case the output
	// buffer will be allocated automatically when the decoding starts. The
	// colorspace 'csp' is taken into account for allocating this buffer. All other
	// parameters are ignored.
	// Returns NULL if the allocation failed, or if some parameters are invalid.
	WebPINewRGB :: proc(csp: CSP_MODE, output_buffer: ^u8, output_buffer_size: uint, output_stride: i32) -> ^WebPIDecoder ---

	// This function allocates and initializes an incremental-decoder object, which
	// will output the raw luma/chroma samples into a preallocated planes if
	// supplied. The luma plane is specified by its pointer 'luma', its size
	// 'luma_size' and its stride 'luma_stride'. Similarly, the chroma-u plane
	// is specified by the 'u', 'u_size' and 'u_stride' parameters, and the chroma-v
	// plane by 'v' and 'v_size'. And same for the alpha-plane. The 'a' pointer
	// can be pass NULL in case one is not interested in the transparency plane.
	// Conversely, 'luma' can be passed NULL if no preallocated planes are supplied.
	// In this case, the output buffer will be automatically allocated (using
	// MODE_YUVA) when decoding starts. All parameters are then ignored.
	// Returns NULL if the allocation failed or if a parameter is invalid.
	WebPINewYUVA :: proc(luma: ^u8, luma_size: uint, luma_stride: i32, u: ^u8, u_size: uint, u_stride: i32, v: ^u8, v_size: uint, v_stride: i32, a: ^u8, a_size: uint, a_stride: i32) -> ^WebPIDecoder ---

	// Deprecated version of the above, without the alpha plane.
	// Kept for backward compatibility.
	WebPINewYUV :: proc(luma: ^u8, luma_size: uint, luma_stride: i32, u: ^u8, u_size: uint, u_stride: i32, v: ^u8, v_size: uint, v_stride: i32) -> ^WebPIDecoder ---

	// Deletes the WebPIDecoder object and associated memory. Must always be called
	// if WebPINewDecoder, WebPINewRGB or WebPINewYUV succeeded.
	WebPIDelete :: proc(idec: ^WebPIDecoder) ---

	// Copies and decodes the next available data. Returns VP8_STATUS_OK when
	// the image is successfully decoded. Returns VP8_STATUS_SUSPENDED when more
	// data is expected. Returns error in other cases.
	WebPIAppend :: proc(idec: ^WebPIDecoder, data: ^u8, data_size: uint) -> VP8StatusCode ---

	// A variant of the above function to be used when data buffer contains
	// partial data from the beginning. In this case data buffer is not copied
	// to the internal memory.
	// Note that the value of the 'data' pointer can change between calls to
	// WebPIUpdate, for instance when the data buffer is resized to fit larger data.
	WebPIUpdate :: proc(idec: ^WebPIDecoder, data: ^u8, data_size: uint) -> VP8StatusCode ---

	// Returns the RGB/A image decoded so far. Returns NULL if output params
	// are not initialized yet. The RGB/A output type corresponds to the colorspace
	// specified during call to WebPINewDecoder() or WebPINewRGB().
	// *last_y is the index of last decoded row in raster scan order. Some pointers
	// (*last_y, *width etc.) can be NULL if corresponding information is not
	// needed. The values in these pointers are only valid on successful (non-NULL)
	// return.
	WebPIDecGetRGB :: proc(idec: ^WebPIDecoder, last_y: ^i32, width: ^i32, height: ^i32, stride: ^i32) -> ^u8 ---

	// Same as above function to get a YUVA image. Returns pointer to the luma
	// plane or NULL in case of error. If there is no alpha information
	// the alpha pointer '*a' will be returned NULL.
	WebPIDecGetYUVA :: proc(idec: ^WebPIDecoder, last_y: ^i32, u: ^^u8, v: ^^u8, a: ^^u8, width: ^i32, height: ^i32, stride: ^i32, uv_stride: ^i32, a_stride: ^i32) -> ^u8 ---

	// Deprecated alpha-less version of WebPIDecGetYUVA(): it will ignore the
	// alpha information (if present). Kept for backward compatibility.
	WebPIDecGetYUV :: proc(idec: ^WebPIDecoder, last_y: ^i32, u: ^^u8, v: ^^u8, width: ^i32, height: ^i32, stride: ^i32, uv_stride: ^i32) -> ^u8 ---

	// Generic call to retrieve information about the displayable area.
	// If non NULL, the left/right/width/height pointers are filled with the visible
	// rectangular area so far.
	// Returns NULL in case the incremental decoder object is in an invalid state.
	// Otherwise returns the pointer to the internal representation. This structure
	// is read-only, tied to WebPIDecoder's lifespan and should not be modified.
	WebPIDecodedArea :: proc(idec: ^WebPIDecoder, left: ^i32, top: ^i32, width: ^i32, height: ^i32) -> ^WebPDecBuffer ---

	// Internal, version-checked, entry point
	WebPGetFeaturesInternal :: proc(data: ^u8, data_size: uint, features: ^WebPBitstreamFeatures, version: i32) -> VP8StatusCode ---

	// Internal, version-checked, entry point
	WebPInitDecoderConfigInternal :: proc(config: ^WebPDecoderConfig, version: i32) -> i32 ---


	// Instantiate a new incremental decoder object with the requested
	// configuration. The bitstream can be passed using 'data' and 'data_size'
	// parameter, in which case the features will be parsed and stored into
	// config->input. Otherwise, 'data' can be NULL and no parsing will occur.
	// Note that 'config' can be NULL too, in which case a default configuration
	// is used. If 'config' is not NULL, it must outlive the WebPIDecoder object
	// as some references to its fields will be used. No internal copy of 'config'
	// is made.
	// The return WebPIDecoder object must always be deleted calling WebPIDelete().
	// Returns NULL in case of error (and config->status will then reflect
	// the error condition, if available).
	WebPIDecode :: proc(data: ^u8, data_size: uint, config: ^WebPDecoderConfig) -> ^WebPIDecoder ---

	// Non-incremental version. This version decodes the full data at once, taking
	// 'config' into account. Returns decoding status (which should be VP8_STATUS_OK
	// if the decoding was successful). Note that 'config' cannot be NULL.
	WebPDecode :: proc(data: ^u8, data_size: uint, config: ^WebPDecoderConfig) -> VP8StatusCode ---
}


// Initialize the structure as empty. Must be called before any other use.
// Returns false in case of version mismatch
WebPInitDecBuffer :: #force_inline proc "contextless" (buffer: ^WebPDecBuffer) -> i32 {
	return WebPInitDecBufferInternal(buffer, WEBP_DECODER_ABI_VERSION)
}

// Retrieve features from the bitstream. The *features structure is filled
// with information gathered from the bitstream.
// Returns VP8_STATUS_OK when the features are successfully retrieved. Returns
// VP8_STATUS_NOT_ENOUGH_DATA when more data is needed to retrieve the
// features from headers. Returns error in other cases.
// Note: The following chunk sequences (before the raw VP8/VP8L data) are
// considered valid by this function:
// RIFF + VP8(L)
// RIFF + VP8X + (optional chunks) + VP8(L)
// ALPH + VP8 <-- Not a valid WebP format: only allowed for internal purpose.
// VP8(L)     <-- Not a valid WebP format: only allowed for internal purpose.
WebPGetFeatures :: #force_inline proc "contextless" (
	data: ^u8,
	data_size: uint,
	features: ^WebPBitstreamFeatures,
) -> VP8StatusCode {
	return WebPGetFeaturesInternal(data, data_size, features, WEBP_DECODER_ABI_VERSION)
}

// Initialize the configuration as empty. This function must always be
// called first, unless WebPGetFeatures() is to be called.
// Returns false in case of mismatched version.
WebPInitDecoderConfig :: #force_inline proc "contextless" (config: ^WebPDecoderConfig) -> i32 {
	return WebPInitDecoderConfigInternal(config, WEBP_DECODER_ABI_VERSION)
}
