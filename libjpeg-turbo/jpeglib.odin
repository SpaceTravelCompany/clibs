// Bindings for jpeglib.h in libjpeg-turbo (JPEG_LIB_VERSION == 62).
package libjpeg_turbo

import "core:c"
import "shared:utils_private/library"

@(private)
JPEGLIB_LIB :: library.LIBPATH + "/libjpeg" + library.ARCH_end

foreign import jpeglib {JPEGLIB_LIB}

// jmorecfg.h
MAX_COMPONENTS :: 10

JSAMPLE :: c.uchar
J12SAMPLE :: c.short
J16SAMPLE :: c.ushort
JCOEF :: c.short
JOCTET :: c.uchar
UINT8 :: c.uchar
UINT16 :: c.ushort
INT16 :: c.short
JDIMENSION :: c.uint

when ODIN_OS == .Windows {
	boolean :: c.bool
	INT32 :: c.int
} else {
	boolean :: b32
	INT32 :: c.long
}

FALSE :: boolean(false)
TRUE :: boolean(true)

MAXJSAMPLE :: 255
CENTERJSAMPLE :: 128
MAXJ12SAMPLE :: 4095
CENTERJ12SAMPLE :: 2048
MAXJ16SAMPLE :: 65535
CENTERJ16SAMPLE :: 32768
JPEG_MAX_DIMENSION :: 65500

RGB_RED :: 0
RGB_GREEN :: 1
RGB_BLUE :: 2
RGB_PIXELSIZE :: 3

// jpeglib.h
DCTSIZE :: 8
DCTSIZE2 :: 64
NUM_QUANT_TBLS :: 4
NUM_HUFF_TBLS :: 4
NUM_ARITH_TBLS :: 16
MAX_COMPS_IN_SCAN :: 4
MAX_SAMP_FACTOR :: 4
C_MAX_BLOCKS_IN_MCU :: 10
D_MAX_BLOCKS_IN_MCU :: 10

JCS_EXTENSIONS :: 1
JCS_ALPHA_EXTENSIONS :: 1

JMSG_LENGTH_MAX :: 200
JMSG_STR_PARM_MAX :: 80

JPOOL_PERMANENT :: 0
JPOOL_IMAGE :: 1
JPOOL_NUMPOOLS :: 2

JPEG_SUSPENDED :: 0
JPEG_HEADER_OK :: 1
JPEG_HEADER_TABLES_ONLY :: 2

JPEG_REACHED_SOS :: 1
JPEG_REACHED_EOI :: 2
JPEG_ROW_COMPLETED :: 3
JPEG_SCAN_COMPLETED :: 4

JPEG_RST0 :: 0xD0
JPEG_EOI :: 0xD9
JPEG_APP0 :: 0xE0
JPEG_COM :: 0xFE

JSAMPROW :: ^JSAMPLE
JSAMPARRAY :: ^JSAMPROW
JSAMPIMAGE :: ^JSAMPARRAY

J12SAMPROW :: ^J12SAMPLE
J12SAMPARRAY :: ^J12SAMPROW
J12SAMPIMAGE :: ^J12SAMPARRAY

J16SAMPROW :: ^J16SAMPLE
J16SAMPARRAY :: ^J16SAMPROW
J16SAMPIMAGE :: ^J16SAMPARRAY

JBLOCK :: [DCTSIZE2]JCOEF
JBLOCKROW :: ^JBLOCK
JBLOCKARRAY :: ^JBLOCKROW
JBLOCKIMAGE :: ^JBLOCKARRAY
JCOEFPTR :: ^JCOEF

JQUANT_TBL :: struct {
	quantval:   [DCTSIZE2]UINT16,
	sent_table: boolean,
}

JHUFF_TBL :: struct {
	bits:       [17]UINT8,
	huffval:    [256]UINT8,
	sent_table: boolean,
}

jpeg_component_info :: struct {
	component_id:       c.int,
	component_index:    c.int,
	h_samp_factor:      c.int,
	v_samp_factor:      c.int,
	quant_tbl_no:       c.int,
	dc_tbl_no:          c.int,
	ac_tbl_no:          c.int,
	width_in_blocks:    JDIMENSION,
	height_in_blocks:   JDIMENSION,
	DCT_scaled_size:    c.int,
	downsampled_width:  JDIMENSION,
	downsampled_height: JDIMENSION,
	component_needed:   boolean,
	MCU_width:          c.int,
	MCU_height:         c.int,
	MCU_blocks:         c.int,
	MCU_sample_width:   c.int,
	last_col_width:     c.int,
	last_row_height:    c.int,
	quant_table:        ^JQUANT_TBL,
	dct_table:          rawptr,
}

jpeg_scan_info :: struct {
	comps_in_scan:   c.int,
	component_index: [MAX_COMPS_IN_SCAN]c.int,
	Ss:              c.int,
	Se:              c.int,
	Ah:              c.int,
	Al:              c.int,
}

jpeg_marker_struct :: struct {
	next:            ^jpeg_marker_struct,
	marker:          UINT8,
	original_length: c.uint,
	data_length:     c.uint,
	data:            ^JOCTET,
}

jpeg_saved_marker_ptr :: ^jpeg_marker_struct

J_COLOR_SPACE :: enum c.int {
	JCS_UNKNOWN = 0,
	JCS_GRAYSCALE,
	JCS_RGB,
	JCS_YCbCr,
	JCS_CMYK,
	JCS_YCCK,
	JCS_EXT_RGB,
	JCS_EXT_RGBX,
	JCS_EXT_BGR,
	JCS_EXT_BGRX,
	JCS_EXT_XBGR,
	JCS_EXT_XRGB,
	JCS_EXT_RGBA,
	JCS_EXT_BGRA,
	JCS_EXT_ABGR,
	JCS_EXT_ARGB,
	JCS_RGB565,
}

J_DCT_METHOD :: enum c.int {
	JDCT_ISLOW = 0,
	JDCT_IFAST,
	JDCT_FLOAT,
}

JDCT_DEFAULT :: J_DCT_METHOD.JDCT_ISLOW
JDCT_FASTEST :: J_DCT_METHOD.JDCT_IFAST

J_DITHER_MODE :: enum c.int {
	JDITHER_NONE = 0,
	JDITHER_ORDERED,
	JDITHER_FS,
}

// Opaque internal module structs used by public structs via pointers.
jvirt_sarray_control :: struct {}
jvirt_barray_control :: struct {}
jpeg_comp_master :: struct {}
jpeg_c_main_controller :: struct {}
jpeg_c_prep_controller :: struct {}
jpeg_c_coef_controller :: struct {}
jpeg_marker_writer :: struct {}
jpeg_color_converter :: struct {}
jpeg_downsampler :: struct {}
jpeg_forward_dct :: struct {}
jpeg_entropy_encoder :: struct {}
jpeg_decomp_master :: struct {}
jpeg_d_main_controller :: struct {}
jpeg_d_coef_controller :: struct {}
jpeg_d_post_controller :: struct {}
jpeg_input_controller :: struct {}
jpeg_marker_reader :: struct {}
jpeg_entropy_decoder :: struct {}
jpeg_inverse_dct :: struct {}
jpeg_upsampler :: struct {}
jpeg_color_deconverter :: struct {}
jpeg_color_quantizer :: struct {}

jvirt_sarray_ptr :: ^jvirt_sarray_control
jvirt_barray_ptr :: ^jvirt_barray_control

jpeg_common_struct :: struct {
	err:             ^jpeg_error_mgr,
	mem:             ^jpeg_memory_mgr,
	progress:        ^jpeg_progress_mgr,
	client_data:     rawptr,
	is_decompressor: boolean,
	global_state:    c.int,
}

jpeg_compress_struct :: struct {
	err:                ^jpeg_error_mgr,
	mem:                ^jpeg_memory_mgr,
	progress:           ^jpeg_progress_mgr,
	client_data:        rawptr,
	is_decompressor:    boolean,
	global_state:       c.int,
	dest:               ^jpeg_destination_mgr,
	image_width:        JDIMENSION,
	image_height:       JDIMENSION,
	input_components:   c.int,
	in_color_space:     J_COLOR_SPACE,
	input_gamma:        f64,
	data_precision:     c.int,
	num_components:     c.int,
	jpeg_color_space:   J_COLOR_SPACE,
	comp_info:          ^jpeg_component_info,
	quant_tbl_ptrs:     [NUM_QUANT_TBLS]^JQUANT_TBL,
	dc_huff_tbl_ptrs:   [NUM_HUFF_TBLS]^JHUFF_TBL,
	ac_huff_tbl_ptrs:   [NUM_HUFF_TBLS]^JHUFF_TBL,
	arith_dc_L:         [NUM_ARITH_TBLS]UINT8,
	arith_dc_U:         [NUM_ARITH_TBLS]UINT8,
	arith_ac_K:         [NUM_ARITH_TBLS]UINT8,
	num_scans:          c.int,
	scan_info:          ^jpeg_scan_info,
	raw_data_in:        boolean,
	arith_code:         boolean,
	optimize_coding:    boolean,
	CCIR601_sampling:   boolean,
	smoothing_factor:   c.int,
	dct_method:         J_DCT_METHOD,
	restart_interval:   c.uint,
	restart_in_rows:    c.int,
	write_JFIF_header:  boolean,
	JFIF_major_version: UINT8,
	JFIF_minor_version: UINT8,
	density_unit:       UINT8,
	X_density:          UINT16,
	Y_density:          UINT16,
	write_Adobe_marker: boolean,
	next_scanline:      JDIMENSION,
	progressive_mode:   boolean,
	max_h_samp_factor:  c.int,
	max_v_samp_factor:  c.int,
	total_iMCU_rows:    JDIMENSION,
	comps_in_scan:      c.int,
	cur_comp_info:      [MAX_COMPS_IN_SCAN]^jpeg_component_info,
	MCUs_per_row:       JDIMENSION,
	MCU_rows_in_scan:   JDIMENSION,
	blocks_in_MCU:      c.int,
	MCU_membership:     [C_MAX_BLOCKS_IN_MCU]c.int,
	Ss:                 c.int,
	Se:                 c.int,
	Ah:                 c.int,
	Al:                 c.int,
	master:             ^jpeg_comp_master,
	main:               ^jpeg_c_main_controller,
	prep:               ^jpeg_c_prep_controller,
	coef:               ^jpeg_c_coef_controller,
	marker:             ^jpeg_marker_writer,
	cconvert:           ^jpeg_color_converter,
	downsample:         ^jpeg_downsampler,
	fdct:               ^jpeg_forward_dct,
	entropy:            ^jpeg_entropy_encoder,
	script_space:       ^jpeg_scan_info,
	script_space_size:  c.int,
}

jpeg_decompress_struct :: struct {
	err:                      ^jpeg_error_mgr,
	mem:                      ^jpeg_memory_mgr,
	progress:                 ^jpeg_progress_mgr,
	client_data:              rawptr,
	is_decompressor:          boolean,
	global_state:             c.int,
	src:                      ^jpeg_source_mgr,
	image_width:              JDIMENSION,
	image_height:             JDIMENSION,
	num_components:           c.int,
	jpeg_color_space:         J_COLOR_SPACE,
	out_color_space:          J_COLOR_SPACE,
	scale_num:                c.uint,
	scale_denom:              c.uint,
	output_gamma:             f64,
	buffered_image:           boolean,
	raw_data_out:             boolean,
	dct_method:               J_DCT_METHOD,
	do_fancy_upsampling:      boolean,
	do_block_smoothing:       boolean,
	quantize_colors:          boolean,
	dither_mode:              J_DITHER_MODE,
	two_pass_quantize:        boolean,
	desired_number_of_colors: c.int,
	enable_1pass_quant:       boolean,
	enable_external_quant:    boolean,
	enable_2pass_quant:       boolean,
	output_width:             JDIMENSION,
	output_height:            JDIMENSION,
	out_color_components:     c.int,
	output_components:        c.int,
	rec_outbuf_height:        c.int,
	actual_number_of_colors:  c.int,
	colormap:                 JSAMPARRAY,
	output_scanline:          JDIMENSION,
	input_scan_number:        c.int,
	input_iMCU_row:           JDIMENSION,
	output_scan_number:       c.int,
	output_iMCU_row:          JDIMENSION,
	coef_bits:                ^[DCTSIZE2]c.int,
	quant_tbl_ptrs:           [NUM_QUANT_TBLS]^JQUANT_TBL,
	dc_huff_tbl_ptrs:         [NUM_HUFF_TBLS]^JHUFF_TBL,
	ac_huff_tbl_ptrs:         [NUM_HUFF_TBLS]^JHUFF_TBL,
	data_precision:           c.int,
	comp_info:                ^jpeg_component_info,
	progressive_mode:         boolean,
	arith_code:               boolean,
	arith_dc_L:               [NUM_ARITH_TBLS]UINT8,
	arith_dc_U:               [NUM_ARITH_TBLS]UINT8,
	arith_ac_K:               [NUM_ARITH_TBLS]UINT8,
	restart_interval:         c.uint,
	saw_JFIF_marker:          boolean,
	JFIF_major_version:       UINT8,
	JFIF_minor_version:       UINT8,
	density_unit:             UINT8,
	X_density:                UINT16,
	Y_density:                UINT16,
	saw_Adobe_marker:         boolean,
	Adobe_transform:          UINT8,
	CCIR601_sampling:         boolean,
	marker_list:              jpeg_saved_marker_ptr,
	max_h_samp_factor:        c.int,
	max_v_samp_factor:        c.int,
	min_DCT_scaled_size:      c.int,
	total_iMCU_rows:          JDIMENSION,
	sample_range_limit:       ^JSAMPLE,
	comps_in_scan:            c.int,
	cur_comp_info:            [MAX_COMPS_IN_SCAN]^jpeg_component_info,
	MCUs_per_row:             JDIMENSION,
	MCU_rows_in_scan:         JDIMENSION,
	blocks_in_MCU:            c.int,
	MCU_membership:           [D_MAX_BLOCKS_IN_MCU]c.int,
	Ss:                       c.int,
	Se:                       c.int,
	Ah:                       c.int,
	Al:                       c.int,
	unread_marker:            c.int,
	master:                   ^jpeg_decomp_master,
	main:                     ^jpeg_d_main_controller,
	coef:                     ^jpeg_d_coef_controller,
	post:                     ^jpeg_d_post_controller,
	inputctl:                 ^jpeg_input_controller,
	marker:                   ^jpeg_marker_reader,
	entropy:                  ^jpeg_entropy_decoder,
	idct:                     ^jpeg_inverse_dct,
	upsample:                 ^jpeg_upsampler,
	cconvert:                 ^jpeg_color_deconverter,
	cquantize:                ^jpeg_color_quantizer,
}

j_common_ptr :: ^jpeg_common_struct
j_compress_ptr :: ^jpeg_compress_struct
j_decompress_ptr :: ^jpeg_decompress_struct

jpeg_error_mgr :: struct {
	error_exit:          proc "c" (cinfo: j_common_ptr),
	emit_message:        proc "c" (cinfo: j_common_ptr, msg_level: c.int),
	output_message:      proc "c" (cinfo: j_common_ptr),
	format_message:      proc "c" (cinfo: j_common_ptr, buffer: ^c.char),
	reset_error_mgr:     proc "c" (cinfo: j_common_ptr),
	msg_code:            c.int,
	msg_parm:            struct #raw_union {
		i: [8]c.int,
		s: [JMSG_STR_PARM_MAX]c.char,
	},
	trace_level:         c.int,
	num_warnings:        c.long,
	jpeg_message_table:  ^cstring,
	last_jpeg_message:   c.int,
	addon_message_table: ^cstring,
	first_addon_message: c.int,
	last_addon_message:  c.int,
}

jpeg_progress_mgr :: struct {
	progress_monitor: proc "c" (cinfo: j_common_ptr),
	pass_counter:     c.long,
	pass_limit:       c.long,
	completed_passes: c.int,
	total_passes:     c.int,
}

jpeg_destination_mgr :: struct {
	next_output_byte:    ^JOCTET,
	free_in_buffer:      c.size_t,
	init_destination:    proc "c" (cinfo: j_compress_ptr),
	empty_output_buffer: proc "c" (cinfo: j_compress_ptr) -> boolean,
	term_destination:    proc "c" (cinfo: j_compress_ptr),
}

jpeg_source_mgr :: struct {
	next_input_byte:   ^JOCTET,
	bytes_in_buffer:   c.size_t,
	init_source:       proc "c" (cinfo: j_decompress_ptr),
	fill_input_buffer: proc "c" (cinfo: j_decompress_ptr) -> boolean,
	skip_input_data:   proc "c" (cinfo: j_decompress_ptr, num_bytes: c.long),
	resync_to_restart: proc "c" (cinfo: j_decompress_ptr, desired: c.int) -> boolean,
	term_source:       proc "c" (cinfo: j_decompress_ptr),
}

jpeg_memory_mgr :: struct {
	alloc_small:         proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		sizeofobject: c.size_t,
	) -> rawptr,
	alloc_large:         proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		sizeofobject: c.size_t,
	) -> rawptr,
	alloc_sarray:        proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		samplesperrow: JDIMENSION,
		numrows: JDIMENSION,
	) -> JSAMPARRAY,
	alloc_barray:        proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		blocksperrow: JDIMENSION,
		numrows: JDIMENSION,
	) -> JBLOCKARRAY,
	request_virt_sarray: proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		pre_zero: boolean,
		samplesperrow: JDIMENSION,
		numrows: JDIMENSION,
		maxaccess: JDIMENSION,
	) -> jvirt_sarray_ptr,
	request_virt_barray: proc "c" (
		cinfo: j_common_ptr,
		pool_id: c.int,
		pre_zero: boolean,
		blocksperrow: JDIMENSION,
		numrows: JDIMENSION,
		maxaccess: JDIMENSION,
	) -> jvirt_barray_ptr,
	realize_virt_arrays: proc "c" (cinfo: j_common_ptr),
	access_virt_sarray:  proc "c" (
		cinfo: j_common_ptr,
		ptr: jvirt_sarray_ptr,
		start_row: JDIMENSION,
		num_rows: JDIMENSION,
		writable: boolean,
	) -> JSAMPARRAY,
	access_virt_barray:  proc "c" (
		cinfo: j_common_ptr,
		ptr: jvirt_barray_ptr,
		start_row: JDIMENSION,
		num_rows: JDIMENSION,
		writable: boolean,
	) -> JBLOCKARRAY,
	free_pool:           proc "c" (cinfo: j_common_ptr, pool_id: c.int),
	self_destruct:       proc "c" (cinfo: j_common_ptr),
	max_memory_to_use:   c.long,
	max_alloc_chunk:     c.long,
}

jpeg_marker_parser_method :: #type proc "c" (cinfo: j_decompress_ptr) -> boolean

// jpeglib.h macro wrappers
jpeg_create_compress :: #force_inline proc "contextless" (cinfo: j_compress_ptr) {
	jpeg_CreateCompress(cinfo, JPEG_LIB_VERSION, c.size_t(size_of(jpeg_compress_struct)))
}

jpeg_create_decompress :: #force_inline proc "contextless" (cinfo: j_decompress_ptr) {
	jpeg_CreateDecompress(cinfo, JPEG_LIB_VERSION, c.size_t(size_of(jpeg_decompress_struct)))
}

@(default_calling_convention = "c")
foreign jpeglib {
	jpeg_std_error :: proc(err: ^jpeg_error_mgr) -> ^jpeg_error_mgr ---

	jpeg_CreateCompress :: proc(cinfo: j_compress_ptr, version: c.int, structsize: c.size_t) ---
	jpeg_CreateDecompress :: proc(cinfo: j_decompress_ptr, version: c.int, structsize: c.size_t) ---
	jpeg_destroy_compress :: proc(cinfo: j_compress_ptr) ---
	jpeg_destroy_decompress :: proc(cinfo: j_decompress_ptr) ---

	jpeg_stdio_dest :: proc(cinfo: j_compress_ptr, outfile: ^c.FILE) ---
	jpeg_stdio_src :: proc(cinfo: j_decompress_ptr, infile: ^c.FILE) ---

	jpeg_mem_dest :: proc(cinfo: j_compress_ptr, outbuffer: ^^u8, outsize: ^c.ulong) ---
	jpeg_mem_src :: proc(cinfo: j_decompress_ptr, inbuffer: ^u8, insize: c.ulong) ---

	jpeg_set_defaults :: proc(cinfo: j_compress_ptr) ---
	jpeg_set_colorspace :: proc(cinfo: j_compress_ptr, colorspace: J_COLOR_SPACE) ---
	jpeg_default_colorspace :: proc(cinfo: j_compress_ptr) ---
	jpeg_set_quality :: proc(cinfo: j_compress_ptr, quality: c.int, force_baseline: boolean) ---
	jpeg_set_linear_quality :: proc(cinfo: j_compress_ptr, scale_factor: c.int, force_baseline: boolean) ---
	jpeg_add_quant_table :: proc(cinfo: j_compress_ptr, which_tbl: c.int, basic_table: ^c.uint, scale_factor: c.int, force_baseline: boolean) ---
	jpeg_quality_scaling :: proc(quality: c.int) -> c.int ---
	jpeg_enable_lossless :: proc(cinfo: j_compress_ptr, predictor_selection_value: c.int, point_transform: c.int) ---
	jpeg_simple_progression :: proc(cinfo: j_compress_ptr) ---
	jpeg_suppress_tables :: proc(cinfo: j_compress_ptr, suppress: boolean) ---
	jpeg_alloc_quant_table :: proc(cinfo: j_common_ptr) -> ^JQUANT_TBL ---
	jpeg_alloc_huff_table :: proc(cinfo: j_common_ptr) -> ^JHUFF_TBL ---

	jpeg_start_compress :: proc(cinfo: j_compress_ptr, write_all_tables: boolean) ---
	jpeg_write_scanlines :: proc(cinfo: j_compress_ptr, scanlines: JSAMPARRAY, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg12_write_scanlines :: proc(cinfo: j_compress_ptr, scanlines: J12SAMPARRAY, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg16_write_scanlines :: proc(cinfo: j_compress_ptr, scanlines: J16SAMPARRAY, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg_finish_compress :: proc(cinfo: j_compress_ptr) ---

	jpeg_write_raw_data :: proc(cinfo: j_compress_ptr, data: JSAMPIMAGE, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg12_write_raw_data :: proc(cinfo: j_compress_ptr, data: J12SAMPIMAGE, num_lines: JDIMENSION) -> JDIMENSION ---

	jpeg_write_marker :: proc(cinfo: j_compress_ptr, marker: c.int, dataptr: ^JOCTET, datalen: c.uint) ---
	jpeg_write_m_header :: proc(cinfo: j_compress_ptr, marker: c.int, datalen: c.uint) ---
	jpeg_write_m_byte :: proc(cinfo: j_compress_ptr, val: c.int) ---
	jpeg_write_tables :: proc(cinfo: j_compress_ptr) ---
	jpeg_write_icc_profile :: proc(cinfo: j_compress_ptr, icc_data_ptr: ^JOCTET, icc_data_len: c.uint) ---

	jpeg_read_header :: proc(cinfo: j_decompress_ptr, require_image: boolean) -> c.int ---

	jpeg_start_decompress :: proc(cinfo: j_decompress_ptr) -> boolean ---
	jpeg_read_scanlines :: proc(cinfo: j_decompress_ptr, scanlines: JSAMPARRAY, max_lines: JDIMENSION) -> JDIMENSION ---
	jpeg12_read_scanlines :: proc(cinfo: j_decompress_ptr, scanlines: J12SAMPARRAY, max_lines: JDIMENSION) -> JDIMENSION ---
	jpeg16_read_scanlines :: proc(cinfo: j_decompress_ptr, scanlines: J16SAMPARRAY, max_lines: JDIMENSION) -> JDIMENSION ---
	jpeg_skip_scanlines :: proc(cinfo: j_decompress_ptr, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg12_skip_scanlines :: proc(cinfo: j_decompress_ptr, num_lines: JDIMENSION) -> JDIMENSION ---
	jpeg_crop_scanline :: proc(cinfo: j_decompress_ptr, xoffset: ^JDIMENSION, width: ^JDIMENSION) ---
	jpeg12_crop_scanline :: proc(cinfo: j_decompress_ptr, xoffset: ^JDIMENSION, width: ^JDIMENSION) ---
	jpeg_finish_decompress :: proc(cinfo: j_decompress_ptr) -> boolean ---

	jpeg_read_raw_data :: proc(cinfo: j_decompress_ptr, data: JSAMPIMAGE, max_lines: JDIMENSION) -> JDIMENSION ---
	jpeg12_read_raw_data :: proc(cinfo: j_decompress_ptr, data: J12SAMPIMAGE, max_lines: JDIMENSION) -> JDIMENSION ---

	jpeg_has_multiple_scans :: proc(cinfo: j_decompress_ptr) -> boolean ---
	jpeg_start_output :: proc(cinfo: j_decompress_ptr, scan_number: c.int) -> boolean ---
	jpeg_finish_output :: proc(cinfo: j_decompress_ptr) -> boolean ---
	jpeg_input_complete :: proc(cinfo: j_decompress_ptr) -> boolean ---
	jpeg_new_colormap :: proc(cinfo: j_decompress_ptr) ---
	jpeg_consume_input :: proc(cinfo: j_decompress_ptr) -> c.int ---

	jpeg_calc_output_dimensions :: proc(cinfo: j_decompress_ptr) ---

	jpeg_save_markers :: proc(cinfo: j_decompress_ptr, marker_code: c.int, length_limit: c.uint) ---
	jpeg_set_marker_processor :: proc(cinfo: j_decompress_ptr, marker_code: c.int, routine: jpeg_marker_parser_method) ---

	jpeg_read_coefficients :: proc(cinfo: j_decompress_ptr) -> ^jvirt_barray_ptr ---
	jpeg_write_coefficients :: proc(cinfo: j_compress_ptr, coef_arrays: ^jvirt_barray_ptr) ---
	jpeg_copy_critical_parameters :: proc(srcinfo: j_decompress_ptr, dstinfo: j_compress_ptr) ---

	jpeg_abort_compress :: proc(cinfo: j_compress_ptr) ---
	jpeg_abort_decompress :: proc(cinfo: j_decompress_ptr) ---
	jpeg_abort :: proc(cinfo: j_common_ptr) ---
	jpeg_destroy :: proc(cinfo: j_common_ptr) ---

	jpeg_resync_to_restart :: proc(cinfo: j_decompress_ptr, desired: c.int) -> boolean ---
	jpeg_read_icc_profile :: proc(cinfo: j_decompress_ptr, icc_data_ptr: ^^JOCTET, icc_data_len: ^c.uint) -> boolean ---
}
