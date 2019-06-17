local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")


local plugin = require("kong.plugins.base_plugin"):extend()

-- constructor
function plugin:new()
  plugin.super.new(self, plugin_name)
end


function plugin:access(plugin_conf)
  plugin.super.access(self)


end


plugin.PRIORITY = 1000

-- return our plugin object
return plugin
