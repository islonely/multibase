# Multibase
A V module which supports binary, hexadecimal, base32, base36, base58, and base64 encoding/decoding.

## Installation
V must first be installed on your machine. You can get that from [vlang/v](https://github.com/vlang/v). After installing V execute this command to install this module to your system.

VPM:
```bash
$ v install islonely.multibase
```
VPKG:
```bash
$ vpkg get multibase
```
Manual install:
```bash
$ git clone https://github.com/is-lonely/multibase ~/.vmodules/multibase
```
## Usage
The `encode` and `decode` functions take an encoding type and an input string. They will return a string or error. See [documentation]() for more details.
```v
import base58

fn main() {
	bases := [
		multibase.Encodings.base16
		multibase.Encodings.base32
		multibase.Encodings.base36
		multibase.Encodings.base58
		multibase.Encodings.base64
	]

	input := 'This is a test.'
	println('Input: $input\n')

	for base in bases {
		encoded_string := multibase.encode(base, input) or {
			panic(err)
		}
		println(base.str() + ' encoded:\t$encoded_string')

		decoded_string := multibase.decode(base, encoded_string) or {
			panic(err)
		}
		println(base.str() + ' decoded:\t$decoded_string\n')
	}
}
```
Output:
```
Input: This is a test.

base16 encoded: 54686973206973206120746573742e
base16 decoded: This is a test.

base32 encoded: krugs4zanfzsayjaorsxg5bo
base32 decoded: This is a test.

base36 encoded: paqaqdwm57c63exdavtdbfy
base36 decoded: This is a test.

base58 encoded: 3MxzEfXF5ZVvqtuY9B493
base58 decoded: This is a test.

base64 encoded: VGhpcyBpcyBhIHRlc3Qu
base64 decoded: This is a test.
```

### Credits
This module is adapted from this golang package: [multiformats/go-multibase](https://github.com/multiformats/go-multibase)

### Donations
Pls, I'm broke lol

[![.NET Conf - November 10-12, 2020](https://www.buymeacoffee.com/assets/img/custom_images/yellow_img.png)](https://www.buymeacoffee.com/islonely)
