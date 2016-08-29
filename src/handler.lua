-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")


-- load the base plugin object and create a subclass
local plugin = require("kong.plugins.base_plugin"):extend()

-- constructor
function plugin:new()
  plugin.super.new(self, "myPlugin")  --TODO: change "myPlugin" to the name of the plugin here
  
  -- do initialization here, runs in the 'init_by_lua_block', before worker processes are forked

end

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
--
-- The call to `.super.xxx(self)` is a call to the base_plugin, which does nothing, except logging
-- that the specific handler was executed.
---------------------------------------------------------------------------------------------


--[[ handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the ssl_certificate_by_lua_block handler
function plugin:certificate()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'access_by_lua_block'
function plugin:access()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'header_filter_by_lua_block'
function plugin:header_filter()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter()
  plugin.super.access(self)

  -- your custom code here
  
end --]]

--[[ runs in the 'log_by_lua_block'
function plugin:log()
  plugin.super.access(self)

  -- your custom code here
  
end --]]


-- set the plugin priority, which determines plugin execution order
plugin.PRIORITY = 1000

-- return our plugin object
return plugin
