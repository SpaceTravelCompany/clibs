// Copyright 2012 Google Inc. All Rights Reserved.
//
// Use of this source code is governed by a BSD-style license
// that can be found in the COPYING file in the root of the source
// tree. An additional intellectual property rights grant can be found
// in the file PATENTS. All contributing project authors may
// be found in the AUTHORS file in the root of the source tree.
// -----------------------------------------------------------------------------
//
// Demux API.
// Enables extraction of image and extended format data from WebP files.
// Code Example: Demuxing WebP data to extract all the frames, ICC profile
// and EXIF/XMP metadata.
/*
WebPDemuxer* demux = WebPDemux(&webp_data);

uint32_t width = WebPDemuxGetI(demux, WEBP_FF_CANVAS_WIDTH);
uint32_t height = WebPDemuxGetI(demux, WEBP_FF_CANVAS_HEIGHT);
// ... (Get information about the features present in the WebP file).
uint32_t flags = WebPDemuxGetI(demux, WEBP_FF_FORMAT_FLAGS);

// ... (Iterate over all frames).
WebPIterator iter;
if (WebPDemuxGetFrame(demux, 1, &iter)) {
do {
// ... (Consume 'iter'; e.g. Decode 'iter.fragment' with WebPDecode(),
// ... and get other frame properties like width, height, offsets etc.
// ... see 'struct WebPIterator' below for more info).
} while (WebPDemuxNextFrame(&iter));
WebPDemuxReleaseIterator(&iter);
}

// ... (Extract metadata).
WebPChunkIterator chunk_iter;
if (flags & ICCP_FLAG) WebPDemuxGetChunk(demux, "ICCP", 1, &chunk_iter);
// ... (Consume the ICC profile in 'chunk_iter.chunk').
WebPDemuxReleaseChunkIterator(&chunk_iter);
if (flags & EXIF_FLAG) WebPDemuxGetChunk(demux, "EXIF", 1, &chunk_iter);
// ... (Consume the EXIF metadata in 'chunk_iter.chunk').
WebPDemuxReleaseChunkIterator(&chunk_iter);
if (flags & XMP_FLAG) WebPDemuxGetChunk(demux, "XMP ", 1, &chunk_iter);
// ... (Consume the XMP metadata in 'chunk_iter.chunk').
WebPDemuxReleaseChunkIterator(&chunk_iter);
WebPDemuxDelete(demux);
*/
package webp

import "core:c"

_ :: c

foreign import lib { LIB, LIBDEMUX, LIBMUX }

WebPDemuxer :: struct {}
WebPAnimDecoder :: struct {}


WEBP_DEMUX_ABI_VERSION :: 0x0107    // MAJOR(8b) + MINOR(8b)

//------------------------------------------------------------------------------
// Life of a Demux object
WebPDemuxState :: enum c.int {
	PARSE_ERROR    = -1, // An error occurred while parsing.
	PARSING_HEADER = 0,  // Not enough data to parse full header.
	PARSED_HEADER  = 1,  // Header parsing complete,
                                   // data may be available.
	DONE           = 2,  // Entire file has been parsed.
}

//------------------------------------------------------------------------------
// Data/information extraction.
WebPFormatFeature :: enum c.int {
	FORMAT_FLAGS,     // bit-wise combination of WebPFeatureFlags
                             // corresponding to the 'VP8X' chunk (if present).
	CANVAS_WIDTH,
	CANVAS_HEIGHT,
	LOOP_COUNT,       // only relevant for animated file
	BACKGROUND_COLOR, // idem.
	FRAME_COUNT,      // Number of frames present in the demux object.
                             // In case of a partial demux, this is the number
                             // of frames seen so far, with the last frame
                             // possibly being partial.
}

//------------------------------------------------------------------------------
// Frame iteration.
WebPIterator :: struct {
	frame_num:          i32,
	num_frames:         i32,                // equivalent to WEBP_FF_FRAME_COUNT.
	x_offset, y_offset: i32,                // offset relative to the canvas.
	width, height:      i32,                // dimensions of this frame.
	duration:           i32,                // display duration in milliseconds.
	dispose_method:     WebPMuxAnimDispose, // dispose method for the frame.
	complete:           i32,                // true if 'fragment' contains a full frame. partial images
                  // may still be decoded with the WebP incremental decoder.
	fragment:           WebPData,           // The frame given by 'frame_num'. Note for historical
                      // reasons this is called a fragment.
	has_alpha:          i32,                // True if the frame contains transparency.
	blend_method:       WebPMuxAnimBlend,   // Blend operation for the frame.
	pad:                [2]u32,             // padding for later use.
	private_:           rawptr,             // for internal use only.
}

//------------------------------------------------------------------------------
// Chunk iteration.
WebPChunkIterator :: struct {
	// The current and total number of chunks with the fourcc given to
	// WebPDemuxGetChunk().
	chunk_num: i32,
	num_chunks: i32,
	chunk:      WebPData, // The payload of the chunk.
	pad:        [6]u32,   // padding for later use
	private_:   rawptr,
}

// Global options.
WebPAnimDecoderOptions :: struct {
	// Output colorspace. Only the following modes are supported:
	// MODE_RGBA, MODE_BGRA, MODE_rgbA and MODE_bgrA.
	color_mode: CSP_MODE,
	use_threads: i32,    // If true, use multi-threaded decoding.
	padding:     [7]u32, // Padding for later use.
}

// Global information about the animation..
WebPAnimInfo :: struct {
	canvas_width:  u32,
	canvas_height: u32,
	loop_count:    u32,
	bgcolor:       u32,
	frame_count:   u32,
	pad:           [4]u32, // padding for later use
}

@(default_calling_convention="c", link_prefix="")
foreign lib {
	// Returns the version number of the demux library, packed in hexadecimal using
	// 8bits for each of major/minor/revision. E.g: v2.5.7 is 0x020507.
	WebPGetDemuxVersion :: proc() -> i32 ---

	// Internal, version-checked, entry point
	WebPDemuxInternal :: proc(^WebPData, i32, ^WebPDemuxState, i32) -> ^WebPDemuxer ---

	// Parses the full WebP file given by 'data'. For single images the WebP file
	// header alone or the file header and the chunk header may be absent.
	// Returns a WebPDemuxer object on successful parse, NULL otherwise.
	WebPDemux :: proc(data: ^WebPData) -> ^WebPDemuxer ---

	// Parses the possibly incomplete WebP file given by 'data'.
	// If 'state' is non-NULL it will be set to indicate the status of the demuxer.
	// Returns NULL in case of error or if there isn't enough data to start parsing;
	// and a WebPDemuxer object on successful parse.
	// Note that WebPDemuxer keeps internal pointers to 'data' memory segment.
	// If this data is volatile, the demuxer object should be deleted (by calling
	// WebPDemuxDelete()) and WebPDemuxPartial() called again on the new data.
	// This is usually an inexpensive operation.
	WebPDemuxPartial :: proc(data: ^WebPData, state: ^WebPDemuxState) -> ^WebPDemuxer ---

	// Frees memory associated with 'dmux'.
	WebPDemuxDelete :: proc(dmux: ^WebPDemuxer) ---

	// Get the 'feature' value from the 'dmux'.
	// NOTE: values are only valid if WebPDemux() was used or WebPDemuxPartial()
	// returned a state > WEBP_DEMUX_PARSING_HEADER.
	// If 'feature' is WEBP_FF_FORMAT_FLAGS, the returned value is a bit-wise
	// combination of WebPFeatureFlags values.
	// If 'feature' is WEBP_FF_LOOP_COUNT, WEBP_FF_BACKGROUND_COLOR, the returned
	// value is only meaningful if the bitstream is animated.
	WebPDemuxGetI :: proc(dmux: ^WebPDemuxer, feature: WebPFormatFeature) -> u32 ---

	// Retrieves frame 'frame_number' from 'dmux'.
	// 'iter->fragment' points to the frame on return from this function.
	// Setting 'frame_number' equal to 0 will return the last frame of the image.
	// Returns false if 'dmux' is NULL or frame 'frame_number' is not present.
	// Call WebPDemuxReleaseIterator() when use of the iterator is complete.
	// NOTE: 'dmux' must persist for the lifetime of 'iter'.
	WebPDemuxGetFrame :: proc(dmux: ^WebPDemuxer, frame_number: i32, iter: ^WebPIterator) -> i32 ---

	// Sets 'iter->fragment' to point to the next ('iter->frame_num' + 1) or
	// previous ('iter->frame_num' - 1) frame. These functions do not loop.
	// Returns true on success, false otherwise.
	WebPDemuxNextFrame :: proc(iter: ^WebPIterator) -> i32 ---
	WebPDemuxPrevFrame :: proc(iter: ^WebPIterator) -> i32 ---

	// Releases any memory associated with 'iter'.
	// Must be called before any subsequent calls to WebPDemuxGetChunk() on the same
	// iter. Also, must be called before destroying the associated WebPDemuxer with
	// WebPDemuxDelete().
	WebPDemuxReleaseIterator :: proc(iter: ^WebPIterator) ---

	// Retrieves the 'chunk_number' instance of the chunk with id 'fourcc' from
	// 'dmux'.
	// 'fourcc' is a character array containing the fourcc of the chunk to return,
	// e.g., "ICCP", "XMP ", "EXIF", etc.
	// Setting 'chunk_number' equal to 0 will return the last chunk in a set.
	// Returns true if the chunk is found, false otherwise. Image related chunk
	// payloads are accessed through WebPDemuxGetFrame() and related functions.
	// Call WebPDemuxReleaseChunkIterator() when use of the iterator is complete.
	// NOTE: 'dmux' must persist for the lifetime of the iterator.
	WebPDemuxGetChunk :: proc(dmux: ^WebPDemuxer, fourcc: cstring, chunk_number: i32, iter: ^WebPChunkIterator) -> i32 ---

	// Sets 'iter->chunk' to point to the next ('iter->chunk_num' + 1) or previous
	// ('iter->chunk_num' - 1) chunk. These functions do not loop.
	// Returns true on success, false otherwise.
	WebPDemuxNextChunk :: proc(iter: ^WebPChunkIterator) -> i32 ---
	WebPDemuxPrevChunk :: proc(iter: ^WebPChunkIterator) -> i32 ---

	// Releases any memory associated with 'iter'.
	// Must be called before destroying the associated WebPDemuxer with
	// WebPDemuxDelete().
	WebPDemuxReleaseChunkIterator :: proc(iter: ^WebPChunkIterator) ---

	// Internal, version-checked, entry point.
	WebPAnimDecoderOptionsInitInternal :: proc(dec_options:^WebPAnimDecoderOptions, version: i32) -> i32 ---

	// Internal, version-checked, entry point.
	WebPAnimDecoderNewInternal :: proc(webp_data:^WebPData, dec_options:^WebPAnimDecoderOptions, version:i32) -> ^WebPAnimDecoder ---


	// Get global information about the animation.
	// Parameters:
	//   dec - (in) decoder instance to get information from.
	//   info - (out) global information fetched from the animation.
	// Returns:
	//   True on success.
	WebPAnimDecoderGetInfo :: proc(dec: ^WebPAnimDecoder, info: ^WebPAnimInfo) -> i32 ---

	// Fetch the next frame from 'dec' based on options supplied to
	// WebPAnimDecoderNew(). This will be a fully reconstructed canvas of size
	// 'canvas_width * 4 * canvas_height', and not just the frame sub-rectangle. The
	// returned buffer 'buf' is valid only until the next call to
	// WebPAnimDecoderGetNext(), WebPAnimDecoderReset() or WebPAnimDecoderDelete().
	// Parameters:
	//   dec - (in/out) decoder instance from which the next frame is to be fetched.
	//   buf - (out) decoded frame.
	//   timestamp - (out) timestamp of the frame in milliseconds.
	// Returns:
	//   False if any of the arguments are NULL, or if there is a parsing or
	//   decoding error, or if there are no more frames. Otherwise, returns true.
	WebPAnimDecoderGetNext :: proc(dec: ^WebPAnimDecoder, buf: ^[^]u8, timestamp: ^i32) -> i32 ---

	// Check if there are more frames left to decode.
	// Parameters:
	//   dec - (in) decoder instance to be checked.
	// Returns:
	//   True if 'dec' is not NULL and some frames are yet to be decoded.
	//   Otherwise, returns false.
	WebPAnimDecoderHasMoreFrames :: proc(dec: ^WebPAnimDecoder) -> i32 ---

	// Resets the WebPAnimDecoder object, so that next call to
	// WebPAnimDecoderGetNext() will restart decoding from 1st frame. This would be
	// helpful when all frames need to be decoded multiple times (e.g.
	// info.loop_count times) without destroying and recreating the 'dec' object.
	// Parameters:
	//   dec - (in/out) decoder instance to be reset
	WebPAnimDecoderReset :: proc(dec: ^WebPAnimDecoder) ---

	// Grab the internal demuxer object.
	// Getting the demuxer object can be useful if one wants to use operations only
	// available through demuxer; e.g. to get XMP/EXIF/ICC metadata. The returned
	// demuxer object is owned by 'dec' and is valid only until the next call to
	// WebPAnimDecoderDelete().
	//
	// Parameters:
	//   dec - (in) decoder instance from which the demuxer object is to be fetched.
	WebPAnimDecoderGetDemuxer :: proc(dec: ^WebPAnimDecoder) -> ^WebPDemuxer ---

	// Deletes the WebPAnimDecoder object.
	// Parameters:
	//   dec - (in/out) decoder instance to be deleted
	WebPAnimDecoderDelete :: proc(dec: ^WebPAnimDecoder) ---
}

// Should always be called, to initialize a fresh WebPAnimDecoderOptions
// structure before modification. Returns false in case of version mismatch.
// WebPAnimDecoderOptionsInit() must have succeeded before using the
// 'dec_options' object.
WebPAnimDecoderOptionsInit :: #force_inline proc "contextless" (dec_options: ^WebPAnimDecoderOptions) -> i32 {
	return WebPAnimDecoderOptionsInitInternal(dec_options, WEBP_DEMUX_ABI_VERSION)
}

// Creates and initializes a WebPAnimDecoder object.
// Parameters:
//   webp_data - (in) WebP bitstream. This should remain unchanged during the
//                    lifetime of the output WebPAnimDecoder object.
//   dec_options - (in) decoding options. Can be passed NULL to choose
//                      reasonable defaults (in particular, color mode MODE_RGBA
//                      will be picked).
// Returns:
//   A pointer to the newly created WebPAnimDecoder object, or NULL in case of
//   parsing error, invalid option or memory error.
WebPAnimDecoderNew :: #force_inline proc "contextless"(webp_data: ^WebPData, dec_options: ^WebPAnimDecoderOptions) -> ^WebPAnimDecoder {
	return WebPAnimDecoderNewInternal(webp_data, dec_options, WEBP_DEMUX_ABI_VERSION)
}