//odin binding for webp from https://chromium.googlesource.com/webm/libwebp
package webp

import "shared:utils_private/library"

@(private)
LIB :: library.Libpath + "/libwebp" + library.ArchEnd
@(private)
LIBDEMUX :: library.Libpath + "/libwebpdemux" + library.ArchEnd
@(private)
LIBMUX :: library.Libpath + "/libwebpmux" + library.ArchEnd
@(private)
LIBSHARPYUV :: library.Libpath + "/libsharpyuv" + library.ArchEnd
