#!/bin/bash

Digit=6

hotp() {
	local key="$2" counter="$1"
	HS=$(HMAC_SHA_1 "$key" "$counter")
	Sbits="$(DT "$HS")"
	Snum="$(StToNum "$Sbits")"
	D="$((Snum % (10 ** Digit)))"
	echo "$D"
}

HMAC_SHA_1() {
	local key="$1" counter="$2"
	printf "%016x" "$counter" \
		| xxd -r -ps \
		| openssl mac -digest SHA1 -macopt hexkey:"$1" HMAC \
		| tr -d '\n'
}

DT() {
	String="$(echo -n "$1")"
	OffsetBits="${String:39:1}"
	Offset="$((16#$OffsetBits * 2))"
	P="${String:$Offset:8}"
	printf "%x" "$((16#$P & 16#7fffffff))"
}

StToNum() {
	echo -n "$((16#$1))"
}

hotp "$@"
