#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
ARTICLE="full-pipeline"
FROM_MD_ONLY="false"

for arg in "$@"; do
  case "$arg" in
    --from-md)
      FROM_MD_ONLY="true"
      ;;
    *)
      ARTICLE="$arg"
      ;;
  esac
done

RMD_PATH="$ROOT_DIR/articles/${ARTICLE}.Rmd"
MD_PATH="$ROOT_DIR/articles/${ARTICLE}.md"
HTML_PATH="$ROOT_DIR/articles/${ARTICLE}.html"

if [[ ! -f "$MD_PATH" ]]; then
  echo "Markdown file not found: $MD_PATH" >&2
  exit 1
fi

if [[ ! -f "$HTML_PATH" ]]; then
  echo "HTML file not found: $HTML_PATH" >&2
  exit 1
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "pandoc is required but not found in PATH" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# Always use a stable pkgdown shell source when available.
if git -C "$ROOT_DIR" cat-file -e "HEAD:articles/${ARTICLE}.html" 2>/dev/null; then
  git -C "$ROOT_DIR" show "HEAD:articles/${ARTICLE}.html" > "$TMP_DIR/shell.html"
else
  cp "$HTML_PATH" "$TMP_DIR/shell.html"
fi

if [[ "$FROM_MD_ONLY" != "true" ]]; then
  if [[ ! -f "$RMD_PATH" ]]; then
    echo "Rmd file not found: $RMD_PATH" >&2
    echo "Use --from-md to skip Rmd rendering." >&2
    exit 1
  fi
  Rscript -e "rmarkdown::render('$RMD_PATH', output_format='md_document', output_file='${ARTICLE}.md', output_dir='${ROOT_DIR}/articles', quiet=TRUE)"
fi

# Markdown -> HTML body fragment
pandoc "$MD_PATH" -f gfm -t html5 > "$TMP_DIR/body_raw.html"
# Remove first H1 if present; page-header already has title
perl -0777 -pe 's/^\s*<h1[^>]*>.*?<\/h1>\s*//s' "$TMP_DIR/body_raw.html" > "$TMP_DIR/body.html"

# Extract prefix (through page-header close)
awk '
  {
    print
    if ($0 ~ /<div class="d-none name"><code>.*<\/code><\/div>/) {
      if (getline line) print line
      exit
    }
  }
' "$TMP_DIR/shell.html" > "$TMP_DIR/prefix.html"

# Extract suffix (right sidebar + footer)
awk '
  BEGIN { capture = 0 }
  /<\/main><aside class="col-md-3"><nav id="toc"/ { capture = 1 }
  capture { print }
' "$TMP_DIR/shell.html" > "$TMP_DIR/suffix.html"

cat "$TMP_DIR/prefix.html" "$TMP_DIR/body.html" "$TMP_DIR/suffix.html" > "$HTML_PATH"

echo "Updated: $MD_PATH"
echo "Updated: $HTML_PATH"
