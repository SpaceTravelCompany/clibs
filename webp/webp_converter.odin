package webp

import "base:intrinsics"
import "base:runtime"
import "core:fmt"
import "core:os"
import "shared:utils_private/image_utils"
import "shared:utils_private/library"

@(private)
webp_config :: union {
	WebPDecoderConfig,
	WebPAnimDecoderOptions,
}

/*
WebP image converter structure

Supports both static images and animated WebP images
*/
webp_converter :: struct {
	anim_dec:  ^WebPAnimDecoder,
	anim_info: WebPAnimInfo,
	out_fmt:   image_utils.ColorFmt,
	config:    webp_config,
	out_data:  []byte,
	allocator: runtime.Allocator,
}

/*
Gets the width of the loaded WebP image

Inputs:
- self: Pointer to the WebP converter

Returns:
- The width of the image in pixels, or 0 if no image is loaded
*/
webp_converter_width :: proc "contextless" (self: ^webp_converter) -> u32 {
	if self.config != nil {
		switch &t in self.config {
		case WebPDecoderConfig:
			return u32(t.input.width)
		case WebPAnimDecoderOptions:
			return u32(self.anim_info.canvas_width)
		}
	}
	return 0
}

/*
Gets the height of the loaded WebP image

Inputs:
- self: Pointer to the WebP converter

Returns:
- The height of the image in pixels, or 0 if no image is loaded
*/
webp_converter_height :: proc "contextless" (self: ^webp_converter) -> u32 {
	if self.config != nil {
		switch &t in self.config {
		case WebPDecoderConfig:
			return u32(t.input.height)
		case WebPAnimDecoderOptions:
			return u32(self.anim_info.canvas_height)
		}
	}
	return 0
}

/*
Gets the size in bytes of the loaded WebP image

For animated WebP, returns the total size of all frames

Inputs:
- self: Pointer to the WebP converter

Returns:
- The size of the image data in bytes, or 0 if no image is loaded
*/
webp_converter_size :: proc "contextless" (self: ^webp_converter) -> u32 {
	if self.config != nil {
		switch &t in self.config {
		case WebPDecoderConfig:
			return(
				u32(t.input.height * t.input.width) *
				(image_utils.ColorFmtBit(self.out_fmt) >> 3) \
			)
		case WebPAnimDecoderOptions:
			return(
				self.anim_info.canvas_height *
				self.anim_info.canvas_width *
				self.anim_info.frame_count *
				(image_utils.ColorFmtBit(self.out_fmt) >> 3) \
			)
		}
	}
	return 0
}

/*
Gets the number of frames in the WebP image

Inputs:
- self: Pointer to the WebP converter

Returns:
- The number of frames (1 for static images), or -1 if no image is loaded
*/
webp_converter_frame_cnt :: proc "contextless" (self: ^webp_converter) -> int {
	if self.config != nil {
		switch &t in self.config {
		case WebPAnimDecoderOptions:
			return auto_cast self.anim_info.frame_count
		case WebPDecoderConfig:
			return 1
		}
	}
	return -1
}

webp_converter_deinit :: proc(self: ^webp_converter) {
	if self.config != nil {
		switch &t in self.config {
		case WebPDecoderConfig:
			WebPFreeDecBuffer(&(t.output))
			self.config = nil
		case WebPAnimDecoderOptions:
			WebPAnimDecoderDelete(self.anim_dec)
			self.config = nil
		}
		delete(self.out_data, self.allocator)
		self.out_data = nil
	}
}

/*
Loads a WebP image from byte data

Supports both static and animated WebP images

Inputs:
- self: Pointer to the WebP converter
- data: The WebP image data as bytes
- out_fmt: The desired output color format
- allocator: The allocator to use (default: context.allocator)

Returns:
- The decoded image data as bytes (all frames for animated images)
- An error if loading failed
*/
webp_converter_load :: proc(
	self: ^webp_converter,
	data: []byte,
	out_fmt: image_utils.ColorFmt,
	allocator := context.allocator,
) -> (
	[]byte,
	WebP_Error,
) {
	webp_converter_deinit(self)

	errCode: WebP_Error = nil
	animOp: ^WebPAnimDecoderOptions

	anim_load: {
		self.config = WebPAnimDecoderOptions{}
		WebPAnimDecoderOptionsInit(&self.config.(WebPAnimDecoderOptions))

		wData := WebPData {
			bytes = &data[0],
			size  = len(data),
		}
		animOp = &self.config.(WebPAnimDecoderOptions)
		#partial switch out_fmt {
		case .RGBA:
			animOp.color_mode = CSP_MODE.RGBA
		case .ARGB:
			animOp.color_mode = CSP_MODE.ARGB
		case .BGRA:
			animOp.color_mode = CSP_MODE.BGRA
		case .RGB:
			animOp.color_mode = CSP_MODE.RGB
		case .BGR:
			animOp.color_mode = CSP_MODE.BGR
		case:
			fmt.panicf("unsupports decode fmt : %s", out_fmt)
		}

		self.anim_dec = WebPAnimDecoderNew(&wData, &self.config.(WebPAnimDecoderOptions))
		if self.anim_dec == nil {
			errCode = .WebPAnimDecoderNew_Failed
			break anim_load
		}

		WebPAnimDecoderGetInfo(self.anim_dec, &self.anim_info)
	}

	if errCode != nil {
		//try load static image mode
		self.config = WebPDecoderConfig{}
		WebPInitDecoderConfig(&self.config.(WebPDecoderConfig))
		op := &self.config.(WebPDecoderConfig)
		op.options.no_fancy_upsampling = true
		errCode = WebPGetFeatures(&data[0], len(data), &op.input)
		if errCode != VP8StatusCode.OK {
			self.config = nil
			return nil, errCode
		} else {
			errCode = nil
		}

		op.options.scaled_width = op.input.width
		op.options.scaled_height = op.input.height
		op.output.colorspace = animOp.color_mode
	}

	self.out_fmt = out_fmt
	self.allocator = allocator

	out_data, all_err := runtime.mem_alloc_non_zeroed(
		auto_cast webp_converter_size(self),
		allocator = allocator,
	)
	if all_err != nil {
		return nil, all_err
	}
	self.out_data = out_data

	bit := image_utils.ColorFmtBit(self.out_fmt) >> 3

	switch &t in self.config {
	case WebPDecoderConfig:
		t.output.u.RGBA.rgba = &out_data[0]
		t.output.u.RGBA.stride = t.input.width * i32(bit)
		t.output.u.RGBA.size = uint(t.output.u.RGBA.stride * t.input.height)
		t.output.is_external_memory = 1

		errCode = WebPDecode(&data[0], len(data), &t)
		if errCode != VP8StatusCode.OK {
			delete(out_data, allocator)
			return nil, errCode
		} else {
			errCode = nil
		}
	case WebPAnimDecoderOptions:
		idx := u32(0)

		frame_size := self.anim_info.canvas_width * self.anim_info.canvas_height * bit

		for 0 < WebPAnimDecoderHasMoreFrames(self.anim_dec) {
			timestamp: i32
			buf: [^]u8

			if 0 == WebPAnimDecoderGetNext(self.anim_dec, &buf, &timestamp) {
				delete(out_data, allocator)
				return nil, .WebPAnimDecoderGetNext_Failed
			}
			intrinsics.mem_copy_non_overlapping(&out_data[idx], buf, frame_size)

			idx += frame_size
		}
	}

	return out_data, errCode
}

WebP_Error_In :: enum {
	WebPAnimDecoderNew_Failed,
	WebPAnimDecoderGetNext_Failed,
}

WebP_Error :: union #shared_nil {
	WebP_Error_In,
	VP8StatusCode,
	os.Error,
	runtime.Allocator_Error,
}

/*
Loads a WebP image from a file

Inputs:
- self: Pointer to the WebP converter
- file_path: Path to the WebP image file
- out_fmt: The desired output color format
- allocator: The allocator to use (default: context.allocator)

Returns:
- The decoded image data as bytes
- An error if loading failed
- An error if loading failed
*/
webp_converter_load_file :: proc(
	self: ^webp_converter,
	file_path: string,
	out_fmt: image_utils.ColorFmt,
	allocator := context.allocator,
) -> (
	[]byte,
	WebP_Error,
) {
	imgFileData: []byte
	when library.is_android {
		imgFileReadErr: android.AssetFileError
		imgFileData, imgFileReadErr = android.asset_read_file(file_path, context.temp_allocator)
		os2Error: os.Error = .Invalid_File
		if imgFileReadErr != .None {
			return nil, os2Error
		}
	} else {
		imgFileReadErr: os.Error
		imgFileData, imgFileReadErr = os.read_entire_file_from_path(
			file_path,
			context.temp_allocator,
		)
		if imgFileReadErr != nil {
			return nil, imgFileReadErr
		}
	}

	return webp_converter_load(self, imgFileData, out_fmt, allocator)
}
