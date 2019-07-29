## Cutting A Release
Releases are done from the GitHub UI.

**Versioning**

* Use semantic versioning.
* If it's a Terraform version change, follow it. For example if it's `0.12.4` => `0.12.5` then our version will be += `0.0.1`, ex. `0.3.1` => `0.3.2`.

**Naming**

* Names should start with `v`, ex. `v0.3.1`.

**Description**

Should be a bulletted list of what changed since the last release.
