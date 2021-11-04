local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()

local ledcontrolMap = Map("ledcontrol", translate("LED Control configuration page"),translate(""))

function ledcontrolMap.on_after_commit(self)
  -- restart and capture stderr
  local ret = sys.exec("/etc/init.d/mesh_monitor restart")
  if ret ~= "" then
    ledcontrolMap.message = translate("Error occured: ") .. tostring(ret)
  end
end

local sectionGeneral_ledcontrolMap = ledcontrolMap:section(TypedSection, "ledcontrol", translate("LED Behavior"))
sectionGeneral_ledcontrolMap.addremove = false
sectionGeneral_ledcontrolMap.sortable  = false
sectionGeneral_ledcontrolMap.anonymous   = true

local ledcontrol_enabled = sectionGeneral_ledcontrolMap:option(Flag, "enabled", translate("LED Tactical Mode (LEDs will not stay on continuously)"))
ledcontrol_enabled.rmempty = false

return ledcontrolMap