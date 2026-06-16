# Strata Renovate library

A collection of useful [Renovate config
presets](https://docs.renovatebot.com/config-presets/). Informed by Nava Strata
standards and practices.

## Presets

<!-- preset_summary_table_begin -->

Preset                                        | Description
---                                           | ---
default.json                                  | General recommended config
dependencyDashboard.json                      | Tweaked settings for Dependency Dashboard
groupLangUpdatesRuby.json                     | Group updates to the Ruby language
groupNonMajorUpdatesByManager.json            | Group non-major package updates by package manager
labels.json                                   | Apply standard Strata labels
playwright.json                               | Group playwright package and Docker image updates
security.json                                 | Base security/vulnerability settings
strataTemplate.json                           | Default config for Strata templates themselves
strataTemplateSeparateTemplateOnly.json       | Separate out changes that are for the template itself and do not impact instances
strataTemplateSeparateTemplateOnlyLegacy.json | Separate out changes that are for the template itself and do not impact instances, using the legacy `template-only-*` convention
templateFileMatch.json                        | Allow rules to match Strata templates files for updates
terraformAwsLambdaRuntimes.json               | Update AWS Lambda runtime values in Terraform files
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

## Testing out configs

See the [upstream docs][renovate-validate-config] for more detail, quick summary:

- You can run the `renovate-config-validator` CLI tool to validate the syntax of
  your config
- Create a `renovate/reconfigure` branch on your source repo that the hosted
  app(s) are integrated with, which will automatically be checked on the next
  run

[renovate-validate-config]: https://docs.renovatebot.com/config-validation/

But most useful is to run [Renovate locally][renovate-local]:

[renovate-local]: https://docs.renovatebot.com/modules/platform/local/

``` shell
LOG_LEVEL=debug renovate --platform=local --repository-cache=reset --print-config --config-file-names renovate.json
```

You will almost certainly need to [configure a GitHub PAT][renovate-gh-pat] in
the `RENOVATE_GITHUB_COM_TOKEN` env var.

[renovate-gh-pat]: https://docs.renovatebot.com/getting-started/running/#githubcom-token-for-changelogs-and-tools

## License

This project is licensed under the Apache 2.0 License. See the
[LICENSE](LICENSE) file for details.

## Community

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
