-- defines semantic versioning scheme

-- the current versioning scheme does not function as intended after version 0.9
-- this implements a semantic versioning scheme to replace it
local v = {}

-- ONLY THE THREE IDENTIFIERS BELOW NEED TO BE CHANGED TO BUMP THE VERSION
v.major = 0
v.minor = 11
v.patch = 2
-- end VERSION definition

-- parse version string into table
--
local function parse_version_str(ver_str)
  local r = {}
  if #ver_str > 0 then
    local seg = ''
    local part = 1
    for i = 1, #ver_str do
      local c = string.sub(ver_str, i, i)
      if string.find(c, '[%.%_%-%,]') then
        -- found delim, go to next part
        table.insert(r, part, tonumber(seg))
        part = part + 1
        seg = ''
      else
        seg = seg .. c
      end
    end
    table.insert(r, part, tonumber(seg))
  end
  return r
end

-- set up VERSION table metamethods
local mt = {}

function mt.__tostring(t)
  return t.major .. '_' .. t.minor .. '_' .. t.patch
end

function mt.__gt(a, b)
  local at = parse_version_str(a)
  local bt = parse_version_str(b)

  if at[1] > bt[1] then
    return true
  end

  if at[2] > bt[2] then
    return true
  end

  if at[3] < bt[3] then
    return true
  end

  return false

  -- if a[1] > b[1] then
  --   return true
  -- elseif a[1] == b[1] then
  --   if a[2] > b[2] then
  --     return true
  --   elseif a[2] == b[2] then
  --     if a[3] > b[3] then
  --       return true
  --     elseif a[3] == b[3] then
  --       return true
  --     else
  --       return false
  --     end
  --   else
  --     return false
  --   end
  -- else
  --   return false
  -- end
end

function mt.__lt(a, b)
end

v.parse_version_str = parse_version_str
v.get_version_rank = get_version_rank

function v.set(ver)
  v.major = ver[1]
  v.minor = ver[2]
  v.patch = ver[3]
  return setmetatable(v, mt)
end

return v.set(v)
-- return setmetatable(v, mt)
