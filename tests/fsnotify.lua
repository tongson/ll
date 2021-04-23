local included = pcall(debug.getlocal, 4, 1)
local T = require("test")
local fsnotify = require("fsnotify")
--# = fsnotify
--# :toc:
--# :toc-placement!:
--#
--# Wait for filesystem create, delete, and write events.
--#
--# toc::[]
--#
--# == *fsnotify.create*(_String_) -> _Boolean_
--# Wait for a create event on path.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Path to wait on
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if create event happened
--# |===
local fsnotify_create = function()
	T.is_function(fsnotify.create)
end
--#
--# == *fsnotify.write*(_String_) -> _Boolean_
--# Wait for a write event on path.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Path to wait on
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if write event happened
--# |===
local fsnotify_write = function()
	T.is_function(fsnotify.write)
end
--#
--# == *fsnotify.delete*(_String_) -> _Boolean_
--# Wait for a delete event on path.
--#
--# === Arguments
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |string |Path to wait on
--# |===
--#
--# === Returns
--# [options="header",width="72%"]
--# |===
--# |Type |Description
--# |boolean |`true` if delete event happened
--# |===
local fsnotify_remove = function()
	T.is_function(fsnotify.remove)
end
if included then
	return function()
		T["fsnotify.create"] = fsnotify_create
		T["fsnotify.write"] = fsnotify_write
		T["fsnotify.delete"] = fsnotify_delete
	end
else
	T["fsnotify.create"] = fsnotify_create
	T["fsnotify.write"] = fsnotify_write
	T["fsnotify.delete"] = fsnotify_delete
end
