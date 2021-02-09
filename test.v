module main

import strings
import strconv

pub enum Case {
	lower = 0
	upper = 1
}

pub fn decode(input string) ?string {
	if input.len % 2 != 0 {
		return error(@MOD + ' > ' + @FN + ': Length of input must be divisible by two.')
	}

	mut ret := []byte{cap: input.len/2}
	for i := 0; i < input.len; i += 2 {
		ret << byte(hex_to_int(input[i], input[i+1]))
	}

	return ret.bytestr()
}

pub fn hex_to_int(pre byte, post byte) int {
	input := pre.ascii_str() + post.ascii_str()
	return int(strconv.parse_int(input, 16, 32))
}

pub fn encode(input string) string {
	return encode_wcase(input, .upper)
}

pub fn encode_wcase(input string, c Case) string {
	return encode_args(input, c, false)
}

pub fn encode_args(input string, c Case, prefix bool) string {
	mut ret := strings.new_builder(0)

	for b in input {
		ret.write(b.hex())
	}

	mut str := match c {
		.lower {
			ret.str().to_lower()
		}
		.upper {
			ret.str().to_upper()
		}
	}

	if prefix {
		str = '0x' + str
	}

	return str
}

fn main() {
	str := 'Adam is the best person ever.'
	println(str)
	hex := encode_args(str, .lower, true)
	println(hex)
	dec := decode(hex)?
	println(dec)
}