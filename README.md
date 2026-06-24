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

## Getting started

Get Renovate [set up to run](https://docs.renovatebot.com/#ways-to-run-renovate)
how ever is appropriate for your org/project.

If you are using the hosted app, say on GitHub, the app may create a
"onboarding" change for you with a starter `renovate.json`. Otherwise create a
`renovate.json` file at the root of the repository you want to run it in. The
minimum setup using the Strata presets would look like:

``` json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>navapbc/strata-lib-renovate"
  ]
}
```

(this would only use the `default.json` preset file)

> [!NOTE]
>
> If you are on GitHub, be sure you have enabled Dependency graph/Dependabot
> alerts for the repo to help inform security updates. Dependabot itself doesn't
> need enabled, just the scanning/alerts. By default, Renovate will handle the
> updates Dependabot would otherwise do (if Dependabot was enabled).
>
> https://docs.renovatebot.com/configuration-options/#vulnerabilityalerts

Then run Renovate and see what it says it would create. Tweak the config until
the collection of updates seem sensible to you. For instance, you want to just
try the Renovate default of `config:recommended` at first, then swap to
`github>navapbc/strata-lib-renovate` later.

There are a variety of presets available, many projects may want to start with
something like:

``` json

{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>navapbc/strata-lib-renovate",
    "github>navapbc/strata-lib-renovate:dependencyDashboard",
    "github>navapbc/strata-lib-renovate:groupNonMajorUpdatesByManager",
    "github>navapbc/strata-lib-renovate:playwright"
  ]
}
```

But test things out and find what works for you. The next sections have some
more guidance on getting up and running, and refer to
[docs/tips.md](docs/tips.md) for other helpful info.

## Testing out configs

See the [upstream docs][renovate-validate-config] for more detail, quick
summary:

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

## Suggested project workflow

The default config largely follows the upstream Renovate defaults, which means:

- The Dependency Dashboard will be created, for an overview and manual
  triggering of updates on demand.
- Updates PRs will be limited to a creating a certain number per hour and number
  of open ones in total. This helps avoid your CI system and your maintainers
  from being overwhelmed.
- Security/vulnerability PRs bypass any limits and will always open an update
  when detected.
- Updates will open PRs as they are available (if the project hasn't hit the
  total PR limit yet) and weekly generate a more bulk update.

You should tune all of this to meet your project (and teams') needs, but here's
a general high-level flow for small to medium sized repos based on these
defaults:

- Pin the Dependency Dashboard issue on GitHub, so it's easy to access
- Pick a cadence for general maintenance updates, with presets like:
  1. `schedule:monthly` + `:maintainLockFilesMonthly`
  1. `schedule:weekly` + `:maintainLockFilesWeekly`

Every so often check the Dependency Dashboard for a project, see if any updates
are showing up you think would be valuable (or you just have capacity) to do
now, check the box to have Renovate create a PR for you. Review/tweak the
changes as needed.

On your defined cadence, Renovate will open up PRs for all pending updates, up
to the total limit imposed. So generally build into your development flow some
time to handle these updates on the chosen cadence. The faster your chosen
cadence, generally the smaller number and smaller scope of updates you'll have
to handle at any given time; many smaller changes are be easier to reason about
than fewer big ones (typically). For some maintainers, it may not be practical
to do daily/weekly updates, but avoid anything longer than monthly.

Particularly when introducing Renovate into an existing project you may want to
just use the `:dependencyDashboardApproval` preset at first, manually choosing
which updates to do in what order until you get the list to a manageable size.
Then you can remove the manual approval preset and switch to a schedule.

You may find a mix like `schedule:weekly` and `:maintainLockFilesMonthly`, or
`config:semverAllWeekly` works for you. Or just the defaults without any tweaks!
You can always change the settings to try things out or as project needs change.

You can [read what the Renovate maintainers suggest for general update practices
as well][renovate-upgrade-best-practices].

[renovate-upgrade-best-practices]: https://docs.renovatebot.com/upgrade-best-practices/

## License

This project is licensed under the Apache 2.0 License. See the
[LICENSE](LICENSE) file for details.

## Community

- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Security Policy](SECURITY.md)
