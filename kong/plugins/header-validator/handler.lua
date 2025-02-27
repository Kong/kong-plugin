local kong = kong
local re_match = ngx.re.match

local plugin = {
  PRIORITY = 1000, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1", -- version in X.Y.Z format. Check hybrid-mode compatibility requirements.
}

local function do_exit(status, message)
  status = status or 403
  return kong.response.error(status, message)
end

function plugin:init_worker()
  kong.log.debug("header validator plugin is installed")
end

local function validate_eq(header_value, expected_value)
    if header_value ~= expected_value then
        return false
    end
    return true
end

local function validate_match(header_value, pattern)
    local m, _ = re_match(header_value, pattern)
    if not m then
        return false
    end
    return true
end

local function validate_one_of(header_value, allowed_values)
    for _, allowed_value in ipairs(allowed_values) do
        if header_value == allowed_value then
            return true
        end
    end
    return false
end

function plugin:access(plugin_conf)
  local request_headers = kong.request.get_headers()

  for header_name, validation_rules in pairs(plugin_conf.headers or {}) do
    local header_value = request_headers[header_name]
    if not header_value then
      return do_exit(403, "Header is missing")
    end

    if validation_rules.eq then
      local valid = validate_eq(header_value, validation_rules.eq)
      if not valid then
        return do_exit(403, "Header is invalid")
      end
    end

    if validation_rules.match then
      local valid = validate_match(header_value, validation_rules.match)
      if not valid then
        return do_exit(403, "Header doesn't match")
      end
    end

    if validation_rules.one_of then
      local valid = validate_one_of(header_value, validation_rules.one_of)
      if not valid then
        return do_exit(403, "Header is not one of the allowed values")
      end
    end
  end
end

return plugin
