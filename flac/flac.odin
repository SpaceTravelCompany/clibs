// Odin binding for libFLAC (Free Lossless Audio Codec)
// Based on FLAC headers from https://github.com/xiph/flac
package flac

import "core:c"
import "shared:utils_private/library"

@(private)
LIB :: library.Libpath + "/libFLAC" + library.ArchEnd
foreign import lib {LIB}

// ============================================================
// ordinals.h
// ============================================================

FLAC__int8  :: c.char
FLAC__uint8 :: byte
FLAC__int16 :: i16
FLAC__int32 :: i32
FLAC__int64 :: i64
FLAC__uint16 :: u16
FLAC__uint32 :: u32
FLAC__uint64 :: u64
FLAC__bool   :: c.int
FLAC__byte   :: FLAC__uint8

// ============================================================
// callback.h
// ============================================================

FLAC__IOHandle :: rawptr

FLAC__IOCallbacks :: struct {
	read:  proc "c" (ptr: rawptr, size: c.size_t, nmemb: c.size_t, handle: FLAC__IOHandle) -> c.size_t,
	write: proc "c" (ptr: rawptr, size: c.size_t, nmemb: c.size_t, handle: FLAC__IOHandle) -> c.size_t,
	seek:  proc "c" (handle: FLAC__IOHandle, offset: FLAC__int64, whence: c.int) -> c.int,
	tell:  proc "c" (handle: FLAC__IOHandle) -> FLAC__int64,
	eof:   proc "c" (handle: FLAC__IOHandle) -> c.int,
	close: proc "c" (handle: FLAC__IOHandle) -> c.int,
}

// ============================================================
// format.h
// ============================================================

FLAC__MAX_METADATA_TYPE_CODE :: 126
FLAC__MIN_BLOCK_SIZE :: 16
FLAC__MAX_BLOCK_SIZE :: 65535
FLAC__SUBSET_MAX_BLOCK_SIZE_48000HZ :: 4608
FLAC__MAX_CHANNELS :: 8
FLAC__MIN_BITS_PER_SAMPLE :: 4
FLAC__MAX_BITS_PER_SAMPLE :: 32
FLAC__REFERENCE_CODEC_MAX_BITS_PER_SAMPLE :: 32
FLAC__MAX_SAMPLE_RATE :: 1048575
FLAC__MAX_LPC_ORDER :: 32
FLAC__SUBSET_MAX_LPC_ORDER_48000HZ :: 12
FLAC__MIN_QLP_COEFF_PRECISION :: 5
FLAC__MAX_QLP_COEFF_PRECISION :: 15
FLAC__MAX_FIXED_ORDER :: 4
FLAC__MAX_RICE_PARTITION_ORDER :: 15
FLAC__SUBSET_MAX_RICE_PARTITION_ORDER :: 8
FLAC__STREAM_SYNC_LENGTH :: 4

FLAC__EntropyCodingMethodType :: enum c.int {
	PARTITIONED_RICE  = 0,
	PARTITIONED_RICE2 = 1,
}

FLAC__EntropyCodingMethod_PartitionedRiceContents :: struct {
	parameters:        [^]FLAC__uint32,
	raw_bits:          [^]FLAC__uint32,
	capacity_by_order: FLAC__uint32,
}

FLAC__EntropyCodingMethod_PartitionedRice :: struct {
	order:    FLAC__uint32,
	contents: ^FLAC__EntropyCodingMethod_PartitionedRiceContents,
}

FLAC__EntropyCodingMethod :: struct {
	type: FLAC__EntropyCodingMethodType,
	data: struct #raw_union {
		partitioned_rice: FLAC__EntropyCodingMethod_PartitionedRice,
	},
}

FLAC__SubframeType :: enum c.int {
	CONSTANT = 0,
	VERBATIM = 1,
	FIXED    = 2,
	LPC      = 3,
}

FLAC__Subframe_Constant :: struct {
	value: FLAC__int64,
}

FLAC__VerbatimSubframeDataType :: enum c.int {
	INT32 = 0,
	INT64 = 1,
}

FLAC__Subframe_Verbatim :: struct {
	data:      struct #raw_union {
		int32: [^]FLAC__int32,
		int64: [^]FLAC__int64,
	},
	data_type: FLAC__VerbatimSubframeDataType,
}

FLAC__Subframe_Fixed :: struct {
	entropy_coding_method: FLAC__EntropyCodingMethod,
	order:                 FLAC__uint32,
	warmup:                [FLAC__MAX_FIXED_ORDER]FLAC__int64,
	residual:              [^]FLAC__int32,
}

FLAC__Subframe_LPC :: struct {
	entropy_coding_method: FLAC__EntropyCodingMethod,
	order:                 FLAC__uint32,
	qlp_coeff_precision:   FLAC__uint32,
	quantization_level:    c.int,
	qlp_coeff:             [FLAC__MAX_LPC_ORDER]FLAC__int32,
	warmup:                [FLAC__MAX_LPC_ORDER]FLAC__int64,
	residual:              [^]FLAC__int32,
}

FLAC__Subframe :: struct {
	type:        FLAC__SubframeType,
	data:        struct #raw_union {
		constant: FLAC__Subframe_Constant,
		fixed:    FLAC__Subframe_Fixed,
		lpc:      FLAC__Subframe_LPC,
		verbatim: FLAC__Subframe_Verbatim,
	},
	wasted_bits: FLAC__uint32,
}

FLAC__ChannelAssignment :: enum c.int {
	INDEPENDENT = 0,
	LEFT_SIDE   = 1,
	RIGHT_SIDE  = 2,
	MID_SIDE    = 3,
}

FLAC__FrameNumberType :: enum c.int {
	FRAME_NUMBER  = 0,
	SAMPLE_NUMBER = 1,
}

FLAC__FrameHeader :: struct {
	blocksize:          FLAC__uint32,
	sample_rate:        FLAC__uint32,
	channels:           FLAC__uint32,
	channel_assignment: FLAC__ChannelAssignment,
	bits_per_sample:    FLAC__uint32,
	number_type:        FLAC__FrameNumberType,
	number:             struct #raw_union {
		frame_number:  FLAC__uint32,
		sample_number: FLAC__uint64,
	},
	crc: FLAC__uint8,
}

FLAC__FrameFooter :: struct {
	crc: FLAC__uint16,
}

FLAC__Frame :: struct {
	header:    FLAC__FrameHeader,
	subframes: [FLAC__MAX_CHANNELS]FLAC__Subframe,
	footer:    FLAC__FrameFooter,
}

FLAC__MetadataType :: enum c.int {
	STREAMINFO      = 0,
	PADDING         = 1,
	APPLICATION     = 2,
	SEEKTABLE       = 3,
	VORBIS_COMMENT  = 4,
	CUESHEET        = 5,
	PICTURE         = 6,
	UNDEFINED       = 7,
	MAX_METADATA    = FLAC__MAX_METADATA_TYPE_CODE,
}

FLAC__StreamMetadata_StreamInfo :: struct {
	min_blocksize:   FLAC__uint32,
	max_blocksize:   FLAC__uint32,
	min_framesize:   FLAC__uint32,
	max_framesize:   FLAC__uint32,
	sample_rate:     FLAC__uint32,
	channels:        FLAC__uint32,
	bits_per_sample: FLAC__uint32,
	total_samples:   FLAC__uint64,
	md5sum:          [16]FLAC__byte,
}

FLAC__StreamMetadata_Padding :: struct {
	dummy: c.int,
}

FLAC__StreamMetadata_Application :: struct {
	id:   [4]FLAC__byte,
	data: [^]FLAC__byte,
}

FLAC__StreamMetadata_SeekPoint :: struct {
	sample_number:  FLAC__uint64,
	stream_offset:  FLAC__uint64,
	frame_samples:  FLAC__uint32,
}

FLAC__StreamMetadata_SeekTable :: struct {
	num_points: FLAC__uint32,
	points:     ^FLAC__StreamMetadata_SeekPoint,
}

FLAC__StreamMetadata_VorbisComment_Entry :: struct {
	length: FLAC__uint32,
	entry:  [^]FLAC__byte,
}

FLAC__StreamMetadata_VorbisComment :: struct {
	vendor_string: FLAC__StreamMetadata_VorbisComment_Entry,
	num_comments:  FLAC__uint32,
	comments:      ^FLAC__StreamMetadata_VorbisComment_Entry,
}

FLAC__StreamMetadata_CueSheet_Index :: struct {
	offset: FLAC__uint64,
	number: FLAC__byte,
}

FLAC__StreamMetadata_CueSheet_Track :: struct {
	offset:        FLAC__uint64,
	number:        FLAC__byte,
	isrc:          [13]c.char,
	type:          FLAC__uint32,
	pre_emphasis:  FLAC__uint32,
	num_indices:   FLAC__byte,
	indices:       ^FLAC__StreamMetadata_CueSheet_Index,
}

FLAC__StreamMetadata_CueSheet :: struct {
	media_catalog_number: [129]c.char,
	lead_in:              FLAC__uint64,
	is_cd:                FLAC__bool,
	num_tracks:           FLAC__uint32,
	tracks:               ^FLAC__StreamMetadata_CueSheet_Track,
}

FLAC__StreamMetadata_Picture_Type :: enum c.int {
	OTHER               = 0,
	FILE_ICON_STANDARD  = 1,
	FILE_ICON           = 2,
	FRONT_COVER         = 3,
	BACK_COVER          = 4,
	LEAFLET_PAGE        = 5,
	MEDIA               = 6,
	LEAD_ARTIST         = 7,
	ARTIST              = 8,
	CONDUCTOR           = 9,
	BAND                = 10,
	COMPOSER            = 11,
	LYRICIST            = 12,
	RECORDING_LOCATION  = 13,
	DURING_RECORDING    = 14,
	DURING_PERFORMANCE  = 15,
	VIDEO_SCREEN_CAPTURE = 16,
	FISH                = 17,
	ILLUSTRATION        = 18,
	BAND_LOGOTYPE       = 19,
	PUBLISHER_LOGOTYPE  = 20,
	UNDEFINED           = 21,
}

FLAC__StreamMetadata_Picture :: struct {
	type:        FLAC__StreamMetadata_Picture_Type,
	mime_type:   cstring,
	description: [^]FLAC__byte,
	width:       FLAC__uint32,
	height:      FLAC__uint32,
	depth:       FLAC__uint32,
	colors:      FLAC__uint32,
	data_length: FLAC__uint32,
	data:        [^]FLAC__byte,
}

FLAC__StreamMetadata_Unknown :: struct {
	data: [^]FLAC__byte,
}

FLAC__StreamMetadata :: struct {
	type:     FLAC__MetadataType,
	is_last:  FLAC__bool,
	length:   FLAC__uint32,
	data:     struct #raw_union {
		stream_info:    FLAC__StreamMetadata_StreamInfo,
		padding:        FLAC__StreamMetadata_Padding,
		application:    FLAC__StreamMetadata_Application,
		seek_table:     FLAC__StreamMetadata_SeekTable,
		vorbis_comment: FLAC__StreamMetadata_VorbisComment,
		cue_sheet:      FLAC__StreamMetadata_CueSheet,
		picture:        FLAC__StreamMetadata_Picture,
		unknown:        FLAC__StreamMetadata_Unknown,
	},
}

@(default_calling_convention = "c")
foreign lib {
	FLAC__format_sample_rate_is_valid :: proc(sample_rate: FLAC__uint32) -> FLAC__bool ---
	FLAC__format_blocksize_is_subset :: proc(blocksize: FLAC__uint32, sample_rate: FLAC__uint32) -> FLAC__bool ---
	FLAC__format_sample_rate_is_subset :: proc(sample_rate: FLAC__uint32) -> FLAC__bool ---
	FLAC__format_vorbiscomment_entry_name_is_legal :: proc(name: cstring) -> FLAC__bool ---
	FLAC__format_vorbiscomment_entry_value_is_legal :: proc(value: [^]FLAC__byte, length: FLAC__uint32) -> FLAC__bool ---
	FLAC__format_vorbiscomment_entry_is_legal :: proc(entry: [^]FLAC__byte, length: FLAC__uint32) -> FLAC__bool ---
	FLAC__format_seektable_is_legal :: proc(seek_table: ^FLAC__StreamMetadata_SeekTable) -> FLAC__bool ---
	FLAC__format_seektable_sort :: proc(seek_table: ^FLAC__StreamMetadata_SeekTable) -> FLAC__uint32 ---
	FLAC__format_cuesheet_is_legal :: proc(cue_sheet: ^FLAC__StreamMetadata_CueSheet, check_cd_da_subset: FLAC__bool, violation: ^cstring) -> FLAC__bool ---
	FLAC__format_picture_is_legal :: proc(picture: ^FLAC__StreamMetadata_Picture, violation: ^cstring) -> FLAC__bool ---
}

// ============================================================
// stream_decoder.h
// ============================================================

FLAC__StreamDecoderState :: enum c.int {
	SEARCH_FOR_METADATA     = 0,
	READ_METADATA           = 1,
	SEARCH_FOR_FRAME_SYNC   = 2,
	READ_FRAME              = 3,
	END_OF_STREAM           = 4,
	OGG_ERROR               = 5,
	SEEK_ERROR              = 6,
	ABORTED                 = 7,
	MEMORY_ALLOCATION_ERROR = 8,
	UNINITIALIZED           = 9,
	END_OF_LINK             = 10,
}

FLAC__StreamDecoderInitStatus :: enum c.int {
	OK                       = 0,
	UNSUPPORTED_CONTAINER    = 1,
	INVALID_CALLBACKS        = 2,
	MEMORY_ALLOCATION_ERROR  = 3,
	ERROR_OPENING_FILE       = 4,
	ALREADY_INITIALIZED      = 5,
}

FLAC__StreamDecoderReadStatus :: enum c.int {
	CONTINUE      = 0,
	END_OF_STREAM = 1,
	ABORT         = 2,
	END_OF_LINK   = 3,
}

FLAC__StreamDecoderSeekStatus :: enum c.int {
	OK           = 0,
	ERROR        = 1,
	UNSUPPORTED  = 2,
}

FLAC__StreamDecoderTellStatus :: enum c.int {
	OK           = 0,
	ERROR        = 1,
	UNSUPPORTED  = 2,
}

FLAC__StreamDecoderLengthStatus :: enum c.int {
	OK           = 0,
	ERROR        = 1,
	UNSUPPORTED  = 2,
}

FLAC__StreamDecoderWriteStatus :: enum c.int {
	CONTINUE = 0,
	ABORT    = 1,
}

FLAC__StreamDecoderErrorStatus :: enum c.int {
	LOST_SYNC            = 0,
	BAD_HEADER           = 1,
	FRAME_CRC_MISMATCH   = 2,
	UNPARSEABLE_STREAM   = 3,
	BAD_METADATA         = 4,
	OUT_OF_BOUNDS        = 5,
	MISSING_FRAME        = 6,
}

FLAC__StreamDecoder :: struct {
	protected_: ^struct {},
	private_:   ^struct {},
}

FLAC__StreamDecoderReadCallback  :: #type proc "c" (decoder: ^FLAC__StreamDecoder, buffer: [^]FLAC__byte, bytes: ^c.size_t, client_data: rawptr) -> FLAC__StreamDecoderReadStatus
FLAC__StreamDecoderSeekCallback  :: #type proc "c" (decoder: ^FLAC__StreamDecoder, absolute_byte_offset: FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderSeekStatus
FLAC__StreamDecoderTellCallback  :: #type proc "c" (decoder: ^FLAC__StreamDecoder, absolute_byte_offset: ^FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderTellStatus
FLAC__StreamDecoderLengthCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, stream_length: ^FLAC__uint64, client_data: rawptr) -> FLAC__StreamDecoderLengthStatus
FLAC__StreamDecoderEofCallback   :: #type proc "c" (decoder: ^FLAC__StreamDecoder, client_data: rawptr) -> FLAC__bool
FLAC__StreamDecoderWriteCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, frame: ^FLAC__Frame, buffer: [^][^]FLAC__int32, client_data: rawptr) -> FLAC__StreamDecoderWriteStatus
FLAC__StreamDecoderMetadataCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, metadata: ^FLAC__StreamMetadata, client_data: rawptr)
FLAC__StreamDecoderErrorCallback :: #type proc "c" (decoder: ^FLAC__StreamDecoder, status: FLAC__StreamDecoderErrorStatus, client_data: rawptr)

@(default_calling_convention = "c")
foreign lib {
	FLAC__stream_decoder_new :: proc() -> ^FLAC__StreamDecoder ---
	FLAC__stream_decoder_delete :: proc(decoder: ^FLAC__StreamDecoder) ---

	FLAC__stream_decoder_set_ogg_serial_number :: proc(decoder: ^FLAC__StreamDecoder, serial_number: c.long) -> FLAC__bool ---
	FLAC__stream_decoder_set_decode_chained_stream :: proc(decoder: ^FLAC__StreamDecoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_decoder_set_md5_checking :: proc(decoder: ^FLAC__StreamDecoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond :: proc(decoder: ^FLAC__StreamDecoder, type: FLAC__MetadataType) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond_application :: proc(decoder: ^FLAC__StreamDecoder, id: [^]FLAC__byte) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_respond_all :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore :: proc(decoder: ^FLAC__StreamDecoder, type: FLAC__MetadataType) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore_application :: proc(decoder: ^FLAC__StreamDecoder, id: [^]FLAC__byte) -> FLAC__bool ---
	FLAC__stream_decoder_set_metadata_ignore_all :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---

	FLAC__stream_decoder_get_state :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__StreamDecoderState ---
	FLAC__stream_decoder_get_resolved_state_string :: proc(decoder: ^FLAC__StreamDecoder) -> cstring ---
	FLAC__stream_decoder_get_decode_chained_stream :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_get_md5_checking :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_get_total_samples :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint64 ---
	FLAC__stream_decoder_find_total_samples :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint64 ---
	FLAC__stream_decoder_get_channels :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_channel_assignment :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__ChannelAssignment ---
	FLAC__stream_decoder_get_bits_per_sample :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_sample_rate :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_blocksize :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__uint32 ---
	FLAC__stream_decoder_get_decode_position :: proc(decoder: ^FLAC__StreamDecoder, position: ^FLAC__uint64) -> FLAC__bool ---
	FLAC__stream_decoder_get_client_data :: proc(decoder: ^FLAC__StreamDecoder) -> rawptr ---
	FLAC__stream_decoder_get_link_lengths :: proc(decoder: ^FLAC__StreamDecoder, link_lengths: ^^FLAC__uint64) -> c.int32_t ---

	FLAC__stream_decoder_init_stream :: proc(
		decoder: ^FLAC__StreamDecoder,
		read_callback: FLAC__StreamDecoderReadCallback,
		seek_callback: FLAC__StreamDecoderSeekCallback,
		tell_callback: FLAC__StreamDecoderTellCallback,
		length_callback: FLAC__StreamDecoderLengthCallback,
		eof_callback: FLAC__StreamDecoderEofCallback,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_ogg_stream :: proc(
		decoder: ^FLAC__StreamDecoder,
		read_callback: FLAC__StreamDecoderReadCallback,
		seek_callback: FLAC__StreamDecoderSeekCallback,
		tell_callback: FLAC__StreamDecoderTellCallback,
		length_callback: FLAC__StreamDecoderLengthCallback,
		eof_callback: FLAC__StreamDecoderEofCallback,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_FILE :: proc(
		decoder: ^FLAC__StreamDecoder,
		file: rawptr,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_ogg_FILE :: proc(
		decoder: ^FLAC__StreamDecoder,
		file: rawptr,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_file :: proc(
		decoder: ^FLAC__StreamDecoder,
		filename: cstring,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_init_ogg_file :: proc(
		decoder: ^FLAC__StreamDecoder,
		filename: cstring,
		write_callback: FLAC__StreamDecoderWriteCallback,
		metadata_callback: FLAC__StreamDecoderMetadataCallback,
		error_callback: FLAC__StreamDecoderErrorCallback,
		client_data: rawptr,
	) -> FLAC__StreamDecoderInitStatus ---

	FLAC__stream_decoder_finish :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_finish_link :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_flush :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_reset :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---

	FLAC__stream_decoder_process_single :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_until_end_of_metadata :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_until_end_of_link :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_process_until_end_of_stream :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_skip_single_frame :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_skip_single_link :: proc(decoder: ^FLAC__StreamDecoder) -> FLAC__bool ---
	FLAC__stream_decoder_seek_absolute :: proc(decoder: ^FLAC__StreamDecoder, sample: FLAC__uint64) -> FLAC__bool ---
}

// ============================================================
// stream_encoder.h
// ============================================================

FLAC__StreamEncoderState :: enum c.int {
	OK                               = 0,
	UNINITIALIZED                    = 1,
	OGG_ERROR                        = 2,
	VERIFY_DECODER_ERROR             = 3,
	VERIFY_MISMATCH_IN_AUDIO_DATA    = 4,
	CLIENT_ERROR                     = 5,
	IO_ERROR                         = 6,
	FRAMING_ERROR                    = 7,
	MEMORY_ALLOCATION_ERROR          = 8,
}

FLAC__STREAM_ENCODER_SET_NUM_THREADS_OK :: 0
FLAC__STREAM_ENCODER_SET_NUM_THREADS_NOT_COMPILED_WITH_MULTITHREADING_ENABLED :: 1
FLAC__STREAM_ENCODER_SET_NUM_THREADS_ALREADY_INITIALIZED :: 2
FLAC__STREAM_ENCODER_SET_NUM_THREADS_TOO_MANY_THREADS :: 3

FLAC__StreamEncoderInitStatus :: enum c.int {
	OK                                            = 0,
	ENCODER_ERROR                                 = 1,
	UNSUPPORTED_CONTAINER                         = 2,
	INVALID_CALLBACKS                             = 3,
	INVALID_NUMBER_OF_CHANNELS                    = 4,
	INVALID_BITS_PER_SAMPLE                       = 5,
	INVALID_SAMPLE_RATE                           = 6,
	INVALID_BLOCK_SIZE                            = 7,
	INVALID_MAX_LPC_ORDER                         = 8,
	INVALID_QLP_COEFF_PRECISION                   = 9,
	BLOCK_SIZE_TOO_SMALL_FOR_LPC_ORDER            = 10,
	NOT_STREAMABLE                                = 11,
	INVALID_METADATA                              = 12,
	ALREADY_INITIALIZED                           = 13,
}

FLAC__StreamEncoderReadStatus :: enum c.int {
	CONTINUE      = 0,
	END_OF_STREAM = 1,
	ABORT         = 2,
	UNSUPPORTED   = 3,
}

FLAC__StreamEncoderWriteStatus :: enum c.int {
	OK           = 0,
	FATAL_ERROR  = 1,
}

FLAC__StreamEncoderSeekStatus :: enum c.int {
	OK           = 0,
	ERROR        = 1,
	UNSUPPORTED  = 2,
}

FLAC__StreamEncoderTellStatus :: enum c.int {
	OK           = 0,
	ERROR        = 1,
	UNSUPPORTED  = 2,
}

FLAC__StreamEncoder :: struct {
	protected_: ^struct {},
	private_:   ^struct {},
}

FLAC__StreamEncoderReadCallback  :: #type proc "c" (encoder: ^FLAC__StreamEncoder, buffer: [^]FLAC__byte, bytes: ^c.size_t, client_data: rawptr) -> FLAC__StreamEncoderReadStatus
FLAC__StreamEncoderWriteCallback :: #type proc "c" (encoder: ^FLAC__StreamEncoder, buffer: [^]FLAC__byte, bytes: c.size_t, samples: FLAC__uint32, current_frame: FLAC__uint32, client_data: rawptr) -> FLAC__StreamEncoderWriteStatus
FLAC__StreamEncoderSeekCallback :: #type proc "c" (encoder: ^FLAC__StreamEncoder, absolute_byte_offset: FLAC__uint64, client_data: rawptr) -> FLAC__StreamEncoderSeekStatus
FLAC__StreamEncoderTellCallback :: #type proc "c" (encoder: ^FLAC__StreamEncoder, absolute_byte_offset: ^FLAC__uint64, client_data: rawptr) -> FLAC__StreamEncoderTellStatus
FLAC__StreamEncoderMetadataCallback :: #type proc "c" (encoder: ^FLAC__StreamEncoder, metadata: ^FLAC__StreamMetadata, client_data: rawptr)
FLAC__StreamEncoderProgressCallback :: #type proc "c" (encoder: ^FLAC__StreamEncoder, bytes_written: FLAC__uint64, samples_written: FLAC__uint64, frames_written: FLAC__uint32, total_frames_estimate: FLAC__uint32, client_data: rawptr)

@(default_calling_convention = "c")
foreign lib {
	FLAC__stream_encoder_new :: proc() -> ^FLAC__StreamEncoder ---
	FLAC__stream_encoder_delete :: proc(encoder: ^FLAC__StreamEncoder) ---

	FLAC__stream_encoder_set_ogg_serial_number :: proc(encoder: ^FLAC__StreamEncoder, serial_number: c.long) -> FLAC__bool ---
	FLAC__stream_encoder_set_verify :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_streamable_subset :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_channels :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_bits_per_sample :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_sample_rate :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_compression_level :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_blocksize :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_loose_mid_side_stereo :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_apodization :: proc(encoder: ^FLAC__StreamEncoder, specification: cstring) -> FLAC__bool ---
	FLAC__stream_encoder_set_max_lpc_order :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_qlp_coeff_precision :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_qlp_coeff_prec_search :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_escape_coding :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_do_exhaustive_model_search :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_set_min_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_max_residual_partition_order :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_total_samples_estimate :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__uint64) -> FLAC__bool ---
	FLAC__stream_encoder_set_metadata :: proc(encoder: ^FLAC__StreamEncoder, metadata: [^]^FLAC__StreamMetadata, num_blocks: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_limit_min_bitrate :: proc(encoder: ^FLAC__StreamEncoder, value: FLAC__bool) -> FLAC__bool ---
	FLAC__stream_encoder_get_state :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__StreamEncoderState ---
	FLAC__stream_encoder_get_verify_decoder_state :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__StreamDecoderState ---
	FLAC__stream_encoder_get_resolved_state_string :: proc(encoder: ^FLAC__StreamEncoder) -> cstring ---
	FLAC__stream_encoder_get_verify_decoder_error_stats :: proc(encoder: ^FLAC__StreamEncoder, absolute_sample: ^FLAC__uint64, frame_number: ^FLAC__uint32, channel: ^FLAC__uint32, sample: ^FLAC__uint32, expected: ^FLAC__int32, got: ^FLAC__int32) -> FLAC__bool ---
	FLAC__stream_encoder_get_channels :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_bits_per_sample :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_sample_rate :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_blocksize :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_num_threads :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_limit_min_bitrate :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_get_total_samples_estimate :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__uint64 ---

	FLAC__stream_encoder_init_stream :: proc(
		encoder: ^FLAC__StreamEncoder,
		write_callback: FLAC__StreamEncoderWriteCallback,
		seek_callback: FLAC__StreamEncoderSeekCallback,
		tell_callback: FLAC__StreamEncoderTellCallback,
		metadata_callback: FLAC__StreamEncoderMetadataCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_init_ogg_stream :: proc(
		encoder: ^FLAC__StreamEncoder,
		read_callback: FLAC__StreamEncoderReadCallback,
		write_callback: FLAC__StreamEncoderWriteCallback,
		seek_callback: FLAC__StreamEncoderSeekCallback,
		tell_callback: FLAC__StreamEncoderTellCallback,
		metadata_callback: FLAC__StreamEncoderMetadataCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_init_FILE :: proc(
		encoder: ^FLAC__StreamEncoder,
		file: rawptr,
		progress_callback: FLAC__StreamEncoderProgressCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_init_ogg_FILE :: proc(
		encoder: ^FLAC__StreamEncoder,
		file: rawptr,
		progress_callback: FLAC__StreamEncoderProgressCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_init_file :: proc(
		encoder: ^FLAC__StreamEncoder,
		filename: cstring,
		progress_callback: FLAC__StreamEncoderProgressCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_init_ogg_file :: proc(
		encoder: ^FLAC__StreamEncoder,
		filename: cstring,
		progress_callback: FLAC__StreamEncoderProgressCallback,
		client_data: rawptr,
	) -> FLAC__StreamEncoderInitStatus ---

	FLAC__stream_encoder_finish :: proc(encoder: ^FLAC__StreamEncoder) -> FLAC__bool ---
	FLAC__stream_encoder_process :: proc(encoder: ^FLAC__StreamEncoder, buffer: [^][^]FLAC__int32, samples: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_process_interleaved :: proc(encoder: ^FLAC__StreamEncoder, buffer: [^]FLAC__int32, samples: FLAC__uint32) -> FLAC__bool ---
	FLAC__stream_encoder_set_num_threads :: proc(encoder: ^FLAC__StreamEncoder, num: FLAC__uint32) -> FLAC__uint32 ---
	FLAC__stream_encoder_get_client_data :: proc(encoder: ^FLAC__StreamEncoder) -> rawptr ---
}

// ============================================================
// metadata.h
// ============================================================

FLAC__Metadata_SimpleIteratorStatus :: enum c.int {
	OK                        = 0,
	ILLEGAL_INPUT             = 1,
	ERROR_OPENING_FILE        = 2,
	NOT_A_FLAC_FILE           = 3,
	NOT_WRITABLE              = 4,
	BAD_METADATA              = 5,
	READ_ERROR                = 6,
	SEEK_ERROR                = 7,
	WRITE_ERROR               = 8,
	RENAME_ERROR              = 9,
	UNLINK_ERROR              = 10,
	MEMORY_ALLOCATION_ERROR   = 11,
	INTERNAL_ERROR            = 12,
}

FLAC__Metadata_ChainStatus :: enum c.int {
	OK                             = 0,
	ILLEGAL_INPUT                  = 1,
	ERROR_OPENING_FILE             = 2,
	NOT_A_FLAC_FILE                = 3,
	NOT_WRITABLE                   = 4,
	BAD_METADATA                   = 5,
	READ_ERROR                     = 6,
	SEEK_ERROR                     = 7,
	WRITE_ERROR                    = 8,
	RENAME_ERROR                   = 9,
	UNLINK_ERROR                   = 10,
	MEMORY_ALLOCATION_ERROR        = 11,
	INTERNAL_ERROR                 = 12,
	INVALID_CALLBACKS              = 13,
	READ_WRITE_MISMATCH            = 14,
	WRONG_WRITE_CALL               = 15,
}

FLAC__Metadata_SimpleIterator :: struct {}
FLAC__Metadata_Chain :: struct {}
FLAC__Metadata_Iterator :: struct {}

@(default_calling_convention = "c")
foreign lib {
	// Level 0
	FLAC__metadata_get_streaminfo :: proc(filename: cstring, streaminfo: ^FLAC__StreamMetadata) -> FLAC__bool ---
	FLAC__metadata_get_tags :: proc(filename: cstring, tags: ^^FLAC__StreamMetadata) -> FLAC__bool ---
	FLAC__metadata_get_cuesheet :: proc(filename: cstring, cuesheet: ^^FLAC__StreamMetadata) -> FLAC__bool ---
	FLAC__metadata_get_picture :: proc(filename: cstring, picture: ^^FLAC__StreamMetadata, type: FLAC__StreamMetadata_Picture_Type, mime_type: cstring, description: [^]FLAC__byte, max_width: FLAC__uint32, max_height: FLAC__uint32, max_depth: FLAC__uint32, max_colors: FLAC__uint32) -> FLAC__bool ---

	// Level 1 - SimpleIterator
	FLAC__metadata_simple_iterator_new :: proc() -> ^FLAC__Metadata_SimpleIterator ---
	FLAC__metadata_simple_iterator_delete :: proc(iterator: ^FLAC__Metadata_SimpleIterator) ---
	FLAC__metadata_simple_iterator_status :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__Metadata_SimpleIteratorStatus ---
	FLAC__metadata_simple_iterator_init :: proc(iterator: ^FLAC__Metadata_SimpleIterator, filename: cstring, read_only: FLAC__bool, preserve_file_stats: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_is_writable :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_next :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_prev :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_is_last :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_get_block_offset :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> c.long ---
	FLAC__metadata_simple_iterator_get_block_type :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__MetadataType ---
	FLAC__metadata_simple_iterator_get_block_length :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> FLAC__uint32 ---
	FLAC__metadata_simple_iterator_get_application_id :: proc(iterator: ^FLAC__Metadata_SimpleIterator, id: [^]FLAC__byte) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_get_block :: proc(iterator: ^FLAC__Metadata_SimpleIterator) -> ^FLAC__StreamMetadata ---
	FLAC__metadata_simple_iterator_set_block :: proc(iterator: ^FLAC__Metadata_SimpleIterator, block: ^FLAC__StreamMetadata, use_padding: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_insert_block_after :: proc(iterator: ^FLAC__Metadata_SimpleIterator, block: ^FLAC__StreamMetadata, use_padding: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_simple_iterator_delete_block :: proc(iterator: ^FLAC__Metadata_SimpleIterator, use_padding: FLAC__bool) -> FLAC__bool ---

	// Level 2 - Chain
	FLAC__metadata_chain_new :: proc() -> ^FLAC__Metadata_Chain ---
	FLAC__metadata_chain_delete :: proc(chain: ^FLAC__Metadata_Chain) ---
	FLAC__metadata_chain_status :: proc(chain: ^FLAC__Metadata_Chain) -> FLAC__Metadata_ChainStatus ---
	FLAC__metadata_chain_read :: proc(chain: ^FLAC__Metadata_Chain, filename: cstring) -> FLAC__bool ---
	FLAC__metadata_chain_read_ogg :: proc(chain: ^FLAC__Metadata_Chain, filename: cstring) -> FLAC__bool ---
	FLAC__metadata_chain_read_with_callbacks :: proc(chain: ^FLAC__Metadata_Chain, handle: FLAC__IOHandle, callbacks: FLAC__IOCallbacks) -> FLAC__bool ---
	FLAC__metadata_chain_read_ogg_with_callbacks :: proc(chain: ^FLAC__Metadata_Chain, handle: FLAC__IOHandle, callbacks: FLAC__IOCallbacks) -> FLAC__bool ---
	FLAC__metadata_chain_check_if_tempfile_needed :: proc(chain: ^FLAC__Metadata_Chain, use_padding: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_chain_write :: proc(chain: ^FLAC__Metadata_Chain, use_padding: FLAC__bool, preserve_file_stats: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_chain_write_new_file :: proc(chain: ^FLAC__Metadata_Chain, filename: cstring, use_padding: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_chain_write_with_callbacks :: proc(chain: ^FLAC__Metadata_Chain, use_padding: FLAC__bool, handle: FLAC__IOHandle, callbacks: FLAC__IOCallbacks) -> FLAC__bool ---
	FLAC__metadata_chain_write_with_callbacks_and_tempfile :: proc(chain: ^FLAC__Metadata_Chain, use_padding: FLAC__bool, handle: FLAC__IOHandle, callbacks: FLAC__IOCallbacks, temp_handle: FLAC__IOHandle, temp_callbacks: FLAC__IOCallbacks) -> FLAC__bool ---
	FLAC__metadata_chain_merge_padding :: proc(chain: ^FLAC__Metadata_Chain) ---
	FLAC__metadata_chain_sort_padding :: proc(chain: ^FLAC__Metadata_Chain) ---

	// Level 2 - Iterator
	FLAC__metadata_iterator_new :: proc() -> ^FLAC__Metadata_Iterator ---
	FLAC__metadata_iterator_delete :: proc(iterator: ^FLAC__Metadata_Iterator) ---
	FLAC__metadata_iterator_init :: proc(iterator: ^FLAC__Metadata_Iterator, chain: ^FLAC__Metadata_Chain) ---
	FLAC__metadata_iterator_next :: proc(iterator: ^FLAC__Metadata_Iterator) -> FLAC__bool ---
	FLAC__metadata_iterator_prev :: proc(iterator: ^FLAC__Metadata_Iterator) -> FLAC__bool ---
	FLAC__metadata_iterator_get_block_type :: proc(iterator: ^FLAC__Metadata_Iterator) -> FLAC__MetadataType ---
	FLAC__metadata_iterator_get_block :: proc(iterator: ^FLAC__Metadata_Iterator) -> ^FLAC__StreamMetadata ---
	FLAC__metadata_iterator_set_block :: proc(iterator: ^FLAC__Metadata_Iterator, block: ^FLAC__StreamMetadata) -> FLAC__bool ---
	FLAC__metadata_iterator_delete_block :: proc(iterator: ^FLAC__Metadata_Iterator, replace_with_padding: FLAC__bool) -> FLAC__bool ---
	FLAC__metadata_iterator_insert_block_before :: proc(iterator: ^FLAC__Metadata_Iterator, block: ^FLAC__StreamMetadata) -> FLAC__bool ---
	FLAC__metadata_iterator_insert_block_after :: proc(iterator: ^FLAC__Metadata_Iterator, block: ^FLAC__StreamMetadata) -> FLAC__bool ---
}

// ============================================================
// Exported variables (extern)
// ============================================================

FLAC__STREAM_SYNC :: 0x664C6143

FLAC__STREAM_METADATA_STREAMINFO_LENGTH :: 34
FLAC__STREAM_METADATA_SEEKPOINT_LENGTH :: 18
FLAC__STREAM_METADATA_HEADER_LENGTH :: 4
