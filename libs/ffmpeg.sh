FFMPEG_TARGET_LIBS="libavutil libavcodec libavformat libswscale libavfilter"

ffmpeg_check_exist() {
	check_exist $FFMPEG_TARGET_LIBS
}

ffmpeg_dependencies() {
	eval $1="'$FF_LIBS'"
}

ffmpeg_fetch() {
	do_git_checkout "--depth 1 https://github.com/FFmpeg/FFmpeg.git" $1
	#download_and_extract http://ffmpeg.org/releases/ffmpeg-3.1.2.tar.bz2 $1
}

ffmpeg_clean() {
	make distclean
}

# ./configure
#     --arch=x86_64                       # architecture
#     --pkg-config=pkg-config             # pkg-config excutable file
#     --pkg-config-flags=--static         # link external libs to a static binary while compilation
#     --disable-debug                     # disable debug
#     --disable-doc                       # disable doc
#     --disable-static                    # donot create static libraries (libav*.a)
#     --enable-shared                     # create shared libraries (libav*.so)
#     --enable-gpl                        # enable the code within GPL lisence
#     --enable-postproc                   # enable post process lib
#     --enable-runtime-cpudetect          # detect cpu in runtime
#     --enable-pic                        # enable position independent compilation
#     --target-os=mingw32                 # target os
#     --cross-prefix=                     # cross compilation
#     --enable-dxva2                      # Direct-X Video Acceleration API, developed by Microsoft
#     --enable-libvpx                     # enable external encoding library vp8, vp9
#     --enable-libx264                    # enable external encoding library x264
#     --enable-libx265                    # enable external encoding library x265
#     --prefix=/d/Work/msys_install_dir   # make install prefix, the dir where bin, lib and include exists
#     --disable-w32threads                # disable win32 threading API
#     --enable-pthreads                   # using mingw threading API (POISX)
ffmpeg_set_params() {
	local __resultvar=$1
	local options=$2

	# Make enabled libraries unique.
	FF_ENABLED_LIBS=$(echo "$FF_ENABLED_LIBS" | tr ' ' '\n' | sort -u)

	add_prefix params "--arch=$ARCH \
		--pkg-config=pkg-config \
		--pkg-config-flags=--static \
		--disable-debug \
		--disable-doc \
		--disable-static \
		--enable-shared \
		--enable-gpl \
		--enable-postproc \
		--enable-runtime-cpudetect \
		--enable-pic \
		$options \
		$FF_ENABLED_LIBS"

	eval $__resultvar='$params'
}

ffmpeg_set_pthreads() {
	eval $1='"$2 --disable-w32threads --enable-pthreads"'
}

ffmpeg_configure_darwin() {
	ffmpeg_set_params config "--target-os=darwin"
	ffmpeg_set_pthreads config "$config"

	do_notify "./configure $config"
	./configure $config
}

ffmpeg_configure_linux32() {
	ffmpeg_set_params config "--target-os=linux --enable-cross-compile --extra-ldflags=-ldl"
	ffmpeg_set_pthreads config "$config"

	do_notify "./configure $config"
	./configure $config
}

ffmpeg_configure_linux64() {
	ffmpeg_set_params config "--target-os=linux"
	ffmpeg_set_pthreads config "$config"

	do_notify "./configure $config"
	./configure $config
}

ffmpeg_configure_mingw() {
	ffmpeg_set_params config "--target-os=mingw32 --cross-prefix=$TOOL_CHAIN_PREFIX --enable-dxva2"
	ffmpeg_set_pthreads config "$config"

	do_notify "./configure $config"
	LDFLAGS="$LDFLAGS -static -static-libgcc -static-libstdc++" ./configure $config
}

ffmpeg_configure_win() {
	ffmpeg_set_params config "--toolchain=$TOOLCHAIN --extra-cflags=$CPPFLAGS --extra-ldflags=$LDFLAGS"

	do_notify "./configure $config"
	./configure $config
}

ffmpeg_make() {
	make
}

ffmpeg_install() {
	make install
}

ffmpeg_enable() {
	:
}
