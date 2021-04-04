package main

import (
	"github.com/yuin/gopher-lua"
)

func fsIsdir(L *lua.LState) int {
	dir := L.CheckString(1)
	is := StatPath("directory")
	if is(dir) {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LFalse)
	}
	return 1
}

func fsIsfile(L *lua.LState) int {
	f := L.CheckString(1)
	is := StatPath("")
	if is(f) {
		L.Push(lua.LTrue)
	} else {
		L.Push(lua.LFalse)
	}
	return 1
}

func fsRead(L *lua.LState) int {
	f := L.CheckString(1)
	L.Push(lua.LString(FileRead(f)))
	return 1
}

func fsWrite(L *lua.LState) int {
	f := L.CheckString(1)
	s := L.CheckString(2)
	err := StringToFile(f, s)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	} else {
		L.Push(lua.LTrue)
		return 1
	}
}
