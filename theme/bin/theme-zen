#!/usr/bin/env bash
# Reads pywal colors and updates Zen's userChrome.css and userContent.css

. "$HOME/.cache/theme/colors.sh" || {
  echo "Run theme-switch first."
  exit 1
}

# Find the most recently modified profile directory (excluding backups)
PROFILE_DIR=$(ls -td "$HOME/.zen/"*/ 2>/dev/null | grep -E "\.Default" | grep -v "_backup" | head -n 1 | sed 's/\/$//')

if [ -z "$PROFILE_DIR" ] || [ ! -d "$PROFILE_DIR" ]; then
  echo "Error: Could not find a valid Zen profile directory."
  exit 1
fi

CHROME="$PROFILE_DIR/chrome/userChrome.css"
CONTENT="$PROFILE_DIR/chrome/userContent.css"

# Read colors by line
color4="$accent" # theme accent becomes Zen's primary color

cat >"$CHROME" <<EOF
:root {
  --zen-primary-color:                    $color4 !important;
  --zen-branding-dark:                    $color0 !important;
  --zen-branding-paper:                   $color7 !important;
  --zen-main-browser-background:          $color0 !important;
  --zen-main-browser-background-toolbar:  $color0 !important;
  --toolbar-bgcolor:                       $color0 !important;
  --zen-themed-toolbar-bg-transparent:     $color0 !important;
  --arrowpanel-background:                 $color0 !important;
  --arrowpanel-color:                      $color7 !important;
  --arrowpanel-border-color:               $color8 !important;

  /* Urlbar theming */
  --toolbar-field-background-color: $color0 !important;
  --toolbar-field-color:            $color7 !important;
  --toolbar-field-border-color:     $color8 !important;
  --urlbar-box-bgcolor:             $color0 !important;
  --zen-urlbar-background:          $color0 !important;
}

.zen-toolbar-background,
#zen-main-app-wrapper {
  background: $color0 !important;
}
.zen-browser-generic-background::after,
.zen-browser-generic-background::before {
  background: $color0 !important;
}

/* Urlbar box itself -- note: these are CLASSES, not IDs */
#urlbar .urlbar-background,
.urlbar-background {
  background-color: $color0 !important;
  border-color: $color8 !important;
}

#urlbar .urlbar-input,
.urlbar-input {
  color: $color7 !important;
}

/* Zen's floating urlbar state uses this attribute */
#urlbar[zen-floating-urlbar="true"] .urlbar-background {
  background-color: $color0 !important;
}
EOF

cat >"$CONTENT" <<EOF
/* Force background color on all websites (content pages only, not about: pages) */
@-moz-document url-prefix("http://"), url-prefix("https://") {
  html, body {
    background-color: $color0 !important;
  }
}
EOF

echo "Zen colors successfully applied to: $PROFILE_DIR"
