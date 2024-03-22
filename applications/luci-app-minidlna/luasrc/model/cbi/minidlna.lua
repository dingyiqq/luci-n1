-- Copyright 2012 Gabor Juhos <juhosg@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local m, s, o

m = Map("minidlna", translate("miniDLNA"))

m:section(SimpleSection).template  = "minidlna_status"

s = m:section(TypedSection, "minidlna", translate("miniDLNA Settings"))
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Settings"))
s:tab("advanced", translate("Advanced Settings"))

o = s:taboption("general", Flag, "enabled", translate("Enable:"))
o.rmempty = false

function o.write(self, section, value)
	if value == "1" then
		luci.sys.init.enable("minidlna")
		luci.sys.call("/etc/init.d/minidlna start >/dev/null")
	else
		luci.sys.call("/etc/init.d/minidlna stop >/dev/null")
		luci.sys.init.disable("minidlna")
	end

	return Flag.write(self, section, value)
end

o = s:taboption("general", Value, "port", translate("Port:"))
o.datatype = "port"
o.default = 8200


o = s:taboption("general", Value, "interface", translate("Interfaces:"))

o.template = "cbi/network_ifacelist"
o.widget   = "checkbox"
o.nocreate = true

function o.cfgvalue(self, section)
	local rv = { }
	local val = Value.cfgvalue(self, section)
	if val then
		local ifc
		for ifc in val:gmatch("[^,%s]+") do
			rv[#rv+1] = ifc
		end
	end
	return rv
end

function o.write(self, section, value)
	local rv = { }
	local ifc
	for ifc in luci.util.imatch(value) do
		rv[#rv+1] = ifc
	end
	Value.write(self, section, table.concat(rv, ","))
end


o = s:taboption("general", Value, "friendly_name", translate("Friendly name:"))
o.rmempty = true
o.placeholder = "OpenWrt DLNA Server"

o = s:taboption("advanced", Value, "db_dir", translate("Database directory:"))
o.rmempty = true
o.placeholder = "/var/cache/minidlna"

o = s:taboption("advanced", Value, "log_dir", translate("Log directory:"))
o.rmempty = true
o.placeholder = "/var/log"

s:taboption("advanced", Flag, "inotify", translate("Enable inotify:"))

s:taboption("advanced", Flag, "enable_tivo", translate("Enable TIVO:"))
o.rmempty = true

s:taboption("advanced", Flag, "wide_links", translate("Allow wide links:"))
o.rmempty = true

o = s:taboption("advanced", Flag, "strict_dlna", translate("Strict to DLNA standard:"))
o.rmempty = true

o = s:taboption("advanced", Value, "presentation_url", translate("Presentation URL:"))
o.rmempty = true
o.placeholder = "http://192.168.50.254/"

o = s:taboption("advanced", Value, "notify_interval", translate("Notify interval:"))
o.datatype = "uinteger"
o.placeholder = 900

o = s:taboption("advanced", Value, "serial", translate("Announced serial number:"))
o.placeholder = "12345678"

s:taboption("advanced", Value, "model_number", translate("Announced model number:"))
o.placholder = "1"

o = s:taboption("advanced", Value, "minissdpsocket", translate("miniSSDP socket:"))
o.rmempty = true
o.placeholder = "/var/run/minissdpd.sock"

o = s:taboption("general", ListValue, "root_container", translate("Root container:"))
o:value(".", translate("Standard container"))
o:value("B", translate("Browse directory"))
o:value("M", translate("Music"))
o:value("V", translate("Video"))
o:value("P", translate("Pictures"))


s:taboption("general", DynamicList, "media_dir", translate("Media directories:"))


o = s:taboption("general", DynamicList, "album_art_names", translate("Album art names:"))
o.rmempty = true
o.placeholder = "Cover.jpg"

function o.cfgvalue(self, section)
	local rv = { }

	local val = Value.cfgvalue(self, section)
	if type(val) == "table" then
		val = table.concat(val, "/")
	elseif not val then
		val = ""
	end

	local file
	for file in val:gmatch("[^/%s]+") do
		rv[#rv+1] = file
	end

	return rv
end

function o.write(self, section, value)
	local rv = { }
	local file
	for file in luci.util.imatch(value) do
		rv[#rv+1] = file
	end
	Value.write(self, section, table.concat(rv, "/"))
end


return m
