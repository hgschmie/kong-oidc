local M = {}

local function patternMatch(source, pattern)
	local val= string.find(source, pattern) 
	if (val) then return true end
	return string.find(source, pattern, 1, true) ~= nil
end

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
	  -- ngx.log(ngx.DEBUG, "OidcHandler handling request, path: " .. ngx.var.uri .. " host " .. ngx.var.host .. " pattern " ..  pattern)
      local isMatching = nil
      if (objProp[1] and objProp[1] ~= '*') then
      	if (objProp[2] and objProp[2] ~= '*') then
      		-- ngx.log(ngx.DEBUG, "[bogus] OidcHandler handling request, pattern " ..  objProp[1] .. " : " .. objProp[2])
      		isMatching = (patternMatch(ngx.var.uri, objProp[2]) and ngx.var.host == objProp[1])
      	else
      		-- ngx.log(ngx.DEBUG, "[bogus] OidcHandler handling request, pattern " ..  objProp[1])
      		isMatching = (ngx.var.host == objProp[1])
      	end
      else
      	if (objProp[2] and objProp[2] ~= '*') then      		
      		-- ngx.log(ngx.DEBUG, "[bogus]  OidcHandler handling request, pattern  : " .. objProp[2])
      		isMatching = patternMatch(ngx.var.uri, objProp[2])
      	else 
      		if (objProp[1] == '*' and objProp[2] == '*') then
      			ngx.log(ngx.WARN, "OidcHandler handling request, both * means all should be ignore, better to disble plugin then using this")
      			isMatching = true
      		end
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
