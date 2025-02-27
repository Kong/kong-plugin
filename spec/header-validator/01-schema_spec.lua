local PLUGIN_NAME = "header-validator"


-- helper function to validate data against a schema
local validate do
  local validate_entity = require("spec.helpers").validate_plugin_config_schema
  local plugin_schema = require("kong.plugins."..PLUGIN_NAME..".schema")

  function validate(data)
    return validate_entity(data, plugin_schema)
  end
end


describe(PLUGIN_NAME .. ": (schema)", function()


  it("accepts header validations", function()
    local ok, err = validate({
        headers = {
            { ["X-User-ID"] = { eq = "12345" } },
            { ["X-Request-ID"] = { match = "^[a-zA-Z0-9_-]+$" } },
            { ["X-Role"] = { one_of = { "admin", "user", "guest" } } }
        },
      })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)

  it("rejects when no validation rule is provided", function()
    local ok, err = validate({
        headers = {
            { ["X-User-ID"] = {} }  -- No eq, match, or one_of defined
        }
      })
    assert.is_falsy(ok)
  end)

  it("rejects when 'one_of' is not an array", function()
    local ok, err = validate({
        headers = {
            { ["X-Role"] = { one_of = "admin" } }  -- Should be an array
        }
      })
    assert.is_falsy(ok)
  end)
end)
