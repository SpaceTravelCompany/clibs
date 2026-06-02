package plutovg

import "base:runtime"
import "core:c"
import "shared:utils_private"
import "shared:utils_private/library"

@(private)
LIBPLUTOVG :: library.Libpath + "/libplutovg" + library.ArchEnd
foreign import plutovg {LIBPLUTOVG}

plutovg_destroy_func_t :: #type proc "c" (closure: rawptr)
plutovg_write_func_t :: #type proc "c" (closure: rawptr, data: rawptr, size: c.int)

plutovg_point_t :: struct {
	x: f32,
	y: f32,
}

plutovg_rect_t :: struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
}

plutovg_matrix_t :: struct {
	a: f32,
	b: f32,
	c: f32,
	d: f32,
	e: f32,
	f: f32,
}

plutovg_path_t :: struct {}
plutovg_surface_t :: struct {}
plutovg_paint_t :: struct {}
plutovg_canvas_t :: struct {}
plutovg_font_face_t :: struct {}
plutovg_font_face_cache_t :: struct {}

plutovg_path_command_t :: enum c.int {
	PLUTOVG_PATH_COMMAND_MOVE_TO,
	PLUTOVG_PATH_COMMAND_LINE_TO,
	PLUTOVG_PATH_COMMAND_CUBIC_TO,
	PLUTOVG_PATH_COMMAND_CLOSE,
}

plutovg_path_element_header_t :: struct {
	command: plutovg_path_command_t,
	length:  c.int,
}

plutovg_path_element_t :: struct #raw_union {
	header: plutovg_path_element_header_t,
	point:  plutovg_point_t,
}

plutovg_path_iterator_t :: struct {
	elements: [^]plutovg_path_element_t,
	size:     c.int,
	index:    c.int,
}

plutovg_path_traverse_func_t :: #type proc "c" (
	closure: rawptr,
	command: plutovg_path_command_t,
	points: [^]plutovg_point_t,
	npoints: c.int,
)

plutovg_color_t :: struct {
	r: f32,
	g: f32,
	b: f32,
	a: f32,
}

plutovg_gradient_stop_t :: struct {
	offset: f32,
	color:  plutovg_color_t,
}

plutovg_texture_type_t :: enum c.int {
	PLUTOVG_TEXTURE_TYPE_PLAIN,
	PLUTOVG_TEXTURE_TYPE_TILED,
}

plutovg_spread_method_t :: enum c.int {
	PLUTOVG_SPREAD_METHOD_PAD,
	PLUTOVG_SPREAD_METHOD_REFLECT,
	PLUTOVG_SPREAD_METHOD_REPEAT,
}

plutovg_fill_rule_t :: enum c.int {
	PLUTOVG_FILL_RULE_NON_ZERO,
	PLUTOVG_FILL_RULE_EVEN_ODD,
}

plutovg_operator_t :: enum c.int {
	PLUTOVG_OPERATOR_CLEAR,
	PLUTOVG_OPERATOR_SRC,
	PLUTOVG_OPERATOR_DST,
	PLUTOVG_OPERATOR_SRC_OVER,
	PLUTOVG_OPERATOR_DST_OVER,
	PLUTOVG_OPERATOR_SRC_IN,
	PLUTOVG_OPERATOR_DST_IN,
	PLUTOVG_OPERATOR_SRC_OUT,
	PLUTOVG_OPERATOR_DST_OUT,
	PLUTOVG_OPERATOR_SRC_ATOP,
	PLUTOVG_OPERATOR_DST_ATOP,
	PLUTOVG_OPERATOR_XOR,
}

plutovg_line_cap_t :: enum c.int {
	PLUTOVG_LINE_CAP_BUTT,
	PLUTOVG_LINE_CAP_ROUND,
	PLUTOVG_LINE_CAP_SQUARE,
}

plutovg_line_join_t :: enum c.int {
	PLUTOVG_LINE_JOIN_MITER,
	PLUTOVG_LINE_JOIN_ROUND,
	PLUTOVG_LINE_JOIN_BEVEL,
}

plutovg_path_parse_string :: proc(
	path: ^plutovg_path_t,
	data: string,
) -> (
	ok: bool,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	buf := utils_private.makeNonZeroedSlice(
		[]u8,
		len(data) + 1,
		context.temp_allocator,
	) or_return
	runtime.mem_copy_non_overlapping(raw_data(buf), raw_data(data), len(data))
	buf[len(data)] = 0
	ok = plutovg_path_parse(path, cstring(raw_data(buf)), c.int(len(data)))
	return
}

plutovg_matrix_parse_string :: proc(
	mat: ^plutovg_matrix_t,
	data: string,
) -> (
	ok: bool,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	buf := utils_private.makeNonZeroedSlice(
		[]u8,
		len(data) + 1,
		context.temp_allocator,
	) or_return
	runtime.mem_copy_non_overlapping(raw_data(buf), raw_data(data), len(data))
	buf[len(data)] = 0
	ok = plutovg_matrix_parse(mat, cstring(raw_data(buf)), c.int(len(data)))
	return
}

plutovg_color_parse_string :: proc(
	color: ^plutovg_color_t,
	data: string,
) -> (
	consumed: int,
	err: runtime.Allocator_Error,
) #optional_allocator_error {
	buf := utils_private.makeNonZeroedSlice(
		[]u8,
		len(data) + 1,
		context.temp_allocator,
	) or_return
	runtime.mem_copy_non_overlapping(raw_data(buf), raw_data(data), len(data))
	buf[len(data)] = 0
	consumed = int(plutovg_color_parse(color, cstring(raw_data(buf)), c.int(len(data))))
	return
}

@(default_calling_convention = "c")
foreign plutovg {
	plutovg_version :: proc() -> c.int ---
	plutovg_version_string :: proc() -> cstring ---

	plutovg_matrix_init :: proc(mat: ^plutovg_matrix_t, a, b, c_, d, e, f: f32) ---
	plutovg_matrix_init_identity :: proc(mat: ^plutovg_matrix_t) ---
	plutovg_matrix_init_translate :: proc(mat: ^plutovg_matrix_t, tx, ty: f32) ---
	plutovg_matrix_init_scale :: proc(mat: ^plutovg_matrix_t, sx, sy: f32) ---
	plutovg_matrix_init_rotate :: proc(mat: ^plutovg_matrix_t, angle: f32) ---
	plutovg_matrix_init_shear :: proc(mat: ^plutovg_matrix_t, shx, shy: f32) ---
	plutovg_matrix_translate :: proc(mat: ^plutovg_matrix_t, tx, ty: f32) ---
	plutovg_matrix_scale :: proc(mat: ^plutovg_matrix_t, sx, sy: f32) ---
	plutovg_matrix_rotate :: proc(mat: ^plutovg_matrix_t, angle: f32) ---
	plutovg_matrix_shear :: proc(mat: ^plutovg_matrix_t, shx, shy: f32) ---
	plutovg_matrix_multiply :: proc(mat: ^plutovg_matrix_t, left, right: ^plutovg_matrix_t) ---
	plutovg_matrix_invert :: proc(mat, inverse: ^plutovg_matrix_t) -> bool ---
	plutovg_matrix_map :: proc(mat: ^plutovg_matrix_t, x, y: f32, xx, yy: ^f32) ---
	plutovg_matrix_map_point :: proc(mat: ^plutovg_matrix_t, src: ^plutovg_point_t, dst: ^plutovg_point_t) ---
	plutovg_matrix_map_points :: proc(mat: ^plutovg_matrix_t, src: ^plutovg_point_t, dst: ^plutovg_point_t, count: c.int) ---
	plutovg_matrix_map_rect :: proc(mat: ^plutovg_matrix_t, src: ^plutovg_rect_t, dst: ^plutovg_rect_t) ---
	plutovg_matrix_parse :: proc(mat: ^plutovg_matrix_t, data: cstring, length: c.int) -> bool ---

	plutovg_path_iterator_init :: proc(it: ^plutovg_path_iterator_t, path: ^plutovg_path_t) ---
	plutovg_path_iterator_has_next :: proc(it: ^plutovg_path_iterator_t) -> bool ---
	plutovg_path_iterator_next :: proc(it: ^plutovg_path_iterator_t, points: ^[3]plutovg_point_t) -> plutovg_path_command_t ---
	plutovg_path_create :: proc() -> ^plutovg_path_t ---
	plutovg_path_reference :: proc(path: ^plutovg_path_t) -> ^plutovg_path_t ---
	plutovg_path_destroy :: proc(path: ^plutovg_path_t) ---
	plutovg_path_get_reference_count :: proc(path: ^plutovg_path_t) -> c.int ---
	plutovg_path_get_elements :: proc(path: ^plutovg_path_t, elements: ^[^]plutovg_path_element_t) -> c.int ---
	plutovg_path_move_to :: proc(path: ^plutovg_path_t, x, y: f32) ---
	plutovg_path_line_to :: proc(path: ^plutovg_path_t, x, y: f32) ---
	plutovg_path_quad_to :: proc(path: ^plutovg_path_t, x1, y1, x2, y2: f32) ---
	plutovg_path_cubic_to :: proc(path: ^plutovg_path_t, x1, y1, x2, y2, x3, y3: f32) ---
	plutovg_path_arc_to :: proc(path: ^plutovg_path_t, rx, ry, angle: f32, large_arc_flag, sweep_flag: bool, x, y: f32) ---
	plutovg_path_close :: proc(path: ^plutovg_path_t) ---
	plutovg_path_get_current_point :: proc(path: ^plutovg_path_t, x, y: ^f32) ---
	plutovg_path_reserve :: proc(path: ^plutovg_path_t, count: c.int) ---
	plutovg_path_reset :: proc(path: ^plutovg_path_t) ---
	plutovg_path_add_rect :: proc(path: ^plutovg_path_t, x, y, w, h: f32) ---
	plutovg_path_add_round_rect :: proc(path: ^plutovg_path_t, x, y, w, h, rx, ry: f32) ---
	plutovg_path_add_ellipse :: proc(path: ^plutovg_path_t, cx, cy, rx, ry: f32) ---
	plutovg_path_add_circle :: proc(path: ^plutovg_path_t, cx, cy, r: f32) ---
	plutovg_path_add_arc :: proc(path: ^plutovg_path_t, cx, cy, r, a0, a1: f32, ccw: bool) ---
	plutovg_path_add_path :: proc(path: ^plutovg_path_t, source: ^plutovg_path_t, mat: ^plutovg_matrix_t) ---
	plutovg_path_transform :: proc(path: ^plutovg_path_t, mat: ^plutovg_matrix_t) ---
	plutovg_path_traverse :: proc(path: ^plutovg_path_t, traverse_func: plutovg_path_traverse_func_t, closure: rawptr) ---
	plutovg_path_traverse_flatten :: proc(path: ^plutovg_path_t, traverse_func: plutovg_path_traverse_func_t, closure: rawptr) ---
	plutovg_path_traverse_dashed :: proc(path: ^plutovg_path_t, offset: f32, dashes: [^]f32, ndashes: c.int, traverse_func: plutovg_path_traverse_func_t, closure: rawptr) ---
	plutovg_path_clone :: proc(path: ^plutovg_path_t) -> ^plutovg_path_t ---
	plutovg_path_clone_flatten :: proc(path: ^plutovg_path_t) -> ^plutovg_path_t ---
	plutovg_path_clone_dashed :: proc(path: ^plutovg_path_t, offset: f32, dashes: [^]f32, ndashes: c.int) -> ^plutovg_path_t ---
	plutovg_path_extents :: proc(path: ^plutovg_path_t, extents: ^plutovg_rect_t, tight: bool) -> f32 ---
	plutovg_path_length :: proc(path: ^plutovg_path_t) -> f32 ---
	plutovg_path_parse :: proc(path: ^plutovg_path_t, data: cstring, length: c.int) -> bool ---

	plutovg_color_init_rgb :: proc(color: ^plutovg_color_t, r, g, b: f32) ---
	plutovg_color_init_rgba :: proc(color: ^plutovg_color_t, r, g, b, a: f32) ---
	plutovg_color_init_rgb8 :: proc(color: ^plutovg_color_t, r, g, b: c.int) ---
	plutovg_color_init_rgba8 :: proc(color: ^plutovg_color_t, r, g, b, a: c.int) ---
	plutovg_color_init_rgba32 :: proc(color: ^plutovg_color_t, value: u32) ---
	plutovg_color_init_argb32 :: proc(color: ^plutovg_color_t, value: u32) ---
	plutovg_color_init_hsl :: proc(color: ^plutovg_color_t, h, s, l: f32) ---
	plutovg_color_init_hsla :: proc(color: ^plutovg_color_t, h, s, l, a: f32) ---
	plutovg_color_to_rgba32 :: proc(color: ^plutovg_color_t) -> u32 ---
	plutovg_color_to_argb32 :: proc(color: ^plutovg_color_t) -> u32 ---
	plutovg_color_parse :: proc(color: ^plutovg_color_t, data: cstring, length: c.int) -> c.int ---

	plutovg_surface_create :: proc(width, height: c.int) -> ^plutovg_surface_t ---
	plutovg_surface_create_for_data :: proc(data: [^]u8, width, height, stride: c.int) -> ^plutovg_surface_t ---
	plutovg_surface_load_from_image_file :: proc(filename: cstring) -> ^plutovg_surface_t ---
	plutovg_surface_load_from_image_data :: proc(data: rawptr, length: c.int) -> ^plutovg_surface_t ---
	plutovg_surface_load_from_image_base64 :: proc(data: cstring, length: c.int) -> ^plutovg_surface_t ---
	plutovg_surface_reference :: proc(surface: ^plutovg_surface_t) -> ^plutovg_surface_t ---
	plutovg_surface_destroy :: proc(surface: ^plutovg_surface_t) ---
	plutovg_surface_get_reference_count :: proc(surface: ^plutovg_surface_t) -> c.int ---
	plutovg_surface_get_data :: proc(surface: ^plutovg_surface_t) -> [^]u8 ---
	plutovg_surface_get_width :: proc(surface: ^plutovg_surface_t) -> c.int ---
	plutovg_surface_get_height :: proc(surface: ^plutovg_surface_t) -> c.int ---
	plutovg_surface_get_stride :: proc(surface: ^plutovg_surface_t) -> c.int ---
	plutovg_surface_clear :: proc(surface: ^plutovg_surface_t, color: ^plutovg_color_t) ---
	plutovg_surface_write_to_png :: proc(surface: ^plutovg_surface_t, filename: cstring) -> bool ---
	plutovg_surface_write_to_jpg :: proc(surface: ^plutovg_surface_t, filename: cstring, quality: c.int) -> bool ---
	plutovg_surface_write_to_png_stream :: proc(surface: ^plutovg_surface_t, write_func: plutovg_write_func_t, closure: rawptr) -> bool ---
	plutovg_surface_write_to_jpg_stream :: proc(surface: ^plutovg_surface_t, write_func: plutovg_write_func_t, closure: rawptr, quality: c.int) -> bool ---
	plutovg_convert_argb_to_rgba :: proc(dst: [^]u8, src: [^]u8, width, height, stride: c.int) ---
	plutovg_convert_rgba_to_argb :: proc(dst: [^]u8, src: [^]u8, width, height, stride: c.int) ---

	plutovg_paint_create_rgb :: proc(r, g, b: f32) -> ^plutovg_paint_t ---
	plutovg_paint_create_rgba :: proc(r, g, b, a: f32) -> ^plutovg_paint_t ---
	plutovg_paint_create_color :: proc(color: ^plutovg_color_t) -> ^plutovg_paint_t ---
	plutovg_paint_create_linear_gradient :: proc(x1, y1, x2, y2: f32, spread: plutovg_spread_method_t, stops: ^plutovg_gradient_stop_t, nstops: c.int, mat: ^plutovg_matrix_t) -> ^plutovg_paint_t ---
	plutovg_paint_create_radial_gradient :: proc(cx, cy, cr, fx, fy, fr: f32, spread: plutovg_spread_method_t, stops: ^plutovg_gradient_stop_t, nstops: c.int, mat: ^plutovg_matrix_t) -> ^plutovg_paint_t ---
	plutovg_paint_create_texture :: proc(surface: ^plutovg_surface_t, type: plutovg_texture_type_t, opacity: f32, mat: ^plutovg_matrix_t) -> ^plutovg_paint_t ---
	plutovg_paint_reference :: proc(paint: ^plutovg_paint_t) -> ^plutovg_paint_t ---
	plutovg_paint_destroy :: proc(paint: ^plutovg_paint_t) ---
	plutovg_paint_get_reference_count :: proc(paint: ^plutovg_paint_t) -> c.int ---

	plutovg_canvas_create :: proc(surface: ^plutovg_surface_t) -> ^plutovg_canvas_t ---
	plutovg_canvas_reference :: proc(canvas: ^plutovg_canvas_t) -> ^plutovg_canvas_t ---
	plutovg_canvas_destroy :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_get_reference_count :: proc(canvas: ^plutovg_canvas_t) -> c.int ---
	plutovg_canvas_get_surface :: proc(canvas: ^plutovg_canvas_t) -> ^plutovg_surface_t ---
	plutovg_canvas_save :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_restore :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_set_rgb :: proc(canvas: ^plutovg_canvas_t, r, g, b: f32) ---
	plutovg_canvas_set_rgba :: proc(canvas: ^plutovg_canvas_t, r, g, b, a: f32) ---
	plutovg_canvas_set_color :: proc(canvas: ^plutovg_canvas_t, color: ^plutovg_color_t) ---
	plutovg_canvas_set_linear_gradient :: proc(canvas: ^plutovg_canvas_t, x1, y1, x2, y2: f32, spread: plutovg_spread_method_t, stops: ^plutovg_gradient_stop_t, nstops: c.int, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_set_radial_gradient :: proc(canvas: ^plutovg_canvas_t, cx, cy, cr, fx, fy, fr: f32, spread: plutovg_spread_method_t, stops: ^plutovg_gradient_stop_t, nstops: c.int, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_set_texture :: proc(canvas: ^plutovg_canvas_t, surface: ^plutovg_surface_t, type: plutovg_texture_type_t, opacity: f32, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_set_paint :: proc(canvas: ^plutovg_canvas_t, paint: ^plutovg_paint_t) ---
	plutovg_canvas_get_paint :: proc(canvas: ^plutovg_canvas_t, color: ^plutovg_color_t) -> ^plutovg_paint_t ---
	plutovg_canvas_set_fill_rule :: proc(canvas: ^plutovg_canvas_t, winding: plutovg_fill_rule_t) ---
	plutovg_canvas_get_fill_rule :: proc(canvas: ^plutovg_canvas_t) -> plutovg_fill_rule_t ---
	plutovg_canvas_set_operator :: proc(canvas: ^plutovg_canvas_t, op: plutovg_operator_t) ---
	plutovg_canvas_get_operator :: proc(canvas: ^plutovg_canvas_t) -> plutovg_operator_t ---
	plutovg_canvas_set_opacity :: proc(canvas: ^plutovg_canvas_t, opacity: f32) ---
	plutovg_canvas_get_opacity :: proc(canvas: ^plutovg_canvas_t) -> f32 ---
	plutovg_canvas_set_line_width :: proc(canvas: ^plutovg_canvas_t, line_width: f32) ---
	plutovg_canvas_get_line_width :: proc(canvas: ^plutovg_canvas_t) -> f32 ---
	plutovg_canvas_set_line_cap :: proc(canvas: ^plutovg_canvas_t, line_cap: plutovg_line_cap_t) ---
	plutovg_canvas_get_line_cap :: proc(canvas: ^plutovg_canvas_t) -> plutovg_line_cap_t ---
	plutovg_canvas_set_line_join :: proc(canvas: ^plutovg_canvas_t, line_join: plutovg_line_join_t) ---
	plutovg_canvas_get_line_join :: proc(canvas: ^plutovg_canvas_t) -> plutovg_line_join_t ---
	plutovg_canvas_set_miter_limit :: proc(canvas: ^plutovg_canvas_t, miter_limit: f32) ---
	plutovg_canvas_get_miter_limit :: proc(canvas: ^plutovg_canvas_t) -> f32 ---
	plutovg_canvas_set_dash :: proc(canvas: ^plutovg_canvas_t, offset: f32, dashes: [^]f32, ndashes: c.int) ---
	plutovg_canvas_set_dash_offset :: proc(canvas: ^plutovg_canvas_t, offset: f32) ---
	plutovg_canvas_get_dash_offset :: proc(canvas: ^plutovg_canvas_t) -> f32 ---
	plutovg_canvas_set_dash_array :: proc(canvas: ^plutovg_canvas_t, dashes: [^]f32, ndashes: c.int) ---
	plutovg_canvas_get_dash_array :: proc(canvas: ^plutovg_canvas_t, dashes: ^^f32) -> c.int ---
	plutovg_canvas_translate :: proc(canvas: ^plutovg_canvas_t, tx, ty: f32) ---
	plutovg_canvas_scale :: proc(canvas: ^plutovg_canvas_t, sx, sy: f32) ---
	plutovg_canvas_shear :: proc(canvas: ^plutovg_canvas_t, shx, shy: f32) ---
	plutovg_canvas_rotate :: proc(canvas: ^plutovg_canvas_t, angle: f32) ---
	plutovg_canvas_transform :: proc(canvas: ^plutovg_canvas_t, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_reset_matrix :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_set_matrix :: proc(canvas: ^plutovg_canvas_t, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_get_matrix :: proc(canvas: ^plutovg_canvas_t, mat: ^plutovg_matrix_t) ---
	plutovg_canvas_map :: proc(canvas: ^plutovg_canvas_t, x, y: f32, xx, yy: ^f32) ---
	plutovg_canvas_map_point :: proc(canvas: ^plutovg_canvas_t, src: ^plutovg_point_t, dst: ^plutovg_point_t) ---
	plutovg_canvas_map_rect :: proc(canvas: ^plutovg_canvas_t, src: ^plutovg_rect_t, dst: ^plutovg_rect_t) ---
	plutovg_canvas_move_to :: proc(canvas: ^plutovg_canvas_t, x, y: f32) ---
	plutovg_canvas_line_to :: proc(canvas: ^plutovg_canvas_t, x, y: f32) ---
	plutovg_canvas_quad_to :: proc(canvas: ^plutovg_canvas_t, x1, y1, x2, y2: f32) ---
	plutovg_canvas_cubic_to :: proc(canvas: ^plutovg_canvas_t, x1, y1, x2, y2, x3, y3: f32) ---
	plutovg_canvas_arc_to :: proc(canvas: ^plutovg_canvas_t, rx, ry, angle: f32, large_arc_flag, sweep_flag: bool, x, y: f32) ---
	plutovg_canvas_rect :: proc(canvas: ^plutovg_canvas_t, x, y, w, h: f32) ---
	plutovg_canvas_round_rect :: proc(canvas: ^plutovg_canvas_t, x, y, w, h, rx, ry: f32) ---
	plutovg_canvas_ellipse :: proc(canvas: ^plutovg_canvas_t, cx, cy, rx, ry: f32) ---
	plutovg_canvas_circle :: proc(canvas: ^plutovg_canvas_t, cx, cy, r: f32) ---
	plutovg_canvas_arc :: proc(canvas: ^plutovg_canvas_t, cx, cy, r, a0, a1: f32, ccw: bool) ---
	plutovg_canvas_add_path :: proc(canvas: ^plutovg_canvas_t, path: ^plutovg_path_t) ---
	plutovg_canvas_new_path :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_close_path :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_get_current_point :: proc(canvas: ^plutovg_canvas_t, x, y: ^f32) ---
	plutovg_canvas_get_path :: proc(canvas: ^plutovg_canvas_t) -> ^plutovg_path_t ---
	plutovg_canvas_fill_contains :: proc(canvas: ^plutovg_canvas_t, x, y: f32) -> bool ---
	plutovg_canvas_stroke_contains :: proc(canvas: ^plutovg_canvas_t, x, y: f32) -> bool ---
	plutovg_canvas_clip_contains :: proc(canvas: ^plutovg_canvas_t, x, y: f32) -> bool ---
	plutovg_canvas_fill_extents :: proc(canvas: ^plutovg_canvas_t, extents: ^plutovg_rect_t) ---
	plutovg_canvas_stroke_extents :: proc(canvas: ^plutovg_canvas_t, extents: ^plutovg_rect_t) ---
	plutovg_canvas_clip_extents :: proc(canvas: ^plutovg_canvas_t, extents: ^plutovg_rect_t) ---
	plutovg_canvas_fill :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_stroke :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_clip :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_paint :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_fill_preserve :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_stroke_preserve :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_clip_preserve :: proc(canvas: ^plutovg_canvas_t) ---
	plutovg_canvas_fill_rect :: proc(canvas: ^plutovg_canvas_t, x, y, w, h: f32) ---
	plutovg_canvas_fill_path :: proc(canvas: ^plutovg_canvas_t, path: ^plutovg_path_t) ---
	plutovg_canvas_stroke_rect :: proc(canvas: ^plutovg_canvas_t, x, y, w, h: f32) ---
	plutovg_canvas_stroke_path :: proc(canvas: ^plutovg_canvas_t, path: ^plutovg_path_t) ---
	plutovg_canvas_clip_rect :: proc(canvas: ^plutovg_canvas_t, x, y, w, h: f32) ---
	plutovg_canvas_clip_path :: proc(canvas: ^plutovg_canvas_t, path: ^plutovg_path_t) ---
}
