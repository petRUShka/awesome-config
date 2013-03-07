---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2012, petRUShka <petrushkin@yandex.ru>
---------------------------------------------------

function capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  if raw then return s end
  s = string.gsub(s, '^%s+', '')
  s = string.gsub(s, '%s+$', '')
  s = string.gsub(s, '[\n\r]+', ' ')
  return s
end

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { match = string.match }
local driver = capture("lspci -nnk | grep -i vga -A3 | grep 'in use' | awk '{print $5}'")
-- }}}

-- Thermal: provides temperature levels of GPU. Currently support only nvidia and nouveau drivers
module("vicious.widgets.gpu")


-- {{{ Thermal widget type
local function worker(format)
    if not driver then return end

    if driver == "nouveau" then
      command = "sensors nouveau-pci-0100"
      template = "([%d]+).0°C"
    elseif driver == "nvidia" then
      command = "nvidia-smi -q -d TEMPERATURE"
      template = ": ([%d]+) C"
    else
      return 0
    end
    line = io.popen(command):read("*all")
    return tonumber(string.match(line, template))
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })
