# Brand Extension For Quarto

_TODO_: Add a short description of your extension.

## Installing

```bash
quarto add TylerPollard410/brand
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

This extension installs a [brand.yml](https://posit-dev.github.io/brand-yml/) configuration for _your organization name_.

This extension contributes separate light/dark brand files:

```yaml
brand:
  light: _extensions/brand/light-brand.yml
  dark: _extensions/brand/dark-brand.yml
```

You can override this per project by setting `project.brand` or top-level `brand` in your own `_quarto.yml`.

Note: this extension uses top-level `brand` metadata (instead of `project.brand`) to keep split files working with current Quarto extension loading behavior.

## Editing Shared + Mode Data

Edit the source files:

- `_extensions/brand/src/shared-brand.yml` for values shared by both modes
- `_extensions/brand/src/light-overrides.yml` for light-only overrides
- `_extensions/brand/src/dark-overrides.yml` for dark-only overrides

Then regenerate full standalone brand files:

```bash
_extensions/brand/scripts/build-brand.rb
```

This writes:

- `_extensions/brand/light-brand.yml`
- `_extensions/brand/dark-brand.yml`

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).
