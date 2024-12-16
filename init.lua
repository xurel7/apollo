local clonerefs = cloneref or function(...) return ... end

if hookmetamethod then
  local __namecall
  __namecall = hookmetamethod(game,"__namecall",function(self,...)
    local method = getnamecallmethod():lower()
    if method == "getservice" and checkcaller() then
      return clonerefs(__namecall(self,...))
    end
    return __namecall(self,...)
  end)
end
