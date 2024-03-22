-- Copyright 2020 lwz322 <lwz322@qq.com>
-- Licensed to the public under the MIT License.

local m, s, o

m = Map("frps")
m.title = translate("Frps - Common Settings")

m:section(SimpleSection).template  = "frps/frps_status"

s = m:section(NamedSection, "main", "frps")
s.addremove = false
s.anonymous = true

s:tab("general", translate("General Options"))
s:tab("advanced", translate("Advanced Options"))
s:tab("dashboard", translate("Dashboard Options"))

o = s:taboption("general", Flag, "enabled", translate("Enabled Frps"))

o = s:taboption("general", Value, "client_file", translate("Client file"))
o.default = "/usr/bin/frps"
o.rmempty = false

o = s:taboption("general", ListValue, "run_user", translate("Run daemon as user"))
o:value("", translate("root"))
local user
for user in luci.util.execi("cat /etc/passwd | cut -d':' -f1") do
	o:value(user)
end

o = s:taboption("general", Flag, "enable_logging", translate("Enable logging"))

o = s:taboption("general", Value, "log_file", translate("Log file"))
o:depends("enable_logging", "1")
o.default = "/var/log/frps.log"

o = s:taboption("general", ListValue, "log_level", translate("Log level"))
o:depends("enable_logging", "1")
o:value("trace", translate("Trace"))
o:value("debug", translate("Debug"))
o:value("info", translate("Info"))
o:value("warn", translate("Warning"))
o:value("error", translate("Error"))
o.default = "Warn"

o = s:taboption("general", ListValue, "log_max_days", translate("Log max days"))
o:depends("enable_logging", "1")
o.datatype = "uinteger"
o:value("1", translate("1"))
o:value("2", translate("2"))
o:value("3", translate("3"))
o.default = "3"
o.optional = false

o = s:taboption("general", Flag, "disable_log_color", translate("Disable log color"))
o:depends("enable_logging", "1")
o.enabled = "true"
o.disabled = "false"

o = s:taboption("advanced", Value, "max_pool_count", translate("Max pool count"))
o.datatype = "uinteger"

o = s:taboption("advanced", Value, "max_ports_per_client", translate("Max ports per-client"))
o.datatype = "uinteger"
o.defalut = '0'
o.placeholder = '0'

o = s:taboption("advanced", Value, "subdomain_host", translate("Subdomain host"))
o.datatype = "host"

o = s:taboption("dashboard", Value, "dashboard_addr", translate("Dashboard addr"))
o.default = "0.0.0.0"
o.datatype = "host"

o = s:taboption("dashboard", Value, "dashboard_port", translate("Dashboard port"))
o.default = "7500"
o.datatype = "port"

o = s:taboption("dashboard", Value, "dashboard_user", translate("Dashboard user"))

o = s:taboption("dashboard", Value, "dashboard_pwd", translate("Dashboard password"))
o.password = true

return m
