VMAF_TARGET_LIBS="libvmaf"

vmaf_check_exist() {
    check_exist $VMAF_TARGET_LIBS
}

vmaf_dependencies() {
    eval $1="''"
}

vmaf_fetch() {
    do_git_checkout "https://github.com/Netflix/vmaf.git" $1
}

vmaf_clean() {
    rm -R build/*
}

vmaf_configure() {
    exec_in_dir "libvmaf" meson build --buildtype release -Dprefix=$FF_PREFIX
}

vmaf_make() {
    exec_in_dir "libvmaf" ninja -vC build
}

vmaf_install() {
    exec_in_dir "libvmaf" ninja -vC build install
    sed -i '/^PKG_CONFIG_PATH/ s/pkgconfig/pkgconfig:$FF_PREFIX\/lib\/x86_64-linux-gnu\/pkgconfig/' $FF_PROFILE_DIR/linux-x86_64.local
}

vmaf_enable() {
    enable_library "libvmaf"
}
