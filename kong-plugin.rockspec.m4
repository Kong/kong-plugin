package = "kong-plugin-PLUGIN_NAME"  

version = "PLUGIN_VERSION-PLUGIN_VERSION_OFFSET"

local pluginName = "PLUGIN_NAME"

supported_platforms = {"linux", "macosx"}

source = {
  url = "http://github.com/Kong/kong-plugin.git",
  tag = "PLUGIN_VERSION"
  -- or version + version offset?
}

description = {
  summary = "Kong is a scalable and customizable API Management Layer built on top of Nginx.",
  homepage = "http://getkong.org",
  license = "Apache 2.0"
}

dependencies = {
}

build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "kong/plugins/"..pluginName.."/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "kong/plugins/"..pluginName.."/schema.lua",
  }
}
