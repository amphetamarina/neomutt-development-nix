{
  description = "Neomutt development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
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
            
            # Documentation generation
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
            db
            
            # Features & Compression
            notmuch
            libidn2
            zlib
            lz4
            zstd
            lua
          ];

          shellHook = ''
            export HARDWARE_PLATFORM="${system}"
            
            echo "=============================================="
            echo " 📧 Neomutt Development Environment (Flake)"
            echo "=============================================="
            echo " Dependencies loaded."
            echo ""
            echo " Recommended build loop:"
            echo "   1. ./configure --enable-everything --disable-doc"
            echo "   2. make -j\$(nproc)"
            echo "=============================================="
          '';
        };
      }
    );
}
