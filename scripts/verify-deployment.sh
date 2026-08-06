#!/usr/bin/env bash
set -euo pipefail

site_url="${1:-https://hitbox-maker.takahashinaoki521.workers.dev}"
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

homepage="$(curl --silent --show-error --fail "$site_url/")"
for expected in \
  '<meta property="og:url" content="' \
  '<meta property="og:image" content="' \
  '<meta name="robots" content="index,follow,max-image-preview:large">' \
  '<link rel="canonical" href="' \
  '<meta name="twitter:image" content="' \
  '"@type": "WebApplication"' \
  'samples/cat.jpg' \
  'samples/hamster.jpg' \
  'samples/fugu.jpg' \
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
require_status '/samples/ogp.jpg'
require_status '/robots.txt'
require_status '/sitemap.xml'
printf 'Deployment checks passed for %s\n' "$site_url"
