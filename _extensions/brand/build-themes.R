#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(bslib)
  library(sass)
})

resolve_extension_dir <- function(extension_dir = NULL) {
  if (!is.null(extension_dir)) {
    return(normalizePath(extension_dir, winslash = "/", mustWork = TRUE))
  }

  file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(file_arg)) {
    script_path <- normalizePath(
      sub("^--file=", "", file_arg[[1]]),
      winslash = "/",
      mustWork = TRUE
    )
    return(dirname(script_path))
  }

  normalizePath("_extensions/brand", winslash = "/", mustWork = TRUE)
}

compose_brand_theme <- function(brand_path, preset = "bootstrap", rules_path = NULL) {
  theme <- bs_theme(
    version = 5,
    preset = preset,
    brand = brand_path
  ) |>
    bs_theme_update(
      `enable-gradients` = TRUE,
      `enable-shadows` = TRUE
    )

  if (!is.null(rules_path) && file.exists(rules_path)) {
    theme <- theme |>
      bs_add_rules(sass_file(rules_path))
  }

  theme
}

extract_bootstrap_css <- function(theme) {
  deps <- bs_theme_dependencies(theme)
  bootstrap_dep_index <- which(
    vapply(deps, function(dep) identical(dep$name, "bootstrap"), logical(1))
  )

  if (!length(bootstrap_dep_index)) {
    stop("Could not locate bootstrap dependency for compiled theme output.")
  }

  bootstrap_dep <- deps[[bootstrap_dep_index[[1]]]]
  if (is.null(bootstrap_dep$stylesheet) || !length(bootstrap_dep$stylesheet)) {
    stop("Bootstrap dependency did not expose a stylesheet.")
  }

  css_path <- file.path(bootstrap_dep$src$file, bootstrap_dep$stylesheet[[1]])
  if (!file.exists(css_path)) {
    stop("Compiled stylesheet does not exist: ", css_path)
  }

  css_path
}

write_layered_css <- function(css_source, output_path, layer = "rules") {
  css_lines <- readLines(css_source, warn = FALSE, encoding = "UTF-8")
  writeLines(
    c(sprintf("/*-- scss:%s --*/", layer), css_lines),
    output_path,
    useBytes = TRUE
  )
}

build_extension_themes <- function(
  extension_dir = resolve_extension_dir(),
  presets = c("bootstrap", "shiny"),
  output_dir = file.path(extension_dir, "themes"),
  brand_files = c(light = "light-brand.yml", dark = "dark-brand.yml"),
  include_rules = TRUE
) {
  extension_dir <- normalizePath(extension_dir, winslash = "/", mustWork = TRUE)
  output_dir <- normalizePath(output_dir, winslash = "/", mustWork = FALSE)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)

  rules_path <- if (isTRUE(include_rules)) {
    file.path(extension_dir, "styles.scss")
  } else {
    NULL
  }

  if (!is.null(rules_path) && !file.exists(rules_path)) {
    message("No styles.scss found at ", rules_path, "; compiling without extra Sass rules.")
    rules_path <- NULL
  }

  outputs <- character()
  for (brand_name in names(brand_files)) {
    brand_path <- normalizePath(
      file.path(extension_dir, brand_files[[brand_name]]),
      winslash = "/",
      mustWork = TRUE
    )

    for (preset_name in presets) {
      theme <- compose_brand_theme(
        brand_path = brand_path,
        preset = preset_name,
        rules_path = rules_path
      )
      css_source <- extract_bootstrap_css(theme)

      output_path <- file.path(output_dir, sprintf("%s-%s.css", brand_name, preset_name))
      write_layered_css(css_source, output_path)

      outputs <- c(outputs, output_path)
      message(sprintf("Built %s (%s): %s", brand_name, preset_name, output_path))

      if (identical(preset_name, "bootstrap")) {
        alias_path <- file.path(output_dir, sprintf("%s-theme.css", brand_name))
        if (!file.copy(output_path, alias_path, overwrite = TRUE)) {
          stop("Failed to write alias CSS: ", alias_path)
        }
        outputs <- c(outputs, alias_path)
      }
    }
  }

  invisible(outputs)
}

if (sys.nframe() == 0) {
  build_extension_themes()
}
