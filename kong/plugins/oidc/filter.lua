local M = {}

local function shouldIgnoreRequest(patterns)
  if (patterns) then
    for _, pattern in ipairs(patterns) do
      ngx.log(ngx.DEBUG, "OidcHandler handling request, path: " .. ngx.var.request_uri)
      ngx.log(ngx.DEBUG, "OidcHandler handling request, path ur: " .. ngx.var.uri)
      local isMatching = not (string.find(ngx.var.uri, pattern) == nil)
      if (isMatching) then return true end
    end
  end
  return false
end

function M.shouldProcessRequest(config)
  return not shouldIgnoreRequest(config.filters)
end

return M
