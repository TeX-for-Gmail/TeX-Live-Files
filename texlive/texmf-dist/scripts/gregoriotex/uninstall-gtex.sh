# This script uninstalls GregorioTeX.
# Run it with "bash /path/to/uninstall-gtex.sh".

RM=${RM:-rm}
TEXHASH=${TEXHASH:-texhash}

cd $(dirname ${BASH_SOURCE[0]})/../..

$RM tex/luatex/gregoriotex/gregoriotex-chars.tex
$RM tex/luatex/gregoriotex/gregoriotex-common.tex
$RM tex/luatex/gregoriotex/gregoriotex-main.tex
$RM tex/luatex/gregoriotex/gregoriotex-nabc.tex
$RM tex/luatex/gregoriotex/gregoriotex-signs.tex
$RM tex/luatex/gregoriotex/gregoriotex-spaces.tex
$RM tex/luatex/gregoriotex/gregoriotex-syllable.tex
$RM tex/luatex/gregoriotex/gregoriotex-symbols.tex
$RM tex/luatex/gregoriotex/gregoriotex.tex
$RM tex/luatex/gregoriotex/gsp-default.tex
$RM tex/luatex/gregoriotex/gregoriotex-nabc.lua
$RM tex/luatex/gregoriotex/gregoriotex-signs.lua
$RM tex/luatex/gregoriotex/gregoriotex-symbols.lua
$RM tex/luatex/gregoriotex/gregoriotex.lua
$RM tex/luatex/gregoriotex/gregorio-vowels.dat
rmdir -p tex/luatex/gregoriotex 2> /dev/null || true

$RM tex/lualatex/gregoriotex/gregoriosyms.sty
$RM tex/lualatex/gregoriotex/gregoriotex.sty
rmdir -p tex/lualatex/gregoriotex 2> /dev/null || true

$RM fonts/truetype/public/gregoriotex/greciliae-hole.ttf
$RM fonts/truetype/public/gregoriotex/greciliae-hollow.ttf
$RM fonts/truetype/public/gregoriotex/greciliae-op-hole.ttf
$RM fonts/truetype/public/gregoriotex/greciliae-op-hollow.ttf
$RM fonts/truetype/public/gregoriotex/greciliae-op.ttf
$RM fonts/truetype/public/gregoriotex/greciliae.ttf
$RM fonts/truetype/public/gregoriotex/greextra.ttf
$RM fonts/truetype/public/gregoriotex/gregall.ttf
$RM fonts/truetype/public/gregoriotex/grelaon.ttf
$RM fonts/truetype/public/gregoriotex/gresgmodern.ttf
rmdir -p fonts/truetype/public/gregoriotex 2> /dev/null || true

$RM doc/luatex/gregoriotex/Appendix_Font_Tables.tex
$RM doc/luatex/gregoriotex/Command_Index_User.tex
$RM doc/luatex/gregoriotex/Command_Index_gregorio.tex
$RM doc/luatex/gregoriotex/Command_Index_internal.tex
$RM doc/luatex/gregoriotex/Gabc.tex
$RM doc/luatex/gregoriotex/GregorioNabcRef.tex
$RM doc/luatex/gregoriotex/GregorioRef.tex
$RM doc/luatex/gregoriotex/GregorioRef.lua
$RM doc/luatex/gregoriotex/factus.gabc
$RM doc/luatex/gregoriotex/omnes.gabc
$RM doc/luatex/gregoriotex/pitches2.gabc
$RM doc/luatex/gregoriotex/pitches3.gabc
$RM doc/luatex/gregoriotex/pitches4.gabc
$RM doc/luatex/gregoriotex/pitches5.gabc
$RM doc/luatex/gregoriotex/veni.gabc
$RM doc/luatex/gregoriotex/GregorioNabcRef.pdf
$RM doc/luatex/gregoriotex/GregorioRef.pdf
$RM doc/luatex/gregoriotex/doc_README.md
rmdir -p doc/luatex/gregoriotex 2> /dev/null || true

$RM doc/luatex/gregoriotex/examples/FactusEst.gabc
$RM doc/luatex/gregoriotex/examples/PopulusSion.gabc
$RM doc/luatex/gregoriotex/examples/main-lualatex.tex
$RM doc/luatex/gregoriotex/examples/debugging.tex
rmdir -p doc/luatex/gregoriotex/examples 2> /dev/null || true

$RM fonts/source/gregoriotex/greextra.sfd
$RM fonts/source/gregoriotex/squarize.py
$RM fonts/source/gregoriotex/convertsfdtottf.py
$RM fonts/source/gregoriotex/gregall.sfd
$RM fonts/source/gregoriotex/gresgmodern.sfd
$RM fonts/source/gregoriotex/fonts_README.md
$RM fonts/source/gregoriotex/granapadano-base.sfd
$RM fonts/source/gregoriotex/greciliae-base.sfd
$RM fonts/source/gregoriotex/gregorio-base.sfd
rmdir -p fonts/source/gregoriotex 2> /dev/null || true

$RM scripts/gregoriotex/uninstall-gtex.sh
rmdir -p scripts/gregoriotex 2> /dev/null || true

${TEXHASH}
