#!/usr/bin/env bash
# Descarga las tipografías desde el repositorio oficial de Google Fonts
# y las recorta a latín + cirílico para que la web cargue rápido.
# Se ejecuta solo en GitHub Actions. En tu ordenador:  bash tool/get_fonts.sh
set -euo pipefail
cd "$(dirname "$0")/.."

OUT=assets/fonts
TMP="$(mktemp -d)"
BASE=https://raw.githubusercontent.com/google/fonts/main/ofl
mkdir -p "$OUT"

curl -sSLf -o "$TMP/BebasNeue-Regular.ttf" "$BASE/bebasneue/BebasNeue-Regular.ttf"
curl -sSLf -o "$TMP/Oswald-Variable.ttf" "$BASE/oswald/Oswald%5Bwght%5D.ttf"
for w in Light Regular Italic Medium Bold; do
  curl -sSLf -o "$TMP/IosevkaCharon-$w.ttf" "$BASE/iosevkacharon/IosevkaCharon-$w.ttf"
done

UNICODES="U+0000-024F,U+0300-036F,U+0400-052F,U+1E00-1EFF,U+2000-206F,U+20A0-20CF,U+2100-214F,U+2190-21FF,U+2500-259F,U+25A0-25FF"

for f in "$TMP"/*.ttf; do
  name="$(basename "$f")"
  if command -v pyftsubset >/dev/null 2>&1; then
    pyftsubset "$f" --unicodes="$UNICODES" --layout-features='*' --output-file="$OUT/$name"
  else
    cp "$f" "$OUT/$name"
  fi
done

rm -rf "$TMP"
ls -la "$OUT"
