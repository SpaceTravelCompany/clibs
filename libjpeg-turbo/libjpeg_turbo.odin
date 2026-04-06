// Bindings for [[libjpeg-turbo ; https://github.com/libjpeg-turbo/libjpeg-turbo]]
package libjpeg_turbo

import "core:c"
import "engine:utils_private/library"

@(private)
LIBJPEG :: library.LIBPATH + "/libjpeg" + library.ARCH_end
@(private)
LIBTURBOJPEG :: library.LIBPATH + "/libturbojpeg" + library.ARCH_end

foreign import turbojpeg {LIBTURBOJPEG, LIBJPEG}

// jconfig.h
JPEG_LIB_VERSION :: 62
LIBJPEG_TURBO_VERSION :: "3.1.90"
LIBJPEG_TURBO_VERSION_NUMBER :: 3001090

// turbojpeg.h
TURBOJPEG_VERSION_NUMBER :: 3002000

TJ_NUMINIT :: 3
TJ_NUMSAMP :: 9
TJ_NUMPF :: 12
TJ_NUMCS :: 5
TJ_NUMERR :: 2
TJ_NUMXOP :: 8

TJXOPT_PERFECT :: 1 << 0
TJXOPT_TRIM :: 1 << 1
TJXOPT_CROP :: 1 << 2
TJXOPT_GRAY :: 1 << 3
TJXOPT_NOOUTPUT :: 1 << 4
TJXOPT_PROGRESSIVE :: 1 << 5
TJXOPT_COPYNONE :: 1 << 6
TJXOPT_ARITHMETIC :: 1 << 7
TJXOPT_OPTIMIZE :: 1 << 8

TJFLAG_BOTTOMUP :: 2
TJFLAG_FORCEMMX :: 8
TJFLAG_FORCESSE :: 16
TJFLAG_FORCESSE2 :: 32
TJFLAG_FORCESSE3 :: 128
TJFLAG_FASTUPSAMPLE :: 256
TJFLAG_NOREALLOC :: 1024
TJFLAG_FASTDCT :: 2048
TJFLAG_ACCURATEDCT :: 4096
TJFLAG_STOPONWARNING :: 8192
TJFLAG_PROGRESSIVE :: 16384
TJFLAG_LIMITSCANS :: 32768

NUMSUBOPT :: TJ_NUMSAMP
TJ_444 :: 0
TJ_422 :: 1
TJ_420 :: 2
TJ_411 :: TJ_420
TJ_GRAYSCALE :: 3
TJ_BGR :: 1
TJ_BOTTOMUP :: TJFLAG_BOTTOMUP
TJ_FORCEMMX :: TJFLAG_FORCEMMX
TJ_FORCESSE :: TJFLAG_FORCESSE
TJ_FORCESSE2 :: TJFLAG_FORCESSE2
TJ_ALPHAFIRST :: 64
TJ_FORCESSE3 :: TJFLAG_FORCESSE3
TJ_FASTUPSAMPLE :: TJFLAG_FASTUPSAMPLE
TJ_YUV :: 512

TJINIT :: enum c.int {
	TJINIT_COMPRESS   = 0,
	TJINIT_DECOMPRESS = 1,
	TJINIT_TRANSFORM  = 2,
}

TJSAMP :: enum c.int {
	TJSAMP_444     = 0,
	TJSAMP_422     = 1,
	TJSAMP_420     = 2,
	TJSAMP_GRAY    = 3,
	TJSAMP_440     = 4,
	TJSAMP_411     = 5,
	TJSAMP_441     = 6,
	TJSAMP_410     = 7,
	TJSAMP_24      = 8,
	TJSAMP_UNKNOWN = -1,
}

TJPF :: enum c.int {
	TJPF_RGB     = 0,
	TJPF_BGR     = 1,
	TJPF_RGBX    = 2,
	TJPF_BGRX    = 3,
	TJPF_XBGR    = 4,
	TJPF_XRGB    = 5,
	TJPF_GRAY    = 6,
	TJPF_RGBA    = 7,
	TJPF_BGRA    = 8,
	TJPF_ABGR    = 9,
	TJPF_ARGB    = 10,
	TJPF_CMYK    = 11,
	TJPF_UNKNOWN = -1,
}

TJCS :: enum c.int {
	TJCS_RGB     = 0,
	TJCS_YCbCr   = 1,
	TJCS_GRAY    = 2,
	TJCS_CMYK    = 3,
	TJCS_YCCK    = 4,
	TJCS_DEFAULT = -1,
}

TJPARAM :: enum c.int {
	TJPARAM_STOPONWARNING = 0,
	TJPARAM_BOTTOMUP,
	TJPARAM_NOREALLOC,
	TJPARAM_QUALITY,
	TJPARAM_SUBSAMP,
	TJPARAM_JPEGWIDTH,
	TJPARAM_JPEGHEIGHT,
	TJPARAM_PRECISION,
	TJPARAM_COLORSPACE,
	TJPARAM_FASTUPSAMPLE,
	TJPARAM_FASTDCT,
	TJPARAM_OPTIMIZE,
	TJPARAM_PROGRESSIVE,
	TJPARAM_SCANLIMIT,
	TJPARAM_ARITHMETIC,
	TJPARAM_LOSSLESS,
	TJPARAM_LOSSLESSPSV,
	TJPARAM_LOSSLESSPT,
	TJPARAM_RESTARTBLOCKS,
	TJPARAM_RESTARTROWS,
	TJPARAM_XDENSITY,
	TJPARAM_YDENSITY,
	TJPARAM_DENSITYUNITS,
	TJPARAM_MAXMEMORY,
	TJPARAM_MAXPIXELS,
	TJPARAM_SAVEMARKERS,
}

TJERR :: enum c.int {
	TJERR_WARNING = 0,
	TJERR_FATAL   = 1,
}

TJXOP :: enum c.int {
	TJXOP_NONE      = 0,
	TJXOP_HFLIP     = 1,
	TJXOP_VFLIP     = 2,
	TJXOP_TRANSPOSE = 3,
	TJXOP_TRANSVERSE = 4,
	TJXOP_ROT90     = 5,
	TJXOP_ROT180    = 6,
	TJXOP_ROT270    = 7,
}

tjscalingfactor :: struct {
	num:   c.int,
	denom: c.int,
}

tjregion :: struct {
	x: c.int,
	y: c.int,
	w: c.int,
	h: c.int,
}

tjtransform :: struct {
	r:       tjregion,
	op:      c.int,
	options: c.int,
	data:    rawptr,
	customFilter: proc "c" (
		coeffs: ^c.short,
		arrayRegion: tjregion,
		planeRegion: tjregion,
		componentID: c.int,
		transformID: c.int,
		transform: ^tjtransform,
	) -> c.int,
}

tjhandle :: rawptr

tjMCUWidth :: [TJ_NUMSAMP]c.int{
	8, 16, 16, 8, 8, 32, 8, 32, 16,
}
tjMCUHeight :: [TJ_NUMSAMP]c.int{
	8, 8, 16, 8, 16, 8, 32, 16, 32,
}

tjRedOffset :: [TJ_NUMPF]c.int{
	0, 2, 0, 2, 3, 1, -1, 0, 2, 3, 1, -1,
}
tjGreenOffset :: [TJ_NUMPF]c.int{
	1, 1, 1, 1, 2, 2, -1, 1, 1, 2, 2, -1,
}
tjBlueOffset :: [TJ_NUMPF]c.int{
	2, 0, 2, 0, 1, 3, -1, 2, 0, 1, 3, -1,
}
tjAlphaOffset :: [TJ_NUMPF]c.int{
	-1, -1, -1, -1, -1, -1, -1, 3, 3, 0, 0, -1,
}
tjPixelSize :: [TJ_NUMPF]c.int{
	3, 3, 4, 4, 4, 4, 1, 4, 4, 4, 4, 4,
}

TJUNCROPPED :: tjregion{0, 0, 0, 0}
TJUNSCALED :: tjscalingfactor{1, 1}

TJSCALED :: #force_inline proc "contextless" (
	dimension: c.int,
	scalingFactor: tjscalingfactor,
) -> c.int {
	return (dimension * scalingFactor.num + scalingFactor.denom - 1) / scalingFactor.denom
}

TJPAD :: #force_inline proc "contextless" (width: c.int) -> c.int {
	return (width + 3) & -4
}

// turbojpeg.h exports tj3Init as a macro to tj3InitVersion.
tj3Init :: #force_inline proc "contextless" (initType: TJINIT) -> tjhandle {
	return tj3InitVersion(initType, TURBOJPEG_VERSION_NUMBER)
}

@(default_calling_convention = "c")
foreign turbojpeg {
	tj3InitVersion :: proc(initType: TJINIT, apiVersion: c.int) -> tjhandle ---
	tj3Destroy :: proc(handle: tjhandle) ---
	tj3GetErrorStr :: proc(handle: tjhandle) -> cstring ---
	tj3GetErrorCode :: proc(handle: tjhandle) -> TJERR ---
	tj3Set :: proc(handle: tjhandle, param: TJPARAM, value: c.int) -> c.int ---
	tj3Get :: proc(handle: tjhandle, param: TJPARAM) -> c.int ---
	tj3Alloc :: proc(bytes: c.size_t) -> rawptr ---
	tj3Free :: proc(buffer: rawptr) ---

	tj3JPEGBufSize :: proc(width: c.int, height: c.int, jpegSubsamp: TJSAMP) -> c.size_t ---
	tj3YUVBufSize :: proc(width: c.int, align: c.int, height: c.int, subsamp: TJSAMP) -> c.size_t ---
	tj3YUVPlaneSize :: proc(componentID: c.int, width: c.int, stride: c.int, height: c.int, subsamp: TJSAMP) -> c.size_t ---
	tj3YUVPlaneWidth :: proc(componentID: c.int, width: c.int, subsamp: TJSAMP) -> c.int ---
	tj3YUVPlaneHeight :: proc(componentID: c.int, height: c.int, subsamp: TJSAMP) -> c.int ---

	tj3SetICCProfile :: proc(handle: tjhandle, iccBuf: ^u8, iccSize: c.size_t) -> c.int ---
	tj3GetICCProfile :: proc(handle: tjhandle, iccBuf: ^^u8, iccSize: ^c.size_t) -> c.int ---

	tj3Compress8 :: proc(
		handle: tjhandle,
		srcBuf: ^u8,
		width: c.int,
		pitch: c.int,
		height: c.int,
		pixelFormat: TJPF,
		jpegBuf: ^^u8,
		jpegSize: ^c.size_t,
	) -> c.int ---
	tj3Compress12 :: proc(
		handle: tjhandle,
		srcBuf: ^c.short,
		width: c.int,
		pitch: c.int,
		height: c.int,
		pixelFormat: TJPF,
		jpegBuf: ^^u8,
		jpegSize: ^c.size_t,
	) -> c.int ---
	tj3Compress16 :: proc(
		handle: tjhandle,
		srcBuf: ^c.ushort,
		width: c.int,
		pitch: c.int,
		height: c.int,
		pixelFormat: TJPF,
		jpegBuf: ^^u8,
		jpegSize: ^c.size_t,
	) -> c.int ---
	tj3CompressFromYUVPlanes8 :: proc(handle: tjhandle, srcPlanes: ^^u8, width: c.int, strides: ^c.int, height: c.int, jpegBuf: ^^u8, jpegSize: ^c.size_t) -> c.int ---
	tj3CompressFromYUV8 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, align: c.int, height: c.int, jpegBuf: ^^u8, jpegSize: ^c.size_t) -> c.int ---

	tj3EncodeYUVPlanes8 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF, dstPlanes: ^^u8, strides: ^c.int) -> c.int ---
	tj3EncodeYUV8 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF, dstBuf: ^u8, align: c.int) -> c.int ---

	tj3DecompressHeader :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t) -> c.int ---
	tj3GetScalingFactors :: proc(numScalingFactors: ^c.int) -> ^tjscalingfactor ---
	tj3SetScalingFactor :: proc(handle: tjhandle, scalingFactor: tjscalingfactor) -> c.int ---
	tj3SetCroppingRegion :: proc(handle: tjhandle, croppingRegion: tjregion) -> c.int ---

	tj3Decompress8 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, dstBuf: ^u8, pitch: c.int, pixelFormat: TJPF) -> c.int ---
	tj3Decompress12 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, dstBuf: ^c.short, pitch: c.int, pixelFormat: TJPF) -> c.int ---
	tj3Decompress16 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, dstBuf: ^c.ushort, pitch: c.int, pixelFormat: TJPF) -> c.int ---

	tj3DecompressToYUVPlanes8 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, dstPlanes: ^^u8, strides: ^c.int) -> c.int ---
	tj3DecompressToYUV8 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, dstBuf: ^u8, align: c.int) -> c.int ---
	tj3DecodeYUVPlanes8 :: proc(handle: tjhandle, srcPlanes: ^^u8, strides: ^c.int, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF) -> c.int ---
	tj3DecodeYUV8 :: proc(handle: tjhandle, srcBuf: ^u8, align: c.int, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF) -> c.int ---

	tj3TransformBufSize :: proc(handle: tjhandle, transform: ^tjtransform) -> c.size_t ---
	tj3Transform :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.size_t, n: c.int, dstBufs: ^^u8, dstSizes: ^c.size_t, transforms: ^tjtransform) -> c.int ---

	tj3LoadImage8 :: proc(handle: tjhandle, filename: cstring, width: ^c.int, align: c.int, height: ^c.int, pixelFormat: ^TJPF) -> ^u8 ---
	tj3LoadImage12 :: proc(handle: tjhandle, filename: cstring, width: ^c.int, align: c.int, height: ^c.int, pixelFormat: ^TJPF) -> ^c.short ---
	tj3LoadImage16 :: proc(handle: tjhandle, filename: cstring, width: ^c.int, align: c.int, height: ^c.int, pixelFormat: ^TJPF) -> ^c.ushort ---
	tj3SaveImage8 :: proc(handle: tjhandle, filename: cstring, buffer: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF) -> c.int ---
	tj3SaveImage12 :: proc(handle: tjhandle, filename: cstring, buffer: ^c.short, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF) -> c.int ---
	tj3SaveImage16 :: proc(handle: tjhandle, filename: cstring, buffer: ^c.ushort, width: c.int, pitch: c.int, height: c.int, pixelFormat: TJPF) -> c.int ---

	// Backward compatibility API
	TJBUFSIZE :: proc(width: c.int, height: c.int) -> c.ulong ---
	tjCompress :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelSize: c.int, dstBuf: ^u8, compressedSize: ^c.ulong, jpegSubsamp: c.int, jpegQual: c.int, flags: c.int) -> c.int ---
	tjDecompress :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelSize: c.int, flags: c.int) -> c.int ---
	tjDecompressHeader :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, width: ^c.int, height: ^c.int) -> c.int ---
	tjDestroy :: proc(handle: tjhandle) -> c.int ---
	tjGetErrorStr :: proc() -> cstring ---
	tjInitCompress :: proc() -> tjhandle ---
	tjInitDecompress :: proc() -> tjhandle ---

	TJBUFSIZEYUV :: proc(width: c.int, height: c.int, jpegSubsamp: c.int) -> c.ulong ---
	tjDecompressHeader2 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, width: ^c.int, height: ^c.int, jpegSubsamp: ^c.int) -> c.int ---
	tjDecompressToYUV :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, dstBuf: ^u8, flags: c.int) -> c.int ---
	tjEncodeYUV :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelSize: c.int, dstBuf: ^u8, subsamp: c.int, flags: c.int) -> c.int ---

	tjAlloc :: proc(bytes: c.int) -> ^u8 ---
	tjBufSize :: proc(width: c.int, height: c.int, jpegSubsamp: c.int) -> c.ulong ---
	tjBufSizeYUV :: proc(width: c.int, height: c.int, subsamp: c.int) -> c.ulong ---
	tjCompress2 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, jpegBuf: ^^u8, jpegSize: ^c.ulong, jpegSubsamp: c.int, jpegQual: c.int, flags: c.int) -> c.int ---
	tjDecompress2 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, flags: c.int) -> c.int ---
	tjEncodeYUV2 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, dstBuf: ^u8, subsamp: c.int, flags: c.int) -> c.int ---
	tjFree :: proc(buffer: ^u8) ---
	tjGetScalingFactors :: proc(numscalingfactors: ^c.int) -> ^tjscalingfactor ---
	tjInitTransform :: proc() -> tjhandle ---
	tjTransform :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, n: c.int, dstBufs: ^^u8, dstSizes: ^c.ulong, transforms: ^tjtransform, flags: c.int) -> c.int ---

	tjBufSizeYUV2 :: proc(width: c.int, align: c.int, height: c.int, subsamp: c.int) -> c.ulong ---
	tjCompressFromYUV :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, align: c.int, height: c.int, subsamp: c.int, jpegBuf: ^^u8, jpegSize: ^c.ulong, jpegQual: c.int, flags: c.int) -> c.int ---
	tjCompressFromYUVPlanes :: proc(handle: tjhandle, srcPlanes: ^^u8, width: c.int, strides: ^c.int, height: c.int, subsamp: c.int, jpegBuf: ^^u8, jpegSize: ^c.ulong, jpegQual: c.int, flags: c.int) -> c.int ---
	tjDecodeYUV :: proc(handle: tjhandle, srcBuf: ^u8, align: c.int, subsamp: c.int, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, flags: c.int) -> c.int ---
	tjDecodeYUVPlanes :: proc(handle: tjhandle, srcPlanes: ^^u8, strides: ^c.int, subsamp: c.int, dstBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, flags: c.int) -> c.int ---
	tjDecompressHeader3 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, width: ^c.int, height: ^c.int, jpegSubsamp: ^c.int, jpegColorspace: ^c.int) -> c.int ---
	tjDecompressToYUV2 :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, dstBuf: ^u8, width: c.int, align: c.int, height: c.int, flags: c.int) -> c.int ---
	tjDecompressToYUVPlanes :: proc(handle: tjhandle, jpegBuf: ^u8, jpegSize: c.ulong, dstPlanes: ^^u8, width: c.int, strides: ^c.int, height: c.int, flags: c.int) -> c.int ---
	tjEncodeYUV3 :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, dstBuf: ^u8, align: c.int, subsamp: c.int, flags: c.int) -> c.int ---
	tjEncodeYUVPlanes :: proc(handle: tjhandle, srcBuf: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, dstPlanes: ^^u8, strides: ^c.int, subsamp: c.int, flags: c.int) -> c.int ---
	tjPlaneHeight :: proc(componentID: c.int, height: c.int, subsamp: c.int) -> c.int ---
	tjPlaneSizeYUV :: proc(componentID: c.int, width: c.int, stride: c.int, height: c.int, subsamp: c.int) -> c.ulong ---
	tjPlaneWidth :: proc(componentID: c.int, width: c.int, subsamp: c.int) -> c.int ---

	tjGetErrorCode :: proc(handle: tjhandle) -> TJERR ---
	tjGetErrorStr2 :: proc(handle: tjhandle) -> cstring ---
	tjLoadImage :: proc(filename: cstring, width: ^c.int, align: c.int, height: ^c.int, pixelFormat: ^c.int, flags: c.int) -> ^u8 ---
	tjSaveImage :: proc(filename: cstring, buffer: ^u8, width: c.int, pitch: c.int, height: c.int, pixelFormat: c.int, flags: c.int) -> c.int ---
}
