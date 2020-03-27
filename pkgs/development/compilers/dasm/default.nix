{stdenv, fetchFromGitHub}:

stdenv.mkDerivation rec {
	pname = "dasm";
	version = "2.20.13";

	src = fetchFromGitHub {
		owner = "dasm-assembler";
		repo = "dasm";
		rev = "38c66afbb1773844c8e1bfedc1411d5863edcc49";
		sha256 = "1nr4kvw42vyc6i4p1c06jlih11rhbjjxc27dc7cx5qj635xf4jcf";
	};

	configurePhase = false;
	installPhase = ''
		mkdir -p $out/bin
		install bin/* $out/bin
	'';
	nativeBuildInputs = [];

	meta = with stdenv.lib; {
		homepage = https://dasm-assembler.github.io;
		description = "";
		license = licenses.gpl2;
		platforms = platforms.all;
	};
}
