local M = {}

local function shouldIgnoreRequest(patterns)
  if (patterns) then
   local objProp = { }
   local idx = 1
    for _, pattern in pairs(patterns) do
      idx = 1
      for value in string.gmatch(pattern, "[^:]+") do 
	    objProp[idx] = value
	    idx = idx + 1
	  end
	  ngx.log(ngx.DEBUG, "OidcHandler handling request, path: " .. ngx.var.request_uri .. " host " .. ngx.var.host .. " pattern " ..  pattern)
      local isMatching = false
      if (objProp[1]) then
      	if (objProp[2]) then
      		ngx.log(ngx.DEBUG, "OidcHandler handling request, pattern " ..  objProp[1] .. " : " .. objProp[2])
      		isMatching = (string.find(ngx.var.uri, objProp[2]) ~= nil and ngx.var.host ~= objProp[1])
      	else
      		ngx.log(ngx.DEBUG, "OidcHandler handling request, pattern " ..  objProp[1])
      		isMatching = (ngx.var.host ~= objProp[1])
      	end
      else
      	if (objProp[2]) then      		
      		ngx.log(ngx.DEBUG, "OidcHandler handling request, pattern  : " .. objProp[2])
      		isMatching = string.find(ngx.var.uri, objProp[2]) ~= nil
      	end
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
