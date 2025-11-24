{
  description = "Neomutt development environment (Minimal)";

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

          # Build tools
          nativeBuildInputs = with pkgs; [
            pkg-config
            autoconf
            automake
            gnumake
            gcc
            gettext
            git
            
            # Docs (kept as they are often required for release generation)
            libxslt
            docbook_xsl
            docbook_xml_dtd_42
          ];

          # Runtime libraries (Minimal set for functional client)
          buildInputs = with pkgs; [
            ncurses         # UI
            openssl         # TLS/SSL
            cyrus_sasl      # Auth
            zlib            # Compression
            libidn2         # Domain handling
            libkrb5         # Kerberos/GSSAPI
          ];

          shellHook = ''
            export HARDWARE_PLATFORM="${system}"
            
            echo "=============================================="
            echo " 📧 Neomutt Development Environment (Minimal)"
            echo "=============================================="
            echo " Dependencies loaded: UI, SSL, SASL, IDN, Zlib"
            echo ""
            echo " Recommended build loop:"
            echo "   1. ./configure --disable-doc --ssl --sasl --sasl --gss --zlib"
            echo "   2. make -j\$(nproc)"
            echo "=============================================="
          '';
        };
      }
    );
}
