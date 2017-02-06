{ stdenv, fetchurl, autoconf, automake, cmake, pkgconfig, pythonPackages, libudev, libaio, libuuid, openldap, fuse, libxfs, leveldb, libatomic_ops, snappy, keyutils, gperftools, jemalloc, curl, nss, nspr, expat, fcgi, boost162, lttng-tools, lttng-ust,  yasm, liburcu, linuxHeaders, ... } @ args:

stdenv.mkDerivation {
  version = "11.2.0";
  name = "ceph-11.2.0";

  src = fetchurl {
    url = "https://download.ceph.com/tarballs/ceph_11.2.0.orig.tar.gz";
    sha256 = "1wyagw3kqiy8hq5h1rjk4k07lagh7n7fzrb210avgbal2mh1cz5c";
  };

  patches = [
    ./cmake-findkeyutils.patch
    ./cmake-findxfs.patch
    ./kv_include_asm_generic.patch
  ];

  nativeBuildInputs = [ autoconf automake cmake pkgconfig ];
  buildInputs = [ boost162 pythonPackages.sphinx libudev libaio libuuid openldap fuse libxfs leveldb libatomic_ops snappy keyutils gperftools jemalloc curl nss nspr expat fcgi lttng-tools lttng-ust pythonPackages.cython yasm liburcu linuxHeaders ];

  configurePhase = ''
    mkdir build
    cd build
    cmake -DBOOST_J=$(nproc) -DWITH_XFS=OFF -DWITH_LTTNG=OFF -DWITH_OPENLDAP=OFF -DWITH_TESTS=OFF \
      -DCMAKE_INSTALL_PREFIX=$out \
      -DCMAKE_C_FLAGS="-Wno-unused-variable" -DCMAKE_CXX_FLAGS="-Wno-unused-variable" ..
  '';

  buildPhase = ''
    make
  '';
}
