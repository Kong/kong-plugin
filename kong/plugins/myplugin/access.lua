
local http = require "resty.http"

local _M = {}


-- Create a function to cache results for config based ttl
-- local function get_token_value(config)
--  @todo:


-- Create a function to validate the status-code-as-token
local function validate_auth_token(config, auth_token)
    local auth_server_uri = config.auth_server_host .. auth_token

    -- Create an HTTP client
    local httpc = http.new()
  
    -- Make a request to the authentication server
    local res, err = httpc:request_uri(auth_server_uri, {
      method = "GET",
      -- these headers are a requirement of the mocked auth server (httpstat.us)
      -- read more about it here: https://httpstat.us/
      headers = { 
        ["Accept"] = "application/json",
        ["X-HttpStatus-Response-MockResponseHeader"] = "any-mocked-value"     
      },
      ssl_verify = false -- disable SSL verification for testing purposes
    })
    
    -- debug/inspect auth server response 
    kong.log.inspect(res)
    kong.log.inspect(res.headers)

    -- If there was an error with the request, log the error and return nil
    if not res then
      kong.log.err("Failed to make request to auth server: ", err)
      return nil
    end
  
    -- If the response status is 200, parse the header and return from function
    -- If the response status is not 200, log the error and return nil
    if res.status == 200 then
        local parsed_header_value = res.headers[config.response_header_to_parse]
        kong.log.debug("Parsed header value is: ", parsed_header_value)
        return parsed_header_value
      else
        local error_msg = "Auth server returned error with status code as " .. res.status
        kong.log.err(error_msg)
        return nil
      end
  end


function _M.execute(config)
    -- Get the status-code-as-token from the request header
    local auth_token = kong.request.get_header(config.request_header)
  
    -- If the authentication token is missing or empty, log the error and return a 401 Unauthorized response
    if not auth_token or auth_token == "" then
      kong.log.err("Missing authentication token")
      kong.response.exit(401, { message = "Missing header X-Code-As-Token" })
    end
  
    -- Validate the authentication token
    local parsed_header_value = validate_auth_token(config, auth_token)
  
    -- If there was an error with the validation, log the error and return a 401 Unauthorized response
    if not parsed_header_value then
      kong.log.err("Failed to validate X-Code-As-Token")
      kong.response.exit(401, { message = "Failed authenticate with X-Code-As-Token" })
    end
  
    -- Set the X-User-Id header field with the user ID returned from the auth server
    kong.service.request.set_header(config.proxy_header_to_forward, parsed_header_value)
    kong.log.debug("Parsed header value ", parsed_header_value)
  end

return _M
