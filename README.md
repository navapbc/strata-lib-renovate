# Strata Renovate library

A collection of useful [Renovate config
presets](https://docs.renovatebot.com/config-presets/). Informed by Nava Strata
standards and practices.

## Presets

<!-- preset_summary_table_begin -->

Preset                             | Description
---                                | ---
default.json                       | General recommended config
dependencyDashboard.json           | Tweaked settings for Dependency Dashboard
groupLangUpdatesRuby.json          | Group updates to the Ruby language
groupNonMajorUpdatesByManager.json | Group non-major package updates by package manager
labels.json                        | Apply standard Strata labels
security.json                      | Base security/vulnerability settings
strataTemplate.json                | Default config for Strata templates themselves
templateFileMatch.json             | Allow rules to match Strata templates files for updates
<!-- preset_summary_table_end -->

> [!NOTE]
>
> Note all the `*.json` files are actually JSONC files, which Renovate supports
> in its preset files. Renovate does support a `.json5` extension, but [not
> automatically][no-auto-json5], users need to explicitly add `.json5` in their
> `extends` lines. So to simplify maintenance (i.e., not having to generate
> `.json` files from a more proper `.json5` or `.jsonc` version) and provide as
> simple use for users, just accept the slight inaccuracy of putting JSONC in a
> `.json` file.  We may change this in the future.

[no-auto-json5]: https://github.com/renovatebot/renovate/discussions/34640#discussioncomment-12406687

## Development

To activate a shell environment with required build and runtime dependencies for
functionality in this repo, [install nix](https://nixos.org/download/) and run:

``` shell
nix develop
```

Or if you have direnv, run:

``` shell
echo "use flake" >> .envrc
```

See output of `make help` for development utilities.
