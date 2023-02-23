[![Unix build](https://img.shields.io/github/actions/workflow/status/Kong/kong-plugin/test.yml?branch=master&label=Test&logo=linux)](https://github.com/Kong/kong-plugin/actions/workflows/test.yml)
[![Luacheck](https://github.com/Kong/kong-plugin/workflows/Lint/badge.svg)](https://github.com/Kong/kong-plugin/actions/workflows/lint.yml)

Kong plugin template
====================

This repository contains a very simple Kong plugin template to get you
up and running quickly for developing your own plugins.

This template was designed to work with the
[`kong-pongo`](https://github.com/Kong/kong-pongo) and
[`kong-vagrant`](https://github.com/Kong/kong-vagrant) development environments.

Please check out those repos `README` files for usage instructions. For a complete
walkthrough check [this blogpost on the Kong website](https://konghq.com/blog/custom-lua-plugin-kong-gateway).


Naming and versioning conventions
=================================

There are a number "named" components and related versions. These are the conventions:

* *Kong plugin name*: This is the name of the plugin as it is shown in the Kong
  Manager GUI, and the name used in the file system. A plugin named `my-cool-plugin`
  would have a `handler.lua` file at `./kong/plugins/my-cool-plugin/handler.lua`.

* *Kong plugin version*: This is the version of the plugin code, expressed in
  `x.y.z` format (using Semantic Versioning is recommended). This version should
  be set in the `handler.lua` file as the `VERSION` property on the plugin table.

* *LuaRocks package name*: This is the name used in the LuaRocks eco system.
  By convention this is `kong-plugin-[KongPluginName]`. This name is used
  for the `rockspec` file, both in the filename as well as in the contents
  (LuaRocks requires that they match).

* *LuaRocks package version*: This is the version of the package, and by convention
  it should be identical to the *Kong plugin version*. As with the *LuaRocks package
  name* the version is used in the `rockspec` file, both in the filename as well
  as in the contents (LuaRocks requires that they match).

* *LuaRocks rockspec revision*: This is the revision of the rockspec, and it only
  changes if the rockspec is updated. So when the source code remains the same,
  but build instructions change for example. When there is a new *LuaRocks package
  version* the *LuaRocks rockspec revision* is reset to `1`. As with the *LuaRocks
  package name* the revision is used in the `rockspec` file, both in the filename
  as well as in the contents (LuaRocks requires that they match).

* *LuaRocks rockspec name*: this is the filename of the rockspec. This is the file
  that contains the meta-data and build instructions for the LuaRocks package.
  The filename is `[package name]-[package version]-[package revision].rockspec`.

Example
-------

* *Kong plugin name*: `my-cool-plugin`

* *Kong plugin version*: `1.4.2` (set in the `VERSION` field inside `handler.lua`)

This results in:

* *LuaRocks package name*: `kong-plugin-my-cool-plugin`

* *LuaRocks package version*: `1.4.2`

* *LuaRocks rockspec revision*: `1`

* *rockspec file*: `kong-plugin-my-cool-plugin-1.4.2-1.rockspec`

* File *`handler.lua`* is located at: `./kong/plugins/my-cool-plugin/handler.lua` (and similar for the other plugin files)
