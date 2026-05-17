// Bindings for [[libjxl ; https://github.com/libjxl/libjxl]]
package libjxl

import "core:c"
import "shared:utils_private/library"

@(private)
BROTLI_COMMON_LIB ::
	"../compress/brotli/" + library.LIBPATH + "/libbrotlicommon" + library.ARCH_end
@(private)
BROTLI_DEC_LIB :: "../compress/brotli/" + library.LIBPATH + "/libbrotlidec" + library.ARCH_end
@(private)
BROTLI_ENC_LIB :: "../compress/brotli/" + library.LIBPATH + "/libbrotlienc" + library.ARCH_end

@(private)
LIB :: library.LIBPATH + "/libjxl" + library.ARCH_end
@(private)
LIB_THREADS :: library.LIBPATH + "/libjxl_threads" + library.ARCH_end
@(private)
LIB_CMS :: library.LIBPATH + "/libjxl_cms" + library.ARCH_end

foreign import lib {LIB, LIB_THREADS, LIB_CMS, BROTLI_DEC_LIB, BROTLI_ENC_LIB, BROTLI_COMMON_LIB, "../compress/zlib-ng/" + library.LIBPATH + "/libz" + library.ARCH_end}

VERSION_MAJOR :: 0
VERSION_MINOR :: 12
VERSION_PATCH :: 0
NUMERIC_VERSION :: VERSION_MAJOR << 24 | VERSION_MINOR << 16 | VERSION_PATCH << 8


Bool :: library.BOOL

TRUE :: Bool(true)
FALSE :: Bool(false)

PARALLEL_RET_SUCCESS :: 0
PARALLEL_RET_RUNNER_ERROR :: -1

Data_Type :: enum c.int {
	FLOAT   = 0,
	UINT8   = 2,
	UINT16  = 3,
	FLOAT16 = 5,
}

Endianness :: enum c.int {
	NATIVE_ENDIAN = 0,
	LITTLE_ENDIAN = 1,
	BIG_ENDIAN    = 2,
}

Pixel_Format :: struct {
	num_channels: u32,
	data_type:    Data_Type,
	endianness:   Endianness,
	align:        c.size_t,
}

Bit_Depth_Type :: enum c.int {
	FROM_PIXEL_FORMAT = 0,
	FROM_CODESTREAM   = 1,
	CUSTOM            = 2,
}

Bit_Depth :: struct {
	type:                     Bit_Depth_Type,
	bits_per_sample:          u32,
	exponent_bits_per_sample: u32,
}

Box_Type :: [4]c.char

Parallel_Ret_Code :: c.int

Parallel_Run_Init :: #type proc "c" (
	jpegxl_opaque: rawptr,
	num_threads: c.size_t,
) -> Parallel_Ret_Code
Parallel_Run_Function :: #type proc "c" (jpegxl_opaque: rawptr, value: u32, thread_id: c.size_t)
Parallel_Runner :: #type proc "c" (
	runner_opaque: rawptr,
	jpegxl_opaque: rawptr,
	init: Parallel_Run_Init,
	func: Parallel_Run_Function,
	start_range: u32,
	end_range: u32,
) -> Parallel_Ret_Code

Alloc_Func :: #type proc "c" (opaque: rawptr, size: c.size_t) -> rawptr
Free_Func :: #type proc "c" (opaque: rawptr, address: rawptr)

Memory_Manager :: struct {
	opaque: rawptr,
	alloc:  Alloc_Func,
	free:   Free_Func,
}

Color_Space :: enum c.int {
	RGB,
	GRAY,
	XYB,
	UNKNOWN,
}

White_Point :: enum c.int {
	D65    = 1,
	CUSTOM = 2,
	E      = 10,
	DCI    = 11,
}

Primaries :: enum c.int {
	SRGB   = 1,
	CUSTOM = 2,
	P2100  = 9,
	P3     = 11,
}

Transfer_Function :: enum c.int {
	TF_709     = 1,
	TF_UNKNOWN = 2,
	TF_LINEAR  = 8,
	TF_SRGB    = 13,
	TF_PQ      = 16,
	TF_DCI     = 17,
	TF_HLG     = 18,
	TF_GAMMA   = 65535,
}

Rendering_Intent :: enum c.int {
	PERCEPTUAL = 0,
	RELATIVE   = 1,
	SATURATION = 2,
	ABSOLUTE   = 3,
}

Color_Encoding :: struct {
	color_space:        Color_Space,
	white_point:        White_Point,
	white_point_xy:     [2]f64,
	primaries:          Primaries,
	primaries_red_xy:   [2]f64,
	primaries_green_xy: [2]f64,
	primaries_blue_xy:  [2]f64,
	transfer_function:  Transfer_Function,
	gamma:              f64,
	rendering_intent:   Rendering_Intent,
}

Color_Profile_ICC :: struct {
	data: [^]u8,
	size: c.size_t,
}

Color_Profile :: struct {
	icc:            Color_Profile_ICC,
	color_encoding: Color_Encoding,
	num_channels:   c.size_t,
}

CMS_Set_Fields_From_ICC_Func :: #type proc "c" (
	user_data: rawptr,
	icc_data: [^]u8,
	icc_size: c.size_t,
	color: ^Color_Encoding,
	cmyk: ^Bool,
) -> Bool

CMS_Init_Func :: #type proc "c" (
	init_data: rawptr,
	num_threads: c.size_t,
	pixels_per_thread: c.size_t,
	input_profile: ^Color_Profile,
	output_profile: ^Color_Profile,
	intensity_target: f32,
) -> rawptr

CMS_Get_Buffer_Func :: #type proc "c" (user_data: rawptr, thread: c.size_t) -> ^f32
CMS_Run_Func :: #type proc "c" (
	user_data: rawptr,
	thread: c.size_t,
	input_buffer: ^f32,
	output_buffer: ^f32,
	num_pixels: c.size_t,
) -> Bool
CMS_Destroy_Func :: #type proc "c" (user_data: rawptr)

Cms_Interface :: struct {
	set_fields_data:     rawptr,
	set_fields_from_icc: CMS_Set_Fields_From_ICC_Func,
	init_data:           rawptr,
	init:                CMS_Init_Func,
	get_src_buf:         CMS_Get_Buffer_Func,
	get_dst_buf:         CMS_Get_Buffer_Func,
	run:                 CMS_Run_Func,
	destroy:             CMS_Destroy_Func,
}

Orientation :: enum c.int {
	IDENTITY        = 1,
	FLIP_HORIZONTAL = 2,
	ROTATE_180      = 3,
	FLIP_VERTICAL   = 4,
	TRANSPOSE       = 5,
	ROTATE_90_CW    = 6,
	ANTI_TRANSPOSE  = 7,
	ROTATE_90_CCW   = 8,
}

Extra_Channel_Type :: enum c.int {
	ALPHA,
	DEPTH,
	SPOT_COLOR,
	SELECTION_MASK,
	BLACK,
	CFA,
	THERMAL,
	RESERVED0,
	RESERVED1,
	RESERVED2,
	RESERVED3,
	RESERVED4,
	RESERVED5,
	RESERVED6,
	RESERVED7,
	UNKNOWN,
	OPTIONAL,
}

Preview_Header :: struct {
	xsize: u32,
	ysize: u32,
}

Animation_Header :: struct {
	tps_numerator:   u32,
	tps_denominator: u32,
	num_loops:       u32,
	have_timecodes:  Bool,
}

Basic_Info :: struct {
	have_container:           Bool,
	xsize:                    u32,
	ysize:                    u32,
	bits_per_sample:          u32,
	exponent_bits_per_sample: u32,
	intensity_target:         f32,
	min_nits:                 f32,
	relative_to_max_display:  Bool,
	linear_below:             f32,
	uses_original_profile:    Bool,
	have_preview:             Bool,
	have_animation:           Bool,
	orientation:              Orientation,
	num_color_channels:       u32,
	num_extra_channels:       u32,
	alpha_bits:               u32,
	alpha_exponent_bits:      u32,
	alpha_premultiplied:      Bool,
	preview:                  Preview_Header,
	animation:                Animation_Header,
	intrinsic_xsize:          u32,
	intrinsic_ysize:          u32,
	padding:                  [100]u8,
}

Extra_Channel_Info :: struct {
	type:                     Extra_Channel_Type,
	bits_per_sample:          u32,
	exponent_bits_per_sample: u32,
	dim_shift:                u32,
	name_length:              u32,
	alpha_premultiplied:      Bool,
	spot_color:               [4]f32,
	cfa_channel:              u32,
}

Header_Extensions :: struct {
	extensions: u64,
}

Blend_Mode :: enum c.int {
	REPLACE = 0,
	ADD     = 1,
	BLEND   = 2,
	MULADD  = 3,
	MUL     = 4,
}

Blend_Info :: struct {
	blendmode: Blend_Mode,
	source:    u32,
	alpha:     u32,
	clamp:     Bool,
}

Layer_Info :: struct {
	have_crop:         Bool,
	crop_x0:           i32,
	crop_y0:           i32,
	xsize:             u32,
	ysize:             u32,
	blend_info:        Blend_Info,
	save_as_reference: u32,
}

Frame_Header :: struct {
	duration:    u32,
	timecode:    u32,
	name_length: u32,
	is_last:     Bool,
	layer_info:  Layer_Info,
}

Signature :: enum c.int {
	NOT_ENOUGH_BYTES = 0,
	INVALID          = 1,
	CODESTREAM       = 2,
	CONTAINER        = 3,
}

Decoder_Status :: enum c.int {
	SUCCESS                 = 0,
	ERROR                   = 1,
	NEED_MORE_INPUT         = 2,
	NEED_PREVIEW_OUT_BUFFER = 3,
	NEED_IMAGE_OUT_BUFFER   = 5,
	JPEG_NEED_MORE_OUTPUT   = 6,
	BOX_NEED_MORE_OUTPUT    = 7,
	BASIC_INFO              = 0x40,
	COLOR_ENCODING          = 0x100,
	PREVIEW_IMAGE           = 0x200,
	FRAME                   = 0x400,
	FULL_IMAGE              = 0x1000,
	JPEG_RECONSTRUCTION     = 0x2000,
	BOX                     = 0x4000,
	FRAME_PROGRESSION       = 0x8000,
	BOX_COMPLETE            = 0x10000,
}

Progressive_Detail :: enum c.int {
	kFrames        = 0,
	kDC            = 1,
	kLastPasses    = 2,
	kPasses        = 3,
	kDCProgressive = 4,
	kDCGroups      = 5,
	kGroups        = 6,
}

Color_Profile_Target :: enum c.int {
	ORIGINAL = 0,
	DATA     = 1,
}

Decoder :: struct {}
Encoder :: struct {}
Encoder_Frame_Settings :: struct {}
Encoder_Stats :: struct {}

Image_Out_Callback :: #type proc "c" (opaque: rawptr, x, y, num_pixels: c.size_t, pixels: rawptr)
Image_Out_Init_Callback :: #type proc "c" (
	init_opaque: rawptr,
	num_threads, num_pixels_per_thread: c.size_t,
) -> rawptr
Image_Out_Run_Callback :: #type proc "c" (
	run_opaque: rawptr,
	thread_id, x, y, num_pixels: c.size_t,
	pixels: rawptr,
)
Image_Out_Destroy_Callback :: #type proc "c" (run_opaque: rawptr)

Encoder_Status :: enum c.int {
	ENC_SUCCESS          = 0,
	ENC_ERROR            = 1,
	ENC_NEED_MORE_OUTPUT = 2,
}

Encoder_Error :: enum c.int {
	ENC_ERR_OK            = 0,
	ENC_ERR_GENERIC       = 1,
	ENC_ERR_OOM           = 2,
	ENC_ERR_JBRD          = 3,
	ENC_ERR_BAD_INPUT     = 4,
	ENC_ERR_NOT_SUPPORTED = 0x80,
	ENC_ERR_API_USAGE     = 0x81,
}

Encoder_Frame_Setting_Id :: enum c.int {
	EFFORT                           = 0,
	DECODING_SPEED                   = 1,
	RESAMPLING                       = 2,
	EXTRA_CHANNEL_RESAMPLING         = 3,
	ALREADY_DOWNSAMPLED              = 4,
	PHOTON_NOISE                     = 5,
	NOISE                            = 6,
	DOTS                             = 7,
	PATCHES                          = 8,
	EPF                              = 9,
	GABORISH                         = 10,
	MODULAR                          = 11,
	KEEP_INVISIBLE                   = 12,
	GROUP_ORDER                      = 13,
	GROUP_ORDER_CENTER_X             = 14,
	GROUP_ORDER_CENTER_Y             = 15,
	RESPONSIVE                       = 16,
	PROGRESSIVE_AC                   = 17,
	QPROGRESSIVE_AC                  = 18,
	PROGRESSIVE_DC                   = 19,
	CHANNEL_COLORS_GLOBAL_PERCENT    = 20,
	CHANNEL_COLORS_GROUP_PERCENT     = 21,
	PALETTE_COLORS                   = 22,
	LOSSY_PALETTE                    = 23,
	COLOR_TRANSFORM                  = 24,
	MODULAR_COLOR_SPACE              = 25,
	MODULAR_GROUP_SIZE               = 26,
	MODULAR_PREDICTOR                = 27,
	MODULAR_MA_TREE_LEARNING_PERCENT = 28,
	MODULAR_NB_PREV_CHANNELS         = 29,
	JPEG_RECON_CFL                   = 30,
	FRAME_INDEX_BOX                  = 31,
	BROTLI_EFFORT                    = 32,
	JPEG_COMPRESS_BOXES              = 33,
	BUFFERING                        = 34,
	JPEG_KEEP_EXIF                   = 35,
	JPEG_KEEP_XMP                    = 36,
	JPEG_KEEP_JUMBF                  = 37,
	USE_FULL_IMAGE_HEURISTICS        = 38,
	DISABLE_PERCEPTUAL_HEURISTICS    = 39,
	FILL_ENUM                        = 65535,
}

Encoder_Output_Processor :: struct {
	opaque:                 rawptr,
	get_buffer:             proc "c" (opaque: rawptr, size: ^c.size_t) -> rawptr,
	release_buffer:         proc "c" (opaque: rawptr, written_bytes: c.size_t),
	seek:                   proc "c" (opaque: rawptr, position: u64),
	set_finalized_position: proc "c" (opaque: rawptr, finalized_position: u64),
}

Chunked_Frame_Input_Source :: struct {
	opaque:                          rawptr,
	get_color_channels_pixel_format: proc "c" (opaque: rawptr, pixel_format: ^Pixel_Format),
	get_color_channel_data_at:       proc "c" (
		opaque: rawptr,
		xpos, ypos, xsize, ysize: c.size_t,
		row_offset: ^c.size_t,
	) -> rawptr,
	get_extra_channel_pixel_format:  proc "c" (
		opaque: rawptr,
		ec_index: c.size_t,
		pixel_format: ^Pixel_Format,
	),
	get_extra_channel_data_at:       proc "c" (
		opaque: rawptr,
		ec_index, xpos, ypos, xsize, ysize: c.size_t,
		row_offset: ^c.size_t,
	) -> rawptr,
	release_buffer:                  proc "c" (opaque: rawptr, buf: rawptr),
}

Debug_Image_Callback :: #type proc "c" (
	opaque: rawptr,
	label: cstring,
	xsize, ysize: c.size_t,
	color: ^Color_Encoding,
	pixels: ^u16,
)

Encoder_Stats_Key :: enum c.int {
	HEADER_BITS,
	TOC_BITS,
	DICTIONARY_BITS,
	SPLINES_BITS,
	NOISE_BITS,
	QUANT_BITS,
	MODULAR_TREE_BITS,
	MODULAR_GLOBAL_BITS,
	DC_BITS,
	MODULAR_DC_GROUP_BITS,
	CONTROL_FIELDS_BITS,
	COEF_ORDER_BITS,
	AC_HISTOGRAM_BITS,
	AC_BITS,
	MODULAR_AC_GROUP_BITS,
	NUM_SMALL_BLOCKS,
	NUM_DCT4X8_BLOCKS,
	NUM_AFV_BLOCKS,
	NUM_DCT8_BLOCKS,
	NUM_DCT8X32_BLOCKS,
	NUM_DCT16_BLOCKS,
	NUM_DCT16X32_BLOCKS,
	NUM_DCT32_BLOCKS,
	NUM_DCT32X64_BLOCKS,
	NUM_DCT64_BLOCKS,
	NUM_BUTTERAUGLI_ITERS,
	NUM_STATS,
}

@(default_calling_convention = "c", link_prefix = "Jxl")
foreign lib {
	DecoderVersion :: proc() -> u32 ---
	SignatureCheck :: proc(buf: [^]u8, len: c.size_t) -> Signature ---
	DecoderCreate :: proc(memory_manager: ^Memory_Manager) -> ^Decoder ---
	DecoderReset :: proc(dec: ^Decoder) ---
	DecoderDestroy :: proc(dec: ^Decoder) ---
	DecoderRewind :: proc(dec: ^Decoder) ---
	DecoderSkipFrames :: proc(dec: ^Decoder, amount: c.size_t) ---
	DecoderSkipCurrentFrame :: proc(dec: ^Decoder) -> Decoder_Status ---
	DecoderSetParallelRunner :: proc(dec: ^Decoder, parallel_runner: Parallel_Runner, parallel_runner_opaque: rawptr) -> Decoder_Status ---
	DecoderSizeHintBasicInfo :: proc(dec: ^Decoder) -> c.size_t ---
	DecoderSubscribeEvents :: proc(dec: ^Decoder, events_wanted: c.int) -> Decoder_Status ---
	DecoderSetKeepOrientation :: proc(dec: ^Decoder, skip_reorientation: Bool) -> Decoder_Status ---
	DecoderSetUnpremultiplyAlpha :: proc(dec: ^Decoder, unpremul_alpha: Bool) -> Decoder_Status ---
	DecoderSetRenderSpotcolors :: proc(dec: ^Decoder, render_spotcolors: Bool) -> Decoder_Status ---
	DecoderSetCoalescing :: proc(dec: ^Decoder, coalescing: Bool) -> Decoder_Status ---
	DecoderProcessInput :: proc(dec: ^Decoder) -> Decoder_Status ---
	DecoderSetInput :: proc(dec: ^Decoder, data: [^]u8, size: c.size_t) -> Decoder_Status ---
	DecoderReleaseInput :: proc(dec: ^Decoder) -> c.size_t ---
	DecoderCloseInput :: proc(dec: ^Decoder) ---
	DecoderGetBasicInfo :: proc(dec: ^Decoder, info: ^Basic_Info) -> Decoder_Status ---
	DecoderGetExtraChannelInfo :: proc(dec: ^Decoder, index: c.size_t, info: ^Extra_Channel_Info) -> Decoder_Status ---
	DecoderGetExtraChannelName :: proc(dec: ^Decoder, index: c.size_t, name: [^]c.char, size: c.size_t) -> Decoder_Status ---
	DecoderGetColorAsEncodedProfile :: proc(dec: ^Decoder, target: Color_Profile_Target, color_encoding: ^Color_Encoding) -> Decoder_Status ---
	DecoderGetICCProfileSize :: proc(dec: ^Decoder, target: Color_Profile_Target, size: ^c.size_t) -> Decoder_Status ---
	DecoderGetColorAsICCProfile :: proc(dec: ^Decoder, target: Color_Profile_Target, icc_profile: [^]u8, size: c.size_t) -> Decoder_Status ---
	DecoderSetPreferredColorProfile :: proc(dec: ^Decoder, color_encoding: ^Color_Encoding) -> Decoder_Status ---
	DecoderSetDesiredIntensityTarget :: proc(dec: ^Decoder, desired_intensity_target: f32) -> Decoder_Status ---
	DecoderSetOutputColorProfile :: proc(dec: ^Decoder, color_encoding: ^Color_Encoding, icc_data: [^]u8, icc_size: c.size_t) -> Decoder_Status ---
	DecoderSetCms :: proc(dec: ^Decoder, cms: Cms_Interface) -> Decoder_Status ---
	DecoderPreviewOutBufferSize :: proc(dec: ^Decoder, format: ^Pixel_Format, size: ^c.size_t) -> Decoder_Status ---
	DecoderSetPreviewOutBuffer :: proc(dec: ^Decoder, format: ^Pixel_Format, buffer: rawptr, size: c.size_t) -> Decoder_Status ---
	DecoderGetFrameHeader :: proc(dec: ^Decoder, header: ^Frame_Header) -> Decoder_Status ---
	DecoderGetFrameName :: proc(dec: ^Decoder, name: [^]c.char, size: c.size_t) -> Decoder_Status ---
	DecoderGetExtraChannelBlendInfo :: proc(dec: ^Decoder, index: c.size_t, blend_info: ^Blend_Info) -> Decoder_Status ---
	DecoderImageOutBufferSize :: proc(dec: ^Decoder, format: ^Pixel_Format, size: ^c.size_t) -> Decoder_Status ---
	DecoderSetImageOutBuffer :: proc(dec: ^Decoder, format: ^Pixel_Format, buffer: rawptr, size: c.size_t) -> Decoder_Status ---
	DecoderSetImageOutCallback :: proc(dec: ^Decoder, format: ^Pixel_Format, callback: Image_Out_Callback, opaque: rawptr) -> Decoder_Status ---
	DecoderSetMultithreadedImageOutCallback :: proc(dec: ^Decoder, format: ^Pixel_Format, init_callback: Image_Out_Init_Callback, run_callback: Image_Out_Run_Callback, destroy_callback: Image_Out_Destroy_Callback, init_opaque: rawptr) -> Decoder_Status ---
	DecoderExtraChannelBufferSize :: proc(dec: ^Decoder, format: ^Pixel_Format, size: ^c.size_t, index: u32) -> Decoder_Status ---
	DecoderSetExtraChannelBuffer :: proc(dec: ^Decoder, format: ^Pixel_Format, buffer: rawptr, size: c.size_t, index: u32) -> Decoder_Status ---
	DecoderSetJPEGBuffer :: proc(dec: ^Decoder, data: [^]u8, size: c.size_t) -> Decoder_Status ---
	DecoderReleaseJPEGBuffer :: proc(dec: ^Decoder) -> c.size_t ---
	DecoderSetBoxBuffer :: proc(dec: ^Decoder, data: [^]u8, size: c.size_t) -> Decoder_Status ---
	DecoderReleaseBoxBuffer :: proc(dec: ^Decoder) -> c.size_t ---
	DecoderSetDecompressBoxes :: proc(dec: ^Decoder, decompress: Bool) -> Decoder_Status ---
	DecoderGetBoxType :: proc(dec: ^Decoder, box_type: [^]c.char, decompressed: Bool) -> Decoder_Status ---
	DecoderGetBoxSizeRaw :: proc(dec: ^Decoder, size: ^u64) -> Decoder_Status ---
	DecoderGetBoxSizeContents :: proc(dec: ^Decoder, size: ^u64) -> Decoder_Status ---
	DecoderSetProgressiveDetail :: proc(dec: ^Decoder, detail: Progressive_Detail) -> Decoder_Status ---
	DecoderGetIntendedDownsamplingRatio :: proc(dec: ^Decoder) -> c.size_t ---
	DecoderFlushImage :: proc(dec: ^Decoder) -> Decoder_Status ---
	DecoderSetImageOutBitDepth :: proc(dec: ^Decoder, bit_depth: ^Bit_Depth) -> Decoder_Status ---

	EncoderVersion :: proc() -> u32 ---
	EncoderCreate :: proc(memory_manager: ^Memory_Manager) -> ^Encoder ---
	EncoderReset :: proc(enc: ^Encoder) ---
	EncoderDestroy :: proc(enc: ^Encoder) ---
	EncoderSetCms :: proc(enc: ^Encoder, cms: Cms_Interface) ---
	EncoderSetParallelRunner :: proc(enc: ^Encoder, parallel_runner: Parallel_Runner, parallel_runner_opaque: rawptr) -> Encoder_Status ---
	EncoderGetError :: proc(enc: ^Encoder) -> Encoder_Error ---
	EncoderProcessOutput :: proc(enc: ^Encoder, next_out: ^^u8, avail_out: ^c.size_t) -> Encoder_Status ---
	EncoderSetFrameHeader :: proc(frame_settings: ^Encoder_Frame_Settings, frame_header: ^Frame_Header) -> Encoder_Status ---
	EncoderSetExtraChannelBlendInfo :: proc(frame_settings: ^Encoder_Frame_Settings, index: c.size_t, blend_info: ^Blend_Info) -> Encoder_Status ---
	EncoderSetFrameName :: proc(frame_settings: ^Encoder_Frame_Settings, frame_name: cstring) -> Encoder_Status ---
	EncoderSetFrameBitDepth :: proc(frame_settings: ^Encoder_Frame_Settings, bit_depth: ^Bit_Depth) -> Encoder_Status ---
	EncoderAddJPEGFrame :: proc(frame_settings: ^Encoder_Frame_Settings, buffer: [^]u8, size: c.size_t) -> Encoder_Status ---
	EncoderAddImageFrame :: proc(frame_settings: ^Encoder_Frame_Settings, pixel_format: ^Pixel_Format, buffer: rawptr, size: c.size_t) -> Encoder_Status ---
	EncoderSetOutputProcessor :: proc(enc: ^Encoder, output_processor: Encoder_Output_Processor) -> Encoder_Status ---
	EncoderFlushInput :: proc(enc: ^Encoder) -> Encoder_Status ---
	EncoderAddChunkedFrame :: proc(frame_settings: ^Encoder_Frame_Settings, is_last_frame: Bool, chunked_frame_input: Chunked_Frame_Input_Source) -> Encoder_Status ---
	EncoderSetExtraChannelBuffer :: proc(frame_settings: ^Encoder_Frame_Settings, pixel_format: ^Pixel_Format, buffer: rawptr, size: c.size_t, index: u32) -> Encoder_Status ---
	EncoderAddBox :: proc(enc: ^Encoder, box_type: [^]c.char, contents: [^]u8, size: c.size_t, compress_box: Bool) -> Encoder_Status ---
	EncoderUseBoxes :: proc(enc: ^Encoder) -> Encoder_Status ---
	EncoderCloseBoxes :: proc(enc: ^Encoder) ---
	EncoderCloseFrames :: proc(enc: ^Encoder) ---
	EncoderCloseInput :: proc(enc: ^Encoder) ---
	EncoderSetColorEncoding :: proc(enc: ^Encoder, color: ^Color_Encoding) -> Encoder_Status ---
	EncoderSetICCProfile :: proc(enc: ^Encoder, icc_profile: [^]u8, size: c.size_t) -> Encoder_Status ---
	EncoderInitBasicInfo :: proc(info: ^Basic_Info) ---
	EncoderInitFrameHeader :: proc(frame_header: ^Frame_Header) ---
	EncoderInitBlendInfo :: proc(blend_info: ^Blend_Info) ---
	EncoderSetBasicInfo :: proc(enc: ^Encoder, info: ^Basic_Info) -> Encoder_Status ---
	EncoderSetUpsamplingMode :: proc(enc: ^Encoder, factor, mode: i64) -> Encoder_Status ---
	EncoderInitExtraChannelInfo :: proc(ec_type: Extra_Channel_Type, info: ^Extra_Channel_Info) ---
	EncoderSetExtraChannelInfo :: proc(enc: ^Encoder, index: c.size_t, info: ^Extra_Channel_Info) -> Encoder_Status ---
	EncoderSetExtraChannelName :: proc(enc: ^Encoder, index: c.size_t, name: cstring, size: c.size_t) -> Encoder_Status ---
	EncoderFrameSettingsSetOption :: proc(frame_settings: ^Encoder_Frame_Settings, option: Encoder_Frame_Setting_Id, value: i64) -> Encoder_Status ---
	EncoderFrameSettingsSetFloatOption :: proc(frame_settings: ^Encoder_Frame_Settings, option: Encoder_Frame_Setting_Id, value: f32) -> Encoder_Status ---
	EncoderUseContainer :: proc(enc: ^Encoder, use_container: Bool) -> Encoder_Status ---
	EncoderStoreJPEGMetadata :: proc(enc: ^Encoder, store_jpeg_metadata: Bool) -> Encoder_Status ---
	EncoderSetCodestreamLevel :: proc(enc: ^Encoder, level: c.int) -> Encoder_Status ---
	EncoderGetRequiredCodestreamLevel :: proc(enc: ^Encoder) -> c.int ---
	EncoderSetFrameLossless :: proc(frame_settings: ^Encoder_Frame_Settings, lossless: Bool) -> Encoder_Status ---
	EncoderSetFrameDistance :: proc(frame_settings: ^Encoder_Frame_Settings, distance: f32) -> Encoder_Status ---
	EncoderSetExtraChannelDistance :: proc(frame_settings: ^Encoder_Frame_Settings, index: c.size_t, distance: f32) -> Encoder_Status ---
	EncoderDistanceFromQuality :: proc(quality: f32) -> f32 ---
	EncoderFrameSettingsCreate :: proc(enc: ^Encoder, source: ^Encoder_Frame_Settings) -> ^Encoder_Frame_Settings ---
	ColorEncodingSetToSRGB :: proc(color_encoding: ^Color_Encoding, is_gray: Bool) ---
	ColorEncodingSetToLinearSRGB :: proc(color_encoding: ^Color_Encoding, is_gray: Bool) ---
	EncoderAllowExpertOptions :: proc(enc: ^Encoder) ---
	EncoderSetDebugImageCallback :: proc(frame_settings: ^Encoder_Frame_Settings, callback: Debug_Image_Callback, opaque: rawptr) ---
	EncoderCollectStats :: proc(frame_settings: ^Encoder_Frame_Settings, stats: ^Encoder_Stats) ---

	ThreadParallelRunner :: proc(runner_opaque: rawptr, jpegxl_opaque: rawptr, init: Parallel_Run_Init, func: Parallel_Run_Function, start_range, end_range: u32) -> Parallel_Ret_Code ---
	ThreadParallelRunnerCreate :: proc(memory_manager: ^Memory_Manager, num_worker_threads: c.size_t) -> rawptr ---
	ThreadParallelRunnerDestroy :: proc(runner_opaque: rawptr) ---
	ThreadParallelRunnerDefaultNumWorkerThreads :: proc() -> c.size_t ---

	EncoderStatsCreate :: proc() -> ^Encoder_Stats ---
	EncoderStatsDestroy :: proc(stats: ^Encoder_Stats) ---
	EncoderStatsGet :: proc(stats: ^Encoder_Stats, key: Encoder_Stats_Key) -> c.size_t ---
	EncoderStatsMerge :: proc(stats: ^Encoder_Stats, other: ^Encoder_Stats) ---
}
