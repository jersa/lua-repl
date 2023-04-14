-- Copyright (c) 2011-2015 Rob Hoelz <rob@hoelz.ro>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-- A plugin that runs code in $HOME/.rep.lua before the REPL starts

local setfenv = require('repl.utils').setfenv

local function readable(filename)
  local f = io.open(filename, 'r')
  if not f then
    return false
  end
  f:close()
  return true
end

local function init()
  -- look for an rcfile in the current directory
  local pwd = os.getenv 'PWD'
  local rcfile = pwd .. '/.rep.lua'

  if not readable(rcfile) then
    -- look in the home directory
    local home = os.getenv 'HOME'
    if not home then
      return
    end

    rcfile = home .. '/.rep.lua'
  end

  if not readable(rcfile) then
    return
  end

  local chunk = assert(loadfile(rcfile))
  local env   = setmetatable({ repl = repl }, { __index = _G, __newindex = _G })

  repl._rcfile = rcfile

  setfenv(chunk, env)

  chunk()
  return true
end

return init()
