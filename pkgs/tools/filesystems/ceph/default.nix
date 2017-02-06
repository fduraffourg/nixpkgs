{ stdenv, fetchurl, autoconf, automake, cmake, pkgconfig, pythonPackages, libudev, libaio, libuuid, openldap, fuse, libxfs, leveldb, libatomic_ops, snappy, keyutils, gperftools, jemalloc, curl, nss, nspr, expat, fcgi, boost162, lttng-tools, lttng-ust,  yasm, ... } @ args:

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
  ];

  nativeBuildInputs = [ autoconf automake cmake pkgconfig ];
  buildInputs = [ boost162 pythonPackages.sphinx libudev libaio libuuid openldap fuse libxfs leveldb libatomic_ops snappy keyutils gperftools jemalloc curl nss nspr expat fcgi lttng-tools lttng-ust pythonPackages.cython yasm ];

  configurePhase = ''
    mkdir build
    cd build
    cmake -DBOOST_J=$(nproc) ..
  '';

  buildPhase = ''
    make -j$(nproc)
  '';

  installPhase = ''
  '';
}
