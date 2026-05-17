// Bindings for [[libpng ; https://github.com/pnggroup/libpng]]
package libpng

import "core:c"
import "core:c/libc"
import "shared:utils_private/library"

@(private)
LIBPNG_LIB :: library.LIBPATH + "/libpng" + library.ARCH_end
@(private)
ZLIB_LIB :: "../compress/zlib-ng/" + library.LIBPATH + "/libz" + library.ARCH_end

foreign import libpng {LIBPNG_LIB, ZLIB_LIB}

// png.h
PNG_LIBPNG_VER_STRING :: "1.8.0.git"
PNG_HEADER_VERSION_STRING :: " libpng version " + PNG_LIBPNG_VER_STRING + "\n"

PNG_LIBPNG_VER_MAJOR :: 1
PNG_LIBPNG_VER_MINOR :: 8
PNG_LIBPNG_VER_RELEASE :: 0
PNG_LIBPNG_VER_SHAREDLIB :: 18
PNG_LIBPNG_VER_SONUM :: PNG_LIBPNG_VER_SHAREDLIB
PNG_LIBPNG_VER_DLLNUM :: PNG_LIBPNG_VER_SHAREDLIB
PNG_LIBPNG_VER_BUILD :: 1
PNG_LIBPNG_VER :: 10800

PNG_LIBPNG_BUILD_ALPHA :: 1
PNG_LIBPNG_BUILD_BETA :: 2
PNG_LIBPNG_BUILD_RC :: 3
PNG_LIBPNG_BUILD_STABLE :: 4
PNG_LIBPNG_BUILD_RELEASE_STATUS_MASK :: 7
PNG_LIBPNG_BUILD_PATCH :: 8
PNG_LIBPNG_BUILD_PRIVATE :: 16
PNG_LIBPNG_BUILD_SPECIAL :: 32
PNG_LIBPNG_BUILD_BASE_TYPE :: PNG_LIBPNG_BUILD_BETA

// pnglibconf.h
PNG_ZBUF_SIZE :: 8192
PNG_USER_WIDTH_MAX :: 1000000
PNG_USER_HEIGHT_MAX :: 1000000
PNG_USER_CHUNK_CACHE_MAX :: 1000
PNG_USER_CHUNK_MALLOC_MAX :: 8000000

png_byte :: c.uchar
png_int_16 :: c.short
png_uint_16 :: c.ushort
png_int_32 :: c.int
png_uint_32 :: c.uint
png_size_t :: c.size_t
png_ptrdiff_t :: c.ptrdiff_t
png_alloc_size_t :: c.size_t
png_fixed_point :: png_int_32

png_voidp :: rawptr
png_const_voidp :: rawptr
png_bytep :: ^png_byte
png_const_bytep :: ^png_byte
png_uint_32p :: ^png_uint_32
png_const_uint_32p :: ^png_uint_32
png_int_32p :: ^png_int_32
png_const_int_32p :: ^png_int_32
png_uint_16p :: ^png_uint_16
png_const_uint_16p :: ^png_uint_16
png_int_16p :: ^png_int_16
png_const_int_16p :: ^png_int_16
png_charp :: ^c.char
png_const_charp :: ^c.char
png_fixed_point_p :: ^png_fixed_point
png_const_fixed_point_p :: ^png_fixed_point
png_size_tp :: ^c.size_t
png_const_size_tp :: ^c.size_t
png_doublep :: ^f64
png_const_doublep :: ^f64

png_bytepp :: ^^png_byte
png_uint_32pp :: ^^png_uint_32
png_int_32pp :: ^^png_int_32
png_uint_16pp :: ^^png_uint_16
png_int_16pp :: ^^png_int_16
png_const_charpp :: ^^c.char
png_charpp :: ^^c.char
png_fixed_point_pp :: ^^png_fixed_point
png_doublepp :: ^^f64
png_charppp :: ^^^c.char
png_FILE_p :: ^c.FILE

png_struct :: struct {}
png_info :: struct {}
png_control :: struct {}

png_const_structp :: ^png_struct
png_structp :: ^png_struct
png_structpp :: ^^png_struct
png_structrp :: ^png_struct
png_const_structrp :: ^png_struct

png_infop :: ^png_info
png_const_infop :: ^png_info
png_infopp :: ^^png_info
png_inforp :: ^png_info
png_const_inforp :: ^png_info

png_color :: struct {
	red:   png_byte,
	green: png_byte,
	blue:  png_byte,
}

png_colorp :: ^png_color
png_const_colorp :: ^png_color
png_colorpp :: ^^png_color

png_color_16 :: struct {
	index: png_byte,
	red:   png_uint_16,
	green: png_uint_16,
	blue:  png_uint_16,
	gray:  png_uint_16,
}

png_color_16p :: ^png_color_16
png_const_color_16p :: ^png_color_16
png_color_16pp :: ^^png_color_16

png_color_8 :: struct {
	red:   png_byte,
	green: png_byte,
	blue:  png_byte,
	gray:  png_byte,
	alpha: png_byte,
}

png_color_8p :: ^png_color_8
png_const_color_8p :: ^png_color_8
png_color_8pp :: ^^png_color_8

png_sPLT_entry :: struct {
	red:       png_uint_16,
	green:     png_uint_16,
	blue:      png_uint_16,
	alpha:     png_uint_16,
	frequency: png_uint_16,
}

png_sPLT_entryp :: ^png_sPLT_entry
png_const_sPLT_entryp :: ^png_sPLT_entry
png_sPLT_entrypp :: ^^png_sPLT_entry

png_sPLT_t :: struct {
	name:     ^c.char,
	depth:    png_byte,
	entries:  ^png_sPLT_entry,
	nentries: png_int_32,
}

png_sPLT_tp :: ^png_sPLT_t
png_const_sPLT_tp :: ^png_sPLT_t
png_sPLT_tpp :: ^^png_sPLT_t

png_text :: struct {
	compression: c.int,
	key:         ^c.char,
	text:        ^c.char,
	text_length: c.size_t,
	itxt_length: c.size_t,
	lang:        ^c.char,
	lang_key:    ^c.char,
}

png_textp :: ^png_text
png_const_textp :: ^png_text
png_textpp :: ^^png_text

png_time :: struct {
	year:   png_uint_16,
	month:  png_byte,
	day:    png_byte,
	hour:   png_byte,
	minute: png_byte,
	second: png_byte,
}

png_timep :: ^png_time
png_const_timep :: ^png_time
png_timepp :: ^^png_time

png_unknown_chunk :: struct {
	name:     [5]png_byte,
	data:     ^png_byte,
	size:     c.size_t,
	location: png_byte,
}

png_unknown_chunkp :: ^png_unknown_chunk
png_const_unknown_chunkp :: ^png_unknown_chunk
png_unknown_chunkpp :: ^^png_unknown_chunk

png_row_info :: struct {
	width:       png_uint_32,
	rowbytes:    c.size_t,
	color_type:  png_byte,
	bit_depth:   png_byte,
	channels:    png_byte,
	pixel_depth: png_byte,
}

png_row_infop :: ^png_row_info
png_row_infopp :: ^^png_row_info

png_error_ptr :: #type proc "c" (png_ptr: ^png_struct, error_message: ^c.char)
png_rw_ptr :: #type proc "c" (png_ptr: ^png_struct, data: ^png_byte, length: c.size_t)
png_flush_ptr :: #type proc "c" (png_ptr: ^png_struct)
png_read_status_ptr :: #type proc "c" (png_ptr: ^png_struct, row_number: png_uint_32, pass: c.int)
png_write_status_ptr :: #type proc "c" (png_ptr: ^png_struct, row_number: png_uint_32, pass: c.int)
png_progressive_info_ptr :: #type proc "c" (png_ptr: ^png_struct, info_ptr: ^png_info)
png_progressive_end_ptr :: #type proc "c" (png_ptr: ^png_struct, info_ptr: ^png_info)
png_progressive_frame_ptr :: #type proc "c" (png_ptr: ^png_struct, frame_num: png_uint_32)
png_progressive_row_ptr :: #type proc "c" (png_ptr: ^png_struct, new_row: ^png_byte, row_num: png_uint_32, pass: c.int)
png_user_transform_ptr :: #type proc "c" (png_ptr: ^png_struct, row_info: ^png_row_info, data: ^png_byte)
png_user_chunk_ptr :: #type proc "c" (png_ptr: ^png_struct, chunk: ^png_unknown_chunk) -> c.int
png_longjmp_ptr :: #type proc "c" (env: ^libc.jmp_buf, value: c.int)
png_malloc_ptr :: #type proc "c" (png_ptr: ^png_struct, size: png_alloc_size_t) -> rawptr
png_free_ptr :: #type proc "c" (png_ptr: ^png_struct, ptr: rawptr)

PNG_TEXT_COMPRESSION_NONE_WR :: -3
PNG_TEXT_COMPRESSION_zTXt_WR :: -2
PNG_TEXT_COMPRESSION_NONE :: -1
PNG_TEXT_COMPRESSION_zTXt :: 0
PNG_ITXT_COMPRESSION_NONE :: 1
PNG_ITXT_COMPRESSION_zTXt :: 2
PNG_TEXT_COMPRESSION_LAST :: 3

PNG_HAVE_IHDR :: 0x01
PNG_HAVE_PLTE :: 0x02
PNG_AFTER_IDAT :: 0x08

PNG_UINT_31_MAX :: png_uint_32(0x7fffffff)
PNG_UINT_32_MAX :: ~png_uint_32(0)
PNG_SIZE_MAX :: ~c.size_t(0)

PNG_FP_1 :: 100000
PNG_FP_HALF :: 50000
PNG_FP_MAX :: png_fixed_point(0x7fffffff)
PNG_FP_MIN :: -PNG_FP_MAX

PNG_COLOR_MASK_PALETTE :: 1
PNG_COLOR_MASK_COLOR :: 2
PNG_COLOR_MASK_ALPHA :: 4

PNG_COLOR_TYPE_GRAY :: 0
PNG_COLOR_TYPE_PALETTE :: PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_PALETTE
PNG_COLOR_TYPE_RGB :: PNG_COLOR_MASK_COLOR
PNG_COLOR_TYPE_RGB_ALPHA :: PNG_COLOR_MASK_COLOR | PNG_COLOR_MASK_ALPHA
PNG_COLOR_TYPE_GRAY_ALPHA :: PNG_COLOR_MASK_ALPHA
PNG_COLOR_TYPE_RGBA :: PNG_COLOR_TYPE_RGB_ALPHA
PNG_COLOR_TYPE_GA :: PNG_COLOR_TYPE_GRAY_ALPHA

PNG_COMPRESSION_TYPE_BASE :: 0
PNG_COMPRESSION_TYPE_DEFAULT :: PNG_COMPRESSION_TYPE_BASE

PNG_FILTER_TYPE_BASE :: 0
PNG_INTRAPIXEL_DIFFERENCING :: 64
PNG_FILTER_TYPE_DEFAULT :: PNG_FILTER_TYPE_BASE

PNG_INTERLACE_NONE :: 0
PNG_INTERLACE_ADAM7 :: 1
PNG_INTERLACE_LAST :: 2

PNG_OFFSET_PIXEL :: 0
PNG_OFFSET_MICROMETER :: 1
PNG_OFFSET_LAST :: 2

PNG_EQUATION_LINEAR :: 0
PNG_EQUATION_BASE_E :: 1
PNG_EQUATION_ARBITRARY :: 2
PNG_EQUATION_HYPERBOLIC :: 3
PNG_EQUATION_LAST :: 4

PNG_SCALE_UNKNOWN :: 0
PNG_SCALE_METER :: 1
PNG_SCALE_RADIAN :: 2
PNG_SCALE_LAST :: 3

PNG_RESOLUTION_UNKNOWN :: 0
PNG_RESOLUTION_METER :: 1
PNG_RESOLUTION_LAST :: 2

PNG_sRGB_INTENT_PERCEPTUAL :: 0
PNG_sRGB_INTENT_RELATIVE :: 1
PNG_sRGB_INTENT_SATURATION :: 2
PNG_sRGB_INTENT_ABSOLUTE :: 3
PNG_sRGB_INTENT_LAST :: 4

PNG_fcTL_DISPOSE_OP_NONE :: 0
PNG_fcTL_DISPOSE_OP_BACKGROUND :: 1
PNG_fcTL_DISPOSE_OP_PREVIOUS :: 2
PNG_fcTL_DISPOSE_OP_LAST :: 3

PNG_fcTL_BLEND_OP_SOURCE :: 0
PNG_fcTL_BLEND_OP_OVER :: 1
PNG_fcTL_BLEND_OP_LAST :: 2

PNG_KEYWORD_MAX_LENGTH :: 79
PNG_MAX_PALETTE_LENGTH :: 256

PNG_INFO_gAMA :: 0x0001
PNG_INFO_sBIT :: 0x0002
PNG_INFO_cHRM :: 0x0004
PNG_INFO_PLTE :: 0x0008
PNG_INFO_tRNS :: 0x0010
PNG_INFO_bKGD :: 0x0020
PNG_INFO_hIST :: 0x0040
PNG_INFO_pHYs :: 0x0080
PNG_INFO_oFFs :: 0x0100
PNG_INFO_tIME :: 0x0200
PNG_INFO_pCAL :: 0x0400
PNG_INFO_sRGB :: 0x0800
PNG_INFO_iCCP :: 0x1000
PNG_INFO_sPLT :: 0x2000
PNG_INFO_sCAL :: 0x4000
PNG_INFO_IDAT :: 0x8000
PNG_INFO_eXIf :: 0x10000
PNG_INFO_cICP :: 0x20000
PNG_INFO_cLLI :: 0x40000
PNG_INFO_mDCV :: 0x80000
PNG_INFO_acTL :: 0x100000
PNG_INFO_fcTL :: 0x200000
PNG_INFO_fdAT :: 0x400000

PNG_ERROR_ACTION_NONE :: 1
PNG_ERROR_ACTION_WARN :: 2
PNG_ERROR_ACTION_ERROR :: 3
PNG_RGB_TO_GRAY_DEFAULT :: -1

PNG_ALPHA_PNG :: 0
PNG_ALPHA_STANDARD :: 1
PNG_ALPHA_ASSOCIATED :: 1
PNG_ALPHA_PREMULTIPLIED :: 1
PNG_ALPHA_OPTIMIZED :: 2
PNG_ALPHA_BROKEN :: 3

PNG_DEFAULT_sRGB :: -1
PNG_GAMMA_MAC_18 :: -2
PNG_GAMMA_sRGB :: 220000
PNG_GAMMA_LINEAR :: PNG_FP_1

PNG_FILLER_BEFORE :: 0
PNG_FILLER_AFTER :: 1

PNG_BACKGROUND_GAMMA_UNKNOWN :: 0
PNG_BACKGROUND_GAMMA_SCREEN :: 1
PNG_BACKGROUND_GAMMA_FILE :: 2
PNG_BACKGROUND_GAMMA_UNIQUE :: 3

PNG_CRC_DEFAULT :: 0
PNG_CRC_ERROR_QUIT :: 1
PNG_CRC_WARN_DISCARD :: 2
PNG_CRC_WARN_USE :: 3
PNG_CRC_QUIET_USE :: 4
PNG_CRC_NO_CHANGE :: 5

PNG_NO_FILTERS :: 0x00
PNG_FILTER_NONE :: 0x08
PNG_FILTER_SUB :: 0x10
PNG_FILTER_UP :: 0x20
PNG_FILTER_AVG :: 0x40
PNG_FILTER_PAETH :: 0x80
PNG_FAST_FILTERS :: PNG_FILTER_NONE | PNG_FILTER_SUB | PNG_FILTER_UP
PNG_ALL_FILTERS :: PNG_FAST_FILTERS | PNG_FILTER_AVG | PNG_FILTER_PAETH

PNG_FILTER_VALUE_NONE :: 0
PNG_FILTER_VALUE_SUB :: 1
PNG_FILTER_VALUE_UP :: 2
PNG_FILTER_VALUE_AVG :: 3
PNG_FILTER_VALUE_PAETH :: 4
PNG_FILTER_VALUE_LAST :: 5

PNG_DESTROY_WILL_FREE_DATA :: 1
PNG_SET_WILL_FREE_DATA :: 1
PNG_USER_WILL_FREE_DATA :: 2

PNG_FREE_HIST :: 0x0008
PNG_FREE_ICCP :: 0x0010
PNG_FREE_SPLT :: 0x0020
PNG_FREE_ROWS :: 0x0040
PNG_FREE_PCAL :: 0x0080
PNG_FREE_SCAL :: 0x0100
PNG_FREE_UNKN :: 0x0200
PNG_FREE_PLTE :: 0x1000
PNG_FREE_TRNS :: 0x2000
PNG_FREE_TEXT :: 0x4000
PNG_FREE_EXIF :: 0x8000
PNG_FREE_ALL :: 0xffff
PNG_FREE_MUL :: 0x4220

PNG_TRANSFORM_IDENTITY :: 0x0000
PNG_TRANSFORM_STRIP_16 :: 0x0001
PNG_TRANSFORM_STRIP_ALPHA :: 0x0002
PNG_TRANSFORM_PACKING :: 0x0004
PNG_TRANSFORM_PACKSWAP :: 0x0008
PNG_TRANSFORM_EXPAND :: 0x0010
PNG_TRANSFORM_INVERT_MONO :: 0x0020
PNG_TRANSFORM_SHIFT :: 0x0040
PNG_TRANSFORM_BGR :: 0x0080
PNG_TRANSFORM_SWAP_ALPHA :: 0x0100
PNG_TRANSFORM_SWAP_ENDIAN :: 0x0200
PNG_TRANSFORM_INVERT_ALPHA :: 0x0400
PNG_TRANSFORM_STRIP_FILLER :: 0x0800
PNG_TRANSFORM_STRIP_FILLER_BEFORE :: PNG_TRANSFORM_STRIP_FILLER
PNG_TRANSFORM_STRIP_FILLER_AFTER :: 0x1000
PNG_TRANSFORM_GRAY_TO_RGB :: 0x2000
PNG_TRANSFORM_EXPAND_16 :: 0x4000
PNG_TRANSFORM_SCALE_16 :: 0x8000

PNG_FLAG_MNG_EMPTY_PLTE :: 0x01
PNG_FLAG_MNG_FILTER_64 :: 0x04
PNG_ALL_MNG_FEATURES :: 0x05

PNG_IO_NONE :: 0x0000
PNG_IO_READING :: 0x0001
PNG_IO_WRITING :: 0x0002
PNG_IO_SIGNATURE :: 0x0010
PNG_IO_CHUNK_HDR :: 0x0020
PNG_IO_CHUNK_DATA :: 0x0040
PNG_IO_CHUNK_CRC :: 0x0080
PNG_IO_MASK_OP :: 0x000f
PNG_IO_MASK_LOC :: 0x00f0

PNG_INTERLACE_ADAM7_PASSES :: 7

PNG_IMAGE_VERSION :: 1
PNG_IMAGE_WARNING :: 1
PNG_IMAGE_ERROR :: 2

png_image :: struct {
	opaque:            ^png_control,
	version:           png_uint_32,
	width:             png_uint_32,
	height:            png_uint_32,
	format:            png_uint_32,
	flags:             png_uint_32,
	colormap_entries:  png_uint_32,
	warning_or_error:  png_uint_32,
	message:           [64]c.char,
}

png_imagep :: ^png_image

PNG_FORMAT_FLAG_ALPHA :: 0x01
PNG_FORMAT_FLAG_COLOR :: 0x02
PNG_FORMAT_FLAG_LINEAR :: 0x04
PNG_FORMAT_FLAG_COLORMAP :: 0x08
PNG_FORMAT_FLAG_BGR :: 0x10
PNG_FORMAT_FLAG_AFIRST :: 0x20
PNG_FORMAT_FLAG_ASSOCIATED_ALPHA :: 0x40

PNG_FORMAT_GRAY :: 0
PNG_FORMAT_GA :: PNG_FORMAT_FLAG_ALPHA
PNG_FORMAT_AG :: PNG_FORMAT_GA | PNG_FORMAT_FLAG_AFIRST
PNG_FORMAT_RGB :: PNG_FORMAT_FLAG_COLOR
PNG_FORMAT_BGR :: PNG_FORMAT_FLAG_COLOR | PNG_FORMAT_FLAG_BGR
PNG_FORMAT_RGBA :: PNG_FORMAT_RGB | PNG_FORMAT_FLAG_ALPHA
PNG_FORMAT_ARGB :: PNG_FORMAT_RGBA | PNG_FORMAT_FLAG_AFIRST
PNG_FORMAT_BGRA :: PNG_FORMAT_BGR | PNG_FORMAT_FLAG_ALPHA
PNG_FORMAT_ABGR :: PNG_FORMAT_BGRA | PNG_FORMAT_FLAG_AFIRST

PNG_FORMAT_LINEAR_Y :: PNG_FORMAT_FLAG_LINEAR
PNG_FORMAT_LINEAR_Y_ALPHA :: PNG_FORMAT_FLAG_LINEAR | PNG_FORMAT_FLAG_ALPHA
PNG_FORMAT_LINEAR_RGB :: PNG_FORMAT_FLAG_LINEAR | PNG_FORMAT_FLAG_COLOR
PNG_FORMAT_LINEAR_RGB_ALPHA :: PNG_FORMAT_FLAG_LINEAR | PNG_FORMAT_FLAG_COLOR | PNG_FORMAT_FLAG_ALPHA

PNG_FORMAT_RGB_COLORMAP :: PNG_FORMAT_RGB | PNG_FORMAT_FLAG_COLORMAP
PNG_FORMAT_BGR_COLORMAP :: PNG_FORMAT_BGR | PNG_FORMAT_FLAG_COLORMAP
PNG_FORMAT_RGBA_COLORMAP :: PNG_FORMAT_RGBA | PNG_FORMAT_FLAG_COLORMAP
PNG_FORMAT_ARGB_COLORMAP :: PNG_FORMAT_ARGB | PNG_FORMAT_FLAG_COLORMAP
PNG_FORMAT_BGRA_COLORMAP :: PNG_FORMAT_BGRA | PNG_FORMAT_FLAG_COLORMAP
PNG_FORMAT_ABGR_COLORMAP :: PNG_FORMAT_ABGR | PNG_FORMAT_FLAG_COLORMAP

PNG_IMAGE_FLAG_COLORSPACE_NOT_sRGB :: 0x01
PNG_IMAGE_FLAG_FAST :: 0x02
PNG_IMAGE_FLAG_16BIT_sRGB :: 0x04

PNG_TARGET_SPECIFIC_CODE :: 0
PNG_ARM_NEON :: 0
PNG_MIPS_MSA :: 0
PNG_POWERPC_VSX :: 0
PNG_RISCV_RVV :: 0
PNG_MIPS_MMI :: 2
PNG_MAXIMUM_INFLATE_WINDOW :: 4
PNG_SKIP_sRGB_CHECK_PROFILE :: 6
PNG_OPTION_NEXT :: 10

PNG_OPTION_UNSET :: 0
PNG_OPTION_INVALID :: 1
PNG_OPTION_OFF :: 2
PNG_OPTION_ON :: 3

PNG_IMAGE_FAILED :: #force_inline proc "contextless" (image: png_image) -> bool {
	return (image.warning_or_error & 0x03) > 1
}

PNG_IMAGE_SAMPLE_CHANNELS :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	return (fmt & (PNG_FORMAT_FLAG_COLOR | PNG_FORMAT_FLAG_ALPHA)) + 1
}

PNG_IMAGE_SAMPLE_COMPONENT_SIZE :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	return ((fmt & PNG_FORMAT_FLAG_LINEAR) >> 2) + 1
}

PNG_IMAGE_SAMPLE_SIZE :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	return PNG_IMAGE_SAMPLE_CHANNELS(fmt) * PNG_IMAGE_SAMPLE_COMPONENT_SIZE(fmt)
}

PNG_IMAGE_MAXIMUM_COLORMAP_COMPONENTS :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	return PNG_IMAGE_SAMPLE_CHANNELS(fmt) * 256
}

PNG_IMAGE_PIXEL_CHANNELS :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	if (fmt & PNG_FORMAT_FLAG_COLORMAP) != 0 {
		return 1
	}
	return PNG_IMAGE_SAMPLE_CHANNELS(fmt)
}

PNG_IMAGE_PIXEL_COMPONENT_SIZE :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	if (fmt & PNG_FORMAT_FLAG_COLORMAP) != 0 {
		return 1
	}
	return PNG_IMAGE_SAMPLE_COMPONENT_SIZE(fmt)
}

PNG_IMAGE_PIXEL_SIZE :: #force_inline proc "contextless" (fmt: png_uint_32) -> png_uint_32 {
	if (fmt & PNG_FORMAT_FLAG_COLORMAP) != 0 {
		return 1
	}
	return PNG_IMAGE_SAMPLE_SIZE(fmt)
}

PNG_IMAGE_ROW_STRIDE :: #force_inline proc "contextless" (image: png_image) -> c.size_t {
	return c.size_t(PNG_IMAGE_PIXEL_CHANNELS(image.format)) * c.size_t(image.width)
}

PNG_IMAGE_BUFFER_SIZE :: #force_inline proc "contextless" (image: png_image, row_stride: c.size_t) -> c.size_t {
	return c.size_t(PNG_IMAGE_PIXEL_COMPONENT_SIZE(image.format)) * c.size_t(image.height) * row_stride
}

PNG_IMAGE_SIZE :: #force_inline proc "contextless" (image: png_image) -> c.size_t {
	return PNG_IMAGE_BUFFER_SIZE(image, PNG_IMAGE_ROW_STRIDE(image))
}

PNG_IMAGE_COLORMAP_SIZE :: #force_inline proc "contextless" (image: png_image) -> c.size_t {
	return c.size_t(PNG_IMAGE_SAMPLE_SIZE(image.format)) * c.size_t(image.colormap_entries)
}

@(default_calling_convention = "c")
foreign libpng {
	png_access_version_number :: proc() -> png_uint_32 ---
	png_set_sig_bytes :: proc(png_ptr: ^png_struct, num_bytes: c.int) ---
	png_sig_cmp :: proc(sig: ^png_byte, start: c.size_t, num_to_check: c.size_t) -> c.int ---
	png_create_read_struct :: proc(user_png_ver: ^c.char, error_ptr: rawptr, error_fn: png_error_ptr, warn_fn: png_error_ptr) -> ^png_struct ---
	png_create_write_struct :: proc(user_png_ver: ^c.char, error_ptr: rawptr, error_fn: png_error_ptr, warn_fn: png_error_ptr) -> ^png_struct ---
	png_get_compression_buffer_size :: proc(png_ptr: ^png_struct) -> c.size_t ---
	png_set_compression_buffer_size :: proc(png_ptr: ^png_struct, size: c.size_t) ---
	png_set_longjmp_fn :: proc(png_ptr: ^png_struct, longjmp_fn: png_longjmp_ptr, jmp_buf_size: c.size_t) -> ^libc.jmp_buf ---
	png_longjmp :: proc(png_ptr: ^png_struct, val: c.int) ---
	png_reset_zstream :: proc(png_ptr: ^png_struct) -> c.int ---
	png_create_read_struct_2 :: proc(user_png_ver: ^c.char, error_ptr: rawptr, error_fn: png_error_ptr, warn_fn: png_error_ptr, mem_ptr: rawptr, malloc_fn: png_malloc_ptr, free_fn: png_free_ptr) -> ^png_struct ---
	png_create_write_struct_2 :: proc(user_png_ver: ^c.char, error_ptr: rawptr, error_fn: png_error_ptr, warn_fn: png_error_ptr, mem_ptr: rawptr, malloc_fn: png_malloc_ptr, free_fn: png_free_ptr) -> ^png_struct ---
	png_write_sig :: proc(png_ptr: ^png_struct) ---
	png_write_chunk :: proc(png_ptr: ^png_struct, chunk_name: ^png_byte, data: ^png_byte, length: c.size_t) ---
	png_write_chunk_start :: proc(png_ptr: ^png_struct, chunk_name: ^png_byte, length: png_uint_32) ---
	png_write_chunk_data :: proc(png_ptr: ^png_struct, data: ^png_byte, length: c.size_t) ---
	png_write_chunk_end :: proc(png_ptr: ^png_struct) ---
	png_create_info_struct :: proc(png_ptr: ^png_struct) -> ^png_info ---
	png_info_init_3 :: proc(info_ptr: ^^png_info, png_info_struct_size: c.size_t) ---
	png_write_info_before_PLTE :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_write_info :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_read_info :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_convert_to_rfc1123_buffer :: proc(out: ^c.char, ptime: ^png_time) -> c.int ---
	png_convert_from_struct_tm :: proc(ptime: ^png_time, ttime: ^libc.tm) ---
	png_convert_from_time_t :: proc(ptime: ^png_time, ttime: libc.time_t) ---
	png_set_expand :: proc(png_ptr: ^png_struct) ---
	png_set_expand_gray_1_2_4_to_8 :: proc(png_ptr: ^png_struct) ---
	png_set_palette_to_rgb :: proc(png_ptr: ^png_struct) ---
	png_set_tRNS_to_alpha :: proc(png_ptr: ^png_struct) ---
	png_set_expand_16 :: proc(png_ptr: ^png_struct) ---
	png_set_bgr :: proc(png_ptr: ^png_struct) ---
	png_set_gray_to_rgb :: proc(png_ptr: ^png_struct) ---
	png_set_rgb_to_gray :: proc(png_ptr: ^png_struct, error_action: c.int, red: f64, green: f64) ---
	png_set_rgb_to_gray_fixed :: proc(png_ptr: ^png_struct, error_action: c.int, red: png_fixed_point, green: png_fixed_point) ---
	png_get_rgb_to_gray_status :: proc(png_ptr: ^png_struct) -> png_byte ---
	png_build_grayscale_palette :: proc(bit_depth: c.int, palette: ^png_color) ---
	png_set_alpha_mode :: proc(png_ptr: ^png_struct, mode: c.int, output_gamma: f64) ---
	png_set_alpha_mode_fixed :: proc(png_ptr: ^png_struct, mode: c.int, output_gamma: png_fixed_point) ---
	png_set_strip_alpha :: proc(png_ptr: ^png_struct) ---
	png_set_swap_alpha :: proc(png_ptr: ^png_struct) ---
	png_set_invert_alpha :: proc(png_ptr: ^png_struct) ---
	png_set_filler :: proc(png_ptr: ^png_struct, filler: png_uint_32, flags: c.int) ---
	png_set_add_alpha :: proc(png_ptr: ^png_struct, filler: png_uint_32, flags: c.int) ---
	png_set_swap :: proc(png_ptr: ^png_struct) ---
	png_set_packing :: proc(png_ptr: ^png_struct) ---
	png_set_packswap :: proc(png_ptr: ^png_struct) ---
	png_set_shift :: proc(png_ptr: ^png_struct, true_bits: ^png_color_8) ---
	png_set_interlace_handling :: proc(png_ptr: ^png_struct) -> c.int ---
	png_set_invert_mono :: proc(png_ptr: ^png_struct) ---
	png_set_background :: proc(png_ptr: ^png_struct, background_color: ^png_color_16, background_gamma_code: c.int, need_expand: c.int, background_gamma: f64) ---
	png_set_background_fixed :: proc(png_ptr: ^png_struct, background_color: ^png_color_16, background_gamma_code: c.int, need_expand: c.int, background_gamma: png_fixed_point) ---
	png_set_scale_16 :: proc(png_ptr: ^png_struct) ---
	png_set_strip_16 :: proc(png_ptr: ^png_struct) ---
	png_set_quantize :: proc(png_ptr: ^png_struct, palette: ^png_color, num_palette: c.int, maximum_colors: c.int, histogram: ^png_uint_16, full_quantize: c.int) ---
	png_set_gamma :: proc(png_ptr: ^png_struct, screen_gamma: f64, override_file_gamma: f64) ---
	png_set_gamma_fixed :: proc(png_ptr: ^png_struct, screen_gamma: png_fixed_point, override_file_gamma: png_fixed_point) ---
	png_set_flush :: proc(png_ptr: ^png_struct, nrows: c.int) ---
	png_write_flush :: proc(png_ptr: ^png_struct) ---
	png_start_read_image :: proc(png_ptr: ^png_struct) ---
	png_read_update_info :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_read_rows :: proc(png_ptr: ^png_struct, row: ^^png_byte, display_row: ^^png_byte, num_rows: png_uint_32) ---
	png_read_row :: proc(png_ptr: ^png_struct, row: ^png_byte, display_row: ^png_byte) ---
	png_read_image :: proc(png_ptr: ^png_struct, image: ^^png_byte) ---
	png_write_row :: proc(png_ptr: ^png_struct, row: ^png_byte) ---
	png_write_rows :: proc(png_ptr: ^png_struct, row: ^^png_byte, num_rows: png_uint_32) ---
	png_write_image :: proc(png_ptr: ^png_struct, image: ^^png_byte) ---
	png_write_end :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_read_end :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_destroy_info_struct :: proc(png_ptr: ^png_struct, info_ptr_ptr: ^^png_info) ---
	png_destroy_read_struct :: proc(png_ptr_ptr: ^^png_struct, info_ptr_ptr: ^^png_info, end_info_ptr_ptr: ^^png_info) ---
	png_destroy_write_struct :: proc(png_ptr_ptr: ^^png_struct, info_ptr_ptr: ^^png_info) ---
	png_set_crc_action :: proc(png_ptr: ^png_struct, crit_action: c.int, ancil_action: c.int) ---
	png_set_filter :: proc(png_ptr: ^png_struct, method: c.int, filters: c.int) ---
	png_set_compression_level :: proc(png_ptr: ^png_struct, level: c.int) ---
	png_set_compression_mem_level :: proc(png_ptr: ^png_struct, mem_level: c.int) ---
	png_set_compression_strategy :: proc(png_ptr: ^png_struct, strategy: c.int) ---
	png_set_compression_window_bits :: proc(png_ptr: ^png_struct, window_bits: c.int) ---
	png_set_compression_method :: proc(png_ptr: ^png_struct, method: c.int) ---
	png_set_text_compression_level :: proc(png_ptr: ^png_struct, level: c.int) ---
	png_set_text_compression_mem_level :: proc(png_ptr: ^png_struct, mem_level: c.int) ---
	png_set_text_compression_strategy :: proc(png_ptr: ^png_struct, strategy: c.int) ---
	png_set_text_compression_window_bits :: proc(png_ptr: ^png_struct, window_bits: c.int) ---
	png_set_text_compression_method :: proc(png_ptr: ^png_struct, method: c.int) ---
	png_init_io :: proc(png_ptr: ^png_struct, fp: ^c.FILE) ---
	png_set_error_fn :: proc(png_ptr: ^png_struct, error_ptr: rawptr, error_fn: png_error_ptr, warning_fn: png_error_ptr) ---
	png_get_error_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_set_write_fn :: proc(png_ptr: ^png_struct, io_ptr: rawptr, write_data_fn: png_rw_ptr, output_flush_fn: png_flush_ptr) ---
	png_set_read_fn :: proc(png_ptr: ^png_struct, io_ptr: rawptr, read_data_fn: png_rw_ptr) ---
	png_get_io_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_set_read_status_fn :: proc(png_ptr: ^png_struct, read_row_fn: png_read_status_ptr) ---
	png_set_write_status_fn :: proc(png_ptr: ^png_struct, write_row_fn: png_write_status_ptr) ---
	png_set_mem_fn :: proc(png_ptr: ^png_struct, mem_ptr: rawptr, malloc_fn: png_malloc_ptr, free_fn: png_free_ptr) ---
	png_get_mem_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_set_read_user_transform_fn :: proc(png_ptr: ^png_struct, read_user_transform_fn: png_user_transform_ptr) ---
	png_set_write_user_transform_fn :: proc(png_ptr: ^png_struct, write_user_transform_fn: png_user_transform_ptr) ---
	png_set_user_transform_info :: proc(png_ptr: ^png_struct, user_transform_ptr: rawptr, user_transform_depth: c.int, user_transform_channels: c.int) ---
	png_get_user_transform_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_get_current_row_number :: proc(arg0: ^png_struct) -> png_uint_32 ---
	png_get_current_pass_number :: proc(arg0: ^png_struct) -> png_byte ---
	png_set_read_user_chunk_fn :: proc(png_ptr: ^png_struct, user_chunk_ptr: rawptr, read_user_chunk_fn: png_user_chunk_ptr) ---
	png_get_user_chunk_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_set_progressive_read_fn :: proc(png_ptr: ^png_struct, progressive_ptr: rawptr, info_fn: png_progressive_info_ptr, row_fn: png_progressive_row_ptr, end_fn: png_progressive_end_ptr) ---
	png_get_progressive_ptr :: proc(png_ptr: ^png_struct) -> rawptr ---
	png_process_data :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, buffer: ^png_byte, buffer_size: c.size_t) ---
	png_process_data_pause :: proc(arg0: ^png_struct, save: c.int) -> c.size_t ---
	png_process_data_skip :: proc(arg0: ^png_struct) -> png_uint_32 ---
	png_progressive_combine_row :: proc(png_ptr: ^png_struct, old_row: ^png_byte, new_row: ^png_byte) ---
	png_malloc :: proc(png_ptr: ^png_struct, size: png_alloc_size_t) -> rawptr ---
	png_calloc :: proc(png_ptr: ^png_struct, size: png_alloc_size_t) -> rawptr ---
	png_malloc_warn :: proc(png_ptr: ^png_struct, size: png_alloc_size_t) -> rawptr ---
	png_free :: proc(png_ptr: ^png_struct, ptr: rawptr) ---
	png_free_data :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, free_me: png_uint_32, num: c.int) ---
	png_data_freer :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, freer: c.int, mask: png_uint_32) ---
	png_malloc_default :: proc(png_ptr: ^png_struct, size: png_alloc_size_t) -> rawptr ---
	png_free_default :: proc(png_ptr: ^png_struct, ptr: rawptr) ---
	png_error :: proc(png_ptr: ^png_struct, error_message: ^c.char) ---
	png_chunk_error :: proc(png_ptr: ^png_struct, error_message: ^c.char) ---
	png_err :: proc(png_ptr: ^png_struct) ---
	png_warning :: proc(png_ptr: ^png_struct, warning_message: ^c.char) ---
	png_chunk_warning :: proc(png_ptr: ^png_struct, warning_message: ^c.char) ---
	png_benign_error :: proc(png_ptr: ^png_struct, warning_message: ^c.char) ---
	png_chunk_benign_error :: proc(png_ptr: ^png_struct, warning_message: ^c.char) ---
	png_set_benign_errors :: proc(png_ptr: ^png_struct, allowed: c.int) ---
	png_get_valid :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, flag: png_uint_32) -> png_uint_32 ---
	png_get_rowbytes :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> c.size_t ---
	png_get_rows :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> ^^png_byte ---
	png_set_rows :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, row_pointers: ^^png_byte) ---
	png_get_channels :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_image_width :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_image_height :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_bit_depth :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_color_type :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_filter_type :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_interlace_type :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_compression_type :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_pixels_per_meter :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_x_pixels_per_meter :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_y_pixels_per_meter :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_pixel_aspect_ratio :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> f32 ---
	png_get_pixel_aspect_ratio_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_fixed_point ---
	png_get_x_offset_pixels :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_int_32 ---
	png_get_y_offset_pixels :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_int_32 ---
	png_get_x_offset_microns :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_int_32 ---
	png_get_y_offset_microns :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_int_32 ---
	png_get_signature :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> ^png_byte ---
	png_get_bKGD :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, background: ^^png_color_16) -> png_uint_32 ---
	png_set_bKGD :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, background: ^png_color_16) ---
	png_get_cHRM :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, white_x: ^f64, white_y: ^f64, red_x: ^f64, red_y: ^f64, green_x: ^f64, green_y: ^f64, blue_x: ^f64, blue_y: ^f64) -> png_uint_32 ---
	png_get_cHRM_XYZ :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, red_X: ^f64, red_Y: ^f64, red_Z: ^f64, green_X: ^f64, green_Y: ^f64, green_Z: ^f64, blue_X: ^f64, blue_Y: ^f64, blue_Z: ^f64) -> png_uint_32 ---
	png_get_cHRM_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_white_x: ^png_fixed_point, int_white_y: ^png_fixed_point, int_red_x: ^png_fixed_point, int_red_y: ^png_fixed_point, int_green_x: ^png_fixed_point, int_green_y: ^png_fixed_point, int_blue_x: ^png_fixed_point, int_blue_y: ^png_fixed_point) -> png_uint_32 ---
	png_get_cHRM_XYZ_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_red_X: ^png_fixed_point, int_red_Y: ^png_fixed_point, int_red_Z: ^png_fixed_point, int_green_X: ^png_fixed_point, int_green_Y: ^png_fixed_point, int_green_Z: ^png_fixed_point, int_blue_X: ^png_fixed_point, int_blue_Y: ^png_fixed_point, int_blue_Z: ^png_fixed_point) -> png_uint_32 ---
	png_set_cHRM :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, white_x: f64, white_y: f64, red_x: f64, red_y: f64, green_x: f64, green_y: f64, blue_x: f64, blue_y: f64) ---
	png_set_cHRM_XYZ :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, red_X: f64, red_Y: f64, red_Z: f64, green_X: f64, green_Y: f64, green_Z: f64, blue_X: f64, blue_Y: f64, blue_Z: f64) ---
	png_set_cHRM_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_white_x: png_fixed_point, int_white_y: png_fixed_point, int_red_x: png_fixed_point, int_red_y: png_fixed_point, int_green_x: png_fixed_point, int_green_y: png_fixed_point, int_blue_x: png_fixed_point, int_blue_y: png_fixed_point) ---
	png_set_cHRM_XYZ_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_red_X: png_fixed_point, int_red_Y: png_fixed_point, int_red_Z: png_fixed_point, int_green_X: png_fixed_point, int_green_Y: png_fixed_point, int_green_Z: png_fixed_point, int_blue_X: png_fixed_point, int_blue_Y: png_fixed_point, int_blue_Z: png_fixed_point) ---
	png_get_cICP :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, colour_primaries: ^png_byte, transfer_function: ^png_byte, matrix_coefficients: ^png_byte, video_full_range_flag: ^png_byte) -> png_uint_32 ---
	png_set_cICP :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, colour_primaries: png_byte, transfer_function: png_byte, matrix_coefficients: png_byte, video_full_range_flag: png_byte) ---
	png_get_cLLI :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, maximum_content_light_level: ^f64, maximum_frame_average_light_level: ^f64) -> png_uint_32 ---
	png_get_cLLI_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, maximum_content_light_level_scaled_by_10000: ^png_uint_32, maximum_frame_average_light_level_scaled_by_10000: ^png_uint_32) -> png_uint_32 ---
	png_set_cLLI :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, maximum_content_light_level: f64, maximum_frame_average_light_level: f64) ---
	png_set_cLLI_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, maximum_content_light_level_scaled_by_10000: png_uint_32, maximum_frame_average_light_level_scaled_by_10000: png_uint_32) ---
	png_get_eXIf_1 :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, num_exif: ^png_uint_32, exif: ^^png_byte) -> png_uint_32 ---
	png_set_eXIf_1 :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, num_exif: png_uint_32, exif: ^png_byte) ---
	png_get_gAMA :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, file_gamma: ^f64) -> png_uint_32 ---
	png_get_gAMA_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_file_gamma: ^png_fixed_point) -> png_uint_32 ---
	png_set_gAMA :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, file_gamma: f64) ---
	png_set_gAMA_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_file_gamma: png_fixed_point) ---
	png_get_hIST :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, hist: ^^png_uint_16) -> png_uint_32 ---
	png_set_hIST :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, hist: ^png_uint_16) ---
	png_get_IHDR :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, width: ^png_uint_32, height: ^png_uint_32, bit_depth: ^c.int, color_type: ^c.int, interlace_method: ^c.int, compression_method: ^c.int, filter_method: ^c.int) -> png_uint_32 ---
	png_set_IHDR :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, width: png_uint_32, height: png_uint_32, bit_depth: c.int, color_type: c.int, interlace_method: c.int, compression_method: c.int, filter_method: c.int) ---
	png_get_mDCV :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, white_x: ^f64, white_y: ^f64, red_x: ^f64, red_y: ^f64, green_x: ^f64, green_y: ^f64, blue_x: ^f64, blue_y: ^f64, mastering_display_maximum_luminance: ^f64, mastering_display_minimum_luminance: ^f64) -> png_uint_32 ---
	png_get_mDCV_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_white_x: ^png_fixed_point, int_white_y: ^png_fixed_point, int_red_x: ^png_fixed_point, int_red_y: ^png_fixed_point, int_green_x: ^png_fixed_point, int_green_y: ^png_fixed_point, int_blue_x: ^png_fixed_point, int_blue_y: ^png_fixed_point, mastering_display_maximum_luminance_scaled_by_10000: ^png_uint_32, mastering_display_minimum_luminance_scaled_by_10000: ^png_uint_32) -> png_uint_32 ---
	png_set_mDCV :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, white_x: f64, white_y: f64, red_x: f64, red_y: f64, green_x: f64, green_y: f64, blue_x: f64, blue_y: f64, mastering_display_maximum_luminance: f64, mastering_display_minimum_luminance: f64) ---
	png_set_mDCV_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, int_white_x: png_fixed_point, int_white_y: png_fixed_point, int_red_x: png_fixed_point, int_red_y: png_fixed_point, int_green_x: png_fixed_point, int_green_y: png_fixed_point, int_blue_x: png_fixed_point, int_blue_y: png_fixed_point, mastering_display_maximum_luminance_scaled_by_10000: png_uint_32, mastering_display_minimum_luminance_scaled_by_10000: png_uint_32) ---
	png_get_oFFs :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, offset_x: ^png_int_32, offset_y: ^png_int_32, unit_type: ^c.int) -> png_uint_32 ---
	png_set_oFFs :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, offset_x: png_int_32, offset_y: png_int_32, unit_type: c.int) ---
	png_get_pCAL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, purpose: ^^c.char, X0: ^png_int_32, X1: ^png_int_32, type_: ^c.int, nparams: ^c.int, units: ^^c.char, params: ^^^c.char) -> png_uint_32 ---
	png_set_pCAL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, purpose: ^c.char, X0: png_int_32, X1: png_int_32, type_: c.int, nparams: c.int, units: ^c.char, params: ^^c.char) ---
	png_get_pHYs :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, res_x: ^png_uint_32, res_y: ^png_uint_32, unit_type: ^c.int) -> png_uint_32 ---
	png_set_pHYs :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, res_x: png_uint_32, res_y: png_uint_32, unit_type: c.int) ---
	png_get_PLTE :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, palette: ^^png_color, num_palette: ^c.int) -> png_uint_32 ---
	png_set_PLTE :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, palette: ^png_color, num_palette: c.int) ---
	png_get_sBIT :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, sig_bit: ^^png_color_8) -> png_uint_32 ---
	png_set_sBIT :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, sig_bit: ^png_color_8) ---
	png_get_sRGB :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, file_srgb_intent: ^c.int) -> png_uint_32 ---
	png_set_sRGB :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, srgb_intent: c.int) ---
	png_set_sRGB_gAMA_and_cHRM :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, srgb_intent: c.int) ---
	png_get_iCCP :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, name: ^^c.char, compression_type: ^c.int, profile: ^^png_byte, proflen: ^png_uint_32) -> png_uint_32 ---
	png_set_iCCP :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, name: ^c.char, compression_type: c.int, profile: ^png_byte, proflen: png_uint_32) ---
	png_get_sPLT :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, entries: ^^png_sPLT_t) -> c.int ---
	png_set_sPLT :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, entries: ^png_sPLT_t, nentries: c.int) ---
	png_get_text :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, text_ptr: ^^png_text, num_text: ^c.int) -> c.int ---
	png_set_text :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, text_ptr: ^png_text, num_text: c.int) ---
	png_get_tIME :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, mod_time: ^^png_time) -> png_uint_32 ---
	png_set_tIME :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, mod_time: ^png_time) ---
	png_get_tRNS :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, trans_alpha: ^^png_byte, num_trans: ^c.int, trans_color: ^^png_color_16) -> png_uint_32 ---
	png_set_tRNS :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, trans_alpha: ^png_byte, num_trans: c.int, trans_color: ^png_color_16) ---
	png_get_sCAL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: ^c.int, width: ^f64, height: ^f64) -> png_uint_32 ---
	png_get_sCAL_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: ^c.int, width: ^png_fixed_point, height: ^png_fixed_point) -> png_uint_32 ---
	png_get_sCAL_s :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: ^c.int, swidth: ^^c.char, sheight: ^^c.char) -> png_uint_32 ---
	png_set_sCAL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: c.int, width: f64, height: f64) ---
	png_set_sCAL_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: c.int, width: png_fixed_point, height: png_fixed_point) ---
	png_set_sCAL_s :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unit: c.int, swidth: ^c.char, sheight: ^c.char) ---
	png_set_keep_unknown_chunks :: proc(png_ptr: ^png_struct, keep: c.int, chunk_list: ^png_byte, num_chunks: c.int) ---
	png_handle_as_unknown :: proc(png_ptr: ^png_struct, chunk_name: ^png_byte) -> c.int ---
	png_set_unknown_chunks :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, unknowns: ^png_unknown_chunk, num_unknowns: c.int) ---
	png_set_unknown_chunk_location :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, chunk: c.int, location: c.int) ---
	png_get_unknown_chunks :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, entries: ^^png_unknown_chunk) -> c.int ---
	png_set_invalid :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, mask: c.int) ---
	png_read_png :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, transforms: c.int, params: rawptr) ---
	png_write_png :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, transforms: c.int, params: rawptr) ---
	png_get_copyright :: proc(png_ptr: ^png_struct) -> ^c.char ---
	png_get_header_ver :: proc(png_ptr: ^png_struct) -> ^c.char ---
	png_get_header_version :: proc(png_ptr: ^png_struct) -> ^c.char ---
	png_get_libpng_ver :: proc(png_ptr: ^png_struct) -> ^c.char ---
	png_permit_mng_features :: proc(png_ptr: ^png_struct, mng_features_permitted: png_uint_32) -> png_uint_32 ---
	png_set_user_limits :: proc(png_ptr: ^png_struct, user_width_max: png_uint_32, user_height_max: png_uint_32) ---
	png_get_user_width_max :: proc(png_ptr: ^png_struct) -> png_uint_32 ---
	png_get_user_height_max :: proc(png_ptr: ^png_struct) -> png_uint_32 ---
	png_set_chunk_cache_max :: proc(png_ptr: ^png_struct, user_chunk_cache_max: png_uint_32) ---
	png_get_chunk_cache_max :: proc(png_ptr: ^png_struct) -> png_uint_32 ---
	png_set_chunk_malloc_max :: proc(png_ptr: ^png_struct, user_chunk_cache_max: png_alloc_size_t) ---
	png_get_chunk_malloc_max :: proc(png_ptr: ^png_struct) -> png_alloc_size_t ---
	png_get_pixels_per_inch :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_x_pixels_per_inch :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_y_pixels_per_inch :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_x_offset_inches :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> f32 ---
	png_get_x_offset_inches_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_fixed_point ---
	png_get_y_offset_inches :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> f32 ---
	png_get_y_offset_inches_fixed :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_fixed_point ---
	png_get_pHYs_dpi :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, res_x: ^png_uint_32, res_y: ^png_uint_32, unit_type: ^c.int) -> png_uint_32 ---
	png_get_io_state :: proc(png_ptr: ^png_struct) -> png_uint_32 ---
	png_get_io_chunk_type :: proc(png_ptr: ^png_struct) -> png_uint_32 ---
	png_get_uint_32 :: proc(buf: ^png_byte) -> png_uint_32 ---
	png_get_uint_16 :: proc(buf: ^png_byte) -> png_uint_16 ---
	png_get_int_32 :: proc(buf: ^png_byte) -> png_int_32 ---
	png_get_uint_31 :: proc(png_ptr: ^png_struct, buf: ^png_byte) -> png_uint_32 ---
	png_save_uint_32 :: proc(buf: ^png_byte, i: png_uint_32) ---
	png_save_int_32 :: proc(buf: ^png_byte, i: png_int_32) ---
	png_save_uint_16 :: proc(buf: ^png_byte, i: c.uint) ---
	png_set_check_for_invalid_index :: proc(png_ptr: ^png_struct, allowed: c.int) ---
	png_get_palette_max :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> c.int ---
	png_image_begin_read_from_file :: proc(image: ^png_image, file_name: ^c.char) -> c.int ---
	png_image_begin_read_from_stdio :: proc(image: ^png_image, file: ^c.FILE) -> c.int ---
	png_image_begin_read_from_memory :: proc(image: ^png_image, memory: rawptr, size: c.size_t) -> c.int ---
	png_image_finish_read :: proc(image: ^png_image, background: ^png_color, buffer: rawptr, row_stride: png_int_32, colormap: rawptr) -> c.int ---
	png_image_free :: proc(image: ^png_image) ---
	png_image_write_to_file :: proc(image: ^png_image, file: ^c.char, convert_to_8bit: c.int, buffer: rawptr, row_stride: png_int_32, colormap: rawptr) -> c.int ---
	png_image_write_to_stdio :: proc(image: ^png_image, file: ^c.FILE, convert_to_8_bit: c.int, buffer: rawptr, row_stride: png_int_32, colormap: rawptr) -> c.int ---
	png_image_write_to_memory :: proc(image: ^png_image, memory: rawptr, memory_bytes: ^png_alloc_size_t, convert_to_8_bit: c.int, buffer: rawptr, row_stride: png_int_32, colormap: rawptr) -> c.int ---
	png_set_option :: proc(png_ptr: ^png_struct, option: c.int, onoff: c.int) -> c.int ---
	png_get_acTL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, num_frames: ^png_uint_32, num_plays: ^png_uint_32) -> png_uint_32 ---
	png_set_acTL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, num_frames: png_uint_32, num_plays: png_uint_32) -> png_uint_32 ---
	png_get_num_frames :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_num_plays :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_next_frame_fcTL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, width: ^png_uint_32, height: ^png_uint_32, x_offset: ^png_uint_32, y_offset: ^png_uint_32, delay_num: ^png_uint_16, delay_den: ^png_uint_16, dispose_op: ^png_byte, blend_op: ^png_byte) -> png_uint_32 ---
	png_set_next_frame_fcTL :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, width: png_uint_32, height: png_uint_32, x_offset: png_uint_32, y_offset: png_uint_32, delay_num: png_uint_16, delay_den: png_uint_16, dispose_op: png_byte, blend_op: png_byte) -> png_uint_32 ---
	png_get_next_frame_width :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_next_frame_height :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_next_frame_x_offset :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_next_frame_y_offset :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_32 ---
	png_get_next_frame_delay_num :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_16 ---
	png_get_next_frame_delay_den :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_uint_16 ---
	png_get_next_frame_dispose_op :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_next_frame_blend_op :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_get_first_frame_is_hidden :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) -> png_byte ---
	png_set_first_frame_is_hidden :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, is_hidden: png_byte) -> png_uint_32 ---
	png_read_frame_head :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
	png_set_progressive_frame_fn :: proc(png_ptr: ^png_struct, frame_info_fn: png_progressive_frame_ptr, frame_end_fn: png_progressive_frame_ptr) ---
	png_write_frame_head :: proc(png_ptr: ^png_struct, info_ptr: ^png_info, row_pointers: ^^png_byte, width: png_uint_32, height: png_uint_32, x_offset: png_uint_32, y_offset: png_uint_32, delay_num: png_uint_16, delay_den: png_uint_16, dispose_op: png_byte, blend_op: png_byte) ---
	png_write_frame_tail :: proc(png_ptr: ^png_struct, info_ptr: ^png_info) ---
}
