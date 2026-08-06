#!/usr/bin/env bash
set -euo pipefail

site_url="${1:-https://hitbox.nya3neko2.dev}"
site_url="${site_url%/}"

require_status() {
  local path="$1"
  local status
  status="$(curl --silent --show-error --location --output /dev/null --write-out '%{http_code}' "$site_url$path")"
  if [[ "$status" != "200" ]]; then
    printf 'Expected HTTP 200 for %s, received %s\n' "$path" "$status" >&2
    exit 1
  fi
  printf 'OK  %s\n' "$path"
}

require_content_type() {
  local path="$1"
  local expected="$2"
  local actual
  actual="$(curl --silent --show-error --location --head "$site_url$path" | tr -d '\r' | awk 'BEGIN{IGNORECASE=1} /^content-type:/{print $2; exit}')"
  if [[ "$actual" != "$expected"* ]]; then
    printf 'Expected Content-Type %s for %s, received %s\n' "$expected" "$path" "$actual" >&2
    exit 1
  fi
  printf 'OK  %s (%s)\n' "$path" "$actual"
}

homepage="$(curl --silent --show-error --fail "$site_url/")"
for expected in \
  '<meta property="og:url" content="' \
  '<meta property="og:image" content="' \
  '<meta name="robots" content="index,follow,max-image-preview:large">' \
  '<link rel="canonical" href="' \
  '<meta name="twitter:image" content="' \
  '"@type": "WebApplication"' \
  'HITBOX SNAP' \
  'manifest.webmanifest' \
  'samples/cat.webp' \
  'samples/hamster.webp' \
  'samples/fugu.webp' \
  '利用規約とプライバシー'; do
  if ! grep --fixed-strings --quiet "$expected" <<<"$homepage"; then
    printf 'Homepage is missing expected content: %s\n' "$expected" >&2
    exit 1
  fi
done

require_status '/'
require_status '/samples/cat.jpg'
require_status '/samples/hamster.jpg'
require_status '/samples/fugu.jpg'
require_status '/samples/cat.webp'
require_status '/samples/hamster.webp'
require_status '/samples/fugu.webp'
require_status '/samples/demo-cat.jpg'
require_status '/samples/demo-hamster.jpg'
require_status '/samples/demo-fugu.jpg'
require_status '/samples/demo-cat.webp'
require_status '/samples/demo-hamster.webp'
require_status '/samples/demo-fugu.webp'
require_content_type '/samples/cat.webp' 'image/webp'
require_content_type '/samples/demo-cat.webp' 'image/webp'
require_status '/samples/ogp.jpg'
require_status '/manifest.webmanifest'
require_status '/sw.js'
require_status '/robots.txt'
require_status '/sitemap.xml'
printf 'Deployment checks passed for %s\n' "$site_url"
