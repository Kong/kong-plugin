local typedefs = require "kong.db.schema.typedefs"


local PLUGIN_NAME = "myplugin"


local schema = {
  name = PLUGIN_NAME,
  fields = {
    -- the 'fields' array is the top-level entry with fields defined by Kong
    { consumer = typedefs.no_consumer },  -- this plugin cannot be configured on a consumer (typical for auth plugins)
    { protocols = typedefs.protocols_http },
    { config = {
        -- The 'config' record is the custom part of the plugin schema
        type = "record",
        fields = {
          -- a standard defined field (typedef), with some customizations
          { request_header = typedefs.header_name {
              required = true,
              default = "X-Code-As-Token" } },
          { response_header_to_parse = typedefs.header_name {
              required = true,
              default = "Content-Type" } },
          { proxy_header_to_forward = typedefs.header_name {
                required = true,
                default = "X-Proxy-Header" } },
          { auth_server_host = typedefs.url {  -- Note: using url instead of host
            required = true,
            default = "https://httpstat.us/" } },
          { ttl = {
              type = "integer",
              default = 600,
              required = true,
              gt = 0, 
            }
          }
        },
      },
    },
  },
}

return schema
