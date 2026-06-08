package libtess2

import "core:c"
import "shared:utils_private"
import "shared:utils_private/library"

//=============================================================================
// Library linking
//=============================================================================
LIBTESS2_SHARED :: #config(LIBTESS2_SHARED, false)

@(private)
LIB :: library.Libpath + "/libtess2" + library.ArchEnd

when LIBTESS2_SHARED {
	foreign import libtess2 {LIB + ".dll" when ODIN_OS == .Windows else LIB + ".so"}
} else {
	foreign import libtess2 {LIB}
}

//=============================================================================
// Types
//=============================================================================
Real :: f32
Index :: i32

Tessellator :: distinct rawptr

//=============================================================================
// Constants
//=============================================================================
Undef :: Index(-1)

MaxCoord :: Real(1 << 23)
MinCoord :: -MaxCoord

//=============================================================================
// Enums (matching tesselator.h exactly)
//=============================================================================
WindingRule :: enum c.int {
	ODD         = 0,
	NONZERO     = 1,
	POSITIVE    = 2,
	NEGATIVE    = 3,
	ABS_GEQ_TWO = 4,
}

ElementType :: enum c.int {
	POLYGONS           = 0,
	CONNECTED_POLYGONS = 1,
	BOUNDARY_CONTOURS  = 2,
}

Option :: enum c.int {
	CONSTRAINED_DELAUNAY_TRIANGULATION = 0,
	REVERSE_CONTOURS                   = 1,
}

Status :: enum c.int {
	OK            = 0,
	OUT_OF_MEMORY = 1,
	INVALID_INPUT = 2,
}

//=============================================================================
// Custom allocator (optional - pass nil to use default malloc/free)
//=============================================================================
Alloc :: struct {
	memalloc:             proc "c" (userData: rawptr, size: c.uint) -> rawptr,
	memrealloc:           proc "c" (userData: rawptr, ptr: rawptr, size: c.uint) -> rawptr,
	memfree:              proc "c" (userData: rawptr, ptr: rawptr),
	userData:             rawptr,
	meshEdgeBucketSize:   c.int,
	meshVertexBucketSize: c.int,
	meshFaceBucketSize:   c.int,
	dictNodeBucketSize:   c.int,
	regionBucketSize:     c.int,
	extraVertices:        c.int,
}

//=============================================================================
// Foreign function declarations
//=============================================================================
@(default_calling_convention = "c")
foreign libtess2 {
	// Create/destroy tesselator
	@(link_name = "tessNewTess")
	newTess :: proc(alloc: ^Alloc) -> Tessellator ---

	@(link_name = "tessDeleteTess")
	deleteTess :: proc(tess: Tessellator) ---

	// Add a contour
	@(link_name = "tessAddContour")
	addContour :: proc(tess: Tessellator, size: c.int, pointer: rawptr, stride: c.int, count: c.int) ---

	// Set options
	@(link_name = "tessSetOption")
	setOption :: proc(tess: Tessellator, option: Option, value: c.int) ---

	// Execute tessellation
	@(link_name = "tessTesselate")
	tessellate :: proc(tess: Tessellator, windingRule: WindingRule, elementType: ElementType, polySize: c.int, vertexSize: c.int, normal: ^Real) -> c.int ---

	// Get results
	@(link_name = "tessGetVertexCount")
	getVertexCount :: proc(tess: Tessellator) -> c.int ---

	@(link_name = "tessGetVertices")
	getVertices :: proc(tess: Tessellator) -> [^]Real ---

	@(link_name = "tessGetVertexIndices")
	getVertexIndices :: proc(tess: Tessellator) -> [^]Index ---

	@(link_name = "tessGetElementCount")
	getElementCount :: proc(tess: Tessellator) -> c.int ---

	@(link_name = "tessGetElements")
	getElements :: proc(tess: Tessellator) -> [^]Index ---

	// Status
	@(link_name = "tessGetStatus")
	getStatus :: proc(tess: Tessellator) -> Status ---
}

//=============================================================================
// High-level convenience wrapper
//=============================================================================
// Triangulates a set of 2D polygon contours.
// polys: slice of contours, each contour is a slice of [2]f32 points.
// offset: added to every output index (for index buffer merging).
// return: triangle vertex indices (groups of 3), or nil on failure.
triangulate :: proc(
	polys: [][][2]f32,
	offset: u32 = 0,
	allocator := context.allocator,
) -> (
	indices: []u32,
) {
	tess := newTess(nil)
	if tess == nil do return
	defer deleteTess(tess)

	// Add each contour
	for poly in polys {
		if len(poly) < 3 do continue
		addContour(tess, 2, raw_data(poly), size_of([2]f32), c.int(len(poly)))
	}

	// Tessellate (triangles with odd winding rule)
	result := tessellate(tess, .ODD, .POLYGONS, 3, 2, nil)
	if result == 0 do return

	// Get output
	vertCount := int(getVertexCount(tess))
	vertIndices := getVertexIndices(tess)
	elemCount := int(getElementCount(tess))
	elements := getElements(tess)

	if elemCount == 0 || vertCount == 0 do return

	// Build output index buffer
	// For each triangle (3 vertices):
	//   elements[i*3 + 0..2] are vertex indices into the tesselator's vertex array
	//   vertexIndices[vertex_i] gives the original contour vertex index

	// Count how many valid triangles we have
	triCount := 0
	for i in 0 ..< elemCount {
		if elements[i * 3] != Undef &&
		   elements[i * 3 + 1] != Undef &&
		   elements[i * 3 + 2] != Undef {
			triCount += 1
		}
	}
	if triCount == 0 do return

	indices = utils_private.makeNonZeroedSlice([]u32, triCount * 3, allocator)
	if indices == nil do return nil

	idx := 0
	for i in 0 ..< elemCount {
		base := i * 3
		if elements[base] == Undef || elements[base + 1] == Undef || elements[base + 2] == Undef do continue

		// Map from tesselator vertex index back to original contour vertex index
		i0 := vertIndices[elements[base]]
		i1 := vertIndices[elements[base + 1]]
		i2 := vertIndices[elements[base + 2]]

		// Skip intersection-generated vertices (Undef means new vertex)
		if i0 == Undef || i1 == Undef || i2 == Undef do continue

		indices[idx + 0] = u32(i0) + offset
		indices[idx + 1] = u32(i1) + offset
		indices[idx + 2] = u32(i2) + offset
		idx += 3
	}

	if idx < len(indices) {
		indices = indices[:idx]
	}
	return
}
