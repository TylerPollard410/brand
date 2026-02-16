suppressPackageStartupMessages({
  library(bslib)
})

source("_extensions/brand/build-themes.R")

# Build distributable theme CSS for both brands and presets.
generated_css <- build_extension_themes(
  extension_dir = "_extensions/brand",
  presets = c("bootstrap", "shiny")
)

message("Generated CSS artifacts:")
for (path in generated_css) {
  message(" - ", path)
}

# Quick interactive preview helper for ad hoc inspection.
preview_brand_theme <- function(
  mode = c("light", "dark"),
  preset = c("bootstrap", "shiny")
) {
  mode <- match.arg(mode)
  preset <- match.arg(preset)

  brand_path <- file.path("_extensions/brand", sprintf("%s-brand.yml", mode))
  theme <- compose_brand_theme(
    brand_path = brand_path,
    preset = preset,
    rules_path = "_extensions/brand/styles.scss"
  )

  bs_theme_preview(theme)
}
