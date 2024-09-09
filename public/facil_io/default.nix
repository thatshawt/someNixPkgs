with import <nixpkgs> {};

let
  theGithub = fetchzip {
    url = "https://github.com/boazsegev/facil.io/archive/f261935c6c8fc56d582f0a95e3992bcb324a1f26.zip";
    hash = "sha256-5RfUfppnYj4hvCH+s2SAQMsBJUaJsC1HANZjvqOuhww=";
  };
in
stdenv.mkDerivation rec {
  name = "facilio";
  src = theGithub;
  # Add the derivation to the PATH
  #buildInputs = [ myScript ];
  buildPhase = ''
    mkdir tmp
    ${pkgs.gnumake}/bin/make lib
  '';
  installPhase = ''
    # create the output directory
    mkdir $out

    # copy .so library to /lib
    mkdir $out/lib
    cp -rv tmp/*.so $out/lib

    # copy source code to src
    mkdir $out/src
    cp -rv lib/facil/. $out/src/

    # copy header files into /include
    mkdir $out/include
    cd lib/facil/ # make sure not to get example code
    find -name "*.h" | awk '{system ("mv " $0 " $out/include/")}'
  '';

}
