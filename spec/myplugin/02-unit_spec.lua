-- local helpers = require "spec.helpers"

local PLUGIN_NAME = "myplugin"



describe(PLUGIN_NAME .. ": (unit)", function()

  local plugin, config
  local header_name, header_value


  setup(function()
    _G.kong = {  -- mock the basic Kong function we use in our plugin
      log = {
        inspect = function() end
      },
      service = {
        request = {
          set_header = function(name, val)
            header_name = name
            header_value = val
          end
        }
      },
      response = {
        set_header = function(name, val)
          header_name = name
          header_value = val
        end
      }
    }

    -- load the plugin code
    plugin = require("kong.plugins."..PLUGIN_NAME..".handler")
  end)


  before_each(function()
    -- clear the upvalues to prevent test results mixing between tests
    header_name = nil
    header_value = nil
    config = {
      request_header = "hello-world",
      response_header = "bye-world"
    }
  end)



  it("sets a 'hello-world' header on a request", function()
    plugin:access(config)
    assert.equal("hello-world", header_name)
    assert.equal("this is on a request", header_value)
  end)


  it("gets a 'bye-world' header on a response", function()
    plugin:header_filter(config)
    assert.equal("bye-world", header_name)
    assert.equal("this is on the response", header_value)
  end)

end)
