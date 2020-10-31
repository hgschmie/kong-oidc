local M = {}

local function shouldIgnoreRequest(patterns)
  if (patterns) then
   local objProp = { }
   local idx = 1
    for _, pattern in pairs(patterns) do
      idx = 1
      ngx.log(ngx.DEBUG, "OidcHandler handling request, path: " .. ngx.var.request_uri .. " host " .. ngx.var.host .. " httphost " .. ngx.var.http_host )
      for value in string.gmatch(pattern, "[^:]+") do 
	    objProp[index] = value
	    idx = idx + 1
	  end
      local isMatching = false
      if (objProp[1]) then
      	isMatching = (string.find(ngx.var.uri, objProp[2]) ~= nil and ngx.var.host ~= objProp[1])
      else
      	isMatching = string.find(ngx.var.uri, objProp[2]) ~= nil
      end
      if (isMatching) then return true end
    end
  end
  return false
end

function M.shouldProcessRequest(config)
  return not shouldIgnoreRequest(config.filters)
end

return M
