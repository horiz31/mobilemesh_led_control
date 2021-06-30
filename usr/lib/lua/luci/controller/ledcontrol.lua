module("luci.controller.ledcontrol", package.seeall)
require("uci")

function index()
	entry({"admin", "system", "ledcontrol"}, cbi("ledcontrol/ledcontrol"), _("LED Control"), 47)
end
