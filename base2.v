module multibase

import math

// bin_encode encodes a string of ASCII characters into binary string
pub fn bin_encode(input string) string {
	mut ret := ''
	for b in input {
		ret += bin_encode_byte(b)
	}
	return ret
}

// bin_encode_byte encodes a single byte into a binary string
fn bin_encode_byte(b byte) string {
	mut ret := ''
	for i := 7; i >= 0; i-- {
		ret += if b & (1 << i) != 0 {'1'} else {'0'}
	}

	return ret
}

// bin_decode decodes a binary string into ASCII string
pub fn bin_decode(input string) string {
	mut src := input
	if input.len & 7 != 0 {
		src = '0'.repeat(8-input.len&7) + input
	}

	mut dec := []byte{}

	for src.len > 0 {
		mut x := src[0..8].int()
		dec << bin_decode_byte(x)
		src = src[8..]
	}

	return dec.bytestr()
}

// bin_decode_byte decodes a binary integer into a single byte
fn bin_decode_byte(n int) byte {
	mut ascii_code := 0
	mut x := n
	for i := 0; x != 0; i++ {
		rem := x % 10
		x = x / 10
		ascii_code = ascii_code + rem * int(math.pow(2, f64(i)))
	}
	return byte(ascii_code)
}