#! /usr/bin/env bash

set -euo pipefail

create_hugo_fixture_site() {
  local site_dir="$1"
  local theme_dir="$2"
  local copy_markdown_mode="${3:-global}"
  local home_page_is_post="${4:-true}"
  local show_posts_link="${5:-true}"

  mkdir -p "$site_dir/content/posts" "$site_dir/themes"
  ln -s "$theme_dir" "$site_dir/themes/dario"

  cat > "$site_dir/hugo.toml" <<EOF
baseURL = "https://example.org/blog/"
languageCode = "en-us"
title = "Fixture Site"
theme = "dario"

[params]
  description = "Fixture description"
  showPostsLink = $show_posts_link

[params.author]
  name = "Fixture Author"
EOF

  case "$copy_markdown_mode" in
    global)
      cat >> "$site_dir/hugo.toml" <<'EOF'

[params.copyMarkdown]
  enabled = true
EOF
      ;;
    home)
      cat >> "$site_dir/hugo.toml" <<'EOF'

[params.copyMarkdown]
  enabled = true
  home = true
  posts = false
EOF
      ;;
    posts)
      cat >> "$site_dir/hugo.toml" <<'EOF'

[params.copyMarkdown]
  enabled = true
  home = false
  posts = true
EOF
      ;;
    off)
      cat >> "$site_dir/hugo.toml" <<'EOF'

[params.copyMarkdown]
  enabled = false
EOF
      ;;
    *)
      echo "unsupported copy Markdown fixture mode: $copy_markdown_mode" >&2
      return 1
      ;;
  esac

  cat > "$site_dir/content/_index.md" <<EOF
+++
title = "Home *Post*"
subtitle = "Fixture subtitle"
description = "Fixture homepage description"
homePageIsPost = $home_page_is_post
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

Inline `vendor/cache` code should keep its compact pill styling.

```bash {linenos=inline hl_lines="2"}
# Build without downloading modules.
HUGO_MODULE_PROXY=off hugo --minify
readonly deliberately_long_path="/this/is/a/deliberately/long/path/that/should/scroll/horizontally/instead/of/breaking/highlighted/tokens/across/the/code/block"
```

```yaml
# Pin the reviewed theme revision in go.mod.
module:
  imports:
    - path: github.com/GrantBirki/dario
```

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

  cat > "$site_dir/content/posts/template-literal-og.md" <<'EOF'
+++
title = "{{ .Site.Title }}"
description = "{{ now.Year }}"
date = 2025-02-27T00:00:00Z
+++

This post verifies that Open Graph SVG generation does not execute template actions from content.
EOF
}
