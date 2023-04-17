local helpers = require "spec.helpers"

local PLUGIN_NAME = "myplugin"


for _, strategy in helpers.all_strategies() do if strategy == "postgres" then
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()

      local bp = helpers.get_db_utils(strategy == "off" and "postgres" or strategy, nil, { PLUGIN_NAME })

      -- create a service
      local service = bp.services:insert({
        name = "pyman-test-service",
        url = "https://httpstat.us"
      })

      -- create a route for the service
      local route = bp.routes:insert({
        hosts = { "httpstat.us" },
        service = service,
      })

      -- add the plugin to test to the route we created
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route.id },
        config = {}, -- override default config if neeeded
      }

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,
        -- write & load declarative config, only if 'strategy=off'
        declarative_config = strategy == "off" and helpers.make_yaml_file() or nil,
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
      it("gets a 'X-Code-As-Token' header", function()
        local r = client:get("/200", {
          headers = {
            host = "httpstat.us",
            ["X-Code-As-Token"] = "200",
            ["Accept"] = "application/json",
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the request (as echoed by mockbin) to have the header
        local header_value = assert.request(r).has.header("X-Code-As-Token")
        -- validate the value of that header
        assert.equal("200", header_value)
      end)
    end)


    describe("request", function()
      -- using 'Content-Type' header from mocked auth server response 
      -- and forwarding 'X-Proxy-Header' with the value of 'Content-Type' header
      it("gets a 'Content-Type' header", function()
        local r = client:get("/200", {
          headers = {
            host = "httpstat.us",
            ["X-Code-As-Token"] = "200",
            ["Accept"] = "application/json",
          }
        })
        -- validate that the request succeeded, response status 200
        assert.response(r).has.status(200)
        -- now check the upstream request to have the header
        local header_value = assert.request(r).has.header("X-Proxy-Header")
        -- validate the value of that header
        assert.equal("aMockedValue", header_value)
      end)
    end)
  
  end)
end end
