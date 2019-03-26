local helpers = require "spec.helpers"
local version = require("version").version


local PLUGIN_NAME = "myplugin"

local KONG_VERSION, KONG_ENTERPRISE
do
  local _, _, version_string = assert(helpers.kong_exec("version"))
  KONG_ENTERPRISE = string.lower(version_string):find("enterprise")
  -- grab the version part (NOTE: enterprise versions can have a '-')
  version_string = version_string:match("([%d%.%-]+)")
  version_string = version_string:gsub("%-", ".")

  -- convert Enterprise to accompanying OSS version
  KONG_VERSION = version(version_string)
  if KONG_ENTERPRISE then
    -- convert Enterprise to accompanying OSS version
    if KONG_VERSION <= version("0.34.1") then KONG_VERSION = version("0.13.1")
    else
      error("Unknown Kong Enterprise version: " .. tostring(KONG_VERSION))
    end
  end
end


for _, strategy in helpers.each_strategy() do
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()
      local bp, route1

      if KONG_VERSION >= version("0.15.0") then
        --
        -- Kong version 0.15.0/1.0.0, new test helpers
        --
        local bp = helpers.get_db_utils(strategy, nil, { PLUGIN_NAME })

        local route1 = bp.routes:insert({
          hosts = { "test1.com" },
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route = { id = route1.id },
          config = {},
        }
      else
        --
        -- Pre Kong version 0.15.0/1.0.0, older test helpers
        --
        local bp = helpers.get_db_utils(strategy)

        local route1 = bp.routes:insert({
          hosts = { "test1.com" },
        })
        bp.plugins:insert {
          name = PLUGIN_NAME,
          route_id = route1.id,
          config = {},
        }
      end

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- set the config item to make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,  -- since Kong CE 0.14
        custom_plugins = PLUGIN_NAME,         -- pre Kong CE 0.14
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)



    describe("request", function()
      it("gets a 'hello-world' header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/request",  -- makes mockbin return the entire request
          headers = {
            host = "test1.com"
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the request (as echoed by mockbin) to have the header
        local header_value = assert.request(r).has.header("hello-world")
        -- validate the value of that header
        assert.equal("this is on a request", header_value)
      end)
    end)



    describe("response", function()
      it("gets a 'bye-world' header", function()
        local r = assert(client:send {
          method = "GET",
          path = "/request",  -- makes mockbin return the entire request
          headers = {
            host = "test1.com"
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the response to have the header
        local header_value = assert.response(r).has.header("bye-world")
        -- validate the value of that header
        assert.equal("this is on the response", header_value)
      end)
    end)

  end)
end
