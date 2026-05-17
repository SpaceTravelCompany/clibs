//odin binding for webp from https://chromium.googlesource.com/webm/libwebp
package webp

import "shared:utils_private/library"

@(private)
LIB :: library.LIBPATH + "/libwebp" + library.ARCH_end
@(private)
LIBDEMUX :: library.LIBPATH + "/libwebpdemux" + library.ARCH_end
@(private)
LIBMUX :: library.LIBPATH + "/libwebpmux" + library.ARCH_end
