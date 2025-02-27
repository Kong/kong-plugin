-- local helpers = require "spec.helpers"

local PLUGIN_NAME = "header-validator"



describe(PLUGIN_NAME .. ": (unit)", function()

  local plugin
  local config = {
    { ["X-Header-Eq"] = { eq = "value" } },
    { ["X-Header-Match"] = { match = "^[a-zA-Z0-9_-]+$" } },
    { ["X-Header-Oneof"] = { one_of = { "one", "two", "three" } } }
  }

  local request_headers

  setup(function()
    _G.kong = {  -- mock the basic Kong function we use in our plugin
      request = {
        get_headers = function()
          return request_headers
        end
      },
    }

    -- load the plugin code
    plugin = require("kong.plugins."..PLUGIN_NAME..".handler")
  end)


  before_each(function()
    request_headers = {}
  end)

  -- Test case: Passes all validations
  it("pass all validations", function()
    request_headers = {
      ["X-Header-Eq"] = "value",
      ["X-Header-Match"] = "valid123",
      ["X-Header-Oneof"] = "one"
    }

    plugin:access(config)
    assert.has_no.errors(function()
      plugin:access(config)
    end)
  end)

  -- Test case: Fails `eq` validation
  it("fail by eq validation", function()
    request_headers = {
      ["X-Header-Eq"] = "wrong-value", -- Should be "value"
      ["X-Header-Match"] = "valid123",
      ["X-Header-Oneof"] = "one"
    }

    local success, _ = pcall(plugin.access, config)
    assert.is_falsy(success) -- Expect failure
  end)

  -- Test case: Fails `match` validation
  it("fail by match validation", function()
    request_headers = {
      ["X-Header-Eq"] = "value",
      ["X-Header-Match"] = "!invalid#", -- Should match regex
      ["X-Header-Oneof"] = "one"
    }

    local success, _ = pcall(plugin.access, config)
    assert.is_falsy(success) -- Expect failure
  end)

  -- Test case: Fails `one_of` validation
  it("fail by one_of validation", function()
    request_headers = {
      ["X-Header-Eq"] = "value",
      ["X-Header-Match"] = "valid123",
      ["X-Header-Oneof"] = "four" -- Not in ["one", "two", "three"]
    }

    local success, _ = pcall(plugin.access, config)
    assert.is_falsy(success) -- Expect failure
  end)

  -- Test case: Missing required header
  it("fail when required header is missing", function()
    request_headers = {
      ["X-Header-Match"] = "valid123",
      ["X-Header-Oneof"] = "one"
    }
    -- Missing "X-Header-Eq"

    local success, _ = pcall(plugin.access, config)
    assert.is_falsy(success)
  end)

end)
