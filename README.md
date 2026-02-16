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

1. Edit files in this repo (`_extensions/brand/light-brand.yml`, `_extensions/brand/dark-brand.yml`, `_extensions/brand/_extension.yml`).
2. Bump `version` in `_extensions/brand/_extension.yml`.
3. Commit and push to GitHub.
4. In the consuming repo, run:

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
