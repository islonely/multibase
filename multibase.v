module multibase

import hex				// https://github.com/islonely/v-hex
import base32			// https://github.com/islonely/base32
import base36			// https://github.com/islonely/base36
import base58			// https://github.com/islonely/base58
import encoding.base64	// builtin

// Encodings are the available base encodings that multibase supports.
pub enum Encodings {
	identity 				= 0x00 
	base2 					= 0x30 // 0
	base16 					= 0x66 // f
	base16_upper 			= 0x46 // F
	base32 					= 0x62 // b
	base32_upper			= 0x42 // B
	base32_pad				= 0x63 // c
	base32_pad_upper		= 0x43 // C
	base32_hex 				= 0x76 // v
	base32_hex_upper 		= 0x56 // V
	base32_hex_pad 			= 0x74 // t
	base32_hex_pad_upper 	= 0x54 // T
	base36			 		= 0x6b // k
	base36_upper 			= 0x4b // K
	base58 					= 0x7a // z
	base58_flickr 			= 0x5a // Z
	base64 					= 0x6d // m
	base64_url 				= 0x55 // U
}

// Encoding identifies the type of base-encoding that a multibase is carrying.
type Encoding = int

const(
	unsupported_encoding_error = error(@MOD + '.' + @FN + ': unsupported encoding')

	nopad = rune(-1)
	alphabets32 = {
		'std-lower' 	: base32.new_alphabet_wpadc('abcdefghijklmnopqrstuvwxyz234567', nopad)
		'std-upper'		: base32.new_alphabet_wpadc('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567', nopad)
		'std-lower-pad'	: base32.new_alphabet('abcdefghijklmnopqrstuvwxyz234567')
		'std-upper-pad'	: base32.new_alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567')
		'hex-lower' 	: base32.new_alphabet_wpadc('0123456789abcdefghijklmnopqrstuv', nopad)
		'hex-upper'		: base32.new_alphabet_wpadc('0123456789ABCDEFGHIJKLMNOPQRSTUV', nopad)
		'hex-lower-pad'	: base32.new_alphabet('0123456789abcdefghijklmnopqrstuv')
		'hex-upper-pad'	: base32.new_alphabet('0123456789ABCDEFGHIJKLMNOPQRSTUV')
	}
	alphabets36 = {
		'lower' 	: base36.new_alphabet('0123456789abcdefghijklmnopqrstuvwxyz')
		'upper'		: base36.new_alphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ')	
	}
	alphabets58 = {
		'btc'		: base58.new_alphabet('123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz')
		'flickr'	: base58.new_alphabet('123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ')
	}


	// encoding_to_str is a map of the supported encoding,
	// unsupported encoding specified in standard are left out
	encoding_to_str = map{
		Encodings.identity: 			'identity'
		Encodings.base2:  				'base2'
		Encodings.base16:  				'base16'
		Encodings.base16_upper:  		'base16upper'
		Encodings.base32:  				'base32'
		Encodings.base32_upper:  		'base32upper'
		Encodings.base32_pad:  			'base32pad'
		Encodings.base32_pad_upper:  	'base32padupper'
		Encodings.base32_hex:  			'base32hex'
		Encodings.base32_hex_upper: 	'base32hexupper'
		Encodings.base32_hex_pad:  		'base32hexpad'
		Encodings.base32_hex_pad_upper: 'base32hexpadupper'
		Encodings.base36:  				'base36'
		Encodings.base36_upper:  		'base36upper'
		Encodings.base58:	  			'base58btc'
		Encodings.base58_flickr:  		'base58flickr'
		Encodings.base64:  				'base64'
		Encodings.base64_url:  			'base64urlpad'
	}

)

// encode encodes a given string with the selected encoding
// and returns encoded value. Can also return error from encoding
// functions or if given string is 0 in length.
pub fn encode(base Encodings, data string) ?string {
	if data.len == 0 {
		return error(@MOD + '.' + @FN + ': String is empty; cannot encode.')
	}

	match base {
		.identity {
			return data
		}
		.base2 {
			return bin_encode(data)
		}
		.base16 {
			return hex.encode_str(data)
		}
		.base16_upper {
			return hex.encode_str_upper(data)
		}
		.base32 {
			return base32.encode_walpha(data, alphabets32['std-lower'])
		}
		.base32_upper {
			return base32.encode_walpha(data, alphabets32['std-upper'])
		}
		.base32_hex {
			return base32.encode_walpha(data, alphabets32['hex-lower'])
		}
		.base32_hex_upper {
			return base32.encode_walpha(data, alphabets32['hex-upper'])
		}
		.base32_pad {
			return base32.encode_walpha(data, alphabets32['std-lower-pad'])
		}
		.base32_pad_upper {
			return base32.encode_walpha(data, alphabets32['std-upper-pad'])
		}
		.base32_hex_pad {
			return base32.encode_walpha(data, alphabets32['hex-lower-pad'])
		}
		.base32_hex_pad_upper {
			return base32.encode_walpha(data, alphabets32['hex-upper-pad'])
		}
		.base36 {
			return base36.encode_walpha(data, alphabets36['lower'])
		}
		.base36_upper {
			return base36.encode_walpha(data, alphabets36['upper'])
		}
		.base58 {
			return base58.encode_walpha(data, alphabets58['btc'])
		}
		.base58_flickr {
			return base58.encode_walpha(data, alphabets58['flickr'])
		}
		.base64 {
			return base64.encode_str(data)
		}
		.base64_url {
			return base64.url_encode_str(data)
		}
	}
}

// decode decodes a given string with the selected encoding
// and returns decoded value. Can also return error from decoding
// functions or if given string is 0 in length.
pub fn decode(base Encodings, data string) ?string {
	if !(data.len > 0) {
		return error(@MOD + '.' + @FN + ': String is empty; cannot decode.')
	}

	mut dec := ''

	match base {
		.identity {
			return data
		}
		.base2 {
			dec = bin_decode(data)
		}
		.base16, .base16_upper {
			dec = hex.decode_str(data) or {
				return err
			}
		}
		.base32 {
			dec = base32.decode_walpha(data, alphabets32['std-lower']) or {
				return err
			}
		}
		.base32_upper {
			dec = base32.decode_walpha(data, alphabets32['std-upper']) or {
				return err
			}
		}
		.base32_hex {
			dec = base32.decode_walpha(data, alphabets32['hex-lower']) or {
				return err
			}
		}
		.base32_hex_upper {
			dec = base32.decode_walpha(data, alphabets32['hex-upper']) or {
				return err
			}
		}
		.base32_pad {
			dec = base32.decode_walpha(data, alphabets32['std-lower-pad']) or {
				return err
			}
		}
		.base32_pad_upper {
			dec = base32.decode_walpha(data, alphabets32['std-upper-pad']) or {
				return err
			}
		}
		.base32_hex_pad {
			dec = base32.decode_walpha(data, alphabets32['hex-lower-pad']) or {
				return err
			}
		}
		.base32_hex_pad_upper {
			dec = base32.decode_walpha(data, alphabets32['hex-upper-pad']) or {
				return err
			}
		}
		.base36 {
			dec = base36.decode_walpha(data, alphabets36['lower']) or {
				return err
			}
		}
		.base36_upper {
			dec = base36.decode_walpha(data, alphabets36['upper']) or {
				return err
			}
		}
		.base58 {
			dec = base58.decode_walpha(data, alphabets58['btc']) or {
				return err
			}
		}
		.base58_flickr {
			dec = base58.decode_walpha(data, alphabets58['flickr']) or {
				return err
			}
		}
		.base64 {
			dec = base64.decode_str(data)
			if dec == '' {
				return error('Failed to decode base64 dataing')
			}
		}
		.base64_url {
			dec = base64.url_decode_str(data)
			if dec == '' {
				return error('Failed to URL decode base64 string')
			}
		}
	}

	return dec
}