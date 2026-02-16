# Brand Extension for Quarto

Reusable brand extension for Quarto projects, websites, HTML docs, and Bootstrap/Shiny apps.

## Install

```bash
quarto add TylerPollard410/brand --no-prompt
```

This installs files under `_extensions/TylerPollard410/brand`.

## Use in a project

The extension ships two standalone brand files:

- `_extensions/TylerPollard410/brand/light-brand.yml`
- `_extensions/TylerPollard410/brand/dark-brand.yml`

It also ships generated bslib theme artifacts (built from each brand with gradients,
shadows, and shared Sass rules):

- `_extensions/TylerPollard410/brand/themes/light-theme.css`
- `_extensions/TylerPollard410/brand/themes/dark-theme.css`
- `_extensions/TylerPollard410/brand/themes/light-bootstrap.css`
- `_extensions/TylerPollard410/brand/themes/dark-bootstrap.css`
- `_extensions/TylerPollard410/brand/themes/light-shiny.css`
- `_extensions/TylerPollard410/brand/themes/dark-shiny.css`

These generated files are intended for bslib/Shiny workflows. For Quarto, keep using
`theme: [default, brand]` and the brand YAML pair.

To use both in a consuming repo, set `brand.light` and `brand.dark` in `_quarto.yml`:

```yaml
brand:
  light: _extensions/TylerPollard410/brand/light-brand.yml
  dark: _extensions/TylerPollard410/brand/dark-brand.yml

format:
  html:
    theme:
      light: [default, brand]
      dark: [default, brand]
```

Note: the extension metadata defaults `project.brand` to `light-brand.yml` for compatibility, but explicit `brand.light`/`brand.dark` in your project is the recommended setup.

## Use from R (bslib/Shiny)

Build or rebuild distributable CSS from the extension files:

```bash
Rscript _extensions/TylerPollard410/brand/build-themes.R
```

Or compose the full bslib theme object directly in R:

```r
source("_extensions/TylerPollard410/brand/build-themes.R")

dark_bootstrap <- compose_brand_theme(
  brand_path = "_extensions/TylerPollard410/brand/dark-brand.yml",
  preset = "bootstrap",
  rules_path = "_extensions/TylerPollard410/brand/styles.scss"
)
```

## Keep an existing `_brand.yml`

Use Quarto profiles so you can switch between your existing brand file and this extension:

```yaml
# _quarto.yml
project:
  type: website

brand: _brand.yml
```

```yaml
# _quarto-extension.yml
brand:
  light: _extensions/TylerPollard410/brand/light-brand.yml
  dark: _extensions/TylerPollard410/brand/dark-brand.yml
```

Then render/preview with:

```bash
quarto render --profile extension
```

## Update workflow (publish + consume)

1. Edit files in this repo (`_extensions/brand/light-brand.yml`, `_extensions/brand/dark-brand.yml`, `_extensions/brand/styles.scss`, `_extensions/brand/_extension.yml`).
2. Rebuild generated theme artifacts:

```bash
Rscript _extensions/brand/build-themes.R
```

3. Bump `version` in `_extensions/brand/_extension.yml`.
4. Commit and push to GitHub.
5. In the consuming repo, run:

```bash
quarto update extension TylerPollard410/brand --no-prompt
```

If Quarto reports `[No Change]`, remove the installed folder and add again:

```bash
rm -rf _extensions/TylerPollard410/brand
quarto add TylerPollard410/brand --no-prompt
```

## Example

See [example.qmd](example.qmd) for a minimal extension demo.
