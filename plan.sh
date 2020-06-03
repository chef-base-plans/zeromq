pkg_name=zeromq
pkg_origin=core
pkg_version=4.3.1
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="ZeroMQ core engine in C++, implements ZMTP/3.1"
pkg_upstream_url=http://zeromq.org
pkg_license=('LGPL-3.0-only')
pkg_source="https://github.com/zeromq/libzmq/releases/download/v${pkg_version}/${pkg_name}-${pkg_version}.tar.gz"
pkg_shasum=bcbabe1e2c7d0eec4ed612e10b94b112dd5f06fcefa994a0c79a45d835cd21eb
pkg_deps=(
  core/glibc
  core/gcc-libs
  core/libsodium
)
pkg_build_deps=(
  core/gcc
  core/diffutils
  core/coreutils
  core/make
  core/pkg-config
  core/patchelf
  core/busybox-static
  core/shadow
)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)

do_install() {
  do_default_install
    # shellcheck disable=SC2038
  find "$pkg_prefix/lib" -name "*.so" | xargs -I '%' patchelf --set-rpath "$LD_RUN_PATH" %
}

do_check() {
  # Note: tests/test_filter_ipc.cpp:144 runs a test against a user in another group. When running
  # `id`, it shows that the `root` user belongs to `dialout`.  However the test still fails.
  # Therefore we must ensure the `root` user really is part of dialout group.
  gpasswd -a root dialout

  make check

  # clean this up by going back to default
  gpasswd -d root dialout
}
