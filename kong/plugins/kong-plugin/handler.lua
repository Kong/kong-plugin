-- If you're not sure your plugin is executing, uncomment the line below and restart Kong
-- then it will throw an error which indicates the plugin is being loaded at least.

--assert(ngx.get_phase() == "timer", "The world is coming to an end!")

---------------------------------------------------------------------------------------------
-- In the code below, just remove the opening brackets; `[[` to enable a specific handler
--
-- The handlers are based on the OpenResty handlers, see the OpenResty docs for details
-- on when exactly they are invoked and what limitations each handler has.
---------------------------------------------------------------------------------------------
--

---- @copyright Copyright 2016-2020 Kong Inc. All rights reserved.
---- @license [Apache 2.0](https://opensource.org/licenses/Apache-2.0)

local plugin = {
 PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
 VERSION = 1.0.0
}



-- do initialization here, any module level code runs in the 'init_by_lua_block',
-- before worker processes are forked. So anything you add here will run once,
-- but be available in all workers.



--- Summary ends with a period
--- handles more initialization, but AFTER the worker process has been forked/created
--- It runs in the 'init_worker_by_lua_block'
-- Some description, can be over several lines.
-- @return a nil value
function plugin:init_worker()

  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")

end



--- runs in the 'ssl_certificate_by_lua_block'
--- IMPORTANT: during the `certificate` phase neither `route`, `service`, nor `consumer`
--- will have been identified, hence this handler will only be executed if the plugin is
--- configured as a global plugin!
-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:certificate(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")

end



--- runs in the 'rewrite_by_lua_block'
--- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
--- will have been identified, hence this handler will only be executed if the plugin is
--- configured as a global plugin!
-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:rewrite(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")

end



--- runs in the 'access_by_lua_block'
-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:access(plugin_conf)

  -- your custom code here
  kong.log.inspect(plugin_conf)   -- check the logs for a pretty-printed config!
  ngx.req.set_header(plugin_conf.request_header, "this is on a request")

end


--- runs in the 'header_filter_by_lua_block'
-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:header_filter(plugin_conf)

  -- your custom code here, for example;
  ngx.header[plugin_conf.response_header] = "this is on the response"

end


--- runs in the 'body_filter_by_lua_block'
-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:body_filter(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")

end


--- runs in the 'log_by_lua_block'-- Some description, can be over several lines.
-- @param plugin_conf first parameter
-- @return a nil value
function plugin:log(plugin_conf)

  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")

end


-- return our plugin object
return plugin
