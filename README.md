#Kong plugin template

This repository contains a very simple Kong plugin template to get you
up and running quickly for developing your own plugins.

This readme assumes Kong version 0.9 (and possibly above)

##Installation

1. install Kong and make sure it is starting and stopping properly
2. clone this repo
3. scan `handler.lua` for 'TODO' comments and fix those
4. scan `rockspec` file for 'TODO' comments and fix those
5. rename the rockspec file according to the packagename and version as set in the rockspec
6. execute `luarocks make` from the root of the repo, to install the plugin
7. execute `export KONG_CUSTOM_PLUGINS=yourPluginName` (or alternatively update the Kong configuration file)
8. start Kong with the `--vv` option, which should show the plugin being loaded

##troubleshooting
Most common problem is Kong not loading the plugin. If you're not sure, check the `handler.lua` file, and 
uncomment the assertion at the top. Execute `luarocks make` again, and restart Kong.
Now Kong should fail with an error that the plugin threw in the `init_by_lua` phase.

If Kong doesn't run the plugin, then do `export KONG_CUSTOM_PLUGINS=yourPluginName` and restart Kong.
If it now does fail with the error mentioned above, then your configuration used to start Kong was wrong.
Use `unset KONG_CUSTOM_PLUGINS` to clear the enviornment variable, and fix your configuration file until 
you get the error.

If Kong complains that the plugin is enabled, but it cannot find it, then the LUA_PATH settings are 
incorrect or the plugin is installed in the wrong location.
Make sure to use the LuaRocks version/installation that also is configured for Kong. Try `luarocks list kong` to see 
whether Kong is listed in the list of installed rocks. If it isn't, then you're installing your plugin in the wrong
LuaRocks tree. Possible causes would be existing lua/luarocks installation before Kong was installed.



