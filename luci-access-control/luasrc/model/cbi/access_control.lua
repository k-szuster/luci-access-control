--[[
LuCI - Lua Configuration Interface - Internet access control

Copyright 2015 Krzysztof Szuster.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

local CONFIG_FILE_RULES = "firewall"  
local CONFIG_FILE_AC    = "access_control"
local ma, mr, s, o

ma = Map(CONFIG_FILE_AC, translate("Internet Access Control"),
  	translate("Access Control allows you to manage internet access for specific local hosts."))
if CONFIG_FILE_AC==CONFIG_FILE_RULES then
    mr = ma
else
    mr = Map(CONFIG_FILE_RULES)
end
---------------------------------------------------------------------------------------------
--  General switch

--s = ma:section(TypedSection, "access_control", "General settings")
--    s.anonymous = true
s = ma:section(NamedSection, "general", "access_control", "General settings")
    o = s:option(Flag, "enabled", translate("Enabled"))
        o.rmempty = false

---------------------------------------------------------------------------------------------
-- Rule table

s = mr:section(TypedSection, "rule", translate("Client Rules"))
    s.addremove = true
    s.anonymous = true
--    s.sortable  = true
    s.template = "cbi/tblsection"
    -- hidden, constant options
    s.defaults.enabled = "0"
    s.defaults.src     = "*" --"lan", "guest" or enything on local side
    s.defaults.dest    = "wan"
    s.defaults.target  = "REJECT"
    s.defaults.proto    = "0"
    s.defaults.extra = "--kerneltz"
    
    -- only AC-related rules
    s.filter = function(self, section)
	      return self.map:get (section, "ac_enabled") ~= nil
    end
        
    o = s:option(Flag, "ac_enabled", translate("Enabled"))
        o.default = '1'
        o.rmempty  = false
    
        -- ammend "enabled" option  
        function o.write(self, section, value)
            local s = "cbid.access_control.general.enabled"
            local global_enable = luci.http.formvalue(s)
            if global_enable == "1" then
                self.map:set(section, "enabled", value)
                io.stderr:write("set "..value.."\n")
            else
                self.map:set(section, "enabled", "0")
                io.stderr:write("reset\n")
--            if global_enable == nil then
--                ma.uci:section(CONFIG_FILE_AC, "access_control", "general", 
--                    { enabled = "0" })
--                ma.uci:commit(CONFIG_FILE_AC)
--            end
            end	
--            self.map:set(section, "src",  "*")
--            self.map:set(section, "dest", "wan")
--            self.map:set(section, "target", "REJECT")
--            self.map:set(section, "proto", "0")
--            self.map:set(section, "extra", "--kerneltz")
            return Flag.write(self, section, value)
        end
      
    o = s:option(Value, "name", "Description")
        o.rmempty = false  -- force validate
        -- better validate, then: o.datatype = "minlength(1)"
        o.validate = function(self, val, sid)
            if type(val) ~= "string" or #val == 0 then
                return nil, translate("Name must be specified!")
            end
            return val
        end
        
     o = s:option(Value, "src_mac", "MAC address") 
        o.rmempty = false
        o.datatype = "macaddr"
        luci.sys.net.mac_hints(function(mac, name)
            o:value(mac, "%s (%s)" %{ mac, name })
        end)

    function validate_time(self, value, section)
        local hh, mm
        hh,mm = string.match (value, "^(%d?%d):(%d%d)$")
        hh = tonumber (hh)
        mm = tonumber (mm)
        if hh and mm and hh <= 23 and mm <= 60 then
            return value
        else
            return nil, "Time value must be HH:MM or empty"
        end
    end
    o = s:option(Value, "start_time", "Start time")
        o.rmempty = true  -- do not validae blank
        o.validate = validate_time 
    o = s:option(Value, "stop_time", "End time") 
        o.rmempty = true  -- do not validae blank
        o.validate = validate_time


if CONFIG_FILE_AC==CONFIG_FILE_RULES then
  return ma
else
  return ma, mr
end

