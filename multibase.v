module multibase

import hex
import base32
import base36
import base58
import strconv
import encoding.base64

// Encoding identifies the type of base-encoding that a multibase is carrying.
type Encoding = int

const(
	unsupported_encoding_error = error(@MOD + '.' + @FN + ': unsupported encoding')

	identity          		= 0x00
	base2             		= `0`
	base8             		= `7`
	base10            		= `9`
	base16            		= `f`
	base16_upper      		= `F`
	base32_lower       		= `b`
	base32_upper      		= `B`
	base32_pad_lower   		= `c`
	base32_pad_upper  		= `C`
	base32_hex        		= `v`
	base32_hex_upper  		= `V`
	base32_hex_pad      	= `t`
	base32_hex_pad_upper	= `T`
	base36_lower       		= `k`
	base36_upper       		= `K`
	base58_btc         		= `z`
	base58_flickr      		= `Z`
	base64_normal      		= `m`
	base64_url         		= `u`	// unused
	base64_pad         		= `M`	// unused
	base64_url_pad     		= `U`

	nopad = rune(-1)
	alphabets = {
		'base32': {
			'std-lower' 	: base32.new_alphabet_wpadc('abcdefghijklmnopqrstuvwxyz234567', nopad)
			'std-upper'		: base32.new_alphabet_wpadc('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567', nopad)
			'std-lower-pad'	: base32.new_alphabet('abcdefghijklmnopqrstuvwxyz234567')
			'std-upper-pad'	: base32.new_alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567')
			'hex-lower' 	: base32.new_alphabet_wpadc('0123456789abcdefghijklmnopqrstuv', nopad)
			'hex-upper'		: base32.new_alphabet_wpadc('0123456789ABCDEFGHIJKLMNOPQRSTUV', nopad)
			'hex-lower-pad'	: base32.new_alphabet('0123456789abcdefghijklmnopqrstuv')
			'hex-upper-pad'	: base32.new_alphabet('0123456789ABCDEFGHIJKLMNOPQRSTUV')
		}
		'base36': {
			'lower' 	: base36.new_alphabet('abcdefghijklmnopqrstuvwxyz234567')
			'upper'		: base36.new_alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567')	
		}
		'base58': {
			'btc'		: base58.new_alphabet('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz')
			'flickr'	: base58.new_alphabet('123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ')
		}
	}
)

// EncodingToStr is a map of the supported encoding, unsupported encoding
// specified in standard are left out
encoding_to_str := map[Encoding]string{
	0x00: 'identity',
	int(`0`):  'base2',
	int(`f`):  'base16',
	int(`F`):  'base16upper',
	int(`b`):  'base32',
	int(`B`):  'base32upper',
	int(`c`):  'base32pad',
	int(`C`):  'base32padupper',
	int(`v`):  'base32hex',
	int(`V`):  'base32hexupper',
	int(`t`):  'base32hexpad',
	int(`T`):  'base32hexpadupper',
	int(`k`):  'base36',
	int(`K`):  'base36upper',
	int(`z`):  'base58btc',
	int(`Z`):  'base58flickr',
	int(`m`):  'base64',
	int(`u`):  'base64url',			// unused
	int(`M`):  'base64pad',			// unused
	int(`U`):  'base64urlpad',
}

mut encodings := map[string]Encoding{}

fn init() {
	for e, n in encoding_to_str {
		encodings[n] = e
	}
}

// encode encodes a given string with the selected encoding and returns a
// multibase string (<encoding><base-encoded-string>). It will return
// an error if the selected base is not known.
pub fn encode(base Encoding, data string) ?string {
	match base {
		identity {
			return rune(identity).str() + data.bytestr()
		}
		base2 {
			return base2.str() + bin_encode(data)
		}
		base16 {
			return base16.str() + hex.encode_str(data)
		}
		base16_upper {
			return base16_upper.str() + hex.encode_str_upper(data)
		}
		base32_lower {
			return base32_lower.str() + base32.encode_walpha(data, alphabets['base32']['std-lower'])
		}
		base32_upper {
			return base32_upper.str() + base32.encode_walpha(data, alphabets['base32']['std-upper'])
		}
		base32_hex {
			return base32_hex.str() + base32.encode_walpha(data, alphabets['base32']['hex-lower'])
		}
		base32_hex_upper {
			return base32_hex_upper.str() + base32.encode_walpha(data, alphabets['base32']['hex-upper'])
		}
		base32_pad_lower {
			return base32_pad_lower.str() + base32.encode_walpha(data, alphabets['base32']['std-lower-pad'])
		}
		base32_pad_upper {
			return base32_pad_upper.str() + base32.encode_walpha(data, alphabets['base32']['std-upper-pad'])
		}
		base32_hex_pad {
			return base32_hex_pad.str() + base32.encode_walpha(data, alphabets['base32']['hex-lower-pad'])
		}
		base32_hex_pad_upper {
			return base32_hex_pad_upper.str() + base32.encode_walpha(data, alphabets['base32']['hex-upper-pad'])
		}
		base36_lower {
			return base36_lower.str() + base36.encode_walpha(data, alphabets['base36']['lower'])
		}
		base36_upper {
			return base36_upper.str() + base36.encode_walpha(data, alphabets['base36']['upper'])
		}
		base58_btc {
			return base58_btc.str() + base58.encode_walpha(data, alphabets['base58']['btc'])
		}
		base58_flickr {
			return base58_flickr.str() + base58.encode_walpha(data, alphabets['base58']['flickr'])
		}
		base64_normal {
			return base64_normal.str() + base64.encode_str(data)
		}
		base64_url_pad {
			return base64_url_pad.str() + base64.url_encode_str(data)
		}
		else {
			return unsupported_encoding_error
		}
	}
}

pub fn decode(data string) ?(Encoding, string) {
	if !(data.len > 0) {
		return error(@MOD + '.' + @FN + ': Cannot decode multibase on string less than 1 length')
	}

	enc := Encoding(data[0])
	mut dec := ''
	str := data[1..]

	match enc {
		identity {
			return identity, str
		}
		base2 {
			dec = bin_decode(str)
		}
		base16, base16_upper {
			dec = hex.decode_str(str)
		}
		base32_lower {
			dec = base32.decode_walpha(str, alphabets['base32']['std-lower']) or {
				return err
			}
		}
		base32_upper {
			dec = base32.decode_walpha(str, alphabets['base32']['std-upper']) or {
				return err
			}
		}
		base32_hex {
			dec = base32.decode_walpha(str, alphabets['base32']['hex-lower']) or {
				return err
			}
		}
		base32_hex_upper {
			dec = base32.decode_walpha(str, alphabets['base32']['hex-upper']) or {
				return err
			}
		}
		base32_pad_lower {
			dec = base32.decode_walpha(str, alphabets['base32']['std-lower-pad']) or {
				return err
			}
		}
		base32_pad_upper {
			dec = base32.decode_walpha(str, alphabets['base32']['std-upper-pad']) or {
				return err
			}
		}
		base32_hex_pad {
			dec = base32.decode_walpha(str, alphabets['base32']['hex-lower-pad']) or {
				return err
			}
		}
		base32_hex_pad_upper {
			dec = base32.decode_walpha(str, alphabets['base32']['hex-upper-pad']) or {
				return err
			}
		}
		base36_lower {
			dec = base36.decode_walpha(str, alphabets['base36']['lower']) or {
				return err
			}
		}
		base36_upper {
			dec = base36.decode_walpha(str, alphabets['base36']['upper']) or {
				return err
			}
		}
		base58_btc {
			dec = base58.decode_walpha(str, alphabets['base58']['btc']) or {
				return err
			}
		}
		base58_flickr {
			dec = base58.decode_walpha(str, alphabets['base58']['flickr']) or {
				return err
			}
		}
		base64_normal {
			dec = base64.decode_str(str)
			if dec == '' {
				return error('Failed to decode base64 string')
			}
		}
		base64_url_pad {
			dec = base64.url_decode_str(str)
			if dec == '' {
				return error('Failed to URL decode base64 string')
			}
		}
		else {
			return unsupported_encoding_error
		}
	}

	return enc, dec
}