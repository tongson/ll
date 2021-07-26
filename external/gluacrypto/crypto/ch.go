package gluacrypto_crypto

import (
	"encoding/hex"
	"fmt"
	"strconv"
	"strings"

	"github.com/yuin/gopher-lua"
)

func xorFn(L *lua.LState) int {
	i := L.CheckNumber(1)
	x := L.CheckNumber(2)
	L.Push(lua.LNumber(uint8(i) ^ uint8(x)))
	return 1
}

func hextostrFn(L *lua.LState) int {
	h := L.CheckString(1)
	decodedByteArray, err := hex.DecodeString(h)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LString(string(decodedByteArray)))
	return 1
}

func strtohexFn(L *lua.LState) int {
	h := L.CheckString(1)
	encodedString := hex.EncodeToString([]byte(h))
	L.Push(lua.LString(encodedString))
	return 1
}

func hextointFn(L *lua.LState) int {
	h := L.CheckString(1)
	value, err := strconv.ParseInt(h, 16, 64)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	L.Push(lua.LNumber(value))
	return 1
}

func hextotblFn(L *lua.LState) int {
	h := L.CheckString(1)
	decodedByteArray, err := hex.DecodeString(h)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	t := L.NewTable()
	for _, element := range decodedByteArray {
		t.Append(lua.LNumber(uint8(element)))
	}
	L.Push(t)
	return 1
}

func hexorFn(L *lua.LState) int {
	a := L.CheckString(1)
	b := L.CheckString(2)
	aa, err := hex.DecodeString(a)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	ba, err := hex.DecodeString(b)
	if err != nil {
		L.Push(lua.LNil)
		L.Push(lua.LString(err.Error()))
		return 2
	}
	hexa := strings.Builder{}
	var ax *[]byte
	var bx *[]byte
	var other int
	la := len(aa)
	lb := len(ba)
	switch la > lb {
	case true:
		ax = &aa
		bx = &ba
		other = lb
	case false:
		ax = &ba
		bx = &aa
		other = la
	}
	t := L.NewTable()
	var n int = other - 1
	var r int = 0
	for _, element := range *ax {
		var v uint8
		if r < n {
			v = uint8(element) ^ uint8((*bx)[r])
			r++
		} else {
			v = uint8(element) ^ uint8((*bx)[r])
			r = 0
		}
		hexa.WriteString(fmt.Sprintf("%02x", v))
		t.Append(lua.LNumber(v))
	}
	L.Push(lua.LString(hexa.String()))
	L.Push(t)
	return 2
}
