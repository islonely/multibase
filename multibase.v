module multibase

import base32
import base36
import base58
import encoding.base64

// Encoding identifies the type of base-encoding that a multibase is carrying.
type Encoding = int

const(
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
	base36             		= `k`
	base36_upper       		= `K`
	base58_btc         		= `z`
	base58_flickr      		= `Z`
	base64             		= `m`
	base64_url         		= `u`
	base64_pad         		= `M`
	base64_url_pad     		= `U`

	nopad = rune(-1)
	alphabets = {
		'base32': {
			'std-lower' 	: base32.new_alphabet_wpadc('abcdefghijklmnopqrstuvwxyz234567', nopad)
			'std-upper'		: base32.new_alphabet_wpadc('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567', nopad)
			'std-lower-pad'	: base32.new_alphabet('abcdefghijklmnopqrstuvwxyz234567')
			'std-upper-pad'	: base32.new_alphabet('ABCDEFGHIJKLMNOPQRSTUVWXYZ234567')
		}
	}
)

// EncodingToStr is a map of the supported encoding, unsupported encoding
// specified in standard are left out
encoding_to_str := map{
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
	int(`u`):  'base64url',
	int(`M`):  'base64pad',
	int(`U`):  'base64urlpad',
}

mut encodings := map[string]Encoding{}

fn init() {
	for e, n in encoding_to_str {
		encodings[n] = e
	}
}

pub fn encode(base Encoding, data string) ?string {
	match base {
		identity {
			return rune(identity).str() + data.bytestr()
		}
		base2 {
			return base2.str() + bin_encode(data)
		}
		base16 {
			return base16.str() + hex_encode_string(data)
		}
		base16_upper {
			return base16_upper.str() + hex_encode_upper_string(data)
		}
		base32 {
			return base32_lower.str() + base32.encode_walpha(data, alphabets['base32']['std-lower'])
		}
		base32_upper {
			return base32_upper.str() + base32.encode_walpha(data, alphabets['base32']['std-upper'])
		}
		else {
			return error(@MOD + '.' + @FN + ': unsupported encoding')
		}
	}
}

