local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "header-validator"

local header_value_validations_record = {
    type = "record",
    required = true,
    fields = {
        { eq = { type = "string" } },
        { match = { type = "string" } },
        { one_of = { type = "array", elements = { type = "string" } } }
    },
    entity_checks = {
        { at_least_one_of = { "eq", "match", "one_of" } }
    },
    description = "Validation rules for header value",
}

local header_validations_array = {
    type = "array",
    default = {},
    required = true,
    elements = {
        type = "map",
        keys = typedefs.header_name,
        values = header_value_validations_record,
    },
    description = "List of headers to validate",
}

local schema = {
  name = PLUGIN_NAME,
  fields = {
    { protocols = typedefs.protocols_http },
    { config = {
        type = "record",
        fields = {
          { headers = header_validations_array },
        },
      },
    },
  },
}

return schema
