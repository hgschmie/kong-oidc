local M = {}

local function patternMatch(source, pattern)
	local val= string.find(source, pattern)
	if (val) then return true end
	return string.find(source, pattern, 1, true) ~= nil
end

local function shouldIgnoreRequest(patterns)
  if (patterns) then
    for _, pattern in ipairs(patterns) do
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
