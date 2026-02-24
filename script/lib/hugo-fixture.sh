#! /usr/bin/env bash

set -euo pipefail

create_hugo_fixture_site() {
  local site_dir="$1"
  local theme_dir="$2"

  mkdir -p "$site_dir/content/posts" "$site_dir/themes"
  ln -s "$theme_dir" "$site_dir/themes/dario"

  cat > "$site_dir/hugo.toml" <<'EOF'
baseURL = "https://example.org/blog/"
languageCode = "en-us"
title = "Fixture Site"
theme = "dario"

[params]
  description = "Fixture description"

[params.author]
  name = "Fixture Author"
EOF

  cat > "$site_dir/content/_index.md" <<'EOF'
+++
title = "Home *Post*"
subtitle = "Fixture subtitle"
description = "Fixture homepage description"
homePageIsPost = true
date = 2025-02-24T00:00:00Z
author = "Fixture Author"
+++

Fixture **content** for the homepage.
EOF

  cat > "$site_dir/content/posts/first.md" <<'EOF'
+++
title = "First *Post*"
description = "Fixture post"
ogDescription = "A & B"
date = 2025-02-24T00:00:00Z
+++

Hello from the fixture post.[^1]

## Details

Some text under a heading.

[^1]: Fixture footnote text.
EOF

  cat > "$site_dir/content/posts/absolute-og.md" <<'EOF'
+++
title = "Absolute OG"
description = "Fixture post with absolute OG image"
ogImage = "https://cdn.example.com/og.png"
date = 2025-02-25T00:00:00Z
+++

## Absolute Image

This post uses an absolute OG image URL.
EOF

  cat > "$site_dir/content/posts/no-anchors.md" <<'EOF'
+++
title = "No Anchors"
description = "Fixture post with heading anchors disabled"
disableAnchoredHeadings = true
date = 2025-02-26T00:00:00Z
+++

## Without Anchor

This post should not render a heading anchor.
EOF
}
