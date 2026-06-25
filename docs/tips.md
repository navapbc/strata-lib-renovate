# Renovate Tips

There is a lot of material available upstream to [understand how Renvote itself
works and how to work with it][renovate-reading-list]. Some common needs and
quick references are provided in this doc.

[renovate-reading-list]: https://docs.renovatebot.com/reading-list/

High level things to always keep in mind:

- Rules are evaluated in the order of definition, with later rules overriding
  earlier ones.
- Renovate is very configurable, you can probably get it to do what you want but
  it's okay to just disable/ignore certain pieces in Renovate and handle them
  manually (or with other tools) if that feels simpler.

## Make certain updates opt-in

While the general recommended workflow is to broadly allow Renovate to create
update changes _automatically_ (possibly on a certain schedule rather than
immediately), there are occasions where you don't want Renovate to do that,
either because:

a) you are introducing Renovate to an existing project with a lot of updates and
   it's better to manually order things, or
b) some packages are more involved to handle updates for, or don't follow a
   release pattern where a new version implies you should update

Rather than ignoring the updates entirely (see next section), it's generally
better to just require manual approval for the things you want to "opt-in"
updates for. This preserves visibility for what updates are available (they
still show up on the Dependency Dashboard) and makes it easier to kick them off
when you are ready (just click a checkbox).

See the [Dependency Dashboard Approval][dep-dash-approval] docs for
configuration settings for the different situations above.

[dep-dash-approval]: https://docs.renovatebot.com/key-concepts/dashboard/#dependency-dashboard-approval-workflow

## Ignore updates for specific packages

Add a `packageRules` block like:

```yaml
{
  "packageRules": [
    # ...other blocks...

    {
      "matchPackageNames": [
        "eslint",
        "eslint-config-base"
      ],
      "enabled": false
    }
  ]
}
```

to the end of your existing `packageRules` list.

You can also use the `ignoreDeps` [global
setting](https://docs.renovatebot.com/configuration-options/#ignoredeps), but
that just turns into a `packageRules` block like the above. Generally better,
and more flexible, to just define a `packageRules` block where you can use a
variety of `match*` options as needed.

## Only update specific packages

Somewhat reverse of the above, if you want an allowlist approach:

```yaml
{
  "packageRules": [
    {
      "excludePackageNames": [
        "pydantic"
      ],
      "enabled": false
    }
  ]
}
```

That is, disable (`enabled: false`) all packages _except_ the ones listed
(`excludePackageNames`/`excludePackagePatterns`/etc).

## Reduce noise

As hinted at in the [README.md](../README.md#suggested-project-workflow), using
a schedule for when updates show up can help manage the mental workload around
updates. It also helps highlight more important changes, like security updates
which _do not_ wait to create a PR with default settings. Making general
maintenance things wait in line until the appointed time helps make things
predicable, which helps make things manageable.

There are other strategies as well, [discussed in detail in the upstream
Renovate docs](https://docs.renovatebot.com/noise-reduction/). A notable call
out is grouping updates and this repo provides a few `group*` presets you may
find helpful.
