{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "neomutt-dev-env";

  # Tools required for compilation and configuration
  nativeBuildInputs = with pkgs; [
    pkg-config
    autoconf
    automake
    gnumake
    gcc             # or clang
    gettext         # for msgfmt
    git
    
    # Documentation generation (optional but recommended)
    libxslt
    docbook_xsl
    docbook_xml_dtd_42
  ];

  # Libraries the binary will link against
  buildInputs = with pkgs; [
    # Core UI and SSL
    ncurses
    openssl
    
    # Authentication & Security
    cyrus_sasl
    gpgme
    libgpg-error
    
    # Database Backends (Header Cache)
    lmdb
    gdbm
    tokyocabinet
    kyotocabinet
    rocksdb
    
    # Features & Compression
    notmuch
    libidn2
    zlib
    lz4
    zstd
    lua             # Scripting support
  ];

  # Configure the environment on entry
  shellHook = ''
    export HARDWARE_PLATFORM="${pkgs.stdenv.hostPlatform.system}"
    
    echo "=============================================="
    echo " 📧 Neomutt Development Environment Active"
    echo "=============================================="
    echo " Dependencies loaded."
    echo ""
    echo " Recommended build loop:"
    echo "   1. ./configure --enable-everything --disable-doc"
    echo "   2. make -j\$(nproc)"
    echo ""
    echo " Note: Documentation build requires xsltproc (included),"
    echo " but can be slow. Disable it for rapid iteration."
    echo "=============================================="
  '';
}
