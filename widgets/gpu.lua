---------------------------------------------------
-- Licensed under the GNU General Public License v2
--  * (c) 2012, petRUShka <petrushkin@yandex.ru>
---------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { popen = io.popen }
local setmetatable = setmetatable
local string = { match = string.match }
-- }}}


-- Thermal: provides temperature levels of GPU. Currently support only nvidia and nouveau drivers
module("vicious.widgets.gpu")


-- {{{ Thermal widget type
local function worker(format, warg)
    if not warg then return end

    if warg == "nouveau" then
      command = "sensors nouveau-pci-0100"
      template = "([%d]+).0°C"
    elseif warg == "nvidia" then
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
